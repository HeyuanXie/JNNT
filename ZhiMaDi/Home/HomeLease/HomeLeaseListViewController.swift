//
//  HomeLeaseViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/28.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//租赁列表
class HomeLeaseListViewController: UIViewController ,ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var currentTableView: UITableView!
    var popView : UIView!
    var cityPop : FindDoctorCityPopView!
    var filtedView : UIView!
    var filtedBtnSelect : UIButton!             //筛选-分类高亮btn
    var leaseBtnSelect : UIButton!              //筛选-租期高亮btn
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
        
        let cellId = self.isHorizontal ? "doubleLeaseCell" : "goodsLeaseCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! DoubleGoodsLeaseTableViewCell
        cell.goodsImgVLeft.image = UIImage(named: "home_banner02")
        if self.isHorizontal {
            let size = cell.currentPriceLblLeft.text?.sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 160)
            cell.currentPriceWidthLayout.constant = (size?.width)!
        } else {
            
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = HomeLeaseDetailViewController.CreateFromMainStoryboard() as! HomeLeaseDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    func createFilterMenu() -> UIView{
        let prices = ["默认","人气","价格","筛选",""]
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
                if self.filtedView == nil {
                    self.configFiltedView(CGRectGetMaxY(btn.frame) + 1, height: self.view.bounds.height - CGRectGetMaxY(btn.frame))
                }
                self.presentPopupView(self.filtedView,config: config)
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
    
    func configFiltedView (y:CGFloat,height:CGFloat) {
        let filtedView = UIView(frame: CGRectMake(0 , y, kScreenWidth,  height))
        filtedView.backgroundColor = UIColor.whiteColor()
        let filtedTitleLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 100, height: 16), text: "商品分类", fontSize: 16, textColor: defaultTextColor)
        filtedView.addSubview(filtedTitleLbl)
        let filetTitle = ["全部","床上用品","家具","日用品","植物","装饰品"]
        var i = 0
        var maxY : CGFloat = 0
        for title in filetTitle {
            let width = (kScreenWidth - 24 - 2 * 8)/3
            let Tmp = i%3 , Tmp2 = i/3
            let x = 12 + CGFloat(Tmp) * width + CGFloat(Tmp) * 8
            let y = 16 + 16 + 12 + CGFloat(Tmp2) * (38 + 8)
            
            let btn = UIButton(frame: CGRect(x: x, y: y, width: width, height: 38))
            btn.setBackgroundImage(UIImage.imageWithColor(RGB(240,240,240,1), size: btn.frame.size), forState: .Normal)
            btn.setBackgroundImage(UIImage.imageWithColor(RGB(235,61,61,1.0), size: btn.frame.size), forState: .Selected)

            btn.tag = 1000 + NSInteger(i)
            btn.titleLabel!.font = defaultSysFontWithSize(15)
            btn.setTitle(title, forState: .Normal)
            btn.setTitle(title, forState: .Selected)
            btn.setTitleColor(defaultTextColor, forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            filtedView.addSubview(btn)
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.filtedBtnSelect.selected = false
                self.filtedBtnSelect = sender as! UIButton
                self.filtedBtnSelect.selected = true
            })
            if i == 0 {
                btn.selected = true
                self.filtedBtnSelect = btn
            }
            i++
            if i == filetTitle.count {
                maxY = CGRectGetMaxY(btn.frame)
            }
        }
        filtedView.addSubview( ZMDTool.getLine(CGRect(x: 0, y: maxY + 16, width: kScreenWidth, height: 0.5)))
        
        let leaseTitleLbl = ZMDTool.getLabel(CGRect(x: 12, y: maxY + 32, width: 100, height: 16), text: "租期", fontSize: 16, textColor: defaultTextColor)
        filtedView.addSubview(leaseTitleLbl)
        let leaseTitle = ["全部","半年","一年半","两年"]
        var j = 0
        var maxLeaseY : CGFloat = 0
        for title in leaseTitle {
            let width = (kScreenWidth - 24 - 2 * 8)/3
            let Tmp = j%3 , Tmp2 = j/3
            let x = 12 + CGFloat(Tmp) * width + CGFloat(Tmp) * 8
            let y = maxY + 32 + 16 + 12 + CGFloat(Tmp2) * (38 + 8)
            let btn = UIButton(frame: CGRect(x: x, y: y, width: width, height: 38))
            btn.setBackgroundImage(UIImage.imageWithColor(RGB(240,240,240,1), size: btn.frame.size), forState: .Normal)
            btn.setBackgroundImage(UIImage.imageWithColor(RGB(235,61,61,1.0), size: btn.frame.size), forState: .Selected)
            btn.tag = 1000 + NSInteger(i)
            btn.titleLabel!.font = defaultSysFontWithSize(15)
            btn.setTitle(title, forState: .Normal)
            btn.setTitle(title, forState: .Selected)
            btn.setTitleColor(RGB(192,192,192,1), forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            filtedView.addSubview(btn)
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.leaseBtnSelect.selected = false
                self.leaseBtnSelect = sender as! UIButton
                self.filtedBtnSelect.selected = true
            })
            if j == 0 {
                btn.selected = true
                self.leaseBtnSelect = btn
            }
            j++
            if j == leaseTitle.count {
                maxLeaseY = CGRectGetMaxY(btn.frame)
            }
        }
        filtedView.addSubview( ZMDTool.getLine(CGRect(x: 0, y: maxLeaseY + 16, width: kScreenWidth, height: 0.5)))

        let btn = UIButton(frame: CGRect(x: 0, y: height - 56 , width: kScreenWidth, height: 56))
        btn.backgroundColor = RGB(235,61,61,1.0)
        btn.titleLabel!.font = defaultSysFontWithSize(18)
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        filtedView.addSubview(btn)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
        })
        
        self.filtedView = filtedView
    }
    
}
