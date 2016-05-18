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
    var Sku  : String!                  // 商品货号
    var ShowSku : NSNumber?             //
    var Sold : String!                  // 已售
    var IsFreeShipping : NSNumber? = 0  // 免邮
    var ProductPrice : ZMDProductPrice?
    var DefaultPictureModel : ZMDPictureModel?

    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["ProductPrice":ZMDProductPrice.classForCoder(),"DefaultPictureModel":ZMDPictureModel.classForCoder()]
    }
}
class ZMDProductPrice : NSObject {
    var Price : String! = ""
    var OldPrice : String? = ""         // 原价
    var Rent : String? = ""
}
class ZMDPictureModel : NSObject {
    var PictureId : String! = ""
    var ImageUrl : String? = ""         // 原价
    var FullSizeImageUrl : String? = ""
}


/*
{
"Name": "最新款 布鲁精灵可调档多功能现代简约地中海风情婴儿床",
"ShortDescription": "最新款 布鲁精灵可调档多功能现代简约地中海风情婴儿床",
"FullDescription": null,
"SeName": "-20",
"ThumbDimension": 100,
"ShowSku": false,
"Sku": "ECS014906",
"ShowWeight": false,
"Weight": "",
"ShowDimensions": false,
"Dimensions": "0.00×0.00 * 0.00（宽/小时）",
"DimensionMeasureUnit": "in",
"ShowLegalInfo": true,
"LegalInfo": "*所有价格不包括增值税，加上< a href =“/t/shippinginfo”>航运</a>",
"Manufacturers": [],
"TransportSurcharge": "",
"PagingFilteringContext": [],
"RatingSum": 0,
"TotalReviews": 0,
"ShowReviews": false,
"ShowDeliveryTimes": false,
"InvisibleDeliveryTime": false,
"DeliveryTimeName": null,
"DeliveryTimeHexValue": null,
"IsShipEnabled": true,
"DisplayDeliveryTimeAccordingToStock": true,
"StockAvailablity": "",
"DisplayBasePrice": false,
"BasePriceInfo": null,
"MinPriceProductId": 54,
"CompareEnabled": true,
"IsNew": false,
"HideBuyButtonInLists": false,
"Hit": 0,
"Sold": 0,
"Type": 20,
"ProductPrice": {
"OldPrice": null,
"Price": "¥600.00",
"Rent": "¥0.00",
"Deposit": "¥200.00",
"HasDiscount": false,
"ShowDiscountSign": true,
"DisableBuyButton": false,
"DisableWishListButton": false,
"AvailableForPreOrder": false,
"ForceRedirectionAfterAddingToCart": false,
"CallForPrice": false,
"CustomProperties": {}
},
"DefaultPictureModel": {
"PictureId": 0,
"ThumbImageUrl": null,
"ImageUrl": "/Media/Thumbs/0000/0000182---100.jpg",
"FullSizeImageUrl": "/Media/Thumbs/0000/0000182--.jpg",
"Title": "显示最新款 布鲁精灵可调档多功能现代简约地中海风情婴儿床的详细信息",
"AlternateText": "图为最新款 布鲁精灵可调档多功能现代简约地中海风情婴儿床",
"CustomProperties": {}
},
"SpecificationAttributeModels": [],
"ColorAttributes": [],
"Id": 54,
"CustomProperties": {}
}
*/