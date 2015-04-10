//
//  AppDelegate.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm

let globalURL: String! = "http://livv.net"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        println("debug")
        // Override point for customization after application launch.
        
        // Inside your application(application:didFinishLaunchingWithOptions:)
        
        // Notice setSchemaVersion is set to 1, this is always set manually. It must be
        // higher than the previous version (oldSchemaVersion) or an RLMException is thrown
        RLMRealm.setSchemaVersion(1, forRealmAtPath: RLMRealm.defaultRealmPath(),
            withMigrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        // now that we have called `setSchemaVersion:withMigrationBlock:`, opening an outdated
        // Realm will automatically perform the migration and opening the Realm will succeed
        // i.e. RLMRealm.defaultRealm()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        
        var user: RLMResults = User.allObjects()
        
        if (user.count == 0) {
            
            LoginOrDrawerController(frame: self.window!.frame).setLog(self.window)
            
        }
        else if (!(user[0] as! User).complete) {
            
            LoginOrDrawerController(frame: self.window!.frame).setLog(self.window)
        }
        else {
            
            LoginOrDrawerController(frame: self.window!.frame).root(self.window)
            
        }
        return true
    }
    
    func switchToLogin() -> Void {
        
        LoginOrDrawerController().setLog(self.window)
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        println("Did enter background")
        exit(0)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

