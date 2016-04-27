//
//  MyStoreDistributionTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/27.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 分销管理 cell
class MyStoreDistributionTableViewCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var checkCommissionBtn: UIButton!
    @IBOutlet weak var tongLbl: UILabel!
    @IBOutlet weak var jinLbl: UILabel!
    @IBOutlet weak var yinLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ZMDTool.configViewLayer(checkCommissionBtn)
        ZMDTool.configViewLayerFrameWithColor(checkCommissionBtn, color: RGB(151,151,151,1))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
