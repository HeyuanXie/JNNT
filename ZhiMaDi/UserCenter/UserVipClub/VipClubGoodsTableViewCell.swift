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
    let height = 176
    var imgV : UIImageView!
    var goodsLbl : UILabel!
    var goodsPriceLbl: UILabel!
    var hasLbl: UILabel!
    var cancelBtn:UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = tableViewdefaultBackgroundColor
        self.selectionStyle = .None
        
        let viewBg = UIView(frame: CGRect(x: 0, y: 16, width: kScreenWidth, height: 135+24))
        viewBg.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(viewBg)
         imgV = UIImageView(frame: CGRect(x: 12, y: 12, width: 135, height: 135))
        imgV.backgroundColor = UIColor.clearColor()
        viewBg.addSubview(imgV)
        
         goodsLbl = ZMDTool.getLabel(CGRect(x: 12+135+10, y: 12, width: kScreenWidth - 24-135-10, height: 40), text: "", fontSize: 17)
        goodsLbl.numberOfLines = 2
        viewBg.addSubview(goodsLbl)
        
         goodsPriceLbl = ZMDTool.getLabel(CGRect(x: 12+135+10, y:160/2-17/2, width: kScreenWidth - 24-135-10, height: 17), text: "", fontSize: 17,textColor: RGB(254,145,86,1.0))
        viewBg.addSubview(goodsPriceLbl)
        
         hasLbl = ZMDTool.getLabel(CGRect(x: 12+135+10, y: 160-12-14, width: kScreenWidth - 24-135-10-100, height: 14), text: "", fontSize: 15,textColor: defaultDetailTextColor)
        viewBg.addSubview(hasLbl)
        
         cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 80 - 12, y: 160-12-34, width: 80, height: 34), textForNormal: "马上兑换", fontSize: 15,textColorForNormal:UIColor.whiteColor(), backgroundColor: RGB(254,145,89,1.0), blockForCli: { (sender) -> Void in
        })
        ZMDTool.configViewLayer(cancelBtn)
        viewBg.addSubview(cancelBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
