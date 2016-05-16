//
//  Product.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/16.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品
class ZMDProduct: NSObject {
    var ProductTypeId : NSNumber!
    var Name : String!
    var ShortDescription : String!
    var Sku  : String! // 商品货号
    var Price : String!
    var OldPrice : String! // 原价
    var Sold : String! // 已售
}
