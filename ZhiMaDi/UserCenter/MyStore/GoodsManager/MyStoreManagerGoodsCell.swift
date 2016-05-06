//
//  MyStoreManagerGoodsCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品管理cell
class MyStoreManagerGoodsCell: UITableViewCell {
    let height = CGFloat(150)
    var imgV : UIImageView!
    var goodsLbl,goodsPriceLbl,nextPriceLbl,botLbl : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.None
        self.selectionStyle = .None
        
        ZMDTool.configTableViewCellDefault(self)
        imgV = UIImageView(frame: CGRect(x: 12, y: 12, width: 125, height: 125))
        imgV.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(imgV)
        
        goodsLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y: 12, width: kScreenWidth - 12-125-10-12, height: 15), text: "", fontSize: 15)
        self.contentView.addSubview(goodsLbl)
        
        goodsPriceLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y:CGRectGetMaxY(goodsLbl.frame)+27, width: kScreenWidth - 12-125-10-12, height: 15), text: "", fontSize: 15,textColor: RGB(235,61,61,1.0))
        self.contentView.addSubview(goodsPriceLbl)
        
        nextPriceLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y: CGRectGetMaxY(goodsPriceLbl.frame)+8, width: kScreenWidth - 12-125-10-100, height: 14), text: "", fontSize: 14,textColor: defaultDetailTextColor)
        self.contentView.addSubview(nextPriceLbl)
        
        botLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y: height - 15 - 14, width: kScreenWidth - 12-125-10-12, height: 14), text: "", fontSize: 14,textColor: defaultDetailTextColor)
        self.contentView.addSubview(botLbl)
        
        self.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 149.5, width: kScreenWidth, height: 0.5)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func configCell(cell:MyStoreManagerGoodsCell) {
        cell.imgV.image = UIImage(named: "list_product01")
        cell.goodsLbl.text = "星球系列902E1 床头柜 拷贝"
        cell.goodsPriceLbl.text = "￥495.0"
        cell.nextPriceLbl.text = "原价:￥595.0"
        cell.botLbl.text = "已售:15    库存:215"
    }
    
}
