//
//  QNTool.swift
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import Foundation
import UIKit
// 私有的实例，用户处理一些回调
private let qnToolInstance = QNTool()

/** 通用工具类 */
class QNTool: NSObject {
}

// MARK: - 提示框相关
extension QNTool {
    
    /**
    弹出会自动消失的提示框
    
    :param: message    提示内容
    :param: completion 提示框消失后的回调
    */
    class func showPromptView(message: String = "服务升级中，请耐心等待！", _ completion: (()->Void)? = nil) {
        lyShowPromptView(message, completion)
    }
    
    /**
    弹出进度提示框
    
    :param: message         提示内容
    :param: inView          容器，如果设置为nil，会放在keyWindow上
    :param: timeoutInterval 超时隐藏，如果设置为nil，超时时间是3min
    */
    class func showActivityView(message: String?, inView: UIView? = nil, _ timeoutInterval: NSTimeInterval? = nil) {
        lyShowActivityView(message, inView: inView, timeoutInterval)
    }
    
    /**
    隐藏进度提示框
    */
    class func hiddenActivityView() {
        lyHiddenActivityView()
    }
    
    /**
    显示错误提示
    
    优先显示服务器返回的错误信息，如果没有，则显示网络层返回的错误信息，如果在没有，则显示默认的错误提示
    
    :param: dictionary 服务器返回的Dic
    :param: error      网络层返回的error
    :param: errorMsg   服务器返回的错误信息
    */
    class func showErrorPromptView(dictionary: NSDictionary?, error: NSError?, errorMsg: String? = nil) {
        if errorMsg != nil {
            QNTool.showPromptView(errorMsg!); return
        }
        
        if let errorMsg = dictionary?["errorMsg"] as? String {
            QNTool.showPromptView(errorMsg); return
        }
        
        if error != nil && error!.domain.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            QNTool.showPromptView("网络异常，请稍后重试！"); return
        }
        
        QNTool.showPromptView()
    }
    
    
}

// MARK: - 增加空提示的View
private let kTagEmptyView = 96211
private let kTagMessageLabel = 96212
extension QNTool {
    
    /**
    为inView增加空提示
    
    :param: message    提示内容
    :param: inView     所依附的View
    */
    class func showEmptyView(message: String? = nil, inView: UIView?) {
        if inView == nil { return }
        
        //
        var emptyView: UIView! = inView!.viewWithTag(kTagEmptyView)
        if emptyView == nil {
            emptyView = UIView(frame: inView!.bounds)
            emptyView.backgroundColor = UIColor.clearColor()
            emptyView.tag = kTagEmptyView
            inView!.addSubview(emptyView)
        }
        
        // 设置提示
        if message != nil {
            let widthMax = emptyView.bounds.width - 40
            var messageLabel: UILabel! = emptyView.viewWithTag(kTagMessageLabel) as? UILabel
            if messageLabel == nil {
                messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widthMax, height: 20))
                messageLabel.tag = kTagMessageLabel
                messageLabel.textColor = tableViewCellDefaultDetailTextColor
                messageLabel.backgroundColor = UIColor.clearColor()
                messageLabel.textAlignment = .Center
                messageLabel.autoresizingMask = .FlexibleWidth
                messageLabel.numberOfLines = 0
                emptyView.addSubview(messageLabel)
            }
            
            messageLabel.text = message
            messageLabel.bounds = CGRect(origin: CGPointZero, size: messageLabel.sizeThatFits(CGSize(width: widthMax, height: CGFloat.max)))
            messageLabel.center = CGPoint(x: emptyView.bounds.width/2.0, y: emptyView.bounds.height/2.0)
        }
        else {
            emptyView.viewWithTag(kTagMessageLabel)?.removeFromSuperview()
        }
    }
    
    /**
    隐藏空提示
    
    :param: inView     所依附的View
    */
    class func hiddenEmptyView(forView: UIView?) {
        forView?.viewWithTag(kTagEmptyView)?.removeFromSuperview()
    }
    
    
}

// MARK: - 页面切换相关
extension QNTool {

    /**
    转场动画过渡
    
    :param: vc 将要打开的ViewController
    */
    class func enterRootViewController(vc: UIViewController, animated: Bool = true) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let animationView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            appDelegate.window?.addSubview(animationView)
            let changeRootViewController = { () -> Void in
                appDelegate.window?.rootViewController = vc
                if animated {
                    appDelegate.window?.bringSubviewToFront(animationView)
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        animationView.transform = CGAffineTransformMakeScale(3.0, 3.0)
                        animationView.alpha = 0
                        }, completion: { (finished) -> Void in
                            animationView.removeFromSuperview()
                    })
                }
                else {
                    animationView.removeFromSuperview()
                }
            }
            
            if let viewController = appDelegate.window?.rootViewController where viewController.presentedViewController != nil {
                viewController.dismissViewControllerAnimated(false) {
                    changeRootViewController()
                }
            }
            else {
                changeRootViewController()
            }
        }
    }
    
    /**
    进入登陆的控制器
    */
    class func enterLoginViewController() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
        QNTool.enterRootViewController(vc)
    }
    
    
}

// MARK: - 获得某个范围内的屏幕图像
extension QNTool {
    /// 获得 view 某个范围内的屏幕图像
    class func imageFromView(view: UIView, frame: CGRect) -> UIImageView {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        UIRectClip(frame)
        view.layer.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        return  imageView
    }
}


// MARK: - 判断当前网络状况
extension QNTool {
    /// 网络连接状态
    class func netWorkStatus() -> NetworkStatus {
        let netWorkStatic = Reachability.reachabilityForInternetConnection()
        netWorkStatic.startNotifier()
        return netWorkStatic.currentReachabilityStatus()
    }
}

// MARK: - 让 Navigation 支持右滑返回
extension QNTool: UIGestureRecognizerDelegate {
    
    /**
    让 Navigation 支持右滑返回
    
    :param: navigationController 需要支持的 UINavigationController 对象
    */
    class func addInteractive(navigationController: UINavigationController?) {
        navigationController?.interactivePopGestureRecognizer!.enabled = true
        navigationController?.interactivePopGestureRecognizer!.delegate = qnToolInstance
    }
    
    /**
    移除 Navigation 右滑返回
    
    :param: navigationController 需要支持的 UINavigationController 对象
    */
    class func removeInteractive(navigationController: UINavigationController?) {
        navigationController?.interactivePopGestureRecognizer!.enabled = false
        navigationController?.interactivePopGestureRecognizer!.delegate = nil
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let vc = topViewController() where gestureRecognizer == vc.navigationController?.interactivePopGestureRecognizer {
            return (vc.navigationController!.viewControllers.count > 1)
        }
        return false // 其他情况，则不支持
    }
    
    
}




