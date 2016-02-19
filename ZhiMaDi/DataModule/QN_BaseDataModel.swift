//
//  QN_Base.swift
//  QooccShow
//
//  Created by LiuYu on 14/11/4.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//  Modify by LiuYu on 15-7-16

/// 所有数据模型都必须支持这个协议
import UIKit
protocol QN_DataModelProtocol : NSCoding, NSCopying {
    // 根据dictionary初始化方法 （ 相当于从数据源中读取 ）
    init!(_ dictionary: NSDictionary)
    // 还原出dictionary ( 相当与写数据源 ）  注意与 init!(_ dictionary: NSDictionary) 中的数据对应
    func dictionary() -> NSDictionary
}


/// 所有数据模型类的抽象基类
class QN_BaseDataModel: NSObject {
    
    // MARK: LyDataModelProtocol
    required init!(_ dictionary: NSDictionary) {
        super.init()
        assert(self is QN_DataModelProtocol, "\(self.classForCoder) 必须支持 LyDataModelProtocol")
    }
    
    // MARK: NSCoding
    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! NSDictionary)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject((self as! QN_DataModelProtocol).dictionary())
    }
    
    // MARK: NSCoping
    func copyWithZone(zone: NSZone) -> AnyObject {
        let aClass = self.classForCoder as! QN_BaseDataModel.Type
        return aClass.init((self as! QN_DataModelProtocol).dictionary())
    }
    
    // MARK: description
    override var description: String {
        return (self as! QN_DataModelProtocol).dictionary().description
    }
    
    
}


/**
*  // MARK: - 判断存在性的扩展
*/
extension QN_BaseDataModel {
    /**
    判断 dictionary 中是否存在 key
    
    :param: dictionary 数据源
    :param: keys       所有需要判断的key
    
    :returns: 如果都存在，则返回 true，  有一个或更多个不存在则返回 false
    */
    class func existValue(dictionary: NSDictionary, _ keys: String...) -> Bool {
        for key in keys {
            if dictionary[key] == nil { // 发现一个不存在的，则返回false
                return false
            }
        }
        
        return true
    }
    
    
}
