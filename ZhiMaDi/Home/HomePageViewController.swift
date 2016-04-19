//
//  HomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//首页
class HomePageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ZMDInterceptorProtocol {
    enum UserCenterCellType{
        case HomeContentTypeHead                    /* 头部选项 */
        case HomeContentTypeAd                      /* 广告显示页 */
        case HomeContentTypeMenu                    /* 菜单选择栏目 */
        case HomeContentTypeGoods                   /* 商品栏目 */
        case HomeContentTypeRecommendationHead      /* 推荐商品 Head*/
        case HomeContentTypeRecommendation          /* 推荐商品 */
        case HomeContentTypeTheme                   /* 特卖 主题展示 */
        init(){
            self = HomeContentTypeHead
        }
        var heightForHeadOfSection : CGFloat {
            switch  self {
            case .HomeContentTypeHead :
                return 0
            case .HomeContentTypeAd :
                return 0
            case .HomeContentTypeMenu :
                return 4
            case .HomeContentTypeGoods :
                return 0
            case .HomeContentTypeRecommendationHead:
                return 12
            case .HomeContentTypeRecommendation :
                return 0
            case .HomeContentTypeTheme :
                return 16
            }
        }
        var height : CGFloat {
            switch  self {
            case .HomeContentTypeHead :
                return 44
            case .HomeContentTypeAd :
                return kScreenWidth * 280 / 750
            case .HomeContentTypeMenu :
                return kScreenWidth * 250 / 750
            case .HomeContentTypeGoods :
                return kScreenWidth * 430 / 750
            case .HomeContentTypeRecommendationHead:
                return 48
            case .HomeContentTypeRecommendation :
                return 202
            case .HomeContentTypeTheme :
                return 206
            }
        }
    }
    enum MenuType{
        case Offer
        case Market
        case News
        case Sale
        case Buy
        
        init(){
            self = Offer
        }
        
        var title : String{
            switch self{
            case Offer:
                return "我的租贷"
            case Market:
                return "新品众筹"
            case News:
                return "卡券"
            case Sale:
                return "分类"
            case Buy:
                return "使用帮助"
            }
        }
        
