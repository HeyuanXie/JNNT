//
//  HomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//首页
class HomePageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ZMDInterceptorNavigationBarHiddenProtocol {
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
        case Offer
        case Market
        case News
        case Sale
        case Buy
        case Loan
        
        init(){
            self = Offer
        }
        
        var title : String{
            switch self{
            case Offer:
                return "实时报价"
            case Market:
                return "行情趋势"
            case News:
                return "热点资讯"
            case Sale:
                return "我要卖"
            case Buy:
                return "我要买"
            case Loan:
                return "我要贷"
            }
        }
        
        var image : UIImage?{
            switch self{
            case Offer:
                return UIImage(named: "Home_Offer")
            case Market:
                return UIImage(named: "Home_Market")
            case News:
                return UIImage(named: "Home_News")
            case Sale:
                return UIImage(named: "Home_Sale")
            case Buy:
                return UIImage(named: "Home_Buy")
            case Loan:
                return UIImage(named: "Home_Loan")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Offer:
                let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                homeBuyListViewController.isBought = true
                viewController = homeBuyListViewController
            case Market:
                viewController = HomeMarketViewController.CreateFromMainStoryboard() as! HomeMarketViewController
            case News:
                viewController = UIViewController()
            case Sale:
                viewController = HomeSellViewController.CreateFromMainStoryboard() as! HomeSellViewController
            case Buy:
                viewController = HomeBuyViewController()
            case Loan:
                viewController = HomeLoanViewController()
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    @IBOutlet weak var currentTableView: UITableView!

    var window : UIWindow!
    var userCenterData: [UserCenterCellType]!
    var menuType: [MenuType]!
    let menuBtnTag = 10000
    let menuLblTag = 11000
    let menuImgTag = 11100
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
       
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        UIApplication.sharedApplication().statusBarHidden = false //info.plist  View controller-based status bar appearance = no
        self.setupNewNavigation()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.window.hidden = true
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
        return section > 1 ? 10 : 0
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
            return kScreenWidth*31/68
        case .HomeContentTypeRecommendation :
            return kScreenWidth * 185/720
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  self.userCenterData[indexPath.section] {
        case .HomeContentTypeAd :
            return self.cellForHomeAd(tableView, indexPath: indexPath)
        case .HomeContentTypeMenu :
            return self.cellForHomeMenu(tableView, indexPath: indexPath)
        case .HomeContentTypeTheme :
            return self.cellForHomeTheme(tableView, indexPath: indexPath)
        case .HomeContentTypeRecommendation :
            return self.cellForHomeRecommendation(tableView, indexPath: indexPath)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: - UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.navigationController?.pushViewController(HomeBuyGoodsSearchViewController(), animated: true)
        return true
    }
    //MARK: private method
    //MARK: 广告 cell
    func cellForHomeAd(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "AdCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 7/15))
            let image = ["Home_Top1_Advertisement","Home_Top2_Advertisement"]
            cycleScroll.imgArray = image
//            cycleScroll.delegate = self
            cycleScroll.autoScroll = true
            cycleScroll.autoTime = 2.5
            cell?.addSubview(cycleScroll)

        }
        return cell!
    }
    // 菜单
    func cellForHomeMenu(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "MenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            for var i=0;i<6;i++ {
                let tmp = i/3
                let btnY = tmp * Int(kScreenWidth/3)
                let btnHeightOrWidth = kScreenWidth/3
                let btn = UIButton(frame: CGRectMake(kScreenWidth/3*(CGFloat(i)%3), CGFloat(btnY), kScreenWidth/3, kScreenWidth/3))
                btn.tag = menuBtnTag + i
                btn.backgroundColor = UIColor.whiteColor()
                
                let label = UILabel(frame: CGRectMake(0, btn.bounds.height-24, kScreenWidth/3, 14))
                label.font = UIFont.systemFontOfSize(14)
                label.textColor = UIColor.blackColor()
                label.textAlignment =  .Center
                label.tag = menuLblTag + i
                btn.addSubview(label)
                
                let imgV = UIImageView(frame: CGRectMake(btnHeightOrWidth/2-30, (btnHeightOrWidth-84)/2, 60,60))
                imgV.tag = menuImgTag + i
                btn.addSubview(imgV)
                cell!.contentView.addSubview(btn)
            }
        }
        for var i=0;i<6;i++ {
            let menuType = self.menuType[i]
            let btn = cell?.contentView.viewWithTag(menuBtnTag + i) as! UIButton
            let label = cell?.contentView.viewWithTag(menuLblTag + i) as! UILabel
            let imgV = cell?.contentView.viewWithTag(menuImgTag + i) as! UIImageView
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
                menuType.didSelect(self.navigationController!)
            }
            label.text = menuType.title
            imgV.image = menuType.image
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
            
