//
//  MsgActivityTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import SnapKit
// 消息 Cell
class MsgActivityTableViewCell: UITableViewCell {
    static var height = 165 + 0.5 * (kScreenWidth-48)
    var titleLbl:UILabel!
    var timeLbl :UILabel!
    var detailLbl :UILabel!
    var imaV : UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = tableViewdefaultBackgroundColor
        let bgV = UIView()
        bgV.backgroundColor = UIColor.whiteColor()
        ZMDTool.configViewLayer(bgV)
        titleLbl = ZMDTool.getLabel(CGRect.zero, text: "宝孩梦工厂", fontSize: 17)
        timeLbl = ZMDTool.getLabel(CGRect.zero, text: "2016-10-22 10：29", fontSize: 13,textColor: defaultDetailTextColor)
        imaV = UIImageView(image: UIImage(named: "home_banner03"))
        detailLbl = ZMDTool.getLabel(CGRect.zero, text: "小房间也有梦想，孩子们", fontSize: 15,textColor: defaultDetailTextColor)
        let line = ZMDTool.getLine(CGRect.zero)
        let readLbl = ZMDTool.getLabel(CGRect.zero, text: "阅读全文", fontSize: 15)
        let nextImag = UIImageView(image: UIImage(named: "common_forward"))
        
        self.contentView.addSubview(bgV)
        bgV.addSubview(titleLbl)
        bgV.addSubview(timeLbl)
        bgV.addSubview(imaV)
        bgV.addSubview(detailLbl)
        bgV.addSubview(line)
        bgV.addSubview(readLbl)
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
        timeLbl.snp_makeConstraints { (make) -> Void in
            make.topMargin.equalTo(titleLbl.snp_bottom).offset(17)
            make.leftMargin.equalTo(12)
            make.rightMargin.equalTo(-12)
            make.height.equalTo(13)
        }
        imaV.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(timeLbl.snp_bottom).offset(8)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(imaV.snp_width).multipliedBy(0.5)
        }
        detailLbl.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.top.equalTo(imaV.snp_bottom)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        line.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(detailLbl.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        readLbl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(line.snp_bottom)
            make.left.equalTo(12)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        nextImag.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(readLbl)
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
class ZMD_ActivityMsg: QN_BaseDataModel, QN_DataModelProtocol {
    private(set) var msgId: Int?     // 消息ID
    private(set) var title: String?    // 标题
    private(set) var detailTitle: String?    // 标题
    private(set) var pushTime: String?  //消息推送时间
    
    required init!(_ dictionary: NSDictionary) {
        // 所需要的数据都存在，则开始真正的数据初始化
        // 先判断存在性
        if !QN_BaseDataModel.existValue(dictionary, "msgId") {
            super.init(dictionary)
            return nil
        }
        self.msgId = dictionary["msgId"] as? Int
        self.title = dictionary["title"] as? String
        self.detailTitle = dictionary["detailTitle"] as? String
        self.pushTime = dictionary["pushTime"] as? String
        super.init(dictionary)
    }
    
    func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.msgId, forKey:"msgId")
        dictionary.setValue(self.title, forKey:"title")
        dictionary.setValue(self.detailTitle, forKey:"detailTitle")
        dictionary.setValue(self.pushTime, forKey:"pushTime")
        return dictionary
    }
}