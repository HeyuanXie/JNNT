//
//  HomeBuyListViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/24.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//商品列表
class HomeBuyListViewController: UIViewController ,ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var currentTableView: UITableView!
    var isBought = false
    var popView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.tableHeaderView = self.createHeadAd()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.isBought ?  208 : 170
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.createFilterMenu()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = !self.isBought ? "goodsCell" : "goodsBoughtCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK: -  PrivateMethod
    //headView
    func createHeadAd() -> UIView{
        let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 7/15))
        let image = ["Home_Top1_Advertisement","Home_Top2_Advertisement"]
        cycleScroll.imgArray = image
        //            cycleScroll.delegate = self
        cycleScroll.autoScroll = true
        cycleScroll.autoTime = 2.5
        return cycleScroll
    }
    func createFilterMenu() -> UIView{
        let prices = !self.isBought ? ["价格","分类","品种","区域"] : ["全部","价格","成交量","筛选"]
        let (imageNormal,imageSelected) = ("Home_Buy_Filter1","Home_Buy_Filter2")
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 52))
        for var i=0;i<4;i++ {
            let index = i%4
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * kScreenWidth/4 , 0, kScreenWidth/4, 52))
            btn.backgroundColor = UIColor.whiteColor()
            btn.setImage(UIImage(named: imageNormal), forState: .Normal)
            btn.setImage(UIImage(named: imageSelected), forState: .Selected)
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            view.addSubview(btn)
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.popWindow()
            })
            if i < 3 {
                let line = ZMDTool.getLine(CGRectMake(kScreenWidth/4 - 1, 20, 1, 13))
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