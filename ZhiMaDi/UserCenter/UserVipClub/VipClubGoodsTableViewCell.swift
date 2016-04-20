//
//  VipClubGoodsTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/20.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 会员俱乐部 goods cell
class VipClubGoodsTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.whiteColor()
        
        let imgV = UIImageView(frame: CGRect(x: 12, y: 12, width: 135, height: 135))
        imgV.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(imgV)
        
        let goodsLbl = ZMDTool.getLabel(CGRect(x: 12+135+10, y: 12, width: kScreenWidth - 24-135-10, height: 40), text: "", fontSize: 17)
        self.contentView.addSubview(goodsLbl)
        
        let goodsPriceLbl = ZMDTool.getLabel(CGRect(x: 12+135+10, y:160/2-17/2, width: kScreenWidth - 24-135-10, height: 17), text: "", fontSize: 17,textColor: RGB(254,145,86,1.0))
        self.contentView.addSubview(goodsPriceLbl)
        
        let hasLbl = ZMDTool.getLabel(CGRect(x: 12+135+10, y: 160-12-14, width: kScreenWidth - 24-135-10-100, height: 14), text: "", fontSize: 15,textColor: defaultDetailTextColor)
        self.contentView.addSubview(hasLbl)
        
        let cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 80, y: 160-12-34, width: 80, height: 34), textForNormal: "马上兑换", fontSize: 15,textColorForNormal:UIColor.whiteColor(), backgroundColor: RGB(254,145,89,1.0), blockForCli: { (sender) -> Void in
        })
        ZMDTool.configViewLayer(cancelBtn)
        self.contentView.addSubview(cancelBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