        var image : UIImage?{
            switch self{
            case Offer:
                return UIImage(named: "home_zulin")
            case Market:
                return UIImage(named: "home_new")
            case News:
                return UIImage(named: "home_coupons")
            case Sale:
                return UIImage(named: "home_list")
            case Buy:
                return UIImage(named: "home_help")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Offer:
                let homeBuyListViewController = HomeLeaseListViewController.CreateFromMainStoryboard() as! HomeLeaseListViewController
                viewController = homeBuyListViewController
            case Market:
                viewController = CrowdfundingHomeViewController()
            case News:
                viewController = CardVolumeHomeViewController()
            case Sale:
                viewController = UIViewController()
            case Buy:
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
    var menuType: [MenuType]!
    var 下拉视窗 : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 让导航栏支持右滑返回功能
        ZMDTool.addInteractive(self.navigationController)
        updateUI()
        self.dataInit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().statusBarHidden = false //info.plist  View controller-based status bar appearance = no
        self.setupNewNavigation()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
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
        return self.userCenterData[section].heightForHeadOfSection
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.userCenterData[indexPath.section].height
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  self.userCenterData[indexPath.section] {
        case .HomeContentTypeHead :
            return self.cellForHomeHead(tableView, indexPath: indexPath)
        case .HomeContentTypeAd :
            return self.cellForHomeAd(tableView, indexPath: indexPath)
        case .HomeContentTypeMenu :
            return self.cellForHomeMenu(tableView, indexPath: indexPath)
        case .HomeContentTypeGoods :
            return self.cellForHomeGoods(tableView, indexPath: indexPath)
        case .HomeContentTypeRecommendationHead :
            return self.cellForHomeRecommendationHead(tableView, indexPath: indexPath)
        case .HomeContentTypeRecommendation :
            return self.cellForHomeRecommendation(tableView, indexPath: indexPath)
        case .HomeContentTypeTheme :
            return self.cellForHomeTheme(tableView, indexPath: indexPath)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: private method

    //MARK: 头部菜单 cell
    func cellForHomeHead(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "HeadCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let menuTitles = ["全部","床上用品","儿童家用","生活万花筒","布艺/软饰","生活空间"]
            let width = 80,height = 44
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 44, height: 44)) //66
            scrollView.backgroundColor = UIColor.clearColor()
            scrollView.contentSize = CGSize(width: width * menuTitles.count, height: height)
            cell?.contentView.addSubview(scrollView)
            var i = 0
            for title in menuTitles {
                let x = i * width,y = 0
                let frame = CGRect(x: x, y: y, width: width, height: height)
                i++
                
                let headBtn = UIButton(frame: frame)
                headBtn.setTitle(title, forState: .Normal)
                headBtn.titleLabel?.font = defaultDetailTextSize
                headBtn.setTitleColor(defaultDetailTextColor, forState: .Normal)
                headBtn.setTitleColor(defaultSelectColor, forState: .Selected)
                headBtn.titleLabel?.textAlignment = .Center
                headBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                })
                scrollView.addSubview(headBtn)
            }
            //下部弹窗
            let 下拉 = UIButton(frame: CGRect(x: kScreenWidth - 44, y: 8, width: 44, height: 28))
            下拉.backgroundColor = UIColor.whiteColor()
            下拉.setImage(UIImage(named: "home_down"), forState: .Normal)
            下拉.setImage(UIImage(named: "home_up"), forState: .Selected)
            下拉.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                if self.下拉视窗 == nil {
                    self.下拉视窗 = UIView(frame: CGRect(x: 0, y: 46, width: kScreenWidth, height: 150))
                    self.下拉视窗.backgroundColor = UIColor.whiteColor()
                    self.下拉视窗.alpha = 0.9
                    var i = 0
//                    let btnBg = UIView(frame: self.下拉视窗.bounds)
//                    btnBg.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
//                    self.下拉视窗.addSubview(btnBg)
                    for title in menuTitles {
                        let width = kScreenWidth/CGFloat(3),height = CGFloat(50)
                        let columnIndex  = i%3
                        let rowIndex = i/3
                        let x = CGFloat(columnIndex) * width ,y  = CGFloat(rowIndex)*50
                        i++

                        let menuBtn = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
                        menuBtn.backgroundColor = UIColor.grayColor()
                        menuBtn.setTitle(title, forState: .Normal)
                        menuBtn.titleLabel?.font = defaultDetailTextSize
                        menuBtn.setTitleColor(defaultTextColor, forState: .Normal)
                        menuBtn.setTitleColor(defaultSelectColor, forState: .Selected)
                        menuBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                        })
                        self.下拉视窗.addSubview(menuBtn)
                    }
                }
                if 下拉.selected {
                    self.下拉视窗.removeFromSuperview()
                } else {
                    cell?.contentView.addSubview(self.下拉视窗)
                }
                下拉.selected = !下拉.selected
            })
            cell?.contentView.addSubview(下拉)
        }
        return cell!
    }
    //MARK: 广告 cell
    func cellForHomeAd(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "AdCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 280 / 750))
            cycleScroll.backgroundColor = UIColor.blueColor()
            let image = ["home_banner01","home_banner02","home_banner03","home_banner04","home_banner05"]
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
            
            for var i=0;i<5;i++ {
                _ = 0
                let btnHeight = kScreenWidth * 250 / 750
                let width = kScreenWidth/5
                let btn = UIButton(frame: CGRectMake(kScreenWidth/5*CGFloat(i), 0 ,width, btnHeight))
                btn.tag = 10000 + i
                btn.backgroundColor = UIColor.whiteColor()
                
                let label = UILabel(frame: CGRectMake(0, btnHeight/2 + 25 + 10, width, 14))
                label.font = UIFont.systemFontOfSize(14)
                label.textColor = UIColor.blackColor()
                label.textAlignment =  .Center
                label.tag = 10010 + i
                btn.addSubview(label)
                
                let imgV = UIImageView(frame: CGRectMake(width/2-25, btnHeight/2 - 25 - 15, 50,50))
                imgV.tag = 10020 + i
                btn.addSubview(imgV)
                cell!.contentView.addSubview(btn)
            }
        }
        for var i=0;i<5;i++ {
            let menuType = self.menuType[i]
            let btn = cell?.contentView.viewWithTag(10000 + i) as! UIButton
            let label = cell?.contentView.viewWithTag(10010 + i) as! UILabel
            let imgV = cell?.contentView.viewWithTag(10020 + i) as! UIImageView
            btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                let btnType = self.menuType[sender.tag - 10000]
                if btnType == MenuType.Sale {
                    self.tabBarController?.selectedIndex = 1
                } else {
                    btnType.didSelect(self.navigationController!)
                }
                return RACSignal.empty()
            })
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
            
        }
        return cell!
    }
    //MARK: - 商品 cell
    func cellForHomeGoods(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "goodsCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        let titleLbl = cell?.viewWithTag(10001) as! UILabel
        titleLbl.textColor = defaultTextColor
        let detailLbl = cell?.viewWithTag(10002) as! UILabel
        detailLbl.textColor = defaultDetailTextColor
        return cell!
    }
    //MARK: - 推荐Head cell
    func cellForHomeRecommendationHead(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "RecommendationHeadCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor =  tableViewdefaultBackgroundColor
        }
        return cell!
    }
    //MARK: - 推荐 cell
    func cellForHomeRecommendation(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "RecommendationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = tableViewdefaultBackgroundColor
            
            let data = ["product03","product03","product03","product03","product03"]
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 180)) //66
            scrollView.contentSize = CGSize(width: (136 + 10) * CGFloat(data.count), height: 180)
            cell?.contentView.addSubview(scrollView)
            for var i=0;i<data.count;i++ {
                let btnHeight = CGFloat(180)
                let width = CGFloat(136)
                let btn = UIButton(frame: CGRectMake(10*CGFloat(i + 1)+CGFloat(i) * width, 0,width, btnHeight))
                btn.tag = 10000 + i
                btn.backgroundColor = UIColor.whiteColor()
                
                let titleLbl = UILabel(frame: CGRectMake(0, btnHeight-15-11 - 10 - 11, width, 11))
                titleLbl.font = UIFont.systemFontOfSize(11)
                titleLbl.textColor = defaultSelectColor
                titleLbl.textAlignment =  .Center
                titleLbl.tag = 10010 + i
                titleLbl.text = "儿童桌"
                btn.addSubview(titleLbl)
                
                let moneyLbl = UILabel(frame: CGRectMake(0, btnHeight-15-11, width, 11))
                moneyLbl.font = UIFont.systemFontOfSize(11)
                moneyLbl.textColor = defaultSelectColor
                moneyLbl.textAlignment =  .Center
                moneyLbl.tag = 10020 + i
                moneyLbl.text = "2毛"
                btn.addSubview(moneyLbl)
                
                let imgV = UIImageView(frame: CGRectMake(width/2-48, 30, 96,96))
                imgV.tag = 10030 + i
                imgV.image = UIImage(named: data[i])
                btn.addSubview(imgV)
                cell!.contentView.addSubview(btn)
                scrollView.addSubview(btn)
            }
        }
        return cell!
    }

    func setupNewNavigation() {
        let leftItem = UIBarButtonItem(image: UIImage(named: "Code-Scanner")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        leftItem.customView?.tintColor = UIColor.whiteColor()
        leftItem.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            
            return RACSignal.empty()
        })
        self.navigationItem.rightBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "home_search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        rightItem.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            let vc = HomeBuyGoodsSearchViewController.CreateFromMainStoryboard() as! HomeBuyGoodsSearchViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return RACSignal.empty()
        })
        rightItem.customView?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "home_logo"))
    }

    func updateData (){
        
    }
    func fetchData(){
    }
    private func dataInit(){
        self.userCenterData = [.HomeContentTypeHead,.HomeContentTypeAd,.HomeContentTypeMenu,.HomeContentTypeGoods,.HomeContentTypeRecommendationHead,.HomeContentTypeRecommendation, .HomeContentTypeTheme]
        self.menuType = [MenuType.Offer,MenuType.Market,MenuType.News, MenuType.Sale, MenuType.Buy]
    }
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
}
