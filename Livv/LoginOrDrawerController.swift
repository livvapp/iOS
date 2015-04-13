//
//  LoginOrDrawerController.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm

public class LoginOrDrawerController: UIWindow {
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    //private var newWindow: UIWindow!
    private var drawerController: DrawerController!

    //LOGIN
    public func setLog(win: UIWindow!){
        self.setLogin(win)
        
    }
    //MAP
    public func root(window: UIWindow!){
        self.changeRoot(window)
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeRoot(window: UIWindow!){
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.getContactNames()
        }
        
        window.rootViewController = getDrawer(window)
        
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        
        
        
    }
    
    public func setLogin(window: UIWindow!){

        
        window.tintColor = UIColor.whiteColor()
        
        window.rootViewController = SignUpLoginViewController(window: window)
        
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        
    }
    
    public func getDrawer(window: UIWindow!) -> DrawerController{
        
        let leftSideDrawerViewController = SettingsViewController()
        let centerViewController = MapViewController()
        let rightSideDrawerViewController = TheListiewController()

        
        let navigationController = UINavigationController(rootViewController: centerViewController)
        navigationController.restorationIdentifier = "MapViewCenterControllerRestorationKey"
        
        let rightSideNavController = UINavigationController(rootViewController: rightSideDrawerViewController)
        rightSideNavController.restorationIdentifier = "TheListiewRightControllerRestorationKey"
        
        let leftSideNavController = UINavigationController(rootViewController: leftSideDrawerViewController)
        leftSideNavController.restorationIdentifier = "SettingsViewLeftControllerRestorationKey"
        
        drawerController = DrawerController(centerViewController: navigationController, leftDrawerViewController: leftSideNavController, rightDrawerViewController: rightSideNavController)
        
        self.drawerController.showsShadows = false
        
        self.drawerController.restorationIdentifier = "Drawer"
        
        self.drawerController.maximumRightDrawerWidth = window.frame.width
        self.drawerController.maximumLeftDrawerWidth = window.frame.width
        self.drawerController.openDrawerGestureModeMask = .All
        self.drawerController.closeDrawerGestureModeMask = .All
        
        
        return drawerController
        
    }
    
    //ADDRESS BOOK ACCESS FOR FRIENDS
    //update the many cases of contacts in the future
    
    func getContactNames() {
        
        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            if success {
                
                let users = User.allObjects()
                let user = users[UInt(0)] as! User
                
                if let people = swiftAddressBook?.allPeople {
                    for person in people {
                        //                        NSLog("%@", person.names?.map( {$0.value} ))
                        
                        if (person.firstName != nil){
                            
                            let name: String!
                            
                            if person.lastName != nil {
                                
                                name = "\(person.firstName as String!) \(person.lastName as String!)"
                                
                            }
                            else {
                                name = "\(person.firstName as String!)"
                                
                            }
                            
                            if let personNumbers = person.phoneNumbers {
                                let numbers = (personNumbers.map {number in "\(number.value)"})
                                
                                let personNumber = personNumbers[0]
                                let characterSet = NSCharacterSet(charactersInString: "()-+ ")
                                var phone = (personNumber.value.componentsSeparatedByCharactersInSet(characterSet) as NSArray).componentsJoinedByString("")
                                if !phone.hasPrefix("1") {
                                    phone = ("1\(phone)")
                                }
                                
                                if count(phone) == 11 {
                                    
                                    if (Contacts.objectsWhere("phone = '\(phone)'").count < 1 && phone != user.phone) {
                                        
                                        let contact = Contacts()
                                        let realm = RLMRealm.defaultRealm()
                                        realm.beginWriteTransaction()
                                        contact.name = name
                                        contact.phone = phone
                                        realm.addObject(contact)
                                        realm.commitWriteTransaction()
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
            }
            else {
                DDLogVerbose("Contact books were not accessed", level: ddLogLevel, asynchronous: true)
            }
        })
        
    }
    
}


