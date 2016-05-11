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

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var removedBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ZMDTool.configViewLayerFrameWithColor(deleteBtn, color: defaultTextColor)
        ZMDTool.configViewLayer(deleteBtn)
        ZMDTool.configViewLayerFrameWithColor(removedBtn, color: defaultTextColor)
        ZMDTool.configViewLayer(removedBtn)
    }
    class func configCell(cell:GoodsManagerBatchCell) {
        cell.imgV.image = UIImage(named: "list_product01")
        cell.titleLbl.text = "星球系列902E1 床头柜 拷贝"
    }
    
}
