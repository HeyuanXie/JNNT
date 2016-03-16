//
//  LogisticsViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//选择物流方式
class LogisticsViewController: UIViewController ,  UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    
    var tableView : UITableView!
    
    var finished : ((logistics : String) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subViewInit()
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
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 44 : 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellDefaultHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let label = UILabel(frame: CGRectMake(0, 0, kScreenWidth, 44))
            label.font = defaultSysFontWithSize(12)
            label.text = "   请选择物流方式"
            return label
        }
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 1))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        cell?.textLabel!.text = indexPath.section == 0 ? "物流到付" : "货到付款"
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let text = indexPath.section == 0 ? "物流到付" : "货到付款"
        self.finished(logistics: text)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "帐户安全"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = tableViewdefaultBackgroundColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }

}
