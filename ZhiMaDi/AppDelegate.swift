//
//  AppDelegate.swift
//  ZhiMaDi
//
//  Created by caichong on 16/2/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
/// 第一次启动判断的Key
let kKeyIsFirstStartApp = ("IsFirstStartApp" as NSString).encrypt(g_SecretKey)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("\n<\(APP_NAME)> 开始运行\nversion: \(APP_VERSION)(\(APP_VERSION_BUILD))\nApple ID: \(APP_ID)\nBundle ID: \(APP_BUNDLE_ID)\n")
        // 修改统一的字体
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : navigationTextFont], forState: .Normal)
        //配置分享
        ZMDShareSDKTool.startShare()
        
        // 开启推送服务
        ZMDPushTool.startPushTool(launchOptions)
        ZMDPushTool.clear()
        // 启动过渡页
        let allowShowStartPages = !NSUserDefaults.standardUserDefaults().boolForKey(kKeyIsFirstStartApp)
        if allowShowStartPages {
            UIApplication.sharedApplication().statusBarHidden = true
            let startPages = StartPagesWindow()
            startPages.finished = { () -> Void in
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kKeyIsFirstStartApp)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                ZMDTool.enterRootViewController(vc)
            }
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window?.rootViewController = startPages
            window?.makeKeyAndVisible()
        }
        
        // 开启拦截器
        ZMDInterceptor.start()
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        ZMDPushTool.clear()
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
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        BPush.registerDeviceToken(deviceToken)
        BPush.bindChannelWithCompleteHandler { (result, error) -> Void in
            //回调中看获得channnelid appid userid
        }
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        BPush.handleNotification(userInfo)
        if (application.applicationState == UIApplicationState.Active || application.applicationState == UIApplicationState.Background) {
            ZMDTool.showPromptView("收到一条消息")
        }
        else//跳转到跳转页面。
        {
           
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.NewData)
        if (application.applicationState == UIApplicationState.Active || application.applicationState == UIApplicationState.Background) {
            ZMDTool.showPromptView("收到一条消息")
        }
        else//跳转到跳转页面。
        {
            
        }
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("DeviceToken 获取失败，原因：\(error)")
    }
}

