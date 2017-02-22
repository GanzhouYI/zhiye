//
//  MyNotification.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/6/2.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation

class MyNotification{
    
    static var MyNotify:MyNotification?
    static var predicate:dispatch_once_t = 0
    class func sharedMyNotification()->MyNotification?{
        
        dispatch_once(&predicate) { () -> Void in
            MyNotify = MyNotification()
        }
        return MyNotify
    }

    
    //发送通知消息
    func scheduleNotification(itemID:Int){
        //如果已存在该通知消息，则先取消
        cancelNotification(itemID)
        
        //创建UILocalNotification来进行本地消息通知
        let localNotification = UILocalNotification()
        //推送时间（设置为5秒以后）
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        //时区
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        //推送内容
        localNotification.alertBody = "来自hangge.com的本地消息"
        //声音
        localNotification.soundName = UILocalNotificationDefaultSoundName
        //额外信息
        localNotification.userInfo = ["ItemID":itemID]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    //取消通知消息
    func cancelNotification(itemID:Int){
        //通过itemID获取已有的消息推送，然后删除掉，以便重新判断
        let existingNotification = self.notificationForThisItem(itemID) as UILocalNotification?
        if existingNotification != nil {
            //如果existingNotification不为nil，就取消消息推送
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
        }
    }
    
    //通过遍历所有消息推送，通过itemid的对比，返回UIlocalNotification
    func notificationForThisItem(itemID:Int)-> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        for notification in allNotifications! {
            let info = notification.userInfo as! [String:Int]
            let number = info["ItemID"]
            if number != nil && number == itemID {
                return notification as UILocalNotification
            }
        }
        return nil
    }
}