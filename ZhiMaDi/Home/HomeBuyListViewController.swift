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
    var popView : UIView!
    var cityPop : FindDoctorCityPopView!

    var isHorizontal = true      // 横屏
    var dataArray = ["","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.setupNewNavigation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
        return self.isHorizontal ? (self.dataArray.count/2 + 1) : self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 52 + 16 : 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.isHorizontal ? 581/750 * kScreenWidth + 10 : 300/750 * kScreenWidth
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
        
        let cellId = self.isHorizontal ? "doubleGoodsCell" : "goodsCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! DoubleGoodsTableViewCell
        cell.goodsImgVLeft.image = UIImage(named: "home_banner02")
        if self.isHorizontal {
            
        } else {
            
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = HomeBuyGoodsDetailViewController.CreateFromMainStoryboard() as! HomeBuyGoodsDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    func createFilterMenu() -> UIView{
        let prices = ["默认","销量","价格","最新",""]
        let countForBtn = CGFloat(prices.count)
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 52 + 16))
        view.backgroundColor = UIColor.clearColor()
        for var i=0;i<prices.count;i++ {
            let index = i%prices.count
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * kScreenWidth/countForBtn , 0, kScreenWidth/countForBtn, 52))
            btn.backgroundColor = UIColor.whiteColor()
//            btn.setImage(UIImage(named: imageNormal), forState: .Normal)
//            btn.setImage(UIImage(named: imageSelected), forState: .Selected)
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitle(prices[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            btn.tag = 1000 + i
            view.addSubview(btn)
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                if (sender.tag - 1000) == prices.count - 1 {
                    self.isHorizontal = !self.isHorizontal
                    self.currentTableView.reloadData()
                    return
                }
                if self.cityPop == nil {
                    let height = kScreenHeight/3 * 2 - kScreenHeight/3 * 2 % 40
                    self.cityPop = FindDoctorCityPopView(frame: CGRectMake(0, CGRectGetMaxY(btn.frame), kScreenWidth,height))
//                    if self.currentCity != nil {
//                        cityPop.titleLbl.text = self.currentCity
//                    }
                }
                let config = ZMDPopViewConfig()
                config.showAnimation = .SlideInFromTop
                btn.presentPopupView(self.cityPop,config: config)
            })
            if i < 3 {
                let line = ZMDTool.getLine(CGRectMake(kScreenWidth/4 - 1, 20, 1, 13))
                btn.addSubview(line)
            }
        }
        return view
    }
    func setupNewNavigation() {
        let rightItem = UIBarButtonItem(image: UIImage(named: "home_search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        rightItem.tintColor = navigationTextColor
        rightItem.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            return RACSignal.empty()
        })
        rightItem.customView?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightItem
    }

    func popWindow () {
        self.popView = UIView(frame: CGRectMake(0 , 64+52, kScreenWidth,  self.view.bounds.height - 100))
        self.popView.backgroundColor = UIColor.blueColor()
        self.popView.showAsPopAndhideWhenClickGray()
    }
}
