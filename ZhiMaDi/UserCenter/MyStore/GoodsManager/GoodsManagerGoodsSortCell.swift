//
//  GoodsManagerGoodsSortCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/9.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品分类
class GoodsManagerGoodsSortCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteBtnWidthCon: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleLblWidthCon: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
