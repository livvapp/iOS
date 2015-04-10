//
//  TBClusterAnnotationView.h
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TBClusterAnnotation.h"

@interface TBClusterAnnotationView : MKAnnotationView


@property (assign, nonatomic) NSUInteger count;

@property (assign, nonatomic) NSUInteger weight;

@property (assign, nonatomic) BOOL isParty;

@property (strong, nonatomic) UILabel *countLabel;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCount:(NSUInteger)count;

@end

