//
//  BuyConfirmOrderViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 确认订单
class BuyConfirmOrderViewController: UIViewController,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        
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
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1  {
            return 140
        }
        else if indexPath.section == 4 {
            return 75
        }
        return  tableViewCellDefaultHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cellId = "goodsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        } else if indexPath.section == 4 {
            let cellId = "confirmCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            
            return cell!

        }else {
            let cellId = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let titles = ["货主 ：","","请选择收货地址","请选择物流方式"]
            if indexPath.section == 0 {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            cell?.textLabel!.text = titles[indexPath.section]
            
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 { //收货地址
            let vc = AddressViewController.CreateFromMainStoryboard() as! AddressViewController
            vc.selectAddressFinished = { (address) ->Void in
               let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.textLabel?.text = address
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 3 { //物流方式
            let vc = LogisticsViewController()
            vc.finished = { (logistics) ->Void in
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.textLabel?.text = logistics
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
