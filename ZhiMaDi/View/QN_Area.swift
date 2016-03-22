//
//  QN_Area.swift
//  QooccHealth
//
//  Created by haijie on 15/8/31.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import UIKit
//地区模型
let kKeyId = "id"       // 省/市 Id
let kKeyName = "name"   // 省/市 名称
let kKeyCitys = "citys" // 省 里面的城市

class QN_Area: QN_BaseDataModel, QN_DataModelProtocol {
    var id : String!      //省ID
    var  name : String!   //省名
    var  citys : NSMutableArray   //城市
    
    required init!(_ dictionary: NSDictionary) {
        self.id = dictionary[kKeyId] as? String
        self.name = dictionary[kKeyName] as? String
        self.citys = NSMutableArray(capacity: 0)
        if let citysArray:NSArray = dictionary[kKeyCitys] as? NSArray{
            for  cityDict in citysArray {
                self.citys.addObject(QN_City(cityDict as! NSDictionary))
            }
        }
        super.init(dictionary)
    }
    
    func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey:kKeyId)
        dictionary.setValue(self.name, forKey:kKeyName)
       dictionary.setValue(self.citys, forKey:kKeyCitys)
        return dictionary
    }
}
class QN_City: QN_BaseDataModel, QN_DataModelProtocol {
    var id : String!      //城市ID
    var name : String!    //城市名字
    required init!(_ dictionary: NSDictionary) {
        self.id = dictionary[kKeyId] as? String
        self.name = dictionary[kKeyName] as? String
        super.init(dictionary)
    }
    
    func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey:kKeyId)
        dictionary.setValue(self.name, forKey:kKeyName)
        return dictionary
    }
}