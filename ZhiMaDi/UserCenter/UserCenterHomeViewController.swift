//
//  UserCenterHomeViewController.swift
//  SleepCare
//
//  Created by haijie on 15/12/24.
//  Copyright © 2015年 juxi. All rights reserved.
//

import UIKit

class UserCenterHomeViewController: UIViewController, QNInterceptorProtocol, UITableViewDataSource, UITableViewDelegate  {
    enum UserCenterCellType{
        case headView
        case ReserveBalance
        case Store
        case FamilyMember
        case Serves
        case Messages
        case Cases
        
        init(){
            self = ReserveBalance
        }
        
        var title : String{
            switch self{
            case headView:
                return ""
            case ReserveBalance:
                return "余额"
            case Store:
                return "商城"
            case FamilyMember:
                return "家庭号成员"
            case Serves:
                return "我的服务"
            case Messages:
                return "我的消息"
            case Cases:
                return "病历夹"
            }
        }
        
        var image : UIImage?{
            switch self{
            case headView:
                return UIImage()
            case ReserveBalance:
                return UIImage(named: "UserCenter_Gold")
            case Store:
                return UIImage(named: "UserCenter_Store")
            case FamilyMember:
                return UIImage(named: "UserCenter_FamilyMember")
            case Serves:
                return UIImage(named: "UserCenter_MyServices")
            case Messages:
                return UIImage(named: "UserCenter_News")
            case Cases:
                return UIImage(named: "user_list_ClipCase")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case headView:
                viewController = ViewController()
            case ReserveBalance:
                viewController = ViewController()
            case Store:
                viewController = ViewController()
            case FamilyMember:
                viewController = ViewController()
            case Serves:
                viewController = ViewController()
            case Messages:
                viewController = ViewController()
            case Cases:
                viewController = ViewController()//(DossierViewController.CreateFromStoryboard("Main") as? UIViewController)!
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    
    private let keyHeaderImage = "UserCenter_HeaderImage"
    
    var tableView: UITableView!
    var headerImageView: UIImageView!
    var familyLabel: UILabel!
    var nickName: UILabel!
    var headerData: [String:AnyObject]!
    var balance = "0"
    var userCenterData: [[UserCenterCellType]]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        self.dataInit()
        self.subViewInit()
        // 让导航栏支持右滑返回功能
        ZMDTool.addInteractive(self.navigationController)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 更新个人信息
    private func updateUserInfo() {
    }
    
    //MARK: UITableViewDataSource & UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.userCenterData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let datas = self.userCenterData[section]
        return datas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0 && indexPath.row == 0 {
            let cellIdentifier = "UserCenterCellHead"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell?.selectionStyle = UITableViewCellSelectionStyle.Default
                ZMDTool.configTableViewCellDefault(cell!)
            }
            self.configHeadView(cell!)
            return cell!
        }
        let cellIdentifier = "UserCenterCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        let tagBalanceLabel = 10086
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.selectionStyle = UITableViewCellSelectionStyle.Default
            ZMDTool.configTableViewCellDefault(cell!)
            
            let balanceLabel = UILabel(frame: CGRectMake(cell!.contentView.bounds.size.width-100, 0, 100, cell!.contentView.bounds.size.height))
            balanceLabel.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
            balanceLabel.textColor = UIColor(red: 222/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
            balanceLabel.textAlignment = NSTextAlignment.Right
            balanceLabel.tag = tagBalanceLabel
            cell?.contentView.addSubview(balanceLabel)
        }
        
        let userCellType = self.userCenterData[indexPath.section][indexPath.row]
        cell?.imageView?.image = userCellType.image
        cell?.textLabel?.text = userCellType.title
        let balanceLabel = cell?.viewWithTag(tagBalanceLabel) as! UILabel
        balanceLabel.hidden = userCellType != .ReserveBalance
        balanceLabel.text = self.balance
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.section == 0 && indexPath.row == 0) ? 84 : tableViewCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0*kScreenHeightZoom
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*kScreenHeightZoom
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var  userCellType: UserCenterCellType?
        if indexPath.section == 3 && indexPath.row == 0 {
        
        }else {
            userCellType = self.userCenterData[indexPath.section][indexPath.row]
        }
        userCellType!.didSelect(self.navigationController!)
    }
    
    
    //MARK:- NSNotification Method
    func messageCountChanged() {
        self.tableView.reloadData()
    }
    
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "个人中心"
        // 设置按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Navigation_Setting"), style: .Done, target: self, action: Selector("onSetting"))
        self.view.autoresizesSubviews = true
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.tableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , .FlexibleHeight]
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    func configHeadView(cell : UITableViewCell)  {
        if self.headerImageView == nil {
            let headerImage = UIImage(named: keyHeaderImage)  //默认头像
            let saveHeaderImage = UIImage(contentsOfFile: "")
            self.headerImageView = UIImageView(image: saveHeaderImage ?? headerImage)
            self.headerImageView.frame = CGRect(x: 16, y: 10, width: 64, height: 64)
            self.headerImageView.layer.masksToBounds = true
            self.headerImageView.layer.cornerRadius = headerImageView.frame.width/2
            cell.addSubview(self.headerImageView)
        }
        if self.nickName == nil {
            self.nickName = UILabel(frame: CGRect(x: 96, y: 20, width: self.tableView.bounds.size.width - 146, height: 16))
            self.nickName.textColor = tableViewCellDefaultTextColor
            self.nickName.font = tableViewCellDefaultTextFont
            cell.addSubview(nickName)
        }
        if self.familyLabel == nil {
            self.familyLabel = UILabel(frame: CGRect(x: 96, y: 48, width: self.tableView.bounds.size.width - 146, height: 16))
            self.familyLabel.textColor = tableViewCellDefaultTextColor
            self.familyLabel.font = tableViewCellDefaultTextFont
            cell.addSubview(familyLabel)
        }
    }
    private func dataInit(){
        self.userCenterData = [[UserCenterCellType.headView],[UserCenterCellType.ReserveBalance],[UserCenterCellType.Store], [UserCenterCellType.FamilyMember, UserCenterCellType.Serves, UserCenterCellType.Messages],[UserCenterCellType.Cases]]
    }}
