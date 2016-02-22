//
//  HomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//首页
class HomePageViewController: UIViewController,QNInterceptorProtocol,UITableViewDataSource,UITableViewDelegate {
    enum UserCenterCellType{
        case HomeContentTypeAd                      /* 广告显示页 */
        case HomeContentTypeMenu                    /* 菜单选择栏目 */
        case HomeContentTypeTheme                   /* 主题展示 */
        case HomeContentTypeRecommendation          /* 推荐广告 */
        
        init(){
            self = HomeContentTypeAd
        }
    }
    enum MenuType{
        case NewProduct
        case Exchange
        case Goods
        case OfferCenter
        case Financia
        case Customer
        case Data
        case Order
        
        init(){
            self = NewProduct
        }
        
        var title : String{
            switch self{
            case NewProduct:
                return "新品发布"
            case Exchange:
                return "我要换手"
            case Goods:
                return "商品管理"
            case OfferCenter:
                return "报价中心"
            case Financia:
                return "财务管理"
            case Customer:
                return "客户管理"
            case Data:
                return "数据中心"
            case Order:
                return "订单管理"
            }
        }
        
        var image : UIImage?{
            switch self{
            case NewProduct:
                return UIImage(named: "MineHome_NewProduct")
            case Exchange:
                return UIImage(named: "MineHome_Exchange")
            case Goods:
                return UIImage(named: "MineHome_GoodsManagement")
            case OfferCenter:
                return UIImage(named: "MineHome_OfferCenter")
            case Financia:
                return UIImage(named: "MineHome_FinancialManagement")
            case Customer:
                return UIImage(named: "MineHome_CustomerManagement")
            case Data:
                return UIImage(named: "MineHome_DataCenter")
            case Order:
                return UIImage(named: "MineHome_OrderManagement")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case NewProduct:
                viewController = UIViewController()
            case NewProduct:
                viewController = UIViewController()
            case Exchange:
                viewController = UIViewController()
            case Goods:
                viewController = UIViewController()
            case OfferCenter:
                viewController = UIViewController()
            case Financia:
                viewController = UIViewController()
            case Customer:
                viewController = UIViewController()
            case Data:
                viewController = UIViewController()
            case Order:
                viewController = UIViewController()
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    @IBOutlet weak var currentTableView: UITableView!
    var userCenterData: [UserCenterCellType]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
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
        return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch  self.userCenterData[indexPath.section] {
        case .HomeContentTypeAd :
            return kScreenWidth * 7/15
        case .HomeContentTypeMenu :
            return kScreenWidth/3*2
        case .HomeContentTypeTheme :
            return kScreenWidth*360/750
        case .HomeContentTypeRecommendation :
            return kScreenWidth * 185/720
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  self.userCenterData[indexPath.section] {
        case .HomeContentTypeAd :
            self.cellForHomeAd(tableView, indexPath: indexPath)
        case .HomeContentTypeMenu :
            self.cellForHomeMenu(tableView, indexPath: indexPath)
        case .HomeContentTypeTheme :
            self.cellForHomeTheme(tableView, indexPath: indexPath)
        case .HomeContentTypeRecommendation :
            self.cellForHomeRecommendation(tableView, indexPath: indexPath)
        }
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    //MARK: private method
    // 广告 cell 
    func cellForHomeAd(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "AdCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    // 菜单
    func cellForHomeMenu(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "MenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        let btn = UIButton()
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            
        }
        return cell!
    }
    // 主题 cell
    func cellForHomeTheme(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "ThemeCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    // 底部 cell
    func cellForHomeRecommendation(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "RecommendationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    func updateData (){
        
    }
    func fetchData(){
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.HomeContentTypeAd,UserCenterCellType.HomeContentTypeMenu,UserCenterCellType.HomeContentTypeTheme, UserCenterCellType.HomeContentTypeRecommendation]
    }
}
