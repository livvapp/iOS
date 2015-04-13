//
//  MapViewController.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import Realm
import QuartzCore
import SwiftyJSON

enum CenterViewControllerSection: Int {
    case LeftViewState
    case LeftDrawerAnimation
    case RightViewState
    case RightDrawerAnimation
}

class MapViewController: ViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate  {
    
    var tableView: TagSelectorView!
    var mapView: MKMapView!
    var manager:CLLocationManager!
    var address: String!
    var coordinateQuadTree: TBCoordinateQuadTree! = TBCoordinateQuadTree()
    var button: UIButton!
    var connection: Bool! = true
    
    var accuracy: CLLocationAccuracy!
    var lastLocation: CLLocation!
    
    var intialLocationLoad = false
    
    var userLocation:CLLocation!
    
    var showSplashScreen: Bool! = true
    var inviteLocation: CLLocationCoordinate2D!
    
    var loadAddress: String!

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "MapViewControllerRestorationKey"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let types = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let pushSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
        
        manager = nil
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        

        mapView = MKMapView(frame: CGRectMake(0,0, self.view.frame.width, self.view.frame.height))
        mapView.delegate = self

        mapView.showsUserLocation = true
        view.addSubview(self.mapView)
        mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        self.setupLeftMenuButton()
        self.setupRightMenuButton()
        

