//
//  MyStoreCustomerViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 客户管理
class MyStoreCustomerViewController: UIViewController,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var dataArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = ["","",""]
        self.view.addSubview(self.createFilterMenu())
        self.tableView.backgroundColor = tableViewdefaultBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CustomCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? MyStoreCustomerCell
        if cell == nil {
            cell = MyStoreCustomerCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        cell?.imgV.image = UIImage(named: "home_banner02")
        cell?.nameLbl.text = "葫芦"
        let sizeForName = "葫芦".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 200)
        cell?.nameWidthCon.constant = sizeForName.width
        cell?.leveImgV.image = UIImage(named: "home_banner02")
        cell?.detailLbl.text = "购买次数:20"
        let sizeForDetail = "购买次数:20".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 200)
        cell?.detailWidthCon.constant = sizeForDetail.width
        cell?.timeLbl.text = "上一次购买:02/20 11:50"
        cell?.timeLbl.adjustsFontSizeToFitWidth = true
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = MyStoreCusDetailViewController()
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func createFilterMenu() -> UIView{
        let prices = ["购买次数","累计消费","购买时间"]
        let countForBtn = CGFloat(prices.count)
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 55))
        view.backgroundColor = UIColor.clearColor()
        for var i=0;i<prices.count;i++ {
            let index = i%prices.count
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * kScreenWidth/countForBtn , 0, (kScreenWidth)/countForBtn, 55))
            btn.backgroundColor = UIColor.whiteColor()
            btn.frame = CGRectMake(CGFloat(index) * (kScreenWidth)/countForBtn, 0, (kScreenWidth)/countForBtn, 55)
            btn.setImage(UIImage(named: "list_price_normal"), forState: .Normal)
            btn.setImage(UIImage(named: "list_price_normal"), forState: .Selected)
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitleColor(defaultTextColor, forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn.tag = i
            view.addSubview(btn)
            let size = prices[i].sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 100)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: (CGRectGetWidth(btn.frame)-size.width)/2+size.width+10, bottom: 0, right: 0)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (CGRectGetWidth(btn.frame)-size.width)/2+10)
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                
                self.tableView.reloadData()
            })
            let line = ZMDTool.getLine(CGRectMake(CGRectGetMaxX(btn.frame)-1, 12, 1, 25))
            btn.addSubview(line)
        }
        return view
    }
}

class MyStoreCustomerCell : UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameWidthCon: NSLayoutConstraint!
    @IBOutlet weak var leveImgV: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var detailWidthCon: NSLayoutConstraint!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}