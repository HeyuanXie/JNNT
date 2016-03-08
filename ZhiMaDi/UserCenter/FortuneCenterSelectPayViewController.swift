//
//  FortuneCenterSelectPayViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/8.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//选择支付方式
class FortuneCenterSelectPayViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {

    
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = [["",""],["",""]]
        self.updateUI()
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
        return tableViewCellHeadDefaultHeight
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0  ? 56 : 60
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "topCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel!.text = "订单名称 ： "
            return cell!
        } else {
            let cellId = "payCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.imageView?.image = UIImage(named: "Home_Buy")
            cell?.textLabel?.text = "支付宝支付"
            let imgV = UIImageView(frame: CGRectMake(kScreenWidth - 50 , 11, 38, 38))
            imgV.image  = UIImage(named: "Login_Selected")
            cell?.contentView.addSubview(imgV)
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
        
        let btn = UIButton(frame: CGRectMake(12, 50, kScreenWidth-24, 46))
        btn.setTitle("确认支付", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor(red: 237/255, green: 191/255, blue: 28/255, alpha: 1.0)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            
        }
        footView.addSubview(btn)
        self.currentTableView.tableFooterView = footView
    }

}
