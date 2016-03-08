//
//  FortuneCenterViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//  财富中心
class FortuneCenterViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol,ZMDInterceptorNavigationBarShowProtocol{
    
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.dataArray = ["","","",""]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section>1 ? 10 :  0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            return 90
        case 1 :
            return 58
        case 2 :
            return 140
        case 3 :
            return 140
        default :
            return 0
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellId = "headCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 1 :
            let cellId = "rechargeCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let caseBtn = cell?.viewWithTag(10001) as! UIButton
            caseBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                
            })
            return cell!
        case 2 :
            let cellId = "frozeCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 3 :
            let cellId = "alalysisCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
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
