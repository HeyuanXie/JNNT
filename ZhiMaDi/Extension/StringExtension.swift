//
//  StringExtension.swift
//  QooccHealth
//
//  Created by 肖小丰 on 15/4/17.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import Foundation

extension String{

    func sizeWithAttributeString(attributedString: NSAttributedString, maxWidth: CGFloat) -> CGSize{
        let rect = attributedString.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.size
    }
    func sizeWithFont(font: UIFont, maxWidth: CGFloat) -> CGSize {
        let attributedString = NSAttributedString(string: self, attributes: [NSFontAttributeName : font])
        let rect = attributedString.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
    func sizeWithFont(font: UIFont, maxWidth: CGFloat, lines: Int) -> CGSize {
        var size = self.sizeWithFont(font, maxWidth: maxWidth)
        let simple = "a你".sizeWithAttributes([NSFontAttributeName : font])
        size.height = min(simple.height * CGFloat(lines), size.height)
        return size
    }
    
    
    // MARK: 判断手机号码
    func checkStingIsPhone() -> Bool {
        // 手机号码
        let phoneRegex = "^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let phoneIsMatch = phonePred.evaluateWithObject(self)
        // 固定电话大陆
        let telRegex = "^0\\d{2,3}(\\-)?\\d{7,8}$"
        let telPred = NSPredicate(format: "SELF MATCHES %@", telRegex)
        let telIsMatch = telPred.evaluateWithObject(self)
        
        return (phoneIsMatch || telIsMatch)
    }
    //MARK: 判断11位数字（手机号）
     func checkStingIsPhoneNum() -> Bool {
        let phoneRegex = "^([1-9])\\d{10}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let phoneIsMatch = phonePred.evaluateWithObject(self)
        return phoneIsMatch
    }
    //MARK: 判断身份证号
//    func validateIdentityCard()->Bool{
//        if count(self) <= 0 {
//            return false
//        }
//        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
//        let identityCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return identityCardPredicate.evaluateWithObject(self)
//    }

}