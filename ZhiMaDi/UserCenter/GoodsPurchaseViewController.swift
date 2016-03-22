//
//  GoodsPurchaseViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/18.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//采购管理
class GoodsPurchaseViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    var popView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        // 让导航栏支持右滑返回功能
        ZMDTool.addInteractive(self.navigationController)
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
        return section == 0 ? 62 : 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 248
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.createFilterMenu()
        } else {
            let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
            headView.backgroundColor = UIColor.clearColor()
            return headView
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "goodsCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        if let takeGoodsBtn = cell?.viewWithTag(10008) as? UIButton {
            ZMDTool.configViewLayerFrame(takeGoodsBtn)
            ZMDTool.configViewLayer(takeGoodsBtn)
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func createFilterMenu() -> UIView{
        let prices = ["全部","待付款","待提货","待发货","待收货","已完成"]
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 52))
        for var i=0;i<prices.count;i++ {
            let index = i%prices.count
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * kScreenWidth/CGFloat(prices.count) , 0, kScreenWidth/CGFloat(prices.count), 52))
            btn.backgroundColor = UIColor.whiteColor()
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            view.addSubview(btn)
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.popWindow()
            })
            if i < prices.count {
                let line = ZMDTool.getLine(CGRectMake(kScreenWidth/CGFloat(prices.count) - 1, 20, 1, 13))
                btn.addSubview(line)
            }
        }
        return view
    }
    func popWindow () {
        self.popView = UIView(frame: CGRectMake(0 , 64+52, kScreenWidth,  self.view.bounds.height - 100))
        self.popView.backgroundColor = UIColor.blueColor()
        self.popView.showAsPopAndhideWhenClickGray()
    }
}
