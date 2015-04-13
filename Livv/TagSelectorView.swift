//
//  TagSelectorView.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

//
//  TagSelectorView.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/3/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation
import Realm
import Alamofire
import SwiftyJSON

struct Tags {
    var title: String!
    var isPrivate: Bool!
    var isContact: Bool!
    var phone: String!
    var isSelected: Bool!
    var count: Int!
    var userCount: Int!
}

class TagSelectorView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //add tag button
    var addTag: UITextField!
    var addTagBackground: UIView!
    var points: UILabel!
    var pointsNumber: Int! = 19
    
    //address bar at bottom
    var done: UIButton!
    
    var tableView: UITableView!
    
    //array for multiple tags
    var searchedTags: [Tags] = []
    var tags: [Tags] = []
    var selectedTags: [String] = []
    var instructions: [String] = [" Hello, Hello!", " Set the trend by adding tags", " Top tag = event name", " Use @ to invite freinds", " Use # to create private tags", " Only invites see private tags", " Points are limited", " Upvote correct tags = points", " Send invites = more points", " Attend invites = more points", " Be awesome = most points"]
    
    //mapcontroller
    var mapClass: MapViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init (frame: CGRect, mapClass: MapViewController){
        super.init(frame: frame)
        self.mapClass = mapClass
        self.commonSetup()
    }
    
    deinit{
        addTag = nil
        addTagBackground = nil
        points = nil
        pointsNumber = nil
        done = nil
        tableView = nil
        searchedTags = []
        tags = []
        selectedTags = []
        mapClass = nil
    }
    
    func commonSetup(){
        
        addTagBackground = UIView()
        addTagBackground.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        addTagBackground.layer.cornerRadius = 2
        self.addSubview(addTagBackground)
        
        //addTag button
        addTag = UITextField(frame: CGRect(x: 7, y: 2, width: 90, height: 20))
        addTag.attributedPlaceholder = NSAttributedString(string:"Add Tag",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        addTag.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        addTag.textColor = UIColor.whiteColor()
        self.fitToSize()
        addTag.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        addTag.keyboardType = .Twitter
        addTag.autocorrectionType = .No
        addTag.delegate = self
        addTag.layer.cornerRadius = 2
        
        addTagBackground.addSubview(addTag)
        
        points = UILabel(frame: CGRectMake(self.frame.size.width - 50, 0, 40, 30))
        points.text = String(pointsNumber)
        points.textColor = UIColor.blackColor()
        points.textAlignment = .Right
        //points.backgroundColor = UIColor.redColor()
        //points.layer.cornerRadius = 2
        points.clipsToBounds = true
        points.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        self.addSubview(points)
        
        
        done = UIButton()
        updateDoneTag()
        done.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
        done.addTarget(self, action: "submit:", forControlEvents: .TouchUpInside)
        done.layer.cornerRadius = 2
        done.frame = CGRect(x: 10, y: self.frame.height - 40, width: 90, height: 31)
        self.fitToSizeDone()
        self.addSubview(done)
        
        //addTags()
        
        tableView = UITableView(frame: CGRectMake(0, 31, self.frame.size.width, self.frame.size.height-31-50))
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.rowHeight = 38
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
        
        var singletap: UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: "singleTap:")
        singletap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singletap)
        
        var refresh: UIButton! = UIButton(frame: CGRectMake(self.frame.size.width - 46, self.frame.size.height - 40, 36, 30))
        var refreshImage: UIImage! = UIImage(named: "refresh.png")
        refresh.setImage(refreshImage, forState: .Normal)
        refresh.addTarget(self, action: "refresh:", forControlEvents: .TouchUpInside)
        //refresh.backgroundColor = UIColor.redColor()
        self.addSubview(refresh)
        
        //getSelectedTags()
        
        setUpExistingTags()
        getScore()
    }
    
    func getScore(){
        
        var eventt: RLMResults = Event.objectsWhere("address = %@", self.mapClass.address)
        if ((Event.objectsWhere("address = %@", self.mapClass.address).count > 0)){
            
            var pp: Int! = (eventt[0] as! Event).points
            self.pointsNumber = pp
            self.points.text = String(self.pointsNumber)
            
        } else {
            
            let users = User.allObjects()
            let user = users[UInt(0)] as! User
            
            let URL = NSURL(string:"\(globalURL)/api/users/me/score")
            let mutableURLRequest = NSMutableURLRequest(URL: URL!)
            mutableURLRequest.HTTPMethod = "GET"
            
            var JSONSerializationError: NSError? = nil
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
            
            Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).responseJSON { (req, res, json, error) in
                
                println("Request: \(req)")
                println("Response: \(res)")
                println("JSON Data: \(json)")
                println("Error: \(error)")
                
                if error == nil {
                    
                    var myJSON = JSON(json!)
                    self.pointsNumber = myJSON["score"].intValue
                    self.points.text = myJSON["score"].stringValue
                    
                    
                }
                
            }
        }
    }
    
    func decrementAPoint(){
        
        pointsNumber = pointsNumber - 1
        points.text = String(pointsNumber)
    }
    
    func incrementAPoint(add: Int){
        pointsNumber = pointsNumber + add
        points.text = String(pointsNumber)
        
    }
    
    func refresh(sender: UIButton!){
        
        mapClass.reverseGeocodeForTable()
        //mapClass.getSelectedTags()
        updateDoneTag()
        fitToSizeDone()
        setUpExistingTags()
        //getSelectedTags()
        //call api
    }
    
    func submit(selector: UIButton!){
        
        post()
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func updateDoneTag(){
        
        var splitAdress = split(mapClass.address){$0 == "^"}
        var quickAddress = splitAdress[0]
        done.setTitle(quickAddress, forState: UIControlState.Normal)
        
        delay(2.0){
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.done.alpha = 0
                
                }, completion: ({ success in
                    
                    println("Window did disolve")
                    
                    if self.selectedTags.count == 0 {
                        self.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        self.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                        self.done.setTitle("Cancel", forState: UIControlState.Normal)
                        self.fitToSizeDone()
                    } else {
                        self.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        self.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                        self.done.setTitle("Submit", forState: UIControlState.Normal)
                        self.fitToSizeDone()
                        
                    }

                    
                    UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        
                        self.done.alpha = 1.0
                        
                        }, completion: ({ success in
                            
                            println("Window did appear")
                            //self.usernameTextField.becomeFirstResponder()
                            
                        }))
                    
                }))
        
        }
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        //explanation.hidden = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println((tags.count + searchedTags.count))
        if (tags.count + searchedTags.count) == 0 {
            println(instructions.count)
            return instructions.count
        }
        return tags.count + searchedTags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (tags.count + searchedTags.count) != 0 {
            //searchedtags / addedtags
            if searchedTags.count > indexPath.row {
                
                //if it's a contact -> yellow dude
                if searchedTags[indexPath.row].isContact == true && searchedTags[indexPath.row].isPrivate == false {
                    
                    let cellID = searchedTags[indexPath.row].title
                    var cell:ContactButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? ContactButtonTableViewCell
                    
                    if (cell == nil) {
                        
                        cell = ContactButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                        
                        cell.backgroundColor = UIColor.clearColor()
                        
                        cell.selectionStyle = .None
                        cell.backgroundView = nil
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        
                    }
                    
                    return cell
                }
                    
                    //if it's a private tag -> pink dude
                else if searchedTags[indexPath.row].isContact == false && searchedTags[indexPath.row].isPrivate == true {
                    
                    let cellID = searchedTags[indexPath.row].title
                    var cell:PrivateButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? PrivateButtonTableViewCell
                    
                    if (cell == nil) {
                        
                        cell = PrivateButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                        
                        cell.backgroundColor = UIColor.clearColor()
                        
                        cell.selectionStyle = .None
                        cell.backgroundView = nil
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        
                    }
                    
                    return cell
                    
                }

                else{
                    
                    let cellID = searchedTags[indexPath.row].title
                    var cell:TagButtonViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonViewCell
                    
                    if (cell == nil) {
                        
                        cell = TagButtonViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                        
                        cell.backgroundColor = UIColor.clearColor()
                        cell.selectionStyle = .None
                        cell.backgroundView = nil
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        
                    }
                    
                    return cell
                    
                }

            } else {

                if tags[indexPath.row - searchedTags.count].isContact == true && tags[indexPath.row - searchedTags.count].isPrivate == false {
                    
                    let cellID = tags[indexPath.row - searchedTags.count].title
                    var cell:ContactButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? ContactButtonTableViewCell
                    
                    if (cell == nil) {
                        
                        cell = ContactButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: tags[indexPath.row - searchedTags.count])
                        
                        cell.backgroundColor = UIColor.clearColor()
                        
                        cell.selectionStyle = .None
                        cell.backgroundView = nil
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        
                    }
                    return cell
                    
                }
                    //if it's a private tag -> pink dude
                else if (tags[indexPath.row - searchedTags.count].isContact == false && tags[indexPath.row - searchedTags.count].isPrivate == true) {
                    
                    let cellID = tags[indexPath.row - searchedTags.count].title
                    var cell:PrivateButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? PrivateButtonTableViewCell
                    
                    if (cell == nil) {
                        
                        cell = PrivateButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: tags[indexPath.row - searchedTags.count])
                        
                        cell.backgroundColor = UIColor.clearColor()
                        
                        cell.selectionStyle = .None
                        cell.backgroundView = nil
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        
                    }
                    return cell
                    
                }
                else{
                    
                    let cellID = tags[indexPath.row - searchedTags.count].title
                    var cell:TagButtonViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonViewCell
                    
                    if (cell == nil) {
                        
                        cell = TagButtonViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: tags[indexPath.row - searchedTags.count])
                        
                        cell.backgroundColor = UIColor.clearColor()
                        
                        cell.selectionStyle = .None
                        cell.backgroundView = nil
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        
                    }
                    return cell
                }
            }
        } else {
            
            let cellID = instructions[indexPath.row]
            var cell:InstructionsTableCellView! = tableView.dequeueReusableCellWithIdentifier(cellID) as? InstructionsTableCellView
            
            if (cell == nil) {
                
                cell = InstructionsTableCellView(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, title: instructions[indexPath.row])
                
                cell.backgroundColor = UIColor.clearColor()
                
                cell.selectionStyle = .None
                cell.backgroundView = nil
                cell.contentView.backgroundColor = UIColor.clearColor()
                
            }
            
            return cell
            
        }
        
    }
    
    func selectedTag(sender: UIButton!){
        
        done.highlighted = true
        
        if sender.backgroundColor != UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0){
            
            sender.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            
            sender.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
        }
    }
    
    
    func fitToSize(){
        
        addTag?.sizeToFit()
        addTagBackground.frame = CGRect(x: 10, y: 0, width: addTag.frame.size.width + 10, height:  addTag.frame.size.height + 5)
        
    }
    
    func fitToSizeDone(){
        
        done.sizeToFit()
        self.done.frame = CGRect(x: 10, y: self.frame.height - 40, width: self.done.frame.size.width + 10, height:  31)
        
    }
    
    func textFieldChanged(sender: UITextField!) {
        
        fitToSize()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var actualString: String! = ""
        
        if string == "" {
            
            actualString = textField.text.substringWithRange(Range<String.Index>(start: textField.text.startIndex, end: advance(textField.text.endIndex, -1)))
            
        } else {
            
            actualString = textField.text + string
        }
        
        if count(actualString) > 1{
            
            if (actualString as NSString).substringToIndex(1) == "@" {
                
                var newString = (actualString as NSString).substringFromIndex(1)
                
                if Contacts.objectsWhere("name CONTAINS[c] '\(newString)'").count > 0 {
                    let users = User.allObjects()
                    let user = users[UInt(0)] as! User
                    
                    self.searchedTags = []
                    
                    var length: UInt = Contacts.objectsWhere("name CONTAINS[c] '\(newString)' AND phone BEGINSWITH '1'").count
                    var cntcts = Contacts.objectsWhere("name CONTAINS[c] '\(newString)' AND phone BEGINSWITH '1'")
                    
                    for var i: UInt = 0; i < length; i++ {
                        
                        if (cntcts[i] as! Contacts).phone != user.phone {
                            
                            var tag = Tags(title: (cntcts[i] as! Contacts).name, isPrivate: false, isContact: true, phone: (cntcts[i] as! Contacts).phone, isSelected: false, count: 0, userCount: 0)
                            
                            searchedTags.append(tag)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
            else if (actualString as NSString).substringToIndex(1) == "#" {
                
                var newString = (actualString as NSString).substringFromIndex(1)
                
                if searchedTags.count > 0 {
                    
                    self.searchedTags[0].title = newString
                    
                } else {
                    
                    self.searchedTags.append(Tags(title: newString, isPrivate: true, isContact: false, phone: "", isSelected: false, count: 0, userCount: 0))
                }
                
                self.tableView.reloadData()
                
                
            }
            else {
                
                if searchedTags.count > 0 {
                    
                    self.searchedTags[0].title = actualString
                    
                } else {
                    
                    self.searchedTags.append(Tags(title: actualString, isPrivate: false, isContact: false, phone: "", isSelected: false, count: 0, userCount: 0))
                }
                
                self.tableView.reloadData()
                
            }
        }
            
        else {
            
            self.searchedTags = []
            self.tableView.reloadData()
            
        }
        
        return true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == tableView {
            
            addTag.resignFirstResponder()
            
        }
    }
    
    func singleTap(sender: UITapGestureRecognizer!){
        
        addTag.resignFirstResponder()
        
    }
    
    //API CALLS
    
    func setUpExistingTags(){
        
        var eventt: RLMResults = Event.objectsWhere("address = %@", self.mapClass.address)
        if ((Event.objectsWhere("address = %@", self.mapClass.address).count != 0) &&  eventt[0] != nil ){
            
            var tempTag = tags
            
            var event = eventt[0] as! Event
            
            for var x = 0; x < tags.count; x++ {

                if tags[x].isSelected == false{

                    tags.removeAtIndex(x)
                    x--
                }
                
            }
            for var i = 0; i < Int(event.tags.count); i++ {
            
                if tags.count > 0 {
                    
                    if (event.tags[UInt(i)].name as NSString).substringToIndex(1) == "#" {
                        
                        var newString = (event.tags[UInt(i)].name as NSString).substringFromIndex(1)
                        
                        self.tags.insert(Tags(title: newString, isPrivate: true, isContact: false, phone: "", isSelected: false, count: event.tags[UInt(i)].weight, userCount: 0), atIndex: 0)
                        
                    } else {
                        
                        self.tags.insert(Tags(title: event.tags[UInt(i)].name, isPrivate: false, isContact: false, phone: "", isSelected: false, count: event.tags[UInt(i)].weight, userCount: 0), atIndex: 0)
                        
                    }
                } else {
                    
                    if (event.tags[UInt(i)].name as NSString).substringToIndex(1) == "#" {
                        
                        var newString = (event.tags[UInt(i)].name as NSString).substringFromIndex(1)
                        
                        self.tags.append(Tags(title: newString, isPrivate: true, isContact: false, phone: "", isSelected: false, count: event.tags[UInt(i)].weight, userCount: 0))
                        
                    } else {
                        
                        self.tags.append(Tags(title: event.tags[UInt(i)].name, isPrivate: false, isContact: false, phone: "", isSelected: false, count: event.tags[UInt(i)].weight, userCount: 0))
                        
                    }
                    
                    
                }
                
            }
            
            tags.sort({$0.count > $1.count})

            self.tableView.reloadData()
            
        } else {
            
            //explanation.hidden = false
            
            
            
        }
        
        
        
    }
    
    func post()->Void {
        
        let users = User.allObjects()
        let user = users[UInt(0)] as! User
        
        let parameters = [
            "loc": [
                "type": "Point",
                "coordinates": [
                    self.mapClass.mapView.userLocation.coordinate.longitude,
                    self.mapClass.mapView.userLocation.coordinate.latitude
                ]
            ],
            "accuracy": self.mapClass.accuracy,
            "address": self.mapClass.address,
            "tag": selectedTags
        ]
        
        let URL = NSURL(string: "\(globalURL)/api/posts")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "POST"
        
        var JSONSerializationError: NSError? = nil
        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        
        print(parameters)
        
        Alamofire.request(mutableURLRequest).response {
            
            (request, response, data, error) -> Void in
            
            println("Requesttttt: \(request)")
            println("Responseeeee: \(response)")
            println("Dataaaa: \(data)")
            println("Erroreeee: \(error)")
            
            if error == nil {
                
                self.mapClass.mapView.showsUserLocation = true
                
                UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    self.alpha = 0.0
                    
                    }, completion: ({ success in
                        
                        self.mapClass.setUpVotes()
                        self.removeFromSuperview()
                        
                    }))
                
                
                
            }else {
                
                self.mapClass.mapView.showsUserLocation = true
                UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    self.alpha = 0.0
                    
                    }, completion: ({ success in
                        
                        self.removeFromSuperview()
                        
                    }))
                
                var error: String = "Error while posting tags! request: \(request), response: \(response), data: \(data), error: \(error),"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
                var alert: UIAlertView = UIAlertView(title: "Network Error", message: "You seem to have a bad connection.", delegate: self, cancelButtonTitle: "Close")
                //self.tableView.closeWindow(self.tableView)
                alert.dismissWithClickedButtonIndex(0, animated: true)
                alert.show()
                
            }
            
        }
        
    }
    
}
