//
//  QNStyleAttribute.swift
//  QooccShow
//
//  Created by LiuYu on 14/11/10.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

/** 此文件中放置整个App的风格属性，如默认背景色，导航栏颜色 */

import UIKit.UIColor

// MARK: - 颜色
/// App主色    
let appThemeColor = UIColor(red: 0/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1.0)

/// 默认背景色
let defaultBackgroundColor = UIColor(white: 1.0, alpha: 1.0)
/// 默认灰色背景
let defaultBackgroundGrayColor = UIColor(white: 249/255.0, alpha: 1.0)
/// 默认灰色
let defaultGrayColor = UIColor(white: 81/255.0, alpha: 1.0)
/// 默认的分割线颜色
let defaultLineColor = UIColor(white: 224/255.0, alpha: 1.0)

// MARK: 导航栏
/// 导航栏文本颜色
let navigationTextColor = UIColor(white: 1.0, alpha: 1.0)
/// 导航栏背景颜色
let navigationBackgroundColor = UIColor(red: 255/255.0, green: 136/255.0, blue: 0/255.0, alpha: 1.0)
/// 导航栏字体（titleView不允许被修改）
let navigationTextFont = UIFont.systemFontOfSize(16)


// MARK: - 统一的列表样式
//MARK:- 高度 & 宽度 缩放系数
let COEFFICIENT_OF_HEIGHT_ZOOM = kScreenHeight/568.0
let COEFFICIENT_OF_WIDTH_ZOOM = kScreenWidth/320.0
/// 默认高度
let tableViewCellDefaultHeight: CGFloat = 55.0
/// 默认背景色
let tableViewCellDefaultBackgroundColor = UIColor.whiteColor()
/// 默认内容字体
let tableViewCellDefaultTextFont = UIFont.systemFontOfSize(16)
/// 默认内容颜色
let tableViewCellDefaultTextColor = UIColor(white: 63/255.0, alpha: 1.0)
/// 默认详情字体
let tableViewCellDefaultDetailTextFont = UIFont.systemFontOfSize(14)
/// 默认详情颜色
let tableViewCellDefaultDetailTextColor = UIColor(white: 136/255.0, alpha: 1)
extension QNTool {
    /// 对UITableViewCell对象进行默认配置
    class func configTableViewCellDefault(cell: UITableViewCell) {
        cell.textLabel?.font = tableViewCellDefaultTextFont
        cell.textLabel?.textColor = tableViewCellDefaultTextColor
        cell.contentView.backgroundColor = tableViewCellDefaultBackgroundColor
        cell.detailTextLabel?.font = tableViewCellDefaultDetailTextFont
        cell.detailTextLabel?.textColor = tableViewCellDefaultDetailTextColor
    }
    /// 对UIView对象进行配置(cornerRadius)
    class func configViewLayer(view: UIView) {
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
    }
    ///对UIView对象进行配置(borderWidth、borderColor)
    class func configViewLayerFrame(view: UIView) {
        view.layer.borderWidth = 0.5
        view.layer.borderColor = defaultLineColor.CGColor
    }
}


