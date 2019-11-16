//
//  AppDelegate.swift
//  Bitgrange
//
//  Created by Shravan K on 2/21/18.
//  Copyright © 2018 Bitgrange. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications


let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 180/255, alpha: 1)
let secondaryColor = UIColor(red: 52/255, green: 148/255, blue: 230/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if (error==nil){
                print("Successful Authorization!")
            }
        }
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Messaging.messaging().shouldEstablishDirectChannel = false
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    @objc func refreshToken(notification: NSNotification){
        let refreshToken = InstanceID.instanceID().token()!
        print("*** \(refreshToken) ***")
        fireBaseConnecter()
    }
    func fireBaseConnecter(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
}

