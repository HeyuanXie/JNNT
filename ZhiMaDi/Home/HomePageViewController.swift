//
//  HomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import AVFoundation
//首页
class HomePageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,CycleScrollViewDelegate,ZMDInterceptorProtocol,UITextFieldDelegate {
    //首页section的枚举
    enum UserCenterCellType{
        case HomeContentTypeAd                      /* 广告显示页 */
        case HomeContentTypeMenu                    /* 菜单选择栏目 */
        case HomeContentTypeGoods                   /* 商品栏目 */
        case HomeContentTypeRecommendationHead      /* 推荐商品 Head*/
        case HomeContentTypeRecommendation          /* 推荐商品 */
        case HomeContentTypeTheme                   /* 特卖 主题展示 */
        init(){
            self = HomeContentTypeAd
        }
        
        var heightForHeadOfSection : CGFloat {
            switch  self {
            case .HomeContentTypeAd :
                return 0
            case .HomeContentTypeMenu :
                return 4
            case .HomeContentTypeGoods :
                return 2
            case .HomeContentTypeRecommendationHead:
                return 0
            case .HomeContentTypeRecommendation :
                return 0
            case .HomeContentTypeTheme :
//                return 16
                return 30
            }
        }
        
        var height : CGFloat {
            switch  self {
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
                return 9 + 21 + 6 + 10 + 13 + (kScreenWidth-12*2)*23/57 + 8
            }
        }
    }
    
    //菜单选择类型枚举
    enum MenuType {
        
        case kFeature
        case kCate
        case kPublic
        case kInformation
        
        init(){
            self = kFeature
        }
        
        //菜单选择名称枚举
        var title : String{
            switch self{
            case kFeature:
                return "喀什特色"
            case .kCate:
                return "美食汇"
            case .kPublic:
                return "公益"
            case .kInformation:
                return "农产资讯"
            }
        }
        
        //菜单选择图片枚举
        var image : UIImage?{
            switch self{
            case .kFeature:
                return UIImage(named: "01")
            case .kCate:
                return UIImage(named: "02")
            case .kPublic:
                return UIImage(named: "03")
            case .kInformation:
                return UIImage(named: "04")
            }
        }
        
