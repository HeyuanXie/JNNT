//
//  OrderDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/30.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 我的订单详请
class MyOrderDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    enum UserCenterCellType{
        case UserHead
        case UserMyOrder
        case UserMyOrderMenu
        case UserWallet
        case UserBankCard
        case UserCardVolume
        case UserMyCrowdFunding
        
        case UserMyStore
        case UserVipClub
        case UserCommission
        case UserInvitation
        
        case UserHelp
        case UserMore
        
        init(){
            self = UserHead
        }
        
        var title : String{
            switch self{
            case UserHead :
                return ""
            case UserMyOrder :
                return ""
            case UserMyOrderMenu :
                return ""
                
            case UserWallet :
                return "钱包"
            case UserBankCard :
                return "银行卡"
            case UserCardVolume :
                return "卡券"
            case UserMyCrowdFunding :
                return "我的众筹"
                
            case UserMyStore :
                return "我的店铺"
            case UserVipClub :
                return "会员俱乐部"
            case UserCommission :
                return "赚佣金"
            case UserInvitation :
                return "邀请好友注册"
                
            case UserHelp :
                return "帮助与反馈"
            case UserMore :
                return "浏览记录"
            }
        }
        var image : UIImage?{
            switch self{
            case UserWallet :
                return UIImage(named: "user_wallet")
            case UserBankCard :
                return UIImage(named: "user_bankcard")
            case UserCardVolume :
                return UIImage(named: "user_card")
            case UserMyCrowdFunding :
                return UIImage(named: "user_crowdfunding")
                
            case UserMyStore :
                return UIImage(named: "user_myshop")
            case UserVipClub :
                return UIImage(named: "user_vipclub")
            case UserCommission :
                return UIImage(named: "user_earn")
            case UserInvitation :
                return UIImage(named: "user_share")
                
            case UserHelp :
                return UIImage(named: "user_help")
            default :
                return UIImage(named: "")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case UserMyOrder:
                viewController = MyOrderViewController.CreateFromMainStoryboard() as! MyOrderViewController
            case UserMyOrderMenu:
                viewController = UIViewController()
            case UserWallet:
                viewController = UIViewController()
            case UserBankCard:
                viewController = UIViewController()
            case UserCardVolume:
                viewController = UIViewController()
            case UserMyCrowdFunding:
                viewController = UIViewController()
                
            case UserMyStore:
                viewController = UIViewController()
            case UserVipClub:
                viewController = UIViewController()
            case UserCommission:
                viewController = UIViewController()
            case UserInvitation:
                viewController = UIViewController()
                
            case UserHelp:
                viewController = UIViewController()
            default :
                viewController = UIViewController()
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(pushViewController, animated: true)
        }
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    var userCenterData: [[UserCenterCellType]]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.updateUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
        return self.userCenterData[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType {
        case .UserHead:
            return 190
        default :
            return 55
        }
        if indexPath.section == 0 {
            return 200
        }
        return indexPath.section == 1 ? kScreenWidth/3 * 2 : 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType {
        case .UserHead:
            let cellId = "HeadCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if let personImgV = cell!.viewWithTag(10001) {
                ZMDTool.configViewLayerWithSize(personImgV, size: 42)
            }
            return cell!
        case .UserMyOrder :
            let cellId = "MyOrderCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            return cell!
        case .UserMyOrderMenu :
            let cellId = "MyOrderMenuCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let menuTitle = ["0\n待付款","0\n待发货","0\n待收货","0\n待评价","0\n退货/售后"]
                var i = 0
                for title  in menuTitle {
                    let width = kScreenWidth/5,height = CGFloat(55)
                    let x = CGFloat(i) * width
                    i++
                    let btn = ZMDTool.getButton(CGRect(x: x, y: 0, width: width, height: height), textForNormal: title, fontSize: 14, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                        
                    })
                    btn.titleLabel?.numberOfLines = 2
                    btn.titleLabel?.textAlignment = .Center
                    cell?.contentView.addSubview(btn)
                }
            }
            return cell!
        case .UserMore :
            let cellId = "MoreCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 34 - 100, y: 0, width: 100, height: 55), text: "更多", fontSize: 15,textColor:defaultDetailTextColor)
                label.textAlignment = .Right
                cell?.contentView.addSubview(label)
            }
            cell!.textLabel?.text = cellType.title
            return cell!
        default :
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 54.5, width: kScreenWidth, height: 0.5)))
            }
            
            cell?.imageView?.image = cellType.image
            cell!.textLabel?.text = cellType.title
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType{
        case .UserMyOrder:
            cellType.didSelect(self.navigationController!)
        default:
            break
        }
    }
    //MARK:Private Method
    func configHead() {
        
    }
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
    private func dataInit(){
        self.userCenterData = [[.UserHead,.UserMyOrder,.UserMyOrderMenu], [.UserWallet,.UserBankCard,.UserCardVolume,.UserMyCrowdFunding],[.UserWallet,.UserMyStore,.UserVipClub,.UserCommission,.UserInvitation],[.UserHelp],[.UserMore]]
    }
}