//
//  CreateUsernameView.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Alamofire
import Realm

class CreateUsernameView: UIView,  UITextFieldDelegate {
    
    var usernameTextField: UITextField!
    var submittedTag: String!
    var mapClass: MapViewController!
    var usernameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        usernameTextField = nil
        submittedTag = nil
        mapClass = nil
        usernameLabel = nil
        
        println("CreateUseranemView deinit complete")
    }
    
    func createView(){
        
        //edit the view
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 2
        
        //create the textfield on the view
        usernameTextField = UITextField(frame: CGRectMake(5, self.frame.size.height-110, self.frame.size.width-10, 50))
        usernameTextField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        usernameTextField.placeholder = "Username"
        usernameTextField.textAlignment = NSTextAlignment.Center
        usernameTextField.keyboardType = UIKeyboardType.NamePhonePad
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        usernameTextField.returnKeyType = UIReturnKeyType.Done
        usernameTextField.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        usernameTextField.delegate = self
        self.addSubview(usernameTextField)
        
        //create the 'Create' button
        var usernameCreate: UIButton = UIButton(frame: CGRectMake(5, self.frame.size.height-55, self.frame.size.width-10, 50))
        usernameCreate.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        usernameCreate.setTitle("Create", forState: UIControlState.Normal)
        usernameCreate.addTarget(self, action: "create:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(usernameCreate)
        
        usernameLabel = UILabel(frame: CGRectMake(5, 0, self.frame.size.width-10, 40))
        usernameLabel.text = "Enter Your Name"
        usernameLabel.font = UIFont(name: "HelveticaNeue-Light",
            size: 22.0)
        usernameLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(usernameLabel)
        
        var usernameExplanationLabel: UILabel = UILabel(frame: CGRectMake(20, 27, self.frame.size.width-40, 30))
        usernameExplanationLabel.text = "Help your friends identify invites."
        usernameExplanationLabel.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        usernameExplanationLabel.numberOfLines = 2
        usernameExplanationLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(usernameExplanationLabel)
        
    }
    
    //animation functions
    
    func closeWindow(renderView: MapViewController){
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.frame = CGRectMake(50, self.mapClass.view.frame.height, self.mapClass.view.frame.size.width-100, 170)
            
            }, completion: ({ success in
                
                self.endEditing(true)
                //self.removeFromSuperview()
                
                println("success")
            }))
        
    }
    
    func openWindow(renderView: MapViewController){
        
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.frame =  CGRectMake(50, (renderView.view.frame.height - 216)/2 - 85, renderView.view.frame.size.width - 100, 170)
            
            }, completion: ({ success in
                
                println("Window did appear")
                //self.usernameTextField.becomeFirstResponder()
                //self.submittedTag = tag
                self.mapClass = renderView
                
            }))
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //println("Text field working")
        if (usernameTextField.text != "" && usernameTextField.text != nil){
            
            //self.removeFromSuperview()
            submitUsername()
            
            return false
            
        }
        println("Text field ain't working")
        return true
    }
    
    func create(sender: UIButton!){
        
        submitUsername()
        
    }
    
    func submitUsername() {
        
        let users = User.allObjects()
        let user = users[UInt(0)] as! User
        
        
        let parameters = [
            "username": usernameTextField.text
        ]
        
        let URL = NSURL(string: "\(globalURL)/api/users/me/username")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "POST"
        
        var JSONSerializationError: NSError? = nil
        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        
        print(parameters)
        
        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<201).response {
            
            (request, response, data, error) -> Void in
            
            println("Request from username post: \(request)")
            println("Reponse from username post: \(response)")
            println("Data from username post: \(data)")
            println("Error from username post: \(error)")
            
            if error == nil {
                self.closeWindow(self.mapClass)
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                user.username = self.usernameTextField.text
                realm.commitWriteTransaction()
                
                println("The user is: \(user.username)")
                println("The token is: \(user.token)")
                println("The phone is: \(user.phone)")
                println("The lastTag is: \(user.lastTag)")
                println("it works")
                
                self.mapClass.tableView = TagSelectorView(frame: CGRectMake(0, 72, self.mapClass.view.frame.width, self.mapClass.view.frame.height - 72), mapClass: self.mapClass)
                self.mapClass.view.addSubview(self.mapClass.tableView)
                
                self.removeFromSuperview()
                //close window
                //show bottom screen button
                
            }else {
                
                var error: String = "Error while creating username! request: \(request), response: \(response), data: \(data), error: \(error)"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
                self.usernameLabel.text = "Oops! Try Again!"
                self.usernameLabel.textColor = UIColor.redColor()
                
            }
            
        }
        
        
    }
    
    
    
}
