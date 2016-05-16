//
//  DoubleGoodsTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/23.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品双层形式cell
class DoubleGoodsTableViewCell: UITableViewCell {

    //left
    @IBOutlet weak var goodsImgVLeft: UIImageView!
    @IBOutlet weak var titleLblLeft: UILabel!
    @IBOutlet weak var currentPriceLblLeft: UILabel!   // 当前价 
    @IBOutlet weak var originalPriceLblLeft: UILabel!  // 原价
    @IBOutlet weak var countLblLeft: UILabel!
    @IBOutlet weak var isCollectionBtnLeft: UIButton!
    //right
    @IBOutlet weak var goodsImgVRight: UIImageView!
    @IBOutlet weak var titleLblRight: UILabel!
    @IBOutlet weak var currentPriceLblRight: UILabel!
    @IBOutlet weak var originalPriceLblRight: UILabel!
    @IBOutlet weak var countLblRight: UILabel!
    @IBOutlet weak var isCollectionRight: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func configCell(cell:DoubleGoodsTableViewCell!,product : ZMDProduct!,productR : ZMDProduct?) {
        cell.titleLblLeft.text = product.Name
        cell.currentPriceLblLeft.text = "￥\(product.Price)"
        cell.originalPriceLblLeft.text = "原价:￥\(product.OldPrice)"
        cell.countLblLeft.text = "已售\(product.Sold)件"
        if let productR = productR {
            cell.titleLblRight.text = productR.Name
            cell.currentPriceLblRight.text = "￥\(productR.Price)"
            cell.originalPriceLblRight.text = "原价:￥\(productR.OldPrice)"
            cell.countLblRight.text = "已售\(productR.Sold)件"
        }
    }
}
