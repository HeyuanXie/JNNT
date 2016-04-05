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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
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
            }
            let userLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 300, height: 17), text: "收货人 ：葫芦一娃", fontSize: 17)
            cell?.contentView.addSubview(userLbl)
            let phoneLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 120, y: 16, width: 300, height: 17), text: "13780338447", fontSize: 17)
            cell?.contentView.addSubview(phoneLbl)
            let addressStr = "收货地址:广东省东莞市松山湖高新技术产业园新新"
            let addressSize = addressStr.sizeWithFont(defaultSysFontWithSize(17), maxWidth: kScreenWidth - 24)
            let addressLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: addressSize.height), text: addressStr, fontSize: 17)
            addressLbl.numberOfLines = 2
            cell?.contentView.addSubview(addressLbl)
            return cell!
        } else{
            let cellId = "botCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let botLbl = ZMDTool.getLabel(CGRect(x: 12, y: 0 , width: kScreenWidth, height: 55.5), text: "实付：525.0 获得20积分", fontSize: 16)
            cell?.contentView.addSubview(botLbl)
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
}
