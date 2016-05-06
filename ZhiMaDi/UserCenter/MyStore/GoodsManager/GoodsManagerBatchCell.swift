//
//  GoodsManagerBatchCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 批量管理 cell
class GoodsManagerBatchCell: UITableViewCell {
    let height = CGFloat(150)

    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        ZMDTool.configViewLayerFrameWithColor(deleteBtn, color: defaultTextColor)
        ZMDTool.configViewLayer(deleteBtn)
    }
    class func configCell(cell:MyStoreManagerGoodsCell) {
        cell.imgV.image = UIImage(named: "list_product01")
        cell.goodsLbl.text = "星球系列902E1 床头柜 拷贝"
        cell.goodsPriceLbl.text = "￥495.0"
        cell.nextPriceLbl.text = "原价:￥595.0"
        cell.botLbl.text = "已售:15    库存:215"
    }
    
}
