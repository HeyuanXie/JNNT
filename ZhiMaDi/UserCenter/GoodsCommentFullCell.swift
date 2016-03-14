//
//  GoodsCommentTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/14.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//商品评价cell
class  GoodsCommentFullCell : UITableViewCell {
    
    @IBOutlet weak var goods: UILabel!
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var recommentLbl: UILabel!
    @IBOutlet weak var replyLbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        ZMDTool.configViewLayerFrame(self.replyBtn)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    @IBAction func replyBtnCli(sender: UIButton) {
        
    }
}
class  GoodsCommentEasyCell : UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}