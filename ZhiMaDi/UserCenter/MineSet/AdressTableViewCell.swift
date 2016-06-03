//
//  AdressTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 管理收货地址 -> cell
class AdressTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var editBtnWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func configCell(cell:AdressTableViewCell,address:ZMDAddress) {
        cell.title.text = address.FirstName
        cell.address.text = (address.Address1 ?? "") + (address.Address2 ?? "")
    }
}
