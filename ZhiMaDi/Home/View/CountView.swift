//
//  CountView.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 用于商品数量选择  --View
class CountView: UIView {
    
    var countForBounghtLbl : UIButton!
    var countForBounght = 0
    var finished:((count:Int)->Void)!
    override init(frame:CGRect) {
        super.init(frame: frame)
        var titles = ["-","0","+"],i=0
        for title in titles {
            let btn = UIButton(frame: CGRect(x: 40*i, y: 0, width: 40, height: 40))
            if title == "0" {
                self.countForBounghtLbl = btn
            }
            btn.titleLabel?.font = defaultSysFontWithSize(15)
            btn.setTitle(title, forState: .Normal)
            btn.setTitleColor(defaultTextColor, forState: .Normal)
            btn.tag = 1000+i
            self.addSubview(btn)
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                if (btn.tag - 1000) == 0 && self.countForBounght != 0 {
                    self.countForBounght--
                } else if (btn.tag - 1000) == 2 {
                    self.countForBounght++
                }
                self.countForBounghtLbl.setTitle("\(self.countForBounght)", forState: .Normal)
                self.finished(count: self.countForBounght)
            })
            i++
        }
        self.addSubview(ZMDTool.getLine(CGRect(x: 40, y: 0, width: 0.5, height: 40)))
        self.addSubview(ZMDTool.getLine(CGRect(x: 80, y: 0, width: 0.5, height: 40)))

        ZMDTool.configViewLayerFrame(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
