//
//  CircleScaleCustomView.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/13.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 自定义百分比的圆
class CircleScaleCustomView: UIView {
    let widthOfLine = CGFloat(6)
    var percentage : Double!
    override init(frame:CGRect){
        super.init(frame: frame)
        
    }
    init(frame:CGRect,percentage:Double){
        super.init(frame: frame)
        self.percentage = percentage
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
        UIView.animateWithDuration(3) { () -> Void in
            self.updateUI(rect)
            self.setNeedsDisplay()
        }
    }
    func updateUI(rect: CGRect) {
        let width = rect.size.width
        let height = rect.size.width
        // 获取图形上下文
        let ctx = UIGraphicsGetCurrentContext();
        // 画一个圆
        let circlePath = CGPathCreateMutable()
        CGPathAddEllipseInRect(circlePath, nil, CGRect(x: widthOfLine/2, y: widthOfLine/2, width: width-widthOfLine, height: height-widthOfLine))
        CGContextSetLineWidth(ctx, widthOfLine);
        CGContextSetStrokeColorWithColor(ctx, RGB(229,229,229,1).CGColor)//设置画笔颜色
        CGContextAddPath(ctx, circlePath)
        CGContextStrokePath(ctx)
        
        //通过画弧画圆
        //弧度=角度乘以π后再除以180
        CGContextSetStrokeColorWithColor(ctx, RGB(66,222,212,1).CGColor)
        CGContextAddArc(ctx, width/2, height/2, width/2-widthOfLine/2,CGFloat(270*M_PI/180),CGFloat(270*M_PI/180) + CGFloat(self.percentage * (M_PI*2)), 0) //画弧
        CGContextStrokePath(ctx)
        
        NSString(string: "\(self.percentage*100)%").drawAtPoint(CGPoint(x: 10,y: 35), withAttributes: [NSForegroundColorAttributeName:RGB(66,222,212,1),NSFontAttributeName:defaultSysFontWithSize(28)])
    }
}
