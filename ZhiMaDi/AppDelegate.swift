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
        
        self.configXGPush(launchOptions)
        
        // 开启推送服务
        ZMDPushTool.startPushTool(launchOptions)
        ZMDPushTool.clear()
        // 启动过渡页
//        let allowShowStartPages = !NSUserDefaults.standardUserDefaults().boolForKey(kKeyIsFirstStartApp)
//        if allowShowStartPages {
//            UIApplication.sharedApplication().statusBarHidden = true
//            let startPages = StartPagesWindow()
//            startPages.finished = { () -> Void in
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kKeyIsFirstStartApp)
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//                ZMDTool.enterRootViewController(vc)
//            }
//            window = UIWindow(frame: UIScreen.mainScreen().bounds)
//            window?.rootViewController = startPages
//            window?.makeKeyAndVisible()
//        }
        
        if let lastDate = getObjectFromUserDefaults("openDate") as? NSDate {
            let time = abs(lastDate.timeIntervalSinceNow)
            if time >= 2*24*60*60 {
                HYNetworkCache.clearCache()     //超过两天，清理首页缓存，(也可以在这里处理超过多少天忘记密码)
            }
        }
        let date = NSDate()
        saveObjectToUserDefaults("openDate", value: date)
        
        if let account = g_Account {
            if let password = g_Password {
                QNNetworkTool.loginAjax(account, Password: password, completion: { (success, error, dictionary) -> Void in
                    if success! {
                        
                    }else{
                        
                    }
                })
            }
        }
        
        // 开启拦截器
        ZMDInterceptor.start()
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        ZMDPushTool.clear()
        XGPush.clearLocalNotifications()
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
        
        XGPush.setAccount("JNNTAccount")    // 要在注册设备前调用,更改account要重新注册设备
        
        XG_DeviceToken = deviceToken
        let deviceTokenStr = XGPush.registerDevice(XG_DeviceToken, successCallback: { () -> Void in
            print("XGPush-registerDevice-succeed")
            }) { () -> Void in
                print("XGPush-registerDevice-failed")
        }
        print("deviceTokenStr:\(deviceTokenStr)")
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        BPush.handleNotification(userInfo)
        if (application.applicationState == UIApplicationState.Active || application.applicationState == UIApplicationState.Background) {
            ZMDTool.showPromptView("你有新的消息,请注意查收")
        }
        else//跳转到跳转页面。
        {
           
        }
        XGPush.handleReceiveNotification(userInfo)
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
    //客户端支付
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.host == "safepay" {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic) -> Void in
                
            })
        }
        return true
    }
    // @available(iOS 9.0, *)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if url.host == "safepay" {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic) -> Void in
                
            })
        }
        return true
    }
    
    //MARK: - PrivateMethod
    func configXGPush(launchOptions: [NSObject: AnyObject]?) {
        self.registerPushForIOS8()
        XGPush.startApp(UInt32((XG_AccessId as NSString).integerValue) , appKey: XG_AccessKey)
        let successCallBack = {()
            //如果变成需要注册状态
            /*if !XGPush.isUnRegisterStatus() {
            if __IPHONE_OS_VERSION_MAX_ALLOWED >= 8 {
            if (UIDevice.currentDevice().systemVersion.compare("8", options:.NumericSearch) != NSComparisonResult.OrderedAscending) {
            self.registerPushForIOS8()
            } else {
            self.registerPush()
            }
            }
            }*/
        }
        
        XGPush.initForReregister(successCallBack)
        XGPush.handleLaunching(launchOptions, successCallback: {
            print("[XGPush]--没运行-handleLaunching's successBlock/n/n")
            }) {
                print("[XGPush]--没运行-handleLaunching's errorBlock/n/n")
        }
    }
    
    func registerPushForIOS8() {
        //Types
        let types = UIUserNotificationType.Sound //| UIUserNotificationType.Alert | UIUserNotificationType.Badge
        
        //Actions
        let acceptAction = UIMutableUserNotificationAction()
        
        acceptAction.identifier = "ACCEPT_IDENTIFIER"
        acceptAction.title = "Accept"
        
        acceptAction.activationMode = UIUserNotificationActivationMode.Foreground
        
        acceptAction.destructive = false
        acceptAction.authenticationRequired = false
        
        
        //Categories
        let inviteCategory = UIMutableUserNotificationCategory()
        inviteCategory.identifier = "INVITE_CATEGORY";
        
        inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Default)
        inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Minimal)
        
        //let categories = NSSet(objects: inviteCategory)
        let categories = Set(arrayLiteral: inviteCategory)
        
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func registerPush(){
        UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Sound)
    }
    
    func configPushNotification(launchOptions:[NSObject:AnyObject]?) {
        guard let launchOptions = launchOptions else {
            return
        }
        let tabBarVC = self.window?.rootViewController as! UITabBarController
        tabBarVC.selectedIndex = 3
    }
}

