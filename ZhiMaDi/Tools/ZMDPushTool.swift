//
//  QNPushTool.swift
//  QooccHealth
//
//  Created by LiuYu on 15/4/23.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import Foundation

private let bPushTool = ZMDPushTool()

/// JPush收到消息的通知
let QNNotificationReceviedMessage = "QNNotificationReceviedMessage"

/** 极光推送接受管理器 */
class ZMDPushTool : NSObject {
    var launchOptions : [NSObject: AnyObject]?
    /// 开启极光推送数据的监听
    class func startPushTool(launchOptions: [NSObject: AnyObject]?) {
        bPushTool
        bPushTool.launchOptions = launchOptions
    }
    
    /// 清零
    class func clear() {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override init() {
        super.init()
        // 向系统注册推送
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            //可以添加自定义categories
            //3.创建UIUserNotificationSettings，并设置消息的显示类类型
            let userSetting = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge , UIUserNotificationType.Sound ,UIUserNotificationType.Alert]
                , categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userSetting)
        }

        // 百度推送配置 （测试模式）
        BPush.registerChannel(launchOptions, apiKey: "2Dz0DIkA7RduxKb0oltxo11I", pushMode: BPushMode.Development, withFirstAction: nil, withSecondAction: nil, withCategory: nil, isDebug: true)
        //       // App 是用户点击推送消息启动
        if launchOptions != nil {
            if let userInfo = launchOptions!["UIApplicationLaunchOptionsRemoteNotificationKey"] {
                BPush.handleNotification(userInfo as! [NSObject : AnyObject])
            }
        }
    }
}