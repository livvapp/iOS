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
    var pointsNumber: Int! = 100
    
    //address bar at bottom
    var done: UIButton!
    
    var tableView: UITableView!
    
    var explanation: UIView!
    var pioneer: UILabel!
    
    //array for multiple tags
    var searchedTags: [Tags] = []
    var tags: [Tags] = []
    var selectedTags: [String] = []
    
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
        
        explanation = UIView(frame: CGRectMake(10, 41, self.frame.size.width-20, self.frame.size.height - 91))
        explanation.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        explanation.layer.cornerRadius = 2
        explanation.hidden = true
        self.addSubview(explanation)
        
        pioneer = UILabel(frame: CGRectMake(10, 10, explanation.frame.size.width-20, explanation.frame.size.height - 20))
        pioneer.backgroundColor = UIColor.clearColor()
        pioneer.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        pioneer.numberOfLines = 20
        pioneer.textAlignment = .Left
        pioneer.text = "You're first!\n\nSet the event trend by adding tags. The most popular tag will become the event name.\n\nUse @ to invite friends.\n\nUse # to create a private tag. Private tags are only shared with invites.\n\nTag wisely as you have limited points. Inviting friends, attending invites, and voting on correct tags will increase your point total."
        pioneer.sizeToFit()
        pioneer.textColor = UIColor.whiteColor()
        pioneer.layer.cornerRadius = 2
        explanation.addSubview(pioneer)
        
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
        }
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        explanation.hidden = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("tags count is: \(tags.count)")
        //println("searchedTags count is: \(searchedTags.count)")
        return tags.count + searchedTags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
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
                // if it's a normal tag -> cyan dude
            else{
                
                //println("cyan dude")
                
                let cellID = searchedTags[indexPath.row].title
                var cell:TagButtonViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonViewCell
                
                if (cell == nil) {
                    
                    cell = TagButtonViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    //println("cyan dudee")
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                
                return cell
                
            }
            
            // when a tag has been added and unadded it goes here
        } else {
            
            //if it's a contact -> yellow dude
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
                
                //println("try it out3")
                //println(tags[indexPath.row - searchedTags.count].isContact)
                //println(tags[indexPath.row - searchedTags.count].isPrivate)
                //println(tags[indexPath.row - searchedTags.count].title)
                //println(tags[indexPath.row - searchedTags.count].phone)
                
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
                
                //println("try it out4")
                
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
        println(addTagBackground.frame)
        
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
        
        //println("The textfield text is: \(textField.text)")
        //println("The textfield plus string is: \(textField.text + string)")
        //println("The string is: \(string)")
        //println(range)
        
        if string == "" {
            
            actualString = textField.text.substringWithRange(Range<String.Index>(start: textField.text.startIndex, end: advance(textField.text.endIndex, -1)))
            
        } else {
            
            actualString = textField.text + string
        }
        
        //println("actual string \(actualString)")
        
        if count(actualString) > 1{
            
            if (actualString as NSString).substringToIndex(1) == "@" {
                
                var newString = (actualString as NSString).substringFromIndex(1)
                
                if Contacts.objectsWhere("name CONTAINS[c] '\(newString)'").count > 0 {
                    
                    self.searchedTags = []
                    
                    var length: UInt = Contacts.objectsWhere("name CONTAINS[c] '\(newString)' AND phone BEGINSWITH '1'").count
                    ////println(length)
                    var cntcts = Contacts.objectsWhere("name CONTAINS[c] '\(newString)' AND phone BEGINSWITH '1'")
                    
                    for var i: UInt = 0; i < length; i++ {
                        
                        //check if it already a selected tag
                        
                        //println((cntcts[i] as Contacts).phone)
                        
                        var tag = Tags(title: (cntcts[i] as! Contacts).name, isPrivate: false, isContact: true, phone: (cntcts[i] as! Contacts).phone, isSelected: false, count: 0, userCount: 0)
                        
                        searchedTags.append(tag)
                        
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
            else if (actualString as NSString).substringToIndex(1) == "#" {
                
                //println("try it out")
                
                var newString = (actualString as NSString).substringFromIndex(1)
                
                if searchedTags.count > 0 {
                    
                    self.searchedTags[0].title = newString
                    
                } else {
                    
                    self.searchedTags.append(Tags(title: newString, isPrivate: true, isContact: false, phone: "", isSelected: false, count: 0, userCount: 0))
                }
                
                self.tableView.reloadData()
                
                
            }
            else {
                
                //println("try it out2")
                
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
        
        println("TAPPPPPP")
        addTag.resignFirstResponder()
        
    }
    
    //API CALLS
    
    func setUpExistingTags(){
        
        //disable the button
        
        println(self.mapClass.userLocation.coordinate.latitude)
        println(self.mapClass.userLocation.coordinate.longitude)
        
        var eventt: RLMResults = Event.objectsWhere("address = %@", self.mapClass.address)
        if ((Event.objectsWhere("address = %@", self.mapClass.address).count != 0) &&  eventt[0] != nil ){
            
            var tempTag = tags
            
            //loop through and look for selected Tags only
            
            
            var event = eventt[0] as! Event
            
            for var x = 0; x < tags.count; x++ {
                println("tag: \(tags[x].title)")
                println("selection: \(tags[x].isSelected)")
                if tags[x].isSelected == false{
                    println("removed: \(tags[x].title)")
                    tags.removeAtIndex(x)
                    x--
                }
                
            }
            for var i = 0; i < Int(event.tags.count); i++ {
                
                //this if statement counteracts when the array is empty and we don't want to insert at position 0
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
            //println(tags)
            self.tableView.reloadData()
            
        } else {
            
            explanation.hidden = true
            
            
            
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
                
                //close window
                
                self.mapClass.mapView.showsUserLocation = true
                println("success")
                
                self.removeFromSuperview()
                
            }else {
                
                self.mapClass.mapView.showsUserLocation = true
                self.removeFromSuperview()
                
                var alert: UIAlertView = UIAlertView(title: "Network Error", message: "You seem to have a bad connection.", delegate: self, cancelButtonTitle: "Close")
                //self.tableView.closeWindow(self.tableView)
                alert.dismissWithClickedButtonIndex(0, animated: true)
                alert.show()
                println("there was an error")
                
                
            }
            
        }
        
    }
    
}
