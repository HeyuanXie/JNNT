//
//  OrderGoodsTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 购物车  商品Cell
class OrderGoodsTableViewCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var goodsImgV: UIImageView!
    @IBOutlet weak var goodsNameLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    var editFinish : ((productDetail:ZMDProductDetail)->Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:ZMDShoppingItem) {
        if let imgUrl = item.DefaultPictureModel?.ImageUrl {
            goodsImgV.sd_setImageWithURL(NSURL(string: imgUrl))
        }
        goodsNameLbl.text = item.ProductName
        detailLbl.text = (item.AttributeInfo as NSString).stringByReplacingOccurrencesOfString("<br />", withString: " ")
        priceLbl.text = item.SubTotal
        quantityLbl.text = "x\(item.Quantity)"
        
        editBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            QNNetworkTool.fetchProductDetail(item.ProductId.integerValue) { (productDetail, error, dictionary) -> Void in
                if productDetail != nil {
                    self.editFinish(productDetail: productDetail!)
                } else {
                    ZMDTool.showErrorPromptView(nil, error: error)
                }
            }
            return RACSignal.empty()
        })
    }
}
