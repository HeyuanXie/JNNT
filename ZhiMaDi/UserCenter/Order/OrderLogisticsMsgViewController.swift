//
//  OrderLogisticsMsgViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/1.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 查看物流信息
class OrderLogisticsMsgViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查看物流信息"
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 2
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 0 ? 170 : 45
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cellId = "MsgCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    
                    ZMDTool.configTableViewCellDefault(cell!)
                    cell?.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 169.5, width: kScreenWidth, height: 0.5)))
                }
                
                let nameLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20 , width: kScreenWidth - 24, height: 17), text: "顺丰物流", fontSize: 17)
                let numLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+15 , width: kScreenWidth-24, height: 17), text: "物流单号 ： 2532424324242", fontSize: 17)
                let paijianPersonLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+15+20+15 , width: kScreenWidth-24, height: 17), text: "物流单号 ： 派件员 : 莎拉波", fontSize: 17)
                cell?.contentView.addSubview(nameLbl)
                cell?.contentView.addSubview(numLbl)
                cell?.contentView.addSubview(paijianPersonLbl)
                
                return cell!
            }else{
                let cellId = "CopyCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    ZMDTool.configTableViewCellDefault(cell!)
                }
                let btn = ZMDTool.getButton(CGRect(x: kScreenWidth - 12 - 90, y: 0, width: 90, height: 45), textForNormal: "复制单号", fontSize: 14,textColorForNormal: defaultDetailTextColor, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                    
                })
                btn.setImage(UIImage(named: "common_order"), forState: .Normal)
                cell?.contentView.addSubview(btn)
                return cell!
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cellId = "MsgCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    
                    ZMDTool.configTableViewCellDefault(cell!)
                    cell?.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 169.5, width: kScreenWidth, height: 0.5)))
                }
                
                let nameLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20 , width: kScreenWidth - 24, height: 17), text: "顺丰物流", fontSize: 17)
                nameLbl.textAlignment = .Center
                let numLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+15 , width: kScreenWidth-24, height: 17), text: "物流单号 ： 2532424324242", fontSize: 17)
                let paijianPersonLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+15+20+15 , width: kScreenWidth-24, height: 17), text: "物流单号 ： 派件员 : 莎拉波", fontSize: 17)
                cell?.contentView.addSubview(nameLbl)
                cell?.contentView.addSubview(numLbl)
                cell?.contentView.addSubview(paijianPersonLbl)
                
                return cell!
            }
        }
        if indexPath.row == 0 {
            let cellId = "Cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                cell?.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }

            let nameLbl = ZMDTool.getLabel(CGRect(x: 12, y: 0 , width: kScreenWidth - 24, height: 55), text: "物流跟踪", fontSize: 17)
            nameLbl.textAlignment = .Center
            cell?.contentView.addSubview(nameLbl)
            return cell!
        }else {
            let cellId = "Cell\(indexPath.section)\(indexPath.row)"
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
