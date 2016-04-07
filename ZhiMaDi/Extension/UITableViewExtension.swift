//
//  UITableViewExtension.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

extension UITableView {
    func addFootBtn(btnText : String,blockForCli : ((AnyObject!) -> Void)!) {
        let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 110))
        footView.backgroundColor = UIColor.clearColor()
        let btn = ZMDTool.getButton(CGRect(x: 12, y: 60, width: kScreenWidth - 24, height: 50), textForNormal: btnText, fontSize: 20, textColorForNormal: UIColor.whiteColor(), backgroundColor: RGB(235,61,61,1.0),blockForCli: blockForCli)
        ZMDTool.configViewLayerWithSize(btn, size: 25)
        footView.addSubview(btn)
        self.tableFooterView = footView
    }
}
