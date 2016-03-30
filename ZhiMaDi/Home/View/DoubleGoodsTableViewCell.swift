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

}
