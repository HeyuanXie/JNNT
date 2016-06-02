//
//  ZMDAttrView.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/31.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 产品详情  规格选项 自定义View
class ZMDAttrView: UIView {
    var selectBtn : UIButton!
    var redLine : UIView!
    
    var titles : [String]!
    var finished : ((index:Int)->Void)!
    var enableIndex = ""
    var IsLineAdaptText = true  //是否随字宽度改变
    var attrStr = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect,titles:[String],attrStr : String) {
        super.init(frame: frame)
        self.titles = titles
        self.attrStr = attrStr
        self.updateUI([])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateUI(menuTitle:[String]) {
        redLine = ZMDTool.getLine(CGRect.zero)
        redLine.backgroundColor = RGB(235,61,61,1.0)
        self.addSubview(redLine)
        
        let SetSelectBtn = { (btn : UIButton) in
            self.selectBtn = btn
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                let selectBtnFrame = self.selectBtn.frame
                if self.IsLineAdaptText {
                    let size = self.selectBtn.titleLabel!.text?.sizeWithFont(self.selectBtn.titleLabel!.font, maxWidth: 100)
                    self.redLine.frame = CGRect(x: CGRectGetMinX(selectBtnFrame) + (CGRectGetWidth(selectBtnFrame) - size!.width)/2, y: CGRectGetHeight(self.frame) - 3.5, width:size!.width, height: 3.5)
                } else {
                    self.redLine.frame = CGRect(x: CGRectGetMinX(selectBtnFrame), y: CGRectGetHeight(self.frame) - 3.5, width:kScreenWidth/CGFloat(menuTitle.count), height: 3.5)
                }
            })
            if self.finished != nil {
                self.finished(index: btn.tag - 1000)
            }
        }
        let getBtn = { (text : String,index : Int) -> UIButton in
            let btn = ZMDTool.getButton(CGRect.zero, textForNormal: text, fontSize: 16,textColorForNormal:defaultTextColor, backgroundColor: UIColor.clearColor(), blockForCom: { (sender) -> RACSignal in
                SetSelectBtn(sender as! UIButton)
                return RACSignal.empty()
            })
            btn.setTitle(text, forState: .Selected)
            btn.setTitleColor(defaultDetailTextColor, forState: .Selected)
            btn.titleLabel?.numberOfLines = 1
            btn.titleLabel?.textAlignment = .Center
            return btn
        }
        
        var x = CGFloat(14)
        var y = 0
        let space = CGFloat(25)
        var index = 0
        for title in titles {
            let sizeTmp = title.sizeWithFont(UIFont.systemFontOfSize(16), maxWidth: 150) //名宽度
            let xTmp = x + space * 2 + sizeTmp.width + 20
            let btn = getBtn(title,index)
            btn.tag = 1000 + index++
            if xTmp < self.frame.width {
                btn.frame = CGRectMake(x, CGFloat(y),sizeTmp.width + 20, 60)
                self.addSubview(btn)
                x = x + sizeTmp.width + 20 + space
            } else {
                y += 38
                x = 12 + sizeTmp.width + 20 + space
                btn.frame = CGRectMake(12, CGFloat(y),sizeTmp.width + 20, 60)
                self.addSubview(btn)
            }
            if btn.tag == 0 {
                self.selectBtn = btn
                SetSelectBtn(self.selectBtn)
            }
        }
    }
    
    class func getHeight(titles:[String],width:CGFloat) -> CGFloat {
        var x = CGFloat(14)
        var y = 0
        let space = CGFloat(25)
        for title in titles {
            let sizeTmp = title.sizeWithFont(UIFont.systemFontOfSize(16), maxWidth: 150) //名宽度
            let xTmp = x + space + sizeTmp.width + 20 + 12
            if xTmp > width {
                y += 60
                x = 14 + sizeTmp.width + 20
            } else {
                x = x + space + sizeTmp.width + 20
            }
        }
        return  CGFloat(y)
    }
}
