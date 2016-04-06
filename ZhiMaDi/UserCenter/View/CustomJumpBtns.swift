//
//  CustomJumpBtns.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/30.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 自定义多个btn的View  有个下标线
class CustomJumpBtns: UIView {
    var selectBtn : UIButton!
    var menuTitle:[String]!
    var finished : ((index:Int)->Void)!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect,menuTitle:[String]) {
        self.menuTitle = menuTitle
        super.init(frame: frame)
        self.updateUI(self.menuTitle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateUI(menuTitle:[String]) {
        let redLine = ZMDTool.getLine(CGRect(x: 0, y: CGRectGetHeight(self.frame) - 2, width: kScreenWidth/CGFloat(menuTitle.count), height: 2))
        redLine.backgroundColor = RGB(235,61,61,1.0)
        self.addSubview(redLine)
        var i = 0
        let width = kScreenWidth/CGFloat(menuTitle.count),height = CGRectGetHeight(self.frame) - 3.5
        let SetSelectBtn = { (btn : UIButton) in
            self.selectBtn = btn
            self.selectBtn.selected = true
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                redLine.frame = CGRect(x: CGRectGetMinX(self.selectBtn.frame), y: CGRectGetHeight(self.frame) - 3.5, width: width, height: 3.5)
            })
            if self.finished != nil {
                self.finished(index: btn.tag - 1000)
            }
        }
        for title  in menuTitle {
            let x = CGFloat(i) * width
            let btn = ZMDTool.getButton(CGRect(x: x, y: 0, width: width, height: height), textForNormal: title, fontSize: 14, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                self.selectBtn.selected = false
                SetSelectBtn(sender as! UIButton)
            })
            btn.setTitle(title, forState: .Selected)
            btn.setTitleColor(RGB(235,61,61,1.0), forState: .Selected)
            btn.titleLabel?.numberOfLines = 2
            btn.titleLabel?.textAlignment = .Center
            btn.tag = 1000 + i
            self.addSubview(btn)
            if i == 0{
                SetSelectBtn(btn)
            }
            i++
        }
    }
    // 分割线
    func addSeparatedLine() {
        let width = kScreenWidth/CGFloat(menuTitle.count)
         var i = 0
        for _ in menuTitle {
            let line = ZMDTool.getLine(CGRect(x: width*CGFloat(i), y:(self.frame.height-25)/2, width:0.5, height:25))
            line.backgroundColor = defaultLineColor
            self.addSubview(line)
            i++
        }
       
    }
}
