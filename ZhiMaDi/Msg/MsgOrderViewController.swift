//
//  MsgOrderViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 订单消息
class MsgOrderViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    
    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = ["","",""]
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
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MsgOrderTableViewCell.height
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = ZMDTool.getLabel(CGRect(x: 0, y: 0, width: kScreenWidth, height: 52), text:QNFormatTool.dateString(NSDate(), format: "yyyy-MM-dd HH:mm"), fontSize: 13,textColor: defaultDetailTextColor,textAlignment: .Center)
        return lbl
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OtherCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? MsgOrderTableViewCell
        if cell == nil {
            cell = MsgOrderTableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
        }
        cell?.updateUIWithData()
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "订单消息"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
}
