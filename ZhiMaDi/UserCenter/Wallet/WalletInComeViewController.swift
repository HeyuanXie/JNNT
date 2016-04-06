//
//  WalletInComeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 帐单详情
class WalletInComeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol  {
    enum CellType {
        case Head
        case DealType
        case Pay
        case Time
        init() {
            self = Head
        }
        var title : String {
            switch self {
            case .DealType :
                return "交易类型"
            case .Pay :
                return "支付方式"
            case .Time :
                return "交易时间"
            default :
                return ""
            }
        }
    }
    var currentTableView: UITableView!
    let cellType = [CellType.Head,CellType.DealType,CellType.Pay,CellType.Time]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return cellType.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.cellType[section]{
        case .Head :
            return 16
        case .DealType :
            return 16
        default :
            return 1
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch self.cellType[indexPath.section]{
        case .Head :
            return 115
        default :
            return 56
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let type = self.cellType[indexPath.section]
        switch type {
        case .Head :
            let cellId = "HeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                let imgV = UIImageView(frame: CGRect(x: 12, y: 12, width: 32, height: 32))
                imgV.image = UIImage(named: "user_wallet_add")
                cell?.contentView.addSubview(imgV)
                
                let topLbl = ZMDTool.getLabel(CGRect(x: 12+32+18, y: 20, width: 200, height: 17), text: "收入金额(元)", fontSize: 17)
                cell?.contentView.addSubview(topLbl)
                let moneyLbl = ZMDTool.getLabel(CGRect(x: 12, y: 62, width: kScreenWidth - 24, height: 26), text: "+100.00", fontSize: 26)
                moneyLbl.textAlignment = .Center
                cell?.contentView.addSubview(moneyLbl)
            }
            return cell!
        default :
            let cellId = "Cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = tableViewCellDefaultBackgroundColor
                cell!.textLabel?.font = tableViewCellDefaultTextFont
                cell!.textLabel?.textColor = tableViewCellDefaultDetailTextColor
                cell!.detailTextLabel?.font = tableViewCellDefaultTextFont
                cell!.detailTextLabel?.textColor = tableViewCellDefaultTextColor
                
                let lbl = ZMDTool.getLabel(CGRect(x: 108, y: 0, width: kScreenWidth - 108 - 12, height: 56), text: "充值", fontSize: 17, textColor: defaultTextColor)
                cell?.contentView.addSubview(lbl)
            }
            cell?.textLabel!.text = type.title
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "我的帐单"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
}
