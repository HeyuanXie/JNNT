//
//  Coupon.swift
//  ZhiMaDi
//
//  Created by haijie on 16/6/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 优惠券
class ZMDCoupon: NSObject {
    var Id:NSNumber?                      //1035,
    var CouponNo:String?                //0L1PCBvar ,
    var CustomerId:NSNumber?              //1,
    var CouponCode:String?              //"2016040810"
    var Discount : ZMDCouponDiscount!
    var indexForDelete : Int?                     // 方便删除
}
class ZMDCouponDiscount: NSObject {
    var Name:String!                    // "10元优惠券",
    var StartDateUtc:String!            // "2016-04-08T00:00:00",
    var EndDateUtc:String!              // "2016-07-30T00:00:00",
    var Explain:String!                 // "订单总额大于100元可以使用",
    var DiscountAmount : NSNumber!      // 10
}
