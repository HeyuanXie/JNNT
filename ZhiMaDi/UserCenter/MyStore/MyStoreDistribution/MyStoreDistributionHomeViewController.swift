//
//  MyStoreDistributionHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/27.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//分销管理
class MyStoreDistributionHomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    enum CardType {
        case Goods  // 商品
        case Seller
        init() {
            self = Goods
        }
    }
    @IBOutlet weak var currentTableView: UITableView!
    var manageBtn : UIButton!
    var dataArray : NSArray!
    let cardTypeAll = [CardType.Goods,.Seller]
    var cardType = CardType()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = ["",""]
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.cardType == .Seller {
            return 0
        }
        return section == 0 ? 0 : 16
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cardType == .Goods ? 194 : 86
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.cardType == .Seller {
            let cellId = "SellerCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = UIColor.whiteColor()
                
                var tag = 10001
                let imgV = UIImageView(frame: CGRect(x: 12, y: 12, width: 60, height: 60))
                imgV.tag = tag++
                cell?.contentView.addSubview(imgV)
                let titleLbl = ZMDTool.getLabel(CGRect(x: CGRectGetMaxX(imgV.frame)+10, y: 12, width: 200, height: 15), text: "", fontSize: 15,textColor: defaultTextColor)
                titleLbl.tag = tag++
                let statusImgV = UIImageView(frame: CGRect.zero)
                statusImgV.tag = tag++
                cell?.contentView.addSubview(statusImgV)
                cell?.contentView.addSubview(titleLbl)
                let detailLbl = ZMDTool.getLabel(CGRect(x: CGRectGetMaxX(imgV.frame)+10, y: CGRectGetMaxY(titleLbl.frame)+30, width: 200, height: 15), text: "", fontSize: 15,textColor:defaultDetailTextColor)
                detailLbl.tag = tag++
                cell?.contentView.addSubview(detailLbl)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 85.5, width: kScreenWidth, height: 0.5)))
            }
            var tag = 10001
            let imgV = cell?.viewWithTag(tag++) as! UIImageView
            let titleLbl = cell?.viewWithTag(tag++) as! UILabel
            let statusImgV = cell?.viewWithTag(tag++) as! UIImageView
            let detailLbl = cell?.viewWithTag(tag++) as! UILabel
            
            imgV.image = UIImage(named: "shop_level_gold")
            titleLbl.text = "葫芦堡旗舰店"
            statusImgV.image = UIImage(named: "shop_level_gold")  // shop_level_gold shop_level_silver shop_level_copper
            let sizeForTitleLbl =  titleLbl.text?.sizeWithFont(defaultSysFontWithSize(15), maxWidth: 200)
            statusImgV.frame = CGRect(x: CGRectGetMinX(titleLbl.frame) + (sizeForTitleLbl?.width)! + 8, y: 12, width: 20, height: 20)
            detailLbl.text = "代销商品：10"
            return cell!
        } else {
            let cellId = "DisGoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! MyStoreDistributionTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = .None
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.cardType == CardType.Seller {
            let vc =  MyStoreDisDetailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "分销管理"
        let menuTitle = ["分销商品","分销商"]
        let customJumpBtns = CustomJumpBtns(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 55),menuTitle: menuTitle,IsLineAdaptText:false)
        customJumpBtns.backgroundColor = UIColor.whiteColor()
        customJumpBtns.addSeparatedLine()
        self.view.addSubview(customJumpBtns)
        customJumpBtns.finished = { (index) ->Void in
            self.cardType = self.cardTypeAll[index]
            self.currentTableView.reloadData()
        }
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
}
