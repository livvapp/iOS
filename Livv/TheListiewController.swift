//
//  TheListiewController.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Invite {
    var name: String!
    var address: String!
    var tags: String!
    var location: CLLocationCoordinate2D!
}

//class TheListiewController: ExampleViewController, UITableViewDelegate, UITableViewDataSource {
class TheListiewController: ViewController, UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource {
    //    var tagleaders: [String!] = []
    //    var myRank: Int! = 1
    var label:UILabel!
    //
    //
    var tableView: UITableView!
    var invites: [Invite] = []
    //    var boardTag: UILabel!
    //var refreshControl:UIRefreshControl!
    //    var numberLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "TheListiewController"
    }
    
    //    init() {
    //        //super.init()
    //    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.restorationIdentifier = "TheListiewController"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        callAPI()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Left did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Left will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Left did disappear")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "TheListiewController"
        
        self.view.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.navigationController?.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.title = "Invites"
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)
        if let font = font {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)]
            //self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(4.5, forBarMetrics: .Default)
        }
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - (self.navigationController?.navigationBar.frame.height as CGFloat! + 20)), style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        println(self.view.frame)
        println(self.tableView.frame)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 80
        self.tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        label = UILabel(frame: self.tableView.bounds)
        label.text = "You currently have no invites"
        label.font = font
        label.textColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        label.textAlignment = .Center
        //label.sizeToFit()
        self.view.addSubview(label)
        label.hidden = true
        
        setupLeftMenuButton()
 
    }
    
    func setupLeftMenuButton() {
        
        
        
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,20,20))
        button.setImage(UIImage(named: "left.png"), forState: .Normal)
        button.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        
        self.navigationItem.setLeftBarButtonItem(item, animated: true)

        
    }
    
    func leftDrawerButtonPress(sender: AnyObject?) {
        let center = MapViewController()
        center.showSplashScreen = false
        //center.inviteLocation.longitude = center.userLocation.coordinate.longitude
        //center.inviteLocation.latitude = center.userLocation.coordinate.latitude
        let nav = UINavigationController(rootViewController: center)
        self.evo_drawerController?.setCenterViewController(nav, withFullCloseAnimation: true, completion: nil)
    }
    
    func refresh(){
        callAPI()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if invites.count == 0 {
            
            label.hidden = false
        }else {
            label.hidden = true
        }

        return invites.count
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var CellIdentifier = "\(invites[indexPath.row].name + invites[indexPath.row].tags + invites[indexPath.row].address)";
        
        var cell : InvitesTableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? InvitesTableViewCell
        
        if (cell == nil) {
            cell = InvitesTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier, view: self, invite: invites[indexPath.row])
        }
        
        // Configure the cell...
        cell!.selectionStyle = .None
        cell!.name.text = invites[indexPath.row].name
        cell!.address.text = invites[indexPath.row].address
        cell!.tags.text = invites[indexPath.row].tags
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let center = MapViewController()
        center.showSplashScreen = false
        center.inviteLocation = invites[indexPath.row].location
        let nav = UINavigationController(rootViewController: center)
        self.evo_drawerController?.setCenterViewController(nav, withFullCloseAnimation: true, completion: nil)
    }
    
    func callAPI(){
        
        let users = User.allObjects()
        let user = users[UInt(0)] as! User
        
        //let parameters = [ "tag" : user.lastTag]
        
        let URL = NSURL(string:"\(globalURL)/api/users/me/feed")
        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.HTTPMethod = "GET"
        
        var JSONSerializationError: NSError? = nil
        //mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //mutableURLRequest.setValue("\(user.lastTag)", forHTTPHeaderField: "Tag")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).responseJSON { (req, res, json, error) in
            
            println("Request: \(req)")
            println("Response: \(res)")
            println("JSON Data: \(json)")
            println("Error: \(error)")
            
            if error == nil {
                var myJSON = JSON(json!)
                println(myJSON)
                
                self.refreshControl.endRefreshing()
                
                self.invites = []
                
                for var x: Int = 0; x < myJSON["feed"].count; x++ {
                    
                    var hostName: String!
                    var address: String!
                    var tags: String! = "No Tag Selected"
                    var location: CLLocationCoordinate2D!
                    
                    var host: String! = myJSON["feed"][x]["host"].stringValue
                    
                    var length: UInt = Contacts.objectsWhere("phone = '\(host)' AND phone BEGINSWITH '1'").count

                    var cntcts = Contacts.objectsWhere("phone = '\(host)' AND phone BEGINSWITH '1'")
                    
                    if length > 0 {
                        
                        hostName = (cntcts[0] as! Contacts).name
                        
                    }
                    
                    //var fullAddress = split(myJSON["address"].stringValue) {$0 == " "}
                    address = "956 Camino Corto"
                    
                    for var i: Int = 0; i < myJSON["feed"][x]["tags"].count; i++ {
                        
                        if i == 0 {
                            
                            tags = myJSON["feed"][x]["tags"][0].stringValue
                        } else {
                            
                            tags = tags + ", " + myJSON["feed"][x]["tags"][0].stringValue
                        }
                        
                    }
                    
                    location = CLLocationCoordinate2DMake(myJSON["feed"][x]["loc"]["coordinates"][1].doubleValue, myJSON["feed"][x]["loc"]["coordinates"][00].doubleValue)
                    
                    
                    println(hostName)
                    println(address)
                    println(tags)
                    println(location.latitude)
                    println(location.longitude)
                    
                    self.invites.append(Invite(name: hostName, address: address, tags: tags, location: location))
                    
                }
                
                self.tableView.reloadData()

                
            }else {
                
                self.refreshControl.endRefreshing()

            }
        }
        
    }

    
}
