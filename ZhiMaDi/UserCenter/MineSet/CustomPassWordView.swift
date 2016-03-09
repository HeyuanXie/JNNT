//
//  CustomPassWordView.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/9.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class CustomPassWordView: UIView,UITextFieldDelegate {
    var textF : UITextField!
    var count : Int = 6
    var strTmp = ""
    var finish :((str:String) -> Void)!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -  PrivateMethod
    func startKeyBoard() {
        textF.becomeFirstResponder()
    }
    func setupUI(frame: CGRect) {
        let width = frame.size.width
        let height = frame.size.height
        // Responder
        textF = UITextField()
        textF.keyboardType = .NumberPad
        textF.textAlignment = .Center
        textF.delegate = self
        self.addSubview(textF)
        
        //背影
        let imgV = UIImageView(frame: CGRectMake(0, 0, width, height))
        imgV.image = UIImage(named: "password_in")
        imgV.backgroundColor = UIColor.clearColor()
        self.addSubview(imgV)
        //圆
        for var i=0;i<6;i++ {
            let x =  (0.5 + CGFloat(i)) * (width/6) - 7.5
            let y =  height/2 - 7.5
            let circle = UIImageView(frame: CGRectMake(x, y, 15, 15))
            circle.image = UIImage(named: "yuan")
            circle.tag = 1000 + i
            self.addSubview(circle)
            circle.hidden = true
        }
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text as! NSString
        text = text.stringByReplacingCharactersInRange(range, withString: string)
        
        for var i = 0 ;i < text.length;i++ {
            let circle = self.viewWithTag(1000 + i)
            circle?.hidden = false
        }
        for var i = 5 ;i >= text.length;i-- {
            let circle = self.viewWithTag(1000 + i)
            circle?.hidden = true
        }
        if text.length == count {
            self.strTmp = text as String
            textField.text = text as String
        }
        if text.length == count {
            self.finish(str: text as String)
            self.endEditing(true)
        }
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.startKeyBoard()
    }
}
