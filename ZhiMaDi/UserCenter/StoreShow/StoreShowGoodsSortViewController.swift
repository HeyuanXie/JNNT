//
//  StoreShowGoodsSortViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/20.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品分类
class StoreShowGoodsSortViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    
    let dataArray = [["全部商品"],["租赁商品"],["床上用品","家具","日用品"]]
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
        return self.dataArray[section].count
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
        return 56
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let arr = self.dataArray[indexPath.section]
        if indexPath.row != arr.count - 1 {
            let cellId = "HasLineCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell?.textLabel?.text = self.dataArray[indexPath.section][indexPath.row]
            return cell!
        } else {
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.dataArray[indexPath.section][indexPath.row]
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        homeBuyListViewController.isStore = true
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "商品分类"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
}
