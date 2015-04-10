//
//  TheListiewController.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Alamofire

//class TheListiewController: ExampleViewController, UITableViewDelegate, UITableViewDataSource {
class TheListiewController: ViewController {
    //    var tagleaders: [String!] = []
    //    var myRank: Int! = 1
    //    var label:UILabel!
    //
    //
    //    var tableView: UITableView!
    //    var boardTag: UILabel!
    //    var refreshControl:UIRefreshControl!
    //    var numberLabel: UILabel!
    
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
        //        println("Left will appear")
        //        let users = User.allObjects()
        //        let user = users[UInt(0)] as! User
        //
        //        if user.lastTag != ""{
        //            numberLabel.hidden = false
        //            tableView.hidden = false
        //            boardTag.hidden = false
        //            label.hidden = true
        //            self.tableView.reloadData()
        //            //callAPI()
        //        } else {
        //
        //            numberLabel.hidden = true
        //            tableView.hidden = true
        //            boardTag.hidden = true
        //            label.hidden = false
        //
        //        }
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
        
        //        println("View did load")
        //
        //        let users = User.allObjects()
        //        let user = users[UInt(0)] as! User
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
        //if user.lastTag != ""{
        //callAPI()
        
        //        numberLabel = UILabel(frame: CGRectMake(190, 8, 20, 20))
        //        numberLabel.font = UIFont(name: "HelveticaNeue-Light",
        //            size: 17.0)
        //        numberLabel.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        //        numberLabel.textAlignment = .Right
        //        self.view.addSubview(numberLabel)
        //
        //        boardTag = UILabel(frame: CGRectMake(15, 0, 375-150-40, 35))
        //        //boardTag.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        //        boardTag.text = user.lastTag
        //        boardTag.font = UIFont(name: "HelveticaNeue-MediumItalic",
        //            size: 19.0)
        //        boardTag.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        //        self.view.addSubview(boardTag)
        //
        //
        //        self.tableView = UITableView(frame: CGRectMake(0, 35, self.view.frame.width, self.view.frame.height - (self.navigationController?.navigationBar.frame.height as CGFloat! + 55)), style: .Plain)
        //        self.tableView.delegate = self
        //        self.tableView.dataSource = self
        //
        //        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        self.tableView.rowHeight = 50
        //        self.tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        //        self.tableView.separatorStyle = .None
        //        self.view.addSubview(tableView)
        //
        //        self.refreshControl = UIRefreshControl(frame: CGRectMake(-50, 0, 50,50))
        //        self.refreshControl.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin
        //        // self.refreshControl.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        //        //self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        //        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //        self.tableView.addSubview(refreshControl)
        //
        //        //callAPI()
        //        //} else {
        //
        //        label = UILabel(frame: CGRectMake(15, 0, 375-150-30, self.view.frame.height - (self.navigationController?.navigationBar.frame.height as CGFloat! + 100)))
        //        label.text = "Oops! Post a tag\nto view the leaderboard."
        //        label.numberOfLines = 15
        //        label.font = UIFont(name: "HelveticaNeue-Light",
        //            size: 17.0)
        //        label.textAlignment = .Center
        //        label.textColor = UIColor.whiteColor()
        //        self.view.addSubview(label)
        //        label.hidden = true
        
        // }
    }
    
    //    func refresh(sender:UIRefreshControl!)
    //    {
    //        println("refresh")
    //        if count(boardTag.text) > 18{
    //            boardTag.adjustsFontSizeToFitWidth = true
    //        }
    //
    //        callAPI()
    //    }
    //
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return tagleaders.count + 1
    //
    //    }
    //
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cellID = "TagCell\(indexPath.row)"
    //        var cell: LeaderBoardTagCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? LeaderBoardTagCell
    //
    //        if cell == nil {
    //            cell = LeaderBoardTagCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, index: indexPath.row, rank: myRank)
    //        }
    //
    //        let users = User.allObjects()
    //        let user = users[UInt(0)] as! User
    //
    //        if indexPath.row == 0 {
    //
    //            cell.textLabel?.text = user.username
    //            cell.rankLabel?.text = String(myRank)
    //
    //        } else {
    //
    //            cell.textLabel?.text = tagleaders[indexPath.row-1]
    //            cell.rankLabel.text = String(indexPath.row)
    //            println("My rank\(myRank)the index\(indexPath.row)")
    //        }
    //
    //        if count(cell.textLabel?.text) > 20){
    //            cell.textLabel?.sizeToFit()
    //        }
    //
    //
    //        return cell
    //
    //    }
    //
    //
    //    func callAPI(){
    //
    //        let users = User.allObjects()
    //        let user = users[UInt(0)] as! User
    //
    //        let parameters = [ "tag" : user.lastTag]
    //
    //        let URL = NSURL(string:"\(globalURL)/api/tags")
    //        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
    //        mutableURLRequest.HTTPMethod = "POST"
    //
    //        var JSONSerializationError: NSError? = nil
    //        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
    //        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        //mutableURLRequest.setValue("\(user.lastTag)", forHTTPHeaderField: "Tag")
    //        mutableURLRequest.setValue("\(user.lastTag)", forHTTPHeaderField: "tag")
    //
    //        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).responseJSON { (req, res, json, error) in
    //
    //            println("Request: \(req)")
    //            println("Response: \(res)")
    //            println("JSON Data: \(json)")
    //            println("Error: \(error)")
    //
    //            if error == nil {
    //                var myJSON = JSON(json!)
    //                println(myJSON)
    //                self.tagleaders = []
    //                for (index: String, subJson: JSON) in myJSON["list"] {
    //                    println("index: \(index), subjson: \(subJson)")
    //                    self.tagleaders.append(subJson.stringValue)
    //                }
    //
    //                self.numberLabel.text = myJSON["total"].stringValue
    //
    //                println("the last tag was \(user.lastTag)")
    //                self.boardTag.text = user.lastTag
    //                if count(self.boardTag.text) > 18{
    //                    self.boardTag.adjustsFontSizeToFitWidth = true
    //                }
    //
    //                self.getRank()
    //
    //            }else {
    //
    //                self.getRank()
    //            }
    //        }
    //
    //    }
    //
    //    func getRank(){
    //
    //        let users = User.allObjects()
    //        let user = users[UInt(0)] as! User
    //
    //        let parameters = [ "tag" : user.lastTag]
    //
    //        let URL = NSURL(string:"\(globalURL)/api/users/me/rank")
    //        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
    //        mutableURLRequest.HTTPMethod = "POST"
    //        var JSONSerializationError: NSError? = nil
    //        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
    //        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
    //        //mutableURLRequest.setValue("\(user.lastTag)", forHTTPHeaderField: "tag")
    //
    //        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).responseJSON { (req, res, json, error) in
    //            
    //            println("Request: \(req)")
    //            println("Response: \(res)")
    //            println("JSON Data: \(json)")
    //            println("Error: \(error)")
    //            
    //            if error == nil {
    //                
    //                //self.tagleaders = []
    //                var myJSON = JSON(json!)
    //                
    //                self.myRank = myJSON["rank"].intValue
    //                println("\(self.myRank)")
    //                self.refreshControl.endRefreshing()
    //                
    //                self.tableView.reloadData()
    //                
    //            }else {
    //                
    //                var alert: UIAlertView = UIAlertView(title: "Network Error", message: "You seem to have a bad connection.", delegate: self, cancelButtonTitle: "Close")
    //                alert.dismissWithClickedButtonIndex(0, animated: true)
    //                alert.show()
    //                self.refreshControl.endRefreshing()
    //                
    //            }
    //        }
    //        
    //    }
    
}
