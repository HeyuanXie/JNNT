//
//  UIViewExtension.swift
//  QooccHealth
//
//  Created by LiuYu on 15/4/25.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import UIKit

private let kTagBadgeLabel = 20087


/**
*  @author LiuYu, 15-04-25 15:04:25
*
*  做一个有BadgeValue的扩展，默认的显示位置是在右上角
*/
extension UIView {
    /// 设置BadgeValue的值和位置,  nil: 隐藏，  "": 小红点， "str": 显示str
    var badgeValue: String? {
        get {
            return (self.viewWithTag(kTagBadgeLabel) as? UILabel)?.text
        }
        set {
            if newValue == nil { // 当设置nil的时候，删除所有相关的View
                self.viewWithTag(kTagBadgeLabel)?.removeFromSuperview()
            }
            else {
                let offsetTop: CGFloat = 10
                let offsetRight: CGFloat = 10
                let height: CGFloat = 18
                self.clipsToBounds = false
                var badgeLabel: UILabel! = self.viewWithTag(kTagBadgeLabel) as? UILabel
                if badgeLabel == nil {
                    badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: offsetTop*2, height: offsetRight*2))
                    badgeLabel.tag = kTagBadgeLabel
                    badgeLabel.autoresizingMask = .FlexibleLeftMargin
                    badgeLabel.textColor = UIColor.whiteColor()
                    badgeLabel.backgroundColor = UIColor(red: 251/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
                    badgeLabel.textAlignment = .Center
                    badgeLabel.layer.masksToBounds = true
                    badgeLabel.font = UIFont.systemFontOfSize(14)
                    self.addSubview(badgeLabel)
                }
                
                if newValue != "" { // 当设置str的时候，显示str
                    badgeLabel.text = newValue!
                    badgeLabel.sizeToFit()
                    badgeLabel.bounds = CGRect(origin: CGPointZero, size: CGSize(width: max(height, badgeLabel.bounds.width + 10/*增加一个偏移值*/), height: height))
                }
                else { // 当设置""的时候，显示小红点
                    badgeLabel.text = newValue!
                    badgeLabel.bounds = CGRect(origin: CGPointZero, size: CGSize(width: 10, height: 10))
                }
                badgeLabel.layer.cornerRadius = badgeLabel.bounds.height/2.0
                badgeLabel.frame = CGRect(origin: CGPoint(x: self.bounds.width - offsetRight - badgeLabel.bounds.height/2.0, y: offsetTop - badgeLabel.bounds.height/2.0), size: badgeLabel.bounds.size)
            }
        }
    }
    
    /**
    设置BadgeValue的值和位置
    
    :param: badgeValue 值
    :param: center     中心点位置
    */
    func setBadgeValue(badgeValue: String?, center: CGPoint) {
        self.badgeValue = badgeValue
        self.viewWithTag(kTagBadgeLabel)?.center = center
    }
}
//方便自定义窗口弹出
extension UIView {
    func showAsPop() {
        let frontToBackWindows = UIApplication.sharedApplication().windows.reverse()
        for window in frontToBackWindows {
            let windowOnMainScreen = window.screen == UIScreen.mainScreen()
            let windowIsVisible = !window.hidden && window.alpha > 0
            let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                window.addSubview(self)
                break
            }
        }
        self.layer.opacity = 0.5;
        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) //半透明色值
            self.layer.opacity = 1.0
            self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }) { (finished) -> Void in
        }
    }
    func hideAsPop() {
        UIView.animateWithDuration(0.15, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseIn , UIViewAnimationOptions.AllowUserInteraction], animations: { () -> Void in
            self.alpha = 0
            self.transform = CGAffineTransformScale(self.transform, 0.8,0.8);
            }) { (finished) -> Void in
                self.canPerformAction(Selector("removeFromSuperview"), withSender: self)
        }
    }
}
//各种基本设置
extension UIView {
    func getLabel() -> UILabel{
        let label = UILabel(frame: CGRect.zero)
        label.text = ""
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(10)
        label.textAlignment = .Center
        return label
    }
}
