//
//  UIImageExtension.swift
//  QooccShow
//
//  Created by LiuYu on 14/12/26.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit.UIImage

// MARK: - 创建一个颜色图片
extension UIImage {
    /**
    创建一个颜色图片
    
    :param: color 颜色
    :param: size  如果不设置，则为  ｛2， 2｝
    :returns: 返回图片，图片的scale为当前屏幕的scale
    */
    class func colorImage(color: UIColor) -> UIImage {
        return self.colorImage(color, size: CGSize(width: 2, height: 2))
    }
    
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFillUsingBlendMode(CGRectMake(0, 0, size.width, size.height), CGBlendMode.XOR)
        let cgImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext()
        return UIImage(CGImage: cgImage!).stretchableImageWithLeftCapWidth(1, topCapHeight: 1)
    }
    class func imageWithColor(color : UIColor,size : CGSize) -> UIImage{
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image!
    }
}
