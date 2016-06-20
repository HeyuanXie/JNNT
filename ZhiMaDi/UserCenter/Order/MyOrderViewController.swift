//
//  MyOrderViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/30.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 我的订单
class MyOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        QNNetworkTool.fetchOrder { (value, error) -> Void in
            if value != nil {
                if let tmp = value![0] as? NSDictionary,let orderItems = tmp["OrderItems"] as? NSArray {
                    self.dataArray.addObjectsFromArray(orderItems as [AnyObject])
                    self.currentTableView.reloadData()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        } else if indexPath.row == 1 {
            return 56
        } else if indexPath.row == 2 {
            return 56
        }
        return 0
        //        if indexPath.row == 2 {
        //            return 56
        //        } else if indexPath.row == 3 {
        //            return 56
        //        } else if indexPath.row == 4 {
        //            return 42
        //        }
        //        return  indexPath.row == 0 ? 48 : 110
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.cellForgoods(tableView, cellForRowAtIndexPath: indexPath)
        }
        if indexPath.row == 1 {
            return self.cellForTotal(tableView, cellForRowAtIndexPath: indexPath)
        }
        if indexPath.row == 2 {
            return self.cellForMenu(tableView, cellForRowAtIndexPath: indexPath)
        }
        if indexPath.row == 0 {
            let cellId = "StoreCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 47.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
        } else if indexPath.row == 2 {
            let cellId = "TotalCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
                cell?.contentView.addSubview(line)
            }
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 55.5), text: "共2件商品,合计:318.0(含运费 : 0.00)", fontSize: 14)
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            
            return cell!
        } else if indexPath.row == 3 {
            let cellId = "MenuCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
                cell?.contentView.addSubview(line)
            }
            let titles = ["到期归还","到期续租","评价","订单详情"]
            var i = 0,minX = CGFloat(0)
            for title in titles {
                let size = title.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 100)
                let width = size.width + 32 ,height = CGFloat(35)
                let x = kScreenWidth - 12 - width - minX,y = CGFloat(12)
                minX = kScreenWidth - x
                let btn = ZMDTool.getMutilButton(CGRect(x: x, y: y, width: width, height: height), textForNormal: title, fontSize: 14, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                    if titles[sender.tag-1000] == "订单详情" {
                        let vc = MyOrderDetailViewController.CreateFromMainStoryboard() as! MyOrderDetailViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if titles[sender.tag-1000] == "评价" {
                        let vc = OrderGoodsScoreViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
                btn.tag = 1000+i
                i++
                ZMDTool.configViewLayerFrame(btn)
                ZMDTool.configViewLayer(btn)
                cell?.contentView.addSubview(btn)
            }
            return cell!

        } else if indexPath.row == 4 {
            let cellId = "ReturnCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 42), text: "剩余归还时间：47时:56分:10秒", fontSize: 14,textColor:RGB(235,61,61,1.0))
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            return cell!
        } else {
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        let menuTitle = ["全部","待付款","待发货","待收货","待评价"]
        let customJumpBtns = CustomJumpBtns(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 55),menuTitle: menuTitle)
        self.view.addSubview(customJumpBtns)
    }
    func cellForgoods(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "GoodsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
        let dic = self.dataArray[indexPath.section] as! NSDictionary
        cell.configCellWithDic(dic)
        return cell
    }
    func cellForTotal(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "TotalCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            
            let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 55.5), text: "共\(self.dataArray.count)件商品,合计:0.0", fontSize: 14) // (含运费 : 0.00)
            label.textAlignment = .Right
            label.tag = 10001
            cell?.contentView.addSubview(label)
        }
        let lbl = cell?.viewWithTag(10001) as! UILabel
        lbl.text = "共\(self.dataArray.count)件商品,合计:0.0"
        return cell!
    }
    func cellForMenu(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "MenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
        }
        let titles = ["评价","订单详情"]
        var i = 0,minX = CGFloat(0)
        for title in titles {
            let size = title.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 100)
            let width = size.width + 32 ,height = CGFloat(35)
            let x = kScreenWidth - 12 - width - minX,y = CGFloat(12)
            minX = kScreenWidth - x
            let btn = ZMDTool.getMutilButton(CGRect(x: x, y: y, width: width, height: height), textForNormal: title, fontSize: 14, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                if titles[sender.tag-1000] == "订单详情" {
                    let vc = MyOrderDetailViewController.CreateFromMainStoryboard() as! MyOrderDetailViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if titles[sender.tag-1000] == "评价" {
                    let vc = OrderGoodsScoreViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            btn.tag = 1000+i
            i++
            ZMDTool.configViewLayerFrame(btn)
            ZMDTool.configViewLayer(btn)
            cell?.contentView.addSubview(btn)
        }
        return cell!
    }
}
