//
//  OrderPaySucceedViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/31.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 支付成功
class OrderPaySucceedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var tableView : UITableView!
    var total = ""
    var orderId : Int!
    var finished : (()->Void)!
    var dic : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.fetchData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 175
        } else if indexPath.row == 1 {
            return 102
        }
        return 56
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellId = "HeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.contentView.backgroundColor = RGB(255,145,89,1.0)
            
            let imgV = UIImageView(frame: CGRect(x: kScreenWidth/2 - 57, y: 32, width: 94, height: 65))
            imgV.image = UIImage(named: "pay_express")
            cell?.contentView.addSubview(imgV)
            let topLbl = ZMDTool.getLabel(CGRect(x: 0, y: 32 + 65 + 23 , width: kScreenWidth, height: 18), text: "嘿嘿~你已付款成功！", fontSize: 18)
            topLbl.textAlignment = .Center
            let botLbl = ZMDTool.getLabel(CGRect(x: 0, y: 32 + 65 + 23 + 18+8 , width: kScreenWidth, height: 16), text: "请等待卖家发货", fontSize: 16)
            botLbl.textAlignment = .Center
            cell?.contentView.addSubview(topLbl)
            cell?.contentView.addSubview(botLbl)
            return cell!
        }else if indexPath.row == 1 {
            let cellId = "msgCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 101.5, width: kScreenWidth, height: 0.5)))
                
                var tag = 10001
                let userLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 300, height: 17), text: "", fontSize: 17)
                userLbl.tag = tag++
                cell?.contentView.addSubview(userLbl)
                let phoneLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 120, y: 16, width: 300, height: 17), text: "", fontSize: 17)
                phoneLbl.tag = tag++
                cell?.contentView.addSubview(phoneLbl)
                let addressStr = ""
                let addressSize = addressStr.sizeWithFont(defaultSysFontWithSize(17), maxWidth: kScreenWidth - 24)
                let addressLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: addressSize.height), text: addressStr, fontSize: 17)
                addressLbl.numberOfLines = 2
                addressLbl.tag = tag++
                cell?.contentView.addSubview(addressLbl)
            }
            
            var tag = 10001
            let userLbl = cell?.viewWithTag(tag++) as! UILabel
            let phoneLbl = cell?.viewWithTag(tag++) as! UILabel
            let addressLbl = cell?.viewWithTag(tag++) as! UILabel
            
            if let dicForAddress = self.dic?["ShippingAddress"] as? NSDictionary,address = ZMDAddress.mj_objectWithKeyValues(dicForAddress) {
                userLbl.text = "收货人 ：\(address.FirstName)"
                phoneLbl.text = "\(address.PhoneNumber)"
                addressLbl.text = "收货地址:\(address.Address1!)\(address.Address2!)"
                let addressStr = addressLbl.text
                let addressSize = addressStr!.sizeWithFont(defaultSysFontWithSize(17), maxWidth: kScreenWidth - 24)
                addressLbl.frame = CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: addressSize.height)
            }
            return cell!
        } else{
            let cellId = "botCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                let botLbl = ZMDTool.getLabel(CGRect(x: 12, y: 0 , width: kScreenWidth, height: 55.5), text: "实付：0.0 获得0积分", fontSize: 16)
                botLbl.tag = 10001
                cell?.contentView.addSubview(botLbl)
            }
            let botLbl = cell?.viewWithTag(10001) as! UILabel
            if let total = self.dic?["OrderTotal"] as? String {
                botLbl.text = "实付：\(total)"
            }
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = tableViewdefaultBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView)
    }
    override func back() {
        if self.finished != nil {
            self.finished()
        } else {
            super.back()
        }
    }
    func fetchData() {
        QNNetworkTool.orderDetail(self.orderId) { (succeed, dictionary, error) -> Void in
            if succeed!  {
                self.dic = dictionary
                self.tableView.reloadData()
            }
        }
    }
}
