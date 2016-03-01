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
        
        // 启动过渡页
//        let allowShowStartPages = !NSUserDefaults.standardUserDefaults().boolForKey(kKeyIsFirstStartApp)
//        if allowShowStartPages {
//            UIApplication.sharedApplication().statusBarHidden = true
//            let startPagesWindow = StartPagesWindow()
//            startPagesWindow.finished = { () -> Void in
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kKeyIsFirstStartApp)
//            }
//        }
        // 开启拦截器
        ZMDInterceptor.start()
        return true
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

