//
//  UIViewControllerExtension.swift
//  QooccShow
//
//  Created by LiuYu on 14/11/3.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit

//MARK:- 为 UIViewController ... 扩展一个公有的从storyboard构建的方法
extension UIViewController {
    //MARK: 从 Main.storyboard 初始化一个当前类
    // 从 Main.storyboard 中创建一个使用了当前类作为 StoryboardID 的类
    public class func CreateFromMainStoryboard() ->  AnyObject! {
        return self.CreateFromStoryboard("Main")
    }
    
    //MARK: 从 storyboardName.storyboard 初始化一个当前类
    // 从 storyboardName.storyboard 中创建一个使用了当前类作为 StoryboardID 的类
    public class func CreateFromStoryboard(name: String) -> AnyObject! {
        let classFullName = NSStringFromClass(self.classForCoder())
        let className = classFullName.componentsSeparatedByString(".").last as String! 
        let mainStoryboard = UIStoryboard(name: name, bundle:nil)
        return mainStoryboard.instantiateViewControllerWithIdentifier(className)
    }
    
    
}

//MARK:- 为 UIViewController ... 扩展一个 返回功能
extension UIViewController {
    @IBAction func back() {
        if let navigationController = self.navigationController where (navigationController.viewControllers.first) != self {
            navigationController.popViewControllerAnimated(true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        }
    }
    @IBAction func gotoMsg() {
        if let navigationController = self.navigationController where (navigationController.viewControllers.first) != self {
                navigationController.popViewControllerAnimated(true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        }
    }
}

//MARK:- 为 UIViewController ... 提供一个标准的导航栏返回按钮配置
extension UIViewController {
    public func configBackButton() {
        let item = UIBarButtonItem(image: UIImage(named: "Navigation_Back")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("back"))
        item.customView?.tintColor = UIColor.blackColor()
        
        self.navigationItem.leftBarButtonItem = item
    }
    public func configMsgButton() {
        let item = UIBarButtonItem(image: UIImage(named: "Navi_Msg")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("back"))
        item.customView?.tintColor = UIColor.blackColor()
        
        self.navigationItem.rightBarButtonItem = item
    }
    public func configMoreButton() {
        let item = UIBarButtonItem(image: UIImage(named: "Msn_More")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("back"))
        item.customView?.tintColor = UIColor.blackColor()
        
        self.navigationItem.rightBarButtonItem = item
    }
}