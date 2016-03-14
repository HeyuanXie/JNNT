//
//  HomeMarketDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/14.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//行情趋势-单品详请
class HomeMarketDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ZMDInterceptorProtocol{

    @IBOutlet weak var currentTableView: UITableView!
    var dealData : NSArray!  //实时成交
    override func viewDidLoad() {
        super.viewDidLoad()
        dealData = ["","",""]
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return self.dealData.count + 2
        }
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 10
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return kScreenWidth * 275 / 720
        }
        if indexPath.section == 1 {
            return 360
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 45
            }
            return 32
        }
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellId = "adCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 275 / 720))
                let image = ["Market01","Market02","Market03","Market04","Market05"]
                cycleScroll.imgArray = image
                //            cycleScroll.delegate = self
                cycleScroll.autoScroll = true
                cycleScroll.autoTime = 2.5
                cell?.addSubview(cycleScroll)
            }
            return cell!
        case 1:
            let cellId = "topCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 2:
            if indexPath.row == 0 {
                let cellId = "bottomTitleCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    
                    ZMDTool.configTableViewCellDefault(cell!)
                    let label = UILabel(frame: CGRectMake(12, 0, kScreenWidth - 24, 45))
                    label.text = "实时成交排行"
                    label.textColor = UIColor.blackColor()
                    label.font = defaultSysFontWithSize(14)
                    cell?.contentView.addSubview(label)
                }
                
                return cell!
            }
            //底部数据
            let cellId = "bottomCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let sellerLbl = cell?.viewWithTag(10001) as! UILabel
            let sizeLbl = cell?.viewWithTag(10002) as! UILabel
            let priceLbl = cell?.viewWithTag(10003) as! UILabel
            let currentLbl = cell?.viewWithTag(10004) as! UILabel
            //标题栏
            if indexPath.row == 1 {
                sellerLbl.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                sizeLbl.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                priceLbl.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                currentLbl.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
            }
            else {
                sellerLbl.text = "张三"
                sizeLbl.text = "80#"
                priceLbl.text = "5.3元/kg"
                currentLbl.text = "5.3元/kg"
            }
            return cell!
        default :
            let cellId = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