        let barColor = UIColor.clearColor()
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.backgroundColor = barColor
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = barColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        button =  UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(0, 0, 100, 40) as CGRect
        button.backgroundColor = UIColor.clearColor()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        button.setTitle("L I V V", forState: UIControlState.Normal)
        button.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: UIControlState.Normal)

        button.addTarget(self, action: Selector("clickOnButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = button
        
        
        
        if showSplashScreen == true {
            var bg: UIView! = UIView(frame: self.view.frame)
            bg.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
            
            self.view.addSubview(bg)
            
            var image: UIImage! = UIImage(named: "ilovevista.png")
            var imageView: UIImageView! = UIImageView(image: image)
            imageView.frame = CGRectMake(50, 0, self.view.frame.width - 100, self.view.frame.height)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            bg.addSubview(imageView)
            
            
            delay(3.2){
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    bg.alpha = 0.0
                    
                    }, completion: ({ success in
                        
                        self.currentLocation()
                        self.setUpVotes()
                        bg.removeFromSuperview()
                        
                    }))
            }
        } else {
            
            delay(1.0){
                
                if self.inviteLocation != nil {
                    
                    let spanX = 0.001
                    let spanY = 0.001
                    
                    var newRegion = MKCoordinateRegion(center: self.inviteLocation, span: MKCoordinateSpanMake(spanX, spanY))
                    
                    self.mapView.setRegion(newRegion, animated: true)
                    
                }
                self.setUpVotes()
            }
        }
        
        var leftGrab:UIView! = UIView(frame: CGRectMake(0, 0, 20, self.view.frame.height))
        var rightGrab:UIView! = UIView(frame: CGRectMake(self.view.frame.width-20, 0, 20, self.view.frame.height))
        
        self.view.addSubview(leftGrab)
        self.view.addSubview(rightGrab)
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func clickOnButton(sender: UIButton!)
    {
        if tableView != nil {
            
            self.tableView.removeFromSuperview()
            
        }
        currentLocation()
        setUpVotes()
        
    }

    
    func setUpVotes(){
        
        var region: MKCoordinateRegion! = mapView.region
        var center: CLLocationCoordinate2D! = mapView.region.center
        var userCenter = mapView.userLocation.coordinate
        
        var lat = region.span.latitudeDelta
        var lon = region.span.longitudeDelta
        
        var location1 = (center.latitude - (lat/2))
        var location2 = (center.latitude + (lat/2))
        var location3 = (center.longitude - (lon/2))
        var location4 = (center.longitude + (lon/2))
        
        let users = User.allObjects()
        let user = users[UInt(0)] as! User
        
        var newCoords = "?x1=\(location3)&x2=\(location4)&y1=\(location1)&y2=\(location2)"
        
        let URL: NSURL! = NSURL(string:"\(globalURL)/api/posts\(newCoords)")
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(mutableURLRequest).responseJSON { (req, res, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
                println("Request: \(req)")
                println("Response: \(res)")
                println("JSON Data: \(json)")
                println("Error: \(error)")
                
                var error: String = "Error while setting up points! request: \(req), response: \(res), data: \(json), error: \(error),"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                realm.deleteObjects(SizeofPoints.allObjects())
                let size = SizeofPoints()
                size.length = "0"
                realm.addObject(size)
                realm.commitWriteTransaction()
                
                self.connection = false
                
            }
            else {
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    self.connection = true
                    
                    NSLog("Success: \(globalURL)/api/posts\(newCoords)")
                    
                    var myJSON = JSON(json!)
                    
                    var x = 0
                    
                    var count = myJSON.count
                    
                    let realm = RLMRealm.defaultRealm()
                    
                    //clear the db
                    realm.beginWriteTransaction()
                    realm.deleteObjects(Vote.allObjects())
                    realm.deleteObjects(Tag.allObjects())
                    realm.deleteObjects(Event.allObjects())
                    realm.deleteObjects(SizeofPoints.allObjects())
                    realm.commitWriteTransaction()
                    
                    var newVote = [Vote](count: count, repeatedValue: Vote())
                    
                    
                    realm.beginWriteTransaction()
                    
                    let size = SizeofPoints()
                    //count is minus 1 to account for default tag
                    size.length = "\(count)"
                    realm.addObject(size)
                    
                    while x < count {
                        
                        let newVote = Vote()
                        
                        var lon: Double = myJSON[x]["loc"]["coordinates"][0].doubleValue
                        var lat: Double = myJSON[x]["loc"]["coordinates"][1].doubleValue
                        var address: String = myJSON[x]["address"].stringValue
                        
                        let newEvent = Event()
                        
                        for (key, value) in myJSON[x]["tags"] {
                            
                            var tag = Tag()
                            tag.name = key
                            tag.weight = value.intValue
                            tag.userSelectedTag = 0
                            
                            newEvent.tags.addObject(tag)
                            
                        }
                        var topTag: String = myJSON[x]["toptag"].stringValue
                        var weight: String = myJSON[x]["topweight"].stringValue
                        
                        newEvent.address = address
                        newEvent.points = myJSON[x]["score"].intValue
                        realm.addObject(newEvent)
                        
                        newVote.bump = "\(lon)^.#/\(lat)^.#/\(address)^.#/\(topTag)/#.^\(weight)"
                        
                        realm.addObject(newVote)
                        
                        x++
                        
                    }
                    
                    realm.commitWriteTransaction()
                    
                    self.coordinateQuadTree.mapView = self.mapView
                    self.coordinateQuadTree.buildTree()
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        
                        var scale: Double = Double((self.mapView.bounds.size.width / CGFloat(self.mapView.visibleMapRect.size.width)))
                        let annotations: NSArray = self.coordinateQuadTree.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
                        //self.requestUpdate()
                        self.updateMapViewAnnotationsWithAnnotations(annotations)
                        
                    }
                }
            }
        }
    }
    
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        if intialLocationLoad == false{
            
            currentLocation()

            intialLocationLoad = true
        }
    }
    
    func currentLocation() -> Void {
        let spanX = 0.01
        let spanY = 0.01
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        
        mapView.setRegion(newRegion, animated: false)
        setUpVotes()
        
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        if connection == true{
            
            if intialLocationLoad == true {
                if (mapView.region.span.latitudeDelta > 44.0 || mapView.region.span.longitudeDelta > 44.0){
                    
                } else {
                    
                    setUpVotes()
                    var scale: Double = Double((self.mapView.bounds.size.width / CGFloat(self.mapView.visibleMapRect.size.width)))
                    let annotations: NSArray = self.coordinateQuadTree.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
                    self.updateMapViewAnnotationsWithAnnotations(annotations)
                    
                }
            }
        } else {
            
            setUpVotes()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Center will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Center did appear")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Center will disappear")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Center did disappear")
    }
    
    func setupLeftMenuAgain() {
        
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,69/2,30))
        button.setImage(UIImage(named: "future.png"), forState: .Normal)
        button.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        
        self.navigationItem.setLeftBarButtonItem(item, animated: true)
        
    }
    
    func setupLeftMenuButton() {
        
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,20,20))
        button.setImage(UIImage(named: "left.png"), forState: .Normal)
        button.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        
        self.navigationItem.setLeftBarButtonItem(item, animated: true)
        
    }
    
    
    func setupRightMenuAgain(){

        var button1: UIButton! = UIButton(frame: CGRectMake(0,0,30,30))
        button1.setImage(UIImage(named: "accept.png"), forState: .Normal)
        button1.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        var item1 = UIBarButtonItem(customView: button1)
        var button2: UIButton! = UIButton(frame: CGRectMake(0,0,30,30))
        button2.setImage(UIImage(named: "deny.png"), forState: .Normal)
        button2.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        var item2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.setRightBarButtonItems([item1, item2], animated: true)
        
    }
    
    func setupRightMenuButton() {
        
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,20,20))
        button.setImage(UIImage(named: "right.png"), forState: .Normal)
        button.addTarget(self, action: "rightDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButtonItem(item, animated: true)
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {

            let reuseId = "me"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            pinView!.draggable = false
            pinView!.canShowCallout = false
            pinView!.annotation = annotation
            pinView!.selected = false
            pinView!.image = UIImage(named: "location_button.png")
            pinView.layer.zPosition = 1
            return pinView
            
        }
        var annotation_count: TBClusterAnnotation! = annotation as! TBClusterAnnotation
        
        let TBAnnotationViewReuseID:String! = "\(annotation_count.title)\(annotation_count.coordinate.latitude)\(annotation_count.coordinate.longitude)\(annotation_count.count)\(annotation_count.weight)"
        
        var annotationView:TBClusterAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(TBAnnotationViewReuseID) as! TBClusterAnnotationView!
        
        if ((annotationView) == nil) {
            
            annotationView = TBClusterAnnotationView(annotation: annotation, reuseIdentifier: TBAnnotationViewReuseID)
        }
        
        annotationView.canShowCallout = true
        
        annotationView.count = UInt(annotation_count.count)
        annotationView.weight = UInt(annotation_count.weight)
        
        if (annotation_count.count == 1) {
            annotationView.isParty = true
        } else {
            annotationView.isParty = false
        }

        return annotationView
        
    }
    
    
    func updateMapViewAnnotationsWithAnnotations(annotations: NSArray) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            var before: NSMutableSet = NSMutableSet(array: self.mapView.annotations)
            before.removeObject(self.mapView.userLocation)
            var after: NSSet = NSSet(array: annotations as [AnyObject])
            
            var toKeep: NSMutableSet = NSMutableSet(set: before)
            
            toKeep.intersectSet(after as Set<NSObject>)
            
            var toAdd: NSMutableSet = NSMutableSet(set: after)
            
            toAdd.minusSet(toKeep as Set<NSObject>)
            
            var toRemove: NSMutableSet! = NSMutableSet(set: before)
            toRemove.minusSet(after as Set<NSObject>)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.mapView.addAnnotations(toAdd.allObjects)
                self.mapView.removeAnnotations(toRemove.allObjects)
            }
            
        }
        
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        userLocation = locations[0] as! CLLocation
        lastLocation = locations[0] as! CLLocation
        
    }
    
    func reverseGeocode(){
        
        
        
        var methodStart: NSDate = NSDate()
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                
                println(error)
                
            } else {
                
                if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                    
                    var subThoroughfare:String = ""
                    
                    if (p.subThoroughfare != nil) {
                        
                        subThoroughfare = p.subThoroughfare
                        
                    }
                    self.accuracy = self.lastLocation.horizontalAccuracy

                    self.address = "\(subThoroughfare) \(p.thoroughfare)^.#/\(p.subLocality)^.#/\(p.subAdministrativeArea)^.#/\(p.postalCode)^.#/\(p.country)"
                    var methodFinished: NSDate = NSDate()
                    var executionTime: NSTimeInterval = methodFinished.timeIntervalSinceDate(methodStart)
                    
                    let users = User.allObjects()
                    let user = users[UInt(0)] as! User
                    
                    if user.username == ""{
                        
                        
                        var createView: CreateUsernameView! = CreateUsernameView(frame: CGRectMake(50, -170, self.view.frame.size.width-100, 170))
                        self.view.addSubview(createView)
                        createView.openWindow(self)
                        createView.usernameTextField.becomeFirstResponder()
                        
                        
                    } else {
                        
                        self.tableView = TagSelectorView(frame: CGRectMake(0, 72, self.view.frame.width, self.view.frame.height - 72), mapClass: self)
                        
                        self.tableView.alpha = 0.0
                        self.view.addSubview(self.tableView)
                        
                        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            
                            self.tableView.alpha = 1.0
                            
                            }, completion: ({ success in
                                
                                
                                
                            }))
                    }
                }
            }
        })
    }
    
    func reverseGeocodeForTable(){
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                
                println(error)
                
            } else {
                
                if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                    
                    var subThoroughfare:String = ""
                    
                    if (p.subThoroughfare != nil) {
                        
                        subThoroughfare = p.subThoroughfare
                        
                    }
                    self.accuracy = self.lastLocation.horizontalAccuracy
                    self.address = "\(subThoroughfare) \(p.thoroughfare)^.#/\(p.subLocality)^.#/\(p.subAdministrativeArea)^.#/\(p.postalCode)^.#/\(p.country)"
                    
                }
            }
        })
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if (view.reuseIdentifier == "me"){
            self.mapView.showsUserLocation = false
            reverseGeocode()
            
        }
        
    }
    
    // MARK: - Bounce Animations
    
    func addBounceAnimatonToView(view: UIView) {
        
        var bounceAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.05, 1.1, 0.9, 1]
        bounceAnimation.duration = 0.6
        
        var timingFunctions: NSMutableArray = NSMutableArray(capacity: bounceAnimation.values.count)
        
        for var i = 0; i < 3; i++ {
            timingFunctions.addObject(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        bounceAnimation.timingFunctions = timingFunctions as [AnyObject]
        bounceAnimation.removedOnCompletion = false
        
        view.layer.addAnimation(bounceAnimation, forKey: "bounce")
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        var vieww: MKAnnotation!
        for vieww in views {
            
            if (vieww.annotation) is MKUserLocation {
                
                view.superview?.bringSubviewToFront(vieww as! UIView)
                self.addBounceAnimatonToView(vieww as! UIView)
            } else {
                view.superview?.sendSubviewToBack(vieww as! UIView)
                self.addBounceAnimatonToView(vieww as! UIView)
                
            }
        }
    }
    
    // MARK: - Button Handlers
    
    func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func rightDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Right, animated: true, completion: nil)
    }
    
    //HELPS WITH MEMORY MANAGEMENT OF THE MAP
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.mapType = MKMapType.Standard

    }
    
}

