//
//  VipClubGoodsDetailTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/21.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// VipClubGoodsDetailTableViewCell
class VipClubGoodsDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detail01: UILabel!
    @IBOutlet weak var detail01Height: NSLayoutConstraint!
    @IBOutlet weak var detail02: UILabel!
    @IBOutlet weak var detail02Height: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func configVipClubGoodsDetailCell(tableView: UITableView,detail01:String,detail02:String) -> UITableViewCell {
        let cellId = "OtherCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! VipClubGoodsDetailTableViewCell
        cell.detail01.text = detail01
        cell.detail02.text = detail02
        let size1 = detail01.sizeWithFont(defaultSysFontWithSize(15), maxWidth: kScreenWidth-40)
        let size2 = detail01.sizeWithFont(defaultSysFontWithSize(15), maxWidth: kScreenWidth-40)
        cell.detail01Height.constant = size1.height
        cell.detail02Height.constant = size2.height
        return cell
    }
    class func heightForVipClubGoodsDetailCell(detail01:String,detail02:String) -> CGFloat {
        let size1 = detail01.sizeWithFont(defaultSysFontWithSize(15), maxWidth: kScreenWidth)
        let size2 = detail01.sizeWithFont(defaultSysFontWithSize(15), maxWidth: kScreenWidth)
        return kScreenWidth + 15 + 18 + 25 + 17 + 12 + size1.height + 25 + 17 + 25 + size2.height + 28 + 17 + 20
    }
}
