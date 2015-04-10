//
//  LoginOrDrawerController.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import DrawerController

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
        
        self.drawerController.maximumRightDrawerWidth = 375-150
        self.drawerController.maximumLeftDrawerWidth = 375-150
        self.drawerController.openDrawerGestureModeMask = .All
        self.drawerController.closeDrawerGestureModeMask = .All
        
        
        return drawerController
        
    }
    
}


