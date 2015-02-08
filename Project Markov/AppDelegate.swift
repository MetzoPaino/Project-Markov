//
//  AppDelegate.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    let dataModel = DataModel()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /*
        This is a new method on UIApplication introduced in iOS 8.
        When an app wants to receive push notifications for remote events,
        but doesn’t want to spam the user with lock-screen messages or in-app popups,
        this method requests the push token without needing to ask the user for permission.
        */
        application.registerForRemoteNotifications()

        
        
        
        
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        
        
        let masterNavigationController = splitViewController.viewControllers[splitViewController.viewControllers.count - 2] as UINavigationController
        let masterViewController = masterNavigationController.topViewController as ThemesViewController
        masterViewController.dataModel = dataModel
        
        
//        for view in masterNavigationController.viewControllers {
//            
//            println( "TypeName0 = \(_stdlib_getTypeName(view))")
//            
//            if view is ThemeTableViewController {
//
//            } else if view is MotifsViewController {
//
//            } else {
//
//            }
//        }
        
        splitViewController.delegate = self

//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        UINavigationBar.appearance().backgroundColor = UIColor.lightTextColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        saveData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        saveData()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("Registered for Push notifications with token: \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Push subscription failed: \(error)")
    }
    
    // MARK: - Save NSUserDefaults
    
    func saveData() {
        dataModel.saveData()
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? MotifsViewController {
                
                // returning false will make the app start on the second view
                return true
//                if topAsDetailController.detailItem == nil {
//                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//                    return true
//                }
            }
        }
        return true
    }
}

