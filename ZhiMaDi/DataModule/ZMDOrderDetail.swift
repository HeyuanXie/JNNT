//
//  ZMDOrderDetail.swift
//  ZhiMaDi
//
//  Created by haijie on 16/6/23.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 订单详情 用
class ZMDOrderDetail: NSObject {
    var OrderTotal : String!
    var Id : NSNumber!
    var OrderStatusId : NSNumber!
    var ShippingStatusId : NSNumber!
    var PaymentStatusId : NSNumber!
    var OrderItems : [ZMDOrderDetailOrderItems]!
    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["OrderItems":ZMDOrderDetailOrderItems.classForCoder()]
    }
}
class ZMDOrderDetailOrderItems: NSObject {
    var UnitPriceInclTax : String!
    var Quantity : NSNumber!
    var AttributeDescription : String!
    var Product : ZMDOrderDetailOrderItemsProduct!
}
class ZMDOrderDetailOrderItemsProduct: NSObject {
    var ProductPictures:[ZMDOrderDetailOrderItemsProductPictureId]?
    var Name : String!
    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["ProductPictures":ZMDOrderDetailOrderItemsProductPictureId.classForCoder()]
    }
}
class ZMDOrderDetailOrderItemsProductPictureId: NSObject {
    var PictureId : NSNumber!
}