            let imgVLeft = UIImageView(frame: CGRectMake(0, 0, kScreenWidth/2,kScreenWidth*31/68))
            let imgVRightTop = UIImageView(frame: CGRectMake(kScreenWidth/2, 0, kScreenWidth/2,kScreenWidth*31/68/2))
            let imgVRightBot = UIImageView(frame: CGRectMake(kScreenWidth/2, kScreenWidth*31/68/2, kScreenWidth/2,kScreenWidth*31/68/2))
            imgVLeft.image = UIImage(named: "Home_Middle01_Advertisement")
            imgVRightTop.image = UIImage(named: "Home_Middle02_Advertisement")
            imgVRightTop.contentMode =  UIViewContentMode.Center
            imgVRightTop.contentMode = UIViewContentMode.ScaleAspectFit
            imgVRightBot.image = UIImage(named: "Home_Middle03_Advertisement")
            imgVRightBot.contentMode =  UIViewContentMode.Center
            imgVRightBot.contentMode = UIViewContentMode.ScaleAspectFit
            cell!.contentView.addSubview(imgVLeft)
            cell!.contentView.addSubview(imgVRightTop)
            cell!.contentView.addSubview(imgVRightBot)
 
            cell?.contentView.addSubview(ZMDTool.getLine(CGRectMake( kScreenWidth/2,0,1,kScreenWidth*31/68)))
            cell?.contentView.addSubview(ZMDTool.getLine(CGRectMake( kScreenWidth/2,kScreenWidth*31/68/2,kScreenWidth/2,1)))
        }
        return cell!
    }
    //MARK: - 底部 cell
    func cellForHomeRecommendation(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "RecommendationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
           
            let imgV = UIImageView(frame: CGRectMake(0, 0, kScreenWidth,kScreenWidth * 185/720))
            imgV.image = UIImage(named: "Home_bottom_Advertisement")
            imgV.contentMode =  UIViewContentMode.Center
            imgV.contentMode = UIViewContentMode.ScaleAspectFit
            cell!.contentView.addSubview(imgV)
        }
        return cell!
    }

    func setupNewNavigation() {
        if self.window == nil {
            window  = UIWindow(frame: CGRectMake(0, 30, kScreenWidth, 38))
            window.backgroundColor = UIColor.clearColor()
            window.alpha = 1.0
            window.hidden = false
            window.windowLevel = UIWindowLevelAlert + 1
            
            let searchBar = UISearchBar(frame: CGRectMake(12, 0, kScreenWidth - 62, 38))
            searchBar.backgroundColor = UIColor.clearColor()
            searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
            searchBar.placeholder = "商品查找"
            window.addSubview(searchBar)
            let searchBtn = UIButton(frame: searchBar.bounds)
            searchBar.addSubview(searchBtn)
            searchBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.tabBarController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(HomeBuyGoodsSearchViewController(), animated: true)
            })
            
            let imgV = UIImageView(frame: CGRectMake(kScreenWidth-40, 0, 28, 28))
            imgV.image = UIImage(named: "Home_Msg")
            window.addSubview(imgV)
            
            let label = UILabel(frame: CGRectMake(kScreenWidth-40, 28, 28, 10))
            label.text = "消息"
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.systemFontOfSize(10)
            label.textAlignment = .Center
            window.addSubview(label)
        }
        self.window.makeKeyAndVisible()
    }

    func updateData (){
        
    }
    func fetchData(){
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.HomeContentTypeAd,UserCenterCellType.HomeContentTypeMenu,UserCenterCellType.HomeContentTypeTheme, UserCenterCellType.HomeContentTypeRecommendation]
        self.menuType = [MenuType.Offer,MenuType.Market,MenuType.News, MenuType.Sale, MenuType.Buy, MenuType.Loan]
    }
    //
    
}
