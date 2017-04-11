//
//  LocalNotification.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class LocalNotification: NSObject {
    
    static var locals: [UILocalNotification]? {
        return UIApplication.shared.scheduledLocalNotifications
    }
    
    //MARK:- 添加本地推送
    class func addNotification(withMessage message: String, withDeltaTimeInterval timeInterval: TimeInterval = 0, withId id: Int = 0) {
        
        let localNoti = UILocalNotification()                       //初始化一个通知
        
        let fireDate = Date().addingTimeInterval(timeInterval)      //通知的触发时间，例如即刻起15分钟后
        localNoti.fireDate = fireDate
        localNoti.timeZone = NSTimeZone.default                     //设置时区
        localNoti.alertBody = message                               //通知上显示的主题内容
        localNoti.soundName = UILocalNotificationDefaultSoundName   //收到通知时播放的声音，默认消息声音
        localNoti.alertAction = "打开FunSport"                       //待机界面的滑动动作提示
        localNoti.applicationIconBadgeNumber = locals == nil ? 1 : locals!.count + 1                    //应用程序图标右上角显示的消息数
        localNoti.userInfo = ["id": id, "name": "funsportValue"]    //通知上绑定的其他信息，为键值对        
        
        UIApplication.shared.scheduleLocalNotification(localNoti)   //添加通知到系统队列中，系统会在指定的时间触发
    }
    
    //MARK:- 通过通知上绑定的id来取消通知，其中id也是你在userInfo中存储的信息
    class func cancelLocalNotification(byId id: String) {
        
        if let localList = locals {
            for localNoti in localList {
                if let dict = localNoti.userInfo {
                    
                    if dict.keys.contains("id") && dict["id"] is String && (dict["id"] as! String) == id {
                        // 取消通知
                        UIApplication.shared.cancelLocalNotification(localNoti)
                    }
                }
            }
        }
    }
    
    class func cancelAllLocalNotifications(){
        UIApplication.shared.cancelAllLocalNotifications()
    }
}
