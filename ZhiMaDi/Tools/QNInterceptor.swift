//
//  QNInterceptor.swift
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import Foundation

private var g_ZMDInterceptor: ZMDInterceptor? = nil

// MARK: - 遵循此协议的将会拦截
/// 遵循此协议的将会拦截，基础拦截（其他拦截协议也是基于他的）
protocol ZMDInterceptorProtocol {}

/// 遵循此协议的 ViewController 会在 viewWillAppear(animated: Bool) 的时候显示导航栏
protocol ZMDInterceptorNavigationBarShowProtocol: ZMDInterceptorProtocol {}

/// 遵循此协议的 ViewController 会在 viewWillAppear(animated: Bool) 的时候隐藏导航栏
protocol ZMDInterceptorNavigationBarHiddenProtocol: ZMDInterceptorProtocol {}

/// 遵循此协议的 ViewController 会支持 IQKeyboardManager 键盘遮挡解决方案
protocol ZMDInterceptorKeyboardProtocol: ZMDInterceptorProtocol {}

/// 遵循此协议的 ViewController 会提供消息按扭
protocol ZMDInterceptorMsnProtocol: ZMDInterceptorProtocol {}

/// 遵循此协议的 ViewController 会提供更多按扭
protocol ZMDInterceptorMoreProtocol: ZMDInterceptorProtocol {}


/** 拦截器，拦截遵循了g_ZMDInterceptorProtocol 协议的类的实例 */
class ZMDInterceptor : NSObject {
    
    /// 开始拦截
    class func start() {
        if g_ZMDInterceptor == nil {
            g_ZMDInterceptor = ZMDInterceptor()
        }
    }
    
    /// 停止拦截
    class func stop() {
        g_ZMDInterceptor = nil
    }
    
    override init() {
        super.init()
        
        //MARK:- UIViewController
        //MARK: 拦截 UIViewController 的 loadView() 方法
        repeat {
            let block : @convention(block) (aspectInfo: AspectInfo) -> Void = { [weak self](aspectInfo: AspectInfo) -> Void in
                if let _ = self, let viewController = aspectInfo.instance() as? UIViewController {
                    // 设置统一的背景色
                    viewController.view.backgroundColor = defaultBackgroundColor
                    // 修改基础配置
                    viewController.edgesForExtendedLayout = UIRectEdge.None
                    
                    if let rootViewController = viewController.navigationController?.viewControllers.first where rootViewController != viewController {
                        if viewController is ZMDInterceptorProtocol {
                            viewController.configBackButton()
                        }
                        if viewController is ZMDInterceptorMsnProtocol {
                            viewController.configMsgButton()
                        }
                        if viewController is ZMDInterceptorMoreProtocol {
                            viewController.configMoreButton()
                        }
                    }
                }
            }
            do {
                try  UIViewController.aspect_hookSelector(Selector("loadView"), withOptions: AspectOptions.PositionAfter, usingBlock: unsafeBitCast(block, AnyObject.self))
            } catch {
                
            }
        } while(false)
        
        //MARK: 拦截 UIViewController 的 viewDidLoad() 方法
//        do { // 目前没有操作，所以不需要拦截
//            let block : @objc_block (aspectInfo: AspectInfo) -> Void = { [weak self](aspectInfo: AspectInfo) -> Void in
//                if let strongSelf = self, let viewController = aspectInfo.instance() as? UIViewController where viewController is g_ZMDInterceptorProtocol {
//                    // ...
//                }
//            }
//            UIViewController.aspect_hookSelector(Selector("viewDidLoad"), withOptions: AspectOptions.PositionBefore, usingBlock: unsafeBitCast(block, AnyObject.self), error: nil)
//        } while(false)
        
        //MARK: 拦截 UIViewController 的 viewWillAppear(animated: Bool) 方法
        repeat {
            let block : @convention(block) (aspectInfo: AspectInfo) -> Void = { [weak self](aspectInfo: AspectInfo) -> Void in
                if let _ = self, let viewController = aspectInfo.instance() as? UIViewController where viewController is ZMDInterceptorProtocol {
                    if viewController.navigationController != nil {
                        // 修改导航栏的显示和隐藏
                        if viewController is ZMDInterceptorNavigationBarShowProtocol {
                            viewController.navigationController?.setNavigationBarHidden(false, animated: true)
                        }
                        else if viewController is ZMDInterceptorNavigationBarHiddenProtocol {
                            viewController.navigationController?.setNavigationBarHidden(true, animated: true)
                        }
                        
                        // 键盘遮挡解决方案
                        if !(viewController is ZMDInterceptorKeyboardProtocol) {
//                            IQKeyboardManager.sharedManager().disableInViewControllerClass(viewController.classForCoder)
                        }
                        
                        // 修改导航栏&状态栏的样式
                        viewController.navigationController?.navigationBar.translucent = false // 关闭透明度效果
//                        UIApplication.sharedApplication().statusBarHidden = false
                        if viewController.navigationController!.viewControllers.count == 1{
//                            if viewController is BindingFamilyViewController || viewController is ForgetPasswordViewController{
//                                UIApplication.sharedApplication().statusBarStyle = .Default
//                                viewController.navigationController?.navigationBar.barTintColor = navigationTextColor
//                                viewController.navigationController?.navigationBar.tintColor = appThemeColor
//                                viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(18)]
//                                return
//                            }
//                            UIApplication.sharedApplication().statusBarStyle = .LightContent
//                            viewController.navigationController?.navigationBar.barTintColor = appThemeColor
//                            viewController.navigationController?.navigationBar.tintColor = navigationTextColor
//                            viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: navigationTextColor, NSFontAttributeName: UIFont.systemFontOfSize(18)]
                        }
                        else {
//                            UIApplication.sharedApplication().statusBarStyle = .Default
//                            viewController.navigationController?.navigationBar.barTintColor = navigationTextColor
                            viewController.navigationController?.navigationBar.tintColor = UIColor.blackColor()
//                            viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: appThemeColor, NSFontAttributeName: UIFont.systemFontOfSize(18)]
                        }
                    }
                }
            }
            do {
                try UIViewController.aspect_hookSelector(Selector("viewWillAppear:"), withOptions: AspectOptions.PositionBefore, usingBlock: unsafeBitCast(block, AnyObject.self))
            } catch {
                
            }
        } while(false)
        
        // MARK: 拦截 UIViewController 的 viewWillDisappear: 方法
        repeat {
            let block : @convention(block) (aspectInfo: AspectInfo) -> Void = { [weak self](aspectInfo: AspectInfo) -> Void in
                if let _ = self, let viewController = aspectInfo.instance() as? UIViewController where viewController is ZMDInterceptorProtocol {
                    viewController.view.endEditing(true)
                }
            }
            do {
                try UIViewController.aspect_hookSelector(Selector("viewWillDisappear:"), withOptions: AspectOptions.PositionBefore, usingBlock: unsafeBitCast(block, AnyObject.self))
            } catch {
                
            }
        } while(false)
        
        //MARK: 拦截 UIViewController 的 deinit 方法，  可测试类是否被释放
//        do {
//            let block : @objc_block (aspectInfo: AspectInfo) -> Void = { [weak self](aspectInfo: AspectInfo) -> Void in
//                if let strongSelf = self, let viewController = aspectInfo.instance() as? UIViewController {
//                    println("控制器被释放:\(viewController.debugDescription)")
//                }
//            }
//            UIViewController.aspect_hookSelector(Selector("dealloc"), withOptions: AspectOptions.PositionBefore, usingBlock: unsafeBitCast(block, AnyObject.self), error: nil)
//        } while(false)
    }
    
    
}