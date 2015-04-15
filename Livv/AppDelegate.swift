//
//  AppDelegate.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm
import LogglyLogger_CocoaLumberjack
import CocoaLumberjack
import Fabric
import Crashlytics
import Parse
import Bolts

let ddLogLevel:DDLogLevel = DDLogLevel.Verbose

let globalURL: String! = "https://livv.net"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        var loggly: LogglyLogger = LogglyLogger()
        loggly.logFormatter = LogglyFormatter()
        loggly.logglyKey = "3b05e407-4548-47ca-bc35-69696794ea62"
        
        var lfields: LogglyFields = LogglyFields()
        var lformatter: LogglyFormatter! = LogglyFormatter(logglyFieldsDelegate: lfields)
        
        loggly.logFormatter = lformatter
        
        loggly.saveInterval = 45
        
        DDLog.addLogger(loggly)
        //DDLog.addLogger(CrashlyticsLogger())

        DDLogVerbose("App did launching with options", level: ddLogLevel, asynchronous: true)
        
        Fabric.with([Crashlytics()])
        
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
        
        Parse.setApplicationId("TFSEFv9UAXROm6HyFRoomYfvRaPc59pdQxZ97ItC",
            clientKey: "4gV8mMvwWMXiTUTeqkBSyGu9dLMn7ANG6DN5QZyZ")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
        
            application.registerForRemoteNotifications()
        } 
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        
        var user: RLMResults = User.allObjects()
        
        if (user.count == 0) {
            
            LoginOrDrawerController(frame: self.window!.frame).setLog(self.window)
            
        }
        else if (!(user[0] as! User).complete) {
            
            LoginOrDrawerController(frame: self.window!.frame).setLog(self.window)
        }
        else {
            DDLogVerbose((user[0] as! User).username, level: ddLogLevel, asynchronous: true)
            lfields.userid = (user[0] as! User).username
            LoginOrDrawerController(frame: self.window!.frame).root(self.window)
            
        }
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
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

