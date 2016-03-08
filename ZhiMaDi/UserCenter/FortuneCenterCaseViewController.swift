//
//  FortuneCenterCaseViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/8.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//提现
class FortuneCenterCaseViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray : NSArray!
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
        return self.dataArray.count + 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewCellHeadDefaultHeight
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return indexPath.section == self.dataArray.count  ? 56 : 100
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < self.dataArray.count {
            let cellId = "cardCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        } else {
            let cellId = "moneyCell"
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

    //MARK: -  PrivateMethod
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 106))
        footView.backgroundColor = UIColor.clearColor()
        let label = UILabel(frame: CGRectMake(12, 14, kScreenWidth - 24,12))
        label.text = "可用金额 ： 35.00"
        label.textColor = UIColor.grayColor()
        label.font = defaultFontWithSize(12)
        let btn = UIButton(frame: CGRectMake(12, 50, kScreenWidth-24, 46))
        btn.setTitle("申请提现", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
           
        }
        footView.addSubview(label)
        footView.addSubview(btn)
        self.currentTableView.tableFooterView = footView
    }
}
