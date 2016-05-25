//
//  DoubleGoodsTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/23.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品双层形式cell
class DoubleGoodsTableViewCell: UITableViewCell {

    //left
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var goodsImgVLeft: UIImageView!
    @IBOutlet weak var titleLblLeft: UILabel!
    @IBOutlet weak var currentPriceLblLeft: UILabel!   // 当前价 
    @IBOutlet weak var originalPriceLblLeft: UILabel!  // 原价
    @IBOutlet weak var countLblLeft: UILabel!
    @IBOutlet weak var isCollectionBtnLeft: UIButton!
    //right
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var goodsImgVRight: UIImageView!
    @IBOutlet weak var titleLblRight: UILabel!
    @IBOutlet weak var currentPriceLblRight: UILabel!
    @IBOutlet weak var originalPriceLblRight: UILabel!
    @IBOutlet weak var countLblRight: UILabel!
    @IBOutlet weak var isCollectionRight: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func configCell(cell:DoubleGoodsTableViewCell!,product : ZMDProduct!,productR : ZMDProduct?) {
        cell.titleLblLeft.text = product.Name
        cell.countLblLeft.text = "已售\(product.Sold)件"
        if let productPrice = product.ProductPrice {
            cell.currentPriceLblLeft.text = "\(productPrice.Price)"
            cell.originalPriceLblLeft.text = "原价:\(productPrice.OldPrice ?? "")"
        }
        if let pictureModel = product.DefaultPictureModel {
            let imgUrl = kImageAddressMain + (pictureModel.ImageUrl ?? "")
            cell.goodsImgVLeft.setImageWithURL(NSURL(string: imgUrl), placeholderImage: UIImage(named: "Home_Buy_AppleGoods"))
        }
        guard let productR = productR else {
            if cell.rightView != nil {
                cell.rightView.hidden = true
            }
            return
        }
        cell.rightView.hidden = false
        cell.titleLblRight.text = productR.Name
        if let productPrice = productR.ProductPrice {
            cell.currentPriceLblRight.text = "\(productPrice.Price)"
            cell.originalPriceLblRight.text = "原价:\(productPrice.OldPrice ?? "")"
        }
        if let pictureModel = productR.DefaultPictureModel {
            let imgUrl = kImageAddressMain + (pictureModel.ImageUrl ?? "")
            cell.goodsImgVRight.setImageWithURL(NSURL(string: imgUrl), placeholderImage: UIImage(named: "Home_Buy_AppleGoods"))
        }
        cell.countLblRight.text = "已售\(productR.Sold)件"
    }
}
