//
//  AppDelegate.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/1/14.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //应用未运行
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch")//用户第一次启动
        {
            print("用户第一次进入")
            //在本地创建所有的表
            MySQL.shareMySQL().initBoot()
            
            let login=LoginViewController()
            self.window?.rootViewController=login
            
            //开启通知
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound],
                                                      categories: nil)
            application.registerUserNotificationSettings(settings)

            self.window?.makeKeyAndVisible()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")
        }
        else
        {
            print("用户不是第一次进入")
            
            let login=LoginViewController()
            self.window?.rootViewController=login
            
            //开启通知
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound],
                                                      categories: nil)
            application.registerUserNotificationSettings(settings)
            self.window?.makeKeyAndVisible()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")
        }
        return true
    }

    
    //应用在正在运行(在前台或后台运行)，点击通知后触发appDelegate代理方法
    func application(application: UIApplication,
                     didReceiveLocalNotification notification: UILocalNotification) {
        //设定Badge数目.应用程序图标右上角显示的消息数
//        UIApplication.sharedApplication().applicationIconBadgeNumber = 1
//        
//        let info = notification.userInfo as! [String:Int]
//        let number = info["ItemID"]
//        
//        let alertController = UIAlertController(title: "本地通知",
//                                                message: "消息内容：\(notification.alertBody)用户数据：\(number)", preferredStyle: .Alert)
//        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
//                action in
//            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//        })
//        let okAction = UIAlertAction(title: "进入应用", style: .Default,
//                                     handler: {
//                                        action in
//                                        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        
//        self.window?.rootViewController!.presentViewController(alertController,
//                                                               animated: true, completion: nil)
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

