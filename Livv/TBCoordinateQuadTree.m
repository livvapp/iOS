//
//  TBCoordinateQuadTree.m
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

#import "TBCoordinateQuadTree.h"
#import "TBClusterAnnotation.h"
#import "Livv-swift.h"

typedef struct TBHotelInfo {
    char* hotelName;
    char* hotelPhoneNumber;
} TBHotelInfo;

TBQuadTreeNodeData TBDataFromLine(NSString *line)
{
    NSArray *components = [line componentsSeparatedByString:@"^.#/"];
    
    double latitude = [components[1] doubleValue];
    double longitude = [components[0] doubleValue];
    
    TBHotelInfo* hotelInfo = malloc(sizeof(TBHotelInfo));
    
    NSString *z = [NSString stringWithFormat:@"%@%@", components[2], @"\0"];
    
    NSLog(@"The hotel phone z is: %@", z);
    
    NSString *hotelPhoneNumber = [z stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"The hotel phoneis: %@", hotelPhoneNumber);
    
    hotelInfo->hotelPhoneNumber = malloc(sizeof(char) * strlen([z cStringUsingEncoding:NSUTF8StringEncoding]) + 1);
    strncpy(hotelInfo->hotelPhoneNumber, [z UTF8String], strlen([z cStringUsingEncoding:NSUTF8StringEncoding]) + 1);
    
    NSString *hotelName = [[components lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *top = [hotelName componentsSeparatedByString:@"/#.^"];
    
    NSString *y = [NSString stringWithFormat:@"%@%@", top[0], @"\0"];
    
    hotelInfo->hotelName = malloc(sizeof(char) * strlen([y cStringUsingEncoding:NSUTF8StringEncoding])+1);
    
    strncpy(hotelInfo->hotelName, [y UTF8String], strlen([y cStringUsingEncoding:NSUTF8StringEncoding])+1);
    
    char* topTag = malloc(sizeof(char) * strlen([y cStringUsingEncoding:NSUTF8StringEncoding]) + 1 );
    strncpy(topTag, [y UTF8String], strlen([y cStringUsingEncoding:NSUTF8StringEncoding]) + 1 );
    int topWeight = [top[1] intValue];
    
    return TBQuadTreeNodeDataMake(latitude, longitude, hotelInfo, topTag, topWeight);
}

TBBoundingBox TBBoundingBoxForMapRect(MKMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return TBBoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect TBMapRectForBoundingBox(TBBoundingBox boundingBox)
{
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));
    
    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

NSInteger TBZoomScaleToZoomLevel(MKZoomScale scale)
{
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

float TBCellSizeForZoomScale(MKZoomScale zoomScale)
{
    NSInteger zoomLevel = TBZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 13:
            return 100;
        case 14:
            return 100;
        case 15:
            return 100;
        case 16:
            return 100;
        case 17:
            return 100;
        case 18:
            return 100;
        case 19:
            return 100;
        default:
            return 100;
    }
}

@implementation TBCoordinateQuadTree

- (void)buildTree
{
    @autoreleasepool {
        
        RLMResults *votes = [Vote allObjects];
        RLMResults *size = [SizeofPoints allObjects];
        
        int count = [size[0][@"length"] intValue];
        
        NSLog(@"The count of points is: %i",count);
        
        TBQuadTreeNodeData *dataArray = malloc(sizeof(TBQuadTreeNodeData) * count);
        for (int i = 0; i < count; i++) {
            dataArray[i] = TBDataFromLine(votes[i][@"bump"]);
            NSLog(@"The quad tree has has been fed with: %@",votes[i][@"bump"]);
            
        }
        
        
        TBBoundingBox world = TBBoundingBoxMake(19, -166, 72, -53);
        _root = TBQuadTreeBuildWithData(dataArray, count, world, 4);
    }
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale
{
    double TBCellSize = TBCellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / TBCellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;
            __block char * toptag = NULL;
            __block int topweight = 0;
            
            NSMutableArray *names = [[NSMutableArray alloc] init];
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            
            
            TBQuadTreeGatherDataInRange(self.root, TBBoundingBoxForMapRect(mapRect), ^(TBQuadTreeNodeData data, char * tt, int tw) {
                totalX += data.x;
                totalY += data.y;
                count++;
                toptag = tt;
                topweight = tw;
                
                TBHotelInfo hotelInfo = *(TBHotelInfo *)data.data;
                
                [names addObject:[[NSString alloc] initWithCString:hotelInfo.hotelName encoding:NSUTF8StringEncoding]];
                
                NSLog(@"The tag name is %s, the address is %s, the count %d, the topweight is %d", hotelInfo.hotelName, hotelInfo.hotelPhoneNumber, count, topweight);
                
                [phoneNumbers addObject:[[NSString alloc] initWithBytes:hotelInfo.hotelPhoneNumber length: strlen(hotelInfo.hotelPhoneNumber) encoding: NSUTF8StringEncoding]];
            });
            
            if (count == 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                TBClusterAnnotation *annotation = [[TBClusterAnnotation alloc] initWithCoordinate:coordinate count:count weight:topweight];
                
                annotation.title = [names lastObject];
                annotation.subtitle = [phoneNumbers lastObject];
                [clusteredAnnotations addObject:annotation];
            }
            
            if (count > 1) {
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                TBClusterAnnotation *annotation = [[TBClusterAnnotation alloc] initWithCoordinate:coordinate count:count weight: topweight];
                if(toptag != NULL)
                    annotation.subtitle = [NSString stringWithFormat: @"Trending: %@", [NSString stringWithUTF8String:toptag]];
                [clusteredAnnotations addObject:annotation];
                
                
            }
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

@end

