//
//  MsgOrderTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import SnapKit
// 订单消息 Cell
class MsgOrderTableViewCell: UITableViewCell {
    static var height = CGFloat(100)
    var titleLbl:UILabel!
    var detailLbl :UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = tableViewdefaultBackgroundColor
        let bgV = UIView()
        bgV.backgroundColor = UIColor.whiteColor()
        ZMDTool.configViewLayer(bgV)
        titleLbl = ZMDTool.getLabel(CGRect.zero, text: "宝孩梦工厂", fontSize: 17)
        detailLbl = ZMDTool.getLabel(CGRect.zero, text: "你的订单正在派送中，已送达松山湖", fontSize: 17,textColor: defaultDetailTextColor)
        detailLbl.numberOfLines = 2
        let nextImag = UIImageView(image: UIImage(named: "common_forward"))
        
        self.contentView.addSubview(bgV)
        bgV.addSubview(titleLbl)
        bgV.addSubview(detailLbl)
        bgV.addSubview(nextImag)
        
        bgV.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(EdgeInsets(top: 0, left: 12, bottom: 0, right: -12))
        }
        titleLbl.snp_makeConstraints { (make) -> Void in
            make.topMargin.equalTo(18)
            make.leftMargin.equalTo(12)
            make.rightMargin.equalTo(-12)
            make.height.equalTo(17)
        }
        detailLbl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLbl.snp_bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(45)
        }
        nextImag.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bgV)
            make.right.equalTo(-8)
            make.width.equalTo(10)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: -  PrivateMethod
    func updateUIWithData() {
        titleLbl.text = "title"
    }
}
