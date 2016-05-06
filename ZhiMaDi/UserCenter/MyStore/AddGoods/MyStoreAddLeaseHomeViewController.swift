//
//  MyStoreAddLeaseHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/3.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 添加出租商品
class MyStoreAddLeaseHomeViewController:  UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    
    let titles = ["选择已有商品","发布新商品"]
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
        return titles.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 016
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = indexPath.row == 0 ? "Cell01" : "Cell02"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            if indexPath.row == 0 {
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let homeBuyListViewController = MyStoreAddLeaseViewController()
            self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
        } else {
            
        }
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "添加出租商品"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
}
