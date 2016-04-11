//
//  WalletMyBillsViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 我的帐单
class WalletMyBillsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    enum BillsType {
        case All
        case Income
        case Spending
        init() {
            self = All
        }
    }
    var currentTableView: UITableView!
    
    var dataArray : NSArray!
    let billsTypeAll = [BillsType.All,BillsType.Income,BillsType.Spending]
    var billsType = BillsType()
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
        switch self.billsType {
        case .All :
            return self.dataArray.count
        case .Income :
            return 1
        case .Spending :
            return 1
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.billsType == .Income {
            return 0
        }
        return section == 0 ? 16 : 0.5
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.billsType == .Income {
            return self.view.bounds.size.height - 55
        }
        return 60
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch self.billsType {
        case .All :
            let cellId = "Cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                let dolbl = ZMDTool.getLabel(CGRect(x: 12, y: 12, width: 100, height: 16), text: "提现", fontSize: 16)
                cell?.contentView.addSubview(dolbl)
                let moneylbl = ZMDTool.getLabel(CGRect(x: kScreenWidth -  12 - 100, y: 12, width: 100, height: 16), text: "-10.00元", fontSize: 16)
                cell?.contentView.addSubview(moneylbl)
                let timelbl = ZMDTool.getLabel(CGRect(x: 12, y: 12 + 16 + 10, width: 100, height: 16), text: "2016-02-26", fontSize: 16,textColor:defaultDetailTextColor)
                cell?.contentView.addSubview(timelbl)
                let balanceLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth -  12 - 100, y: 12 + 16 + 10, width: 100, height: 16), text: "余额：00元", fontSize: 16,textColor:defaultDetailTextColor)
                cell?.contentView.addSubview(balanceLbl)
            }
            
            return cell!
        case .Income:
            let cellId = "NOCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                cell?.contentView.backgroundColor = tableViewdefaultBackgroundColor
                let imgV = UIImageView(frame: CGRect(x: (kScreenWidth - 110)/2, y: (self.view.bounds.size.height - 55)/2 - 110, width: 110, height: 110))
                imgV.image = UIImage(named: "none_wallet")
                cell?.contentView.addSubview(imgV)
                let dolbl = ZMDTool.getLabel(CGRect(x: 12, y: (self.view.bounds.size.height - 55)/2 + 27, width: kScreenWidth - 24, height: 16), text: "你还没有相关记录", fontSize: 16)
                dolbl.textAlignment = .Center
                cell?.contentView.addSubview(dolbl)
            }
            
            return cell!
        case .Spending:
            let cellId = "Cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                let dolbl = ZMDTool.getLabel(CGRect(x: 12, y: 12, width: 100, height: 16), text: "提现", fontSize: 16)
                cell?.contentView.addSubview(dolbl)
                let moneylbl = ZMDTool.getLabel(CGRect(x: kScreenWidth -  12 - 100, y: 12, width: 100, height: 16), text: "-10.00元", fontSize: 16)
                cell?.contentView.addSubview(moneylbl)
                let timelbl = ZMDTool.getLabel(CGRect(x: 12, y: 12 + 16 + 10, width: 100, height: 16), text: "2016-02-26", fontSize: 16,textColor:defaultDetailTextColor)
                cell?.contentView.addSubview(timelbl)
                let balanceLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth -  12 - 100, y: 12 + 16 + 10, width: 100, height: 16), text: "余额：00元", fontSize: 16,textColor:defaultDetailTextColor)
                cell?.contentView.addSubview(balanceLbl)
            }
            
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = WalletInComeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "我的帐单"
        let menuTitle = ["全部","收入","支出"]
        let customJumpBtns = CustomJumpBtns(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 55),menuTitle: menuTitle)
        customJumpBtns.backgroundColor = UIColor.whiteColor()
        customJumpBtns.addSeparatedLine()
        self.view.addSubview(customJumpBtns)
        customJumpBtns.finished = { (index) ->Void in
            self.billsType = self.billsTypeAll[index]
            self.currentTableView.reloadData()
        }
        
        self.currentTableView = UITableView(frame: CGRect(x: 0, y: 55, width: kScreenWidth, height: self.view.bounds.size.height - 55))
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
}