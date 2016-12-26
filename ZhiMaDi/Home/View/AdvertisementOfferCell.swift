//
//  AdvertisementOfferCellTableViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/26.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 首页 广告位  offer
class AdvertisementOfferCell: UITableViewCell {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightTopBtn: UIButton!
    @IBOutlet weak var rightBotBtn: UIButton!
    @IBOutlet weak var testBtn: UIButton!
    
    @IBOutlet weak var rightTopImgV: UIImageView!
    @IBOutlet weak var rightBotImgv: UIImageView!
    @IBOutlet weak var topTitleLbl: UILabel!
    @IBOutlet weak var botTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func configCell(cell:AdvertisementOfferCell,datas:NSArray) {
        if datas.count > 0 {
            let advertisement = datas[0] as! ZMDAdvertisement
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.rightTopImgV.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil)
        }
        if datas.count > 1 {
            let advertisement = datas[1] as! ZMDAdvertisement
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.rightBotImgv.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil)
        }
    }
    
    class func configCell(cell:AdvertisementOfferCell,advertisementAll:[ZMDAdvertisement]?) {
        if let advertisementAll = advertisementAll where advertisementAll.count > 0 {
            let advertisement = advertisementAll[0]
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.leftBtn.sd_setImageWithURL(NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!), forState: UIControlState.Normal)
        }
        if let advertisementAll = advertisementAll where advertisementAll.count > 1 {
            let advertisement = advertisementAll[1]
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.rightTopBtn.sd_setImageWithURL(NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!), forState: UIControlState.Normal)
        }
        if let advertisementAll = advertisementAll where advertisementAll.count > 2 {
            let advertisement = advertisementAll[2]
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.rightBotBtn.sd_setImageWithURL(NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!), forState: UIControlState.Normal)
        }
    }
}

class AdvertisementGoodCell : UITableViewCell {
    @IBOutlet weak var leftBtn : UIButton!
    @IBOutlet weak var topImgView : UIImageView!
    @IBOutlet weak var botImgView : UIImageView!
    @IBOutlet weak var topBtn : UIButton!
    @IBOutlet weak var botBtn : UIButton!
    
    class func configcell(cell:AdvertisementGoodCell,datas:NSArray) {
        if datas.count > 0 {
            let advertisement = datas[0] as! ZMDAdvertisement
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.topImgView.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil)
        }
        if datas.count > 1 {
            let advertisement = datas[1] as! ZMDAdvertisement
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            cell.botImgView.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil)
        }

    }
}