        //点击菜单选择，跳转目标VC的枚举
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case .kFeature:
                viewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                (viewController as! HomeBuyListViewController).Cid = "172"
                (viewController as! HomeBuyListViewController).As = "true"
                (viewController as! HomeBuyListViewController).title = "喀什特色"
            case .kCate:
                viewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                (viewController as! HomeBuyListViewController).Cid = "173"
                (viewController as! HomeBuyListViewController).As = "true"
                (viewController as! HomeBuyListViewController).title = "美食汇"
            case .kPublic:
                viewController = MyWebViewController()
                (viewController as! MyWebViewController).webUrl = "http://www.ksnongte.com/t/gongyi"
//                (viewController as! MyWebViewController).title = "喀什公益"
            case .kInformation:
                viewController = MyWebViewController()
                (viewController as! MyWebViewController).webUrl = "http://www.ksnongte.com/news/list?CategoryId=2"
//                (viewController as! MyWebViewController).title = "农产资讯"
                (viewController as! MyWebViewController).hideWebNavi = true
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        //点击菜单选择，调用方法跳转
        func didSelect(navViewController:UINavigationController){
            self.pushViewController.hidesBottomBarWhenPushed = true
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    
    var userCenterData: [UserCenterCellType]!
    var menuType: [MenuType]!
    var 下拉视窗 : UIView!
    var categories = NSMutableArray()
    var advertisementAll : ZMDAdvertisementAll!
    
    var textInput: UITextField!
    
    var menus = NSMutableArray()    //menuCell的数据
    var history = NSMutableArray()  //浏览历史(猜你喜欢、大家都在看)数据
    var goods = NSMutableArray()    //goodCell数据
    var themes = NSMutableArray()   //特卖专题数据
    
    var noticeView : HYNoticeView!
    var networkObserver : Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkObserver = Reachability.reachabilityForInternetConnection()
        //检测更新
        if !APP_DIDLAUNCHED {
            self.checkUpdate()
        }
        // 让导航栏支持右滑返回功能
        ZMDTool.addInteractive(self.navigationController)
        self.updateUI()//设置table背景色
        self.dataInit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController!.tabBar.hidden = false
        self.fetchData()
        self.setupNewNavigation()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        APP_DIDLAUNCHED = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: checkUpdate
    func checkUpdate() {
        var version = "0.0.0"
        QNNetworkTool.checkUpdate { (error, dictionary) in
            if let dic = dictionary,arr = dic["results"] as? NSArray, resultCount = dic["resultCount"] as? Int where resultCount != 0 {
                if let dict = arr[0] as? NSDictionary {
                    if let appStoreVersion = dict["version"] as? String  {
                        version = appStoreVersion
                        saveObjectToUserDefaults("appStoreVersion", value: version)
                        self.compareTheVersion()
                    }
                }
            }
        }
    }
    
    func compareTheVersion() {
        let appStoreVersion = getObjectFromUserDefaults("appStoreVersion") as! String
        if appStoreVersion == "0.0.0" {
            return
        }
        let result = compareVersion(APP_VERSION, version2: appStoreVersion)
        if result == NSComparisonResult.OrderedAscending {
            self.commonAlertShow(true, btnTitle1: "确定", btnTitle2: "下一次", title: "版本更新", message: "检测到新版本\(appStoreVersion)可用\n是否立即更新?", preferredStyle: .Alert)
        }
    }
    
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userCenterData[section] == .HomeContentTypeGoods {
            return self.goods.count != 0 ? 1 : 0
        }
        //如果为专题section
        if self.userCenterData[section] == .HomeContentTypeTheme {
            if let advertisementAll = self.advertisementAll,topic = advertisementAll.topic {
                return topic.count
            }
            return 0
        }
       //其他section全部只有 1 行
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
        let cellType = self.userCenterData[section]
        //如果为特卖专题，自定义headerView
        if cellType == .HomeContentTypeTheme {
            headView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 30)
            let redView = UIView(frame: CGRect(x: 12, y: 0, width: 8, height: 15))
            redView.backgroundColor = UIColor.redColor()
            redView.center.y = headView.center.y
            let titleLabel = ZMDTool.getLabel(CGRect(x: CGRectGetMaxX(redView.frame)+10, y: 0, width: 90, height: 15), text: "特卖专场", fontSize: 15)
            titleLabel.textAlignment = .Left
            titleLabel.center.y = headView.center.y
            titleLabel.textColor = defaultTextColor
            let line = ZMDTool.getLine(CGRect(x: 12, y: headView.frame.height-1, width: kScreenWidth-2*12, height: 1), backgroundColor: defaultGrayColor)
            headView.addSubview(redView)
            headView.addSubview(titleLabel)
            headView.addSubview(line)
            headView.backgroundColor = UIColor.whiteColor()
        }
        return headView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.userCenterData[indexPath.section] == .HomeContentTypeMenu {
            return self.menus.count > 5 ? zoom(235) : zoom(124)
        }
        return self.userCenterData[indexPath.section].height
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  self.userCenterData[indexPath.section] {
        case .HomeContentTypeAd :
            return self.cellForHomeAd(tableView, indexPath: indexPath)
        case .HomeContentTypeMenu :
            return self.cellForHomeAutoMenu(tableView, indexPath: indexPath)
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
        if indexPath.section == self.userCenterData.count-1 {
            if let advertisementAll = self.advertisementAll,topic = advertisementAll.topic {
                let advertisement = topic[indexPath.row]
                self.advertisementClick(advertisement)
            }
        }
    }
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField.text != "" {
            self.view.viewWithTag(100)?.removeFromSuperview()
            let vc = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
            vc.titleForFilter = textField.text ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return true
    }
    //点击背景、收起键盘
    func textFieldDidBeginEditing(textField: UITextField) {
        let bgBtn = UIButton(frame: self.view.bounds)
        bgBtn.tag = 100
        self.presentPopupView(bgBtn, config: .None)
        bgBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            bgBtn.removeFromSuperview()
            self.textInput.resignFirstResponder()
            return RACSignal.empty()
        })
    }
    
    //MARK: 广告分区cycleScrollView delegate
    func clickImgAtIndex(index: Int) {
        //点击cycleScrollView中图片，响应事件
        if let advertisementAll = self.advertisementAll,top = advertisementAll.top {
            let advertisement = top[index]
            self.advertisementClick(advertisement)
        }
    }

    
    //MARK: - **************TableViewCell*****************
    //MARK: 广告 cell(CycleScrollView)
    func cellForHomeAd(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "AdCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        if let v = cell?.viewWithTag(10001) {
            v.removeFromSuperview()
        }
        let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 280 / 750))
        cycleScroll.tag = 10001
        cycleScroll.backgroundColor = UIColor.whiteColor()
        cycleScroll.delegate = self
        cycleScroll.autoScroll = true
        cycleScroll.autoTime = 2.5
        let imgUrls = NSMutableArray()
        
        if self.advertisementAll != nil && self.advertisementAll.top != nil {
            for id in self.advertisementAll.top! {
                var url = kImageAddressMain + (id.ResourcesCDNPath ?? "")
                if id.ResourcesCDNPath!.hasPrefix("http") {
                    url = id.ResourcesCDNPath!
                }
                url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                imgUrls.addObject(NSURL(string: url)!)
            }
            if imgUrls.count != 0 {
                cycleScroll.urlArray = imgUrls as [AnyObject]
            }
        }
        cell?.addSubview(cycleScroll)
        return cell!
    }
    // 菜单
    func cellForHomeAutoMenu(tableView:UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "AutoMenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            ZMDTool.configTableViewCellDefault(cell!)
            
            for var i=0;i<self.menus.count;i++ {
                let btnHeight = zoom(124)
                let btnWidth = self.menus.count >= 5 ? kScreenWidth/5 : kScreenWidth/CGFloat(self.menus.count)
                let btnX = CGFloat(i%5)*btnWidth
                let btnY = i >= 5 ? zoom(110) : 0
                let btn = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
                btn.tag = 10000 + i
                btn.backgroundColor = UIColor.whiteColor()
                
                let label = UILabel(frame: CGRectMake(0, zoom(90), btnWidth, zoom(14)))
                label.font = UIFont.systemFontOfSize(14)
                label.textColor = defaultTextColor
                label.textAlignment =  .Center
                label.tag = 10010 + i
                btn.addSubview(label)
                
                let imgV = UIImageView(frame: CGRectMake(btnWidth/2-zoom(28.5), zoom(20), zoom(57),zoom(57)))
                imgV.tag = 10020 + i
                btn.addSubview(imgV)
                cell!.contentView.addSubview(btn)
            }
            
            for var i=0;i<self.menus.count;i++ {
                let btn = cell?.contentView.viewWithTag(10000 + i) as! UIButton
                let label = cell?.contentView.viewWithTag(10010 + i) as! UILabel
                let imgV = cell?.contentView.viewWithTag(10020 + i) as! UIImageView
                if self.menus.count != 0 {
                    let ad = self.menus[i] as! ZMDAdvertisement
                    label.text = ad.Title
                    imgV.sd_setImageWithURL(NSURL(string: kImageAddressMain+ad.ResourcesCDNPath!))
                    btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                        self.advertisementClick(ad)
                        return RACSignal.empty()
                    })
                }
            }
        }
        return cell!
    }
    
    //MARK: - 今日特卖
    func cellForHomeGoods(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "goodCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! AdvertisementGoodCell
        AdvertisementGoodCell.configcell(cell, datas: self.goods)
        if self.goods.count > 1 {
            let topAd = self.goods[0] as! ZMDAdvertisement
            let botAd = self.goods[1] as! ZMDAdvertisement
            cell.topBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                self.advertisementClick(topAd)
                return RACSignal.empty()
            })
            cell.botBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                self.advertisementClick(botAd)
                return RACSignal.empty()
            })
        }
        return cell
    }
    //MARK: - 推荐Head cell(换一批)
    func cellForHomeRecommendationHead(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "RecommendationHeadCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        cell?.contentView.backgroundColor = defaultBackgroundColor
        cell?.selectionStyle = .None
        
        let refreshBtn = cell?.viewWithTag(1000) as!UIButton
        refreshBtn.userInteractionEnabled = false
        if let advertisementAll = self.advertisementAll,guess = advertisementAll.guess {
            refreshBtn.userInteractionEnabled = guess.count != 0 ? true : false
        }
        refreshBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: indexPath.section+1))
            let scrollView = cell?.contentView.viewWithTag(10001) as! UIScrollView
            scrollView.contentOffset = Int(scrollView.contentOffset.x+146*2) >= (self.advertisementAll.guess?.count)!*146 ? CGPoint(x: 0, y: 0) : CGPoint(x: scrollView.contentOffset.x+146*2, y: 0)
            return RACSignal.empty()
        })
        return cell!
    }
    //MARK: - 推荐 cell   大家都在看
    func cellForHomeRecommendation(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let kTagScrollView = 10001
        let cellId = "RecommendationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = tableViewdefaultBackgroundColor
            
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 180)) //66
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.tag = kTagScrollView
            cell?.contentView.addSubview(scrollView)
        }
        let scrollView = cell?.viewWithTag(kTagScrollView) as! UIScrollView
        if self.history.count != 0 {
            for subView in scrollView.subviews {
                subView.removeFromSuperview()
            }
            
            scrollView.contentSize = CGSize(width: (136 + 10) * CGFloat(self.history.count), height: 180)
            for var i=0;i<self.history.count;i++ {
                let advertisement = self.history[i] as! ZMDAdvertisement
                let btnHeight = CGFloat(180)
                let width = CGFloat(136)
                let btn = UIButton(frame: CGRectMake(10*CGFloat(i + 1)+CGFloat(i) * width, 0,width, btnHeight))
                btn.tag = 10000 + i
                btn.backgroundColor = UIColor.whiteColor()
                btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                    self.advertisementClick(advertisement)
                    return RACSignal.empty()
                })
                
                let titleLbl = UILabel(frame: CGRectMake(0, btnHeight-15-11 - 10 - 11, width, 11))
                titleLbl.font = UIFont.systemFontOfSize(11)
                titleLbl.textColor = defaultTextColor
                titleLbl.textAlignment =  .Center
                titleLbl.tag = 10010 + i
                titleLbl.text = advertisement.Title
                btn.addSubview(titleLbl)
                
                let moneyLbl = UILabel(frame: CGRectMake(0, btnHeight-15-11, width, 11))
                moneyLbl.font = UIFont.systemFontOfSize(11)
                moneyLbl.textColor = defaultSelectColor
                moneyLbl.textAlignment =  .Center
                moneyLbl.tag = 10020 + i
                moneyLbl.text = advertisement.Other3
                btn.addSubview(moneyLbl)
                
                let imgV = UIImageView(frame: CGRectMake(width/2-48, 30, 96,96))
                let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                imgV.sd_setImageWithURL(NSURL(string: url))
                btn.addSubview(imgV)
                cell!.contentView.addSubview(btn)
                scrollView.addSubview(btn)
            }
        }
        return cell!
    }
    // 特卖专题 cell
    func cellForHomeTheme(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "ThemeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        cell?.selectionStyle = .None
        cell?.viewWithTag(100)?.backgroundColor = defaultBackgroundColor
        
        var tag = 10001
        let imgV = cell?.viewWithTag(tag++) as! UIImageView
        let titleLbl = cell?.viewWithTag(tag++) as! UILabel
        let timeLbl = cell?.viewWithTag(tag++) as! TimeLabel
        titleLbl.textColor = defaultTextColor
        timeLbl.textColor = defaultTextColor
        timeLbl.text = "查看详情"
//        let advertisement = self.themes[indexPath.row] as! ZMDAdvertisement
        if let advertisementAll = self.advertisementAll,topic = advertisementAll.topic {
            let advertisement = topic[indexPath.row]
            let url = kImageAddressMain + (advertisement.ResourcesCDNPath ?? "")
            imgV.sd_setImageWithURL(NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!))
            if let title = advertisement.Title?.componentsSeparatedByString("，").first {
                titleLbl.text = title
            }
            let endTimeText = advertisement.EndTime?.stringByReplacingOccurrencesOfString("T", withString: " ")
            timeLbl.setEndTime(endTimeText!)
        }
        //            timeLbl.start()
        return cell!
    }
    
    //MARK: - ***************OtherMethod*******************
    //MARK:点击广告的响应方法
    func advertisementClick(advertisement: ZMDAdvertisement){
        if let other1 = advertisement.Other1, let other2 = advertisement.Other2 {
            let other1 = other1 as String
            let other2 = other2   //最终参数
            switch other1{
            case "Product":
                let vc = HomeBuyGoodsDetailViewController.CreateFromMainStoryboard() as! HomeBuyGoodsDetailViewController
                vc.productId = (other2 as NSString).integerValue
                self.pushToViewController(vc, animated: true, hideBottom: true)
                break
            case "Seckill":
                break
            case "Topic":
                let vc = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                vc.Cid = other2
                vc.As = "true"
                vc.title = advertisement.Title ?? ""
                self.pushToViewController(vc, animated: true, hideBottom: true)
                break
//            case "Supply":
//                let vc = SupplyDemandDetailViewController.CreateFromMainStoryboard() as! SupplyDemandDetailViewController
//                vc.supplyProductId = (other2 as NSString).integerValue
//                vc.type = 1
//                self.pushToViewController(vc, animated: true, hideBottom: true)
//            case "Demand":
//                let vc = SupplyDemandDetailViewController.CreateFromMainStoryboard() as! SupplyDemandDetailViewController
//                vc.supplyProductId = (other2 as NSString).integerValue
//                vc.type = 2
//                self.pushToViewController(vc, animated: true, hideBottom: true)
//            case "Enterprise":
//                let vc = EnterpriseDetailViewController.CreateFromMainStoryboard() as! EnterpriseDetailViewController
//                vc.enterpriseId = (other2 as NSString).integerValue
//                self.pushToViewController(vc, animated: true, hideBottom: true)
            case "Coupon":
                break
            case "Web":
                let vc = MyWebViewController()
                vc.webUrl = other2
                if let other3 = advertisement.Other3 where other3 == "hideBottom" {
                    vc.hideWebNavi = true
                }
                self.pushToViewController(vc, animated: true, hideBottom: true)
            case "App":
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: other2)!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: other2)!)
                }
            default:
                break
            }
        }else{
            return
        }
    }
    // 下拉视窗
    class ViewForNextMenu: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    //MARK:下拉导航
    func updateViewForNextMenu()  {
        let menuTitles = self.categories
        if self.下拉视窗 != nil {
            for subV in self.下拉视窗.subviews {
                subV.removeFromSuperview()
            }
        }
        
        self.下拉视窗 = UIView(frame: CGRect(x: 0, y: -1, width: kScreenWidth, height: 44+150))
        self.下拉视窗.backgroundColor = UIColor.clearColor()
        let topV = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
        topV.backgroundColor = UIColor.whiteColor()
        self.下拉视窗.addSubview(topV)
        let titleLbl = ZMDTool.getLabel(CGRect(x: 16, y: 0, width: 100, height: 44), text: " 选择分类", fontSize: 17)
        topV.addSubview(titleLbl)
        let 上拉 = UIButton(frame: CGRect(x: kScreenWidth - 44, y: 8, width: 44, height: 28))
        上拉.backgroundColor = UIColor.whiteColor()
        上拉.setImage(UIImage(named: "home_up"), forState: .Normal)
        上拉.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            self.dismissPopupView(self.下拉视窗)
            return RACSignal.empty()
        })
        topV.addSubview(上拉)
        topV.addSubview(ZMDTool.getLine(CGRect(x: kScreenWidth - 44, y: 8, width: 0.5, height: 28)))
        
        var i = 0
        let btnBg = UIView(frame: CGRect(x: 0, y: 44, width: kScreenWidth, height: kScreenWidth * 280/750))
        btnBg.backgroundColor = UIColor(white: 1.0, alpha: 0.9)

        
        self.下拉视窗.addSubview(btnBg)
        for title in menuTitles {
            let width = kScreenWidth/CGFloat(3),height = CGFloat(50)
            let columnIndex  = i%3
            let rowIndex = i/3
            let x = CGFloat(columnIndex) * width ,y  = CGFloat(rowIndex)*50
            i++
            
            let menuBtn = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
            menuBtn.backgroundColor = UIColor.clearColor()
            menuBtn.setTitle((title as! ZMDCategory).Name, forState: .Normal)
            menuBtn.titleLabel?.font = defaultDetailTextSize
            menuBtn.setTitleColor(defaultTextColor, forState: .Normal)
            menuBtn.setTitleColor(defaultSelectColor, forState: .Selected)
            menuBtn.tag = 1000 + i
            menuBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                let category = menuTitles[sender.tag - 1001] as! ZMDCategory
                let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                homeBuyListViewController.Cid = category.Id.stringValue
                homeBuyListViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
            })
            btnBg.addSubview(menuBtn)
            ZMDTool.configViewLayerFrameWithColor(menuBtn, color: UIColor.whiteColor())
        }
    }
    
    //MARK:navigationBar设置
    func setupNewNavigation() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.textInput = UITextField(frame: CGRect(x: 0, y: 0, width: 18*kScreenWidth/11, height: 35))
        self.textInput.placeholder = "商品关键字"
        self.textInput.backgroundColor = UIColor.whiteColor()
        self.textInput.layer.cornerRadius = 2
        self.textInput.layer.masksToBounds = true
        self.textInput.delegate = self
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let leftImageView = UIImageView(frame: CGRect(x: 7.5, y: 6.5, width: 20, height: 22))
        leftView.addSubview(leftImageView)
        leftImageView.image = UIImage(named: "list_search")
        leftImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.textInput.leftView = leftView
        self.textInput.leftViewMode = .Always
        
        self.navigationItem.titleView = self.textInput
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "Code-Scanner")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: nil, action: nil)
        leftItem.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            //二维码扫描
            let vc = CodeScanViewController()
            self.pushToViewController(vc, animated: true, hideBottom: true)
            return RACSignal.empty()
        })
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let image = UIImage(named: "message")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        rightBtn.setImage(image, forState: .Normal)
        rightBtn.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            let vc = MsgHomeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return RACSignal.empty()
        })
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func fetchNewProucts(){
        QNNetworkTool.fetchNewProduct { (products, dictionary, error) in
            if let products = products {
                self.history.removeAllObjects()
                self.history.addObjectsFromArray(products as [AnyObject])
                self.currentTableView.reloadData()
            }else{
                ZMDTool.showErrorPromptView(nil, error: error)
            }
        }
    }
    
    //MARK:数据源获取
    func fetchCache() {
        if let advertisementAllData = HYNetworkCache.cacheJsonWithURL("MainPageInfo"),advertisementAll = ZMDAdvertisementAll.mj_objectWithKeyValues(advertisementAllData) {
            self.advertisementAll = advertisementAll
            if let offer = advertisementAll.offer where offer.count > 0 {
                self.userCenterData = [/*.HomeContentTypeHead,*/.HomeContentTypeAd,.HomeContentTypeMenu,.HomeContentTypeGoods,.HomeContentTypeRecommendationHead,.HomeContentTypeRecommendation, .HomeContentTypeTheme]
            }
            self.currentTableView.reloadData()
        }
        if let menusData = HYNetworkCache.cacheJsonWithURL("mbnt_index_nav"),menus = ZMDAdvertisement.mj_objectArrayWithKeyValuesArray(menusData) {
            self.menus.removeAllObjects()
            self.menus.addObjectsFromArray(menus as [AnyObject])
            self.currentTableView.reloadData()
        }
        if let historyData = HYNetworkCache.cacheJsonWithURL("index_KSnongte"),historys = ZMDAdvertisement.mj_objectArrayWithKeyValuesArray(historyData) {
            self.history.addObjectsFromArray(historys as [AnyObject])
            self.currentTableView.reloadData()
        }
        if let miniAdsData = HYNetworkCache.cacheJsonWithURL("mb_index_dayhot"),miniAds = ZMDAdvertisement.mj_objectArrayWithKeyValuesArray(miniAdsData){
            self.goods.addObjectsFromArray(miniAds as [AnyObject])
            self.currentTableView.reloadData()
        }
    }
    func fetchData(){
        self.fetchCache()
        if self.networkObserver.currentReachabilityStatus() == .NotReachable {
            return
        }
        //获取浏览历史
        /*QNNetworkTool.fetchCustomerHistory { (history, dictionary, error) in
            if let history = history {
                self.history.removeAllObjects()
                self.history.addObjectsFromArray(history as [AnyObject])
                
                if self.history.count == 0 {
                    self.fetchNewProucts()
                    return
                }
                self.currentTableView.reloadData()
            }
        }*/
        
        QNNetworkTool.fetchMainPageInto { (advertisementAll, error, dictionary) -> Void in
            if advertisementAll != nil {
                self.advertisementAll = advertisementAll
                if let offer = advertisementAll?.offer where offer.count > 0 {
                    self.userCenterData = [/*.HomeContentTypeHead,*/.HomeContentTypeAd,.HomeContentTypeMenu,.HomeContentTypeGoods,.HomeContentTypeRecommendationHead,.HomeContentTypeRecommendation, .HomeContentTypeTheme]
                }
                self.currentTableView.reloadData()
            }
        }
        QNNetworkTool.fetchHomeMiniAd("mbnt_index_nav") { (success, products, error) -> Void in
            if success! {
                self.menus.removeAllObjects()
                self.menus.addObjectsFromArray(products as! [AnyObject])
                self.currentTableView.reloadData()
            }
        }
        //大家都在看
        QNNetworkTool.fetchHomeMiniAd("index_KSnongte") { (success, products, error) -> Void in
            if success! {
                self.history.removeAllObjects()
                self.history.addObjectsFromArray(products as! [AnyObject])
                self.currentTableView.reloadData()
            }
        }
        
        QNNetworkTool.fetchHomeMiniAd("mb_index_dayhot") { (success, products, error) -> Void in
            if success! {
                self.goods.removeAllObjects()
                self.goods.addObjectsFromArray(products as! [AnyObject])
                self.currentTableView.reloadData()
            }
        }
    }
    
    private func dataInit(){
        self.userCenterData = [/*.HomeContentTypeHead,*/.HomeContentTypeAd,.HomeContentTypeMenu,.HomeContentTypeGoods,.HomeContentTypeRecommendationHead,.HomeContentTypeRecommendation, .HomeContentTypeTheme]
        self.menuType = [.kFeature,.kCate,.kPublic,.kInformation]
    }
    
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
    
    
    //MARK: - ************Override************
    //MARK: CommonAlert Action重写
    override func alertDestructiveAction() {
        if let url = NSURL(string: APP_URL_IN_ITUNES) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    override func alertCancelAction() {
        
    }
    
    //重写设置状态栏方法
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
