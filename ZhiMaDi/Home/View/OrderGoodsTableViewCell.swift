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
    var editFinish : ((productDetail:ZMDProductDetail,item:ZMDShoppingItem)->Void)!
    var selectFinish : ((Sci:ZMDShoppingItem,isAdd:Bool)->Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //订单详情
    func configCellForOrderDetail(product:ZMDProductForOrderDetail) {
        if let imgUrl = product.PictureUrl {
            let url = "http://xw.ccw.cn"+imgUrl
            goodsImgV.sd_setImageWithURL(NSURL(string: url))
        }
        goodsNameLbl.text = product.ProductName
        detailLbl.text = (product.AttributeInfo as NSString).stringByReplacingOccurrencesOfString("<br />", withString: " ")
        priceLbl.text = product.SubTotal
        quantityLbl.text = "x\(product.Quantity)"
    }
    //确认订单
    func configCellForConfig(item:ZMDShoppingItem) {
        if let imgUrl = item.DefaultPictureModel?.ImageUrl {
            goodsImgV.sd_setImageWithURL(NSURL(string: imgUrl))
        }
        goodsNameLbl.text = item.ProductName
        detailLbl.text = (item.AttributeInfo as NSString).stringByReplacingOccurrencesOfString("<br />", withString: " ")
        priceLbl.text = item.SubTotal
        quantityLbl.text = "x\(item.Quantity)"
    }
    // 我的订单
    func configCellWithDic(dic:NSDictionary) {
        if let product = dic["Product"] as? NSDictionary,let productPictures = product["ProductPictures"] as? NSArray,let pictureId = (productPictures[0] as! NSDictionary)["PictureId"],let name = product["Name"] {
            goodsImgV.sd_setImageWithURL(NSURL(string: "http://xw.ccw.cn/picture/index/\(pictureId)"))
            goodsNameLbl.text = "\(name)"
        }
        if let attributeDescription = dic["AttributeDescription"] as? String {
            detailLbl.text = (attributeDescription as NSString).stringByReplacingOccurrencesOfString("<br />", withString: " ")
        }
        if let UnitPriceInclTax = dic["UnitPriceInclTax"] as? String {
            priceLbl.text = UnitPriceInclTax
        }
        if let Quantity = dic["Quantity"] {
            quantityLbl.text = "x\(Quantity)"
        }
    }
    func configCellForMyOrder(orderItem:ZMDOrderDetailOrderItems) {
        if orderItem.Product.ProductPictures?.count != 0 {
            let pictureId = orderItem.Product.ProductPictures![0].PictureId
            goodsImgV.sd_setImageWithURL(NSURL(string: "http://xw.ccw.cn/picture/index/\(pictureId)"))

        }
        goodsNameLbl.text = orderItem.Product.Name
        if let attributeDescription = orderItem.AttributeDescription {
            detailLbl.text = (attributeDescription as NSString).stringByReplacingOccurrencesOfString("<br />", withString: " ")
        }
        if let UnitPriceInclTax = orderItem.UnitPriceInclTax {
            priceLbl.text = UnitPriceInclTax
        }
        if let Quantity = orderItem.Quantity {
            quantityLbl.text = "x\(Quantity)"
        }
    }
    func configCell(item:ZMDShoppingItem,scis:NSArray) {
        if let imgUrl = item.Picture?.ImageUrl {
            goodsImgV.sd_setImageWithURL(NSURL(string: kImageAddressMain+imgUrl))
        }
        goodsNameLbl.text = item.ProductName
        detailLbl.text = (item.AttributeInfo as NSString).stringByReplacingOccurrencesOfString("<br />", withString: " ")
        priceLbl.text = item.SubTotal
        quantityLbl.text = "x\(item.Quantity)"
        
        editBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            QNNetworkTool.fetchProductDetail(item.ProductId.integerValue) { (productDetail, error, dictionary) -> Void in
                if productDetail != nil {
                    self.editFinish(productDetail: productDetail!,item:item)
                } else {
                    ZMDTool.showErrorPromptView(nil, error: error)
                }
            }
            return RACSignal.empty()
        })
        selectBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            (sender as! UIButton).selected = !(sender as! UIButton).selected
            self.selectFinish(Sci: item,isAdd: (sender as! UIButton).selected)
            return RACSignal.empty()
        })
        selectBtn.selected = false
        for tmp in scis {
            if (tmp as! ZMDShoppingItem).Id == item.Id {
                selectBtn.selected = true
            }
        }
    }
}
