//
//  VipClubHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 会员俱乐部
class VipClubHomeViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ZMDInterceptorProtocol {
    enum CellType{
        case Head                    /* 头部选项 */
        case Menu                    /* 菜单选择栏目 */
        case Theme                   /* 特卖 主题展示 */
        case Recommendation          /* 推荐商品 */

        init(){
            self = Head
        }
        var heightForHeadOfSection : CGFloat {
            switch  self {
            case .Recommendation :
                return 0
            default :
                return 16
            }
        }
        var height : CGFloat {
            switch  self {
            case .Head :
                return 510/750 * kScreenWidth
            case .Menu :
                return 207/750 * kScreenWidth
            case .Theme :
                return 430/750 * kScreenWidth
            case .Recommendation :
                return 176
            }
        }
    }
    enum MenuType{
        case Chenzhan
        case Tequan
        case Choujiang
        
        init(){
            self = Chenzhan
        }
        
        var title : String{
            switch self{
            case Chenzhan:
                return "成长体系"
            case Tequan:
                return "会员特权"
            case Choujiang:
                return "积分抽奖"
            }
        }
        
        var image : UIImage?{
            switch self{
            case Chenzhan:
                return UIImage(named: "home_zulin")
            case Tequan:
                return UIImage(named: "home_new")
            case Choujiang:
                return UIImage(named: "home_coupons")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Chenzhan:
                viewController = UIViewController()
            case Tequan:
                viewController = UIViewController()
            case Choujiang:
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
    
    var cellTypes : [CellType]!
    var menuType: [MenuType]!
    var goodsData = ["","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        // 让导航栏支持右滑返回功能
        ZMDTool.addInteractive(self.navigationController)
        self.dataInit()
        updateUI()
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
        return self.cellTypes[section] == CellType.Recommendation ? self.goodsData.count : 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellTypes.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.cellTypes[section].heightForHeadOfSection
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellTypes[indexPath.section].height
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  self.cellTypes[indexPath.section] {
        case .Head :
            return self.cellForHomeHead(tableView, indexPath: indexPath)
        case .Menu :
            return self.cellForHomeMenu(tableView, indexPath: indexPath)
        case .Theme :
            return self.cellForHomeTheme(tableView, indexPath: indexPath)
        case .Recommendation :
            return self.cellForHomeRecommendation(tableView, indexPath: indexPath)

        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = VipClubGoodsDetailViewController.CreateFromMainStoryboard() as!  VipClubGoodsDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: private method
    
    //MARK: 头部菜单 cell
    func cellForHomeHead(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "HeadCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! VipClubHomeHeadCell
        ZMDTool.configViewLayer(cell.signBtn)
        return cell
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
        let celltype = self.cellTypes[indexPath.section]
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            
            for var i=0;i<3;i++ {
                let btnHeight = celltype.height
                let width = kScreenWidth/3
                let btn = ZMDTool.getButton(CGRect(x: CGFloat(i) * kScreenWidth/3, y: 0, width: width, height: btnHeight), textForNormal: self.menuType[i].title, fontSize: 15, textColorForNormal: defaultTextColor, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                    self.menuType[i].didSelect(self.navigationController!)
                })
                btn.setImage(self.menuType[i].image, forState: .Normal)
                cell?.contentView.addSubview(btn)
            }
        }
        return cell!
    }
    // 主题 cell
    func cellForHomeTheme(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "ThemeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        return cell!
    }
    //MARK: - 推荐 cell
    func cellForHomeRecommendation(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "RecommendationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? VipClubGoodsTableViewCell
        if cell == nil {
            cell = VipClubGoodsTableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        cell!.imgV.image = UIImage(named: "")
        cell!.goodsLbl.text = "电动车棉袄空调被子....衣柜"
        cell!.goodsPriceLbl.text = "5200 积分"
        cell!.hasLbl.text = "已兑换 3件"
        cell!.cancelBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            return RACSignal.empty()
        })
        return cell!
    }
    
    func setupNewNavigation() {
        let rightItm = UIBarButtonItem(title:"兑换历史", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        rightItm.customView?.tintColor = defaultDetailTextColor
        rightItm.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            
            return RACSignal.empty()
        })
        self.navigationItem.rightBarButtonItem = rightItm
    }

    func fetchData(){
    }
    private func dataInit(){
        self.cellTypes = [.Head,.Menu,.Theme,.Recommendation]
        self.menuType = [.Chenzhan,.Tequan, MenuType.Choujiang]
    }
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
}
// 头部 Cell
class VipClubHomeHeadCell : UITableViewCell {
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var signBtn: UIButton!  //签到
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

