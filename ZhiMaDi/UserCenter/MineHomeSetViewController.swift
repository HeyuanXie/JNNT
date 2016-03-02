//
//  MineHomeSetViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/1.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//设置
class MineHomeSetViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    enum UserCenterCellType{
        case User
        case Lock
        case Password
        case Shape
        case Question
        case Phone
        
        init(){
            self = User
        }
        
        var title : String{
            switch self{
            case User:
                return "个人资料"
            case Lock:
                return "帐户安全"
            case Password:
                return "登录密码"
            case Shape:
                return "关于我们"
            case Question:
                return "常见问题"
            case Phone:
                return "客服电话"
            }
        }
        
        var image : UIImage?{
            switch self{
            case User:
                return UIImage(named: "Set_User")
            case Lock:
                return UIImage(named: "Set_Lock")
            case Password:
                return UIImage(named: "Set_User")
            case Shape:
                return UIImage(named: "Set_Shape")
            case Question:
                return UIImage(named: "Set_Question")
            case Phone:
                return UIImage(named: "Set_Phone")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case User:
                viewController = PersonInfoViewController()
            case Lock:
                viewController = AccoutSafeViewController()
            case Password:
                viewController = UIViewController()
            case Shape:
                viewController = UIViewController()
            case Question:
                viewController = UIViewController()
            case Phone:
                viewController = UIViewController()
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }

    var tableView : UITableView!
    
    var userCenterData: [UserCenterCellType]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.subViewInit()
        // Do any additional setup after loading the view.
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
        return self.userCenterData.count + 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 3 || section == self.userCenterData.count) ? 10 : 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == self.userCenterData.count {
            let cellId = "outCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let label = UILabel(frame: CGRectMake(0, 0, kScreenWidth, tableViewCellDefaultHeight))
                label.text = "退出登录"
                label.font = tableViewCellDefaultTextFont
                label.textAlignment = .Center
                cell?.contentView.addSubview(label)
            }
            return cell!
        }
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            let usertype  = self.userCenterData[indexPath.section]
            let imgV = UIImageView(frame: CGRectMake(12, tableViewCellDefaultHeight/2 - 12, 24, 24))
            imgV.image = usertype.image
            
            let label = UILabel(frame: CGRectMake(46, 0, 100, tableViewCellDefaultHeight))
            label.text = usertype.title
            label.font = tableViewCellDefaultTextFont
            cell?.contentView.addSubview(imgV)
            cell?.contentView.addSubview(label)
            
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let usertype  = self.userCenterData[indexPath.section]
        usertype.didSelect(self.navigationController!)
    }
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "设置"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.User,UserCenterCellType.Lock,UserCenterCellType.Password, UserCenterCellType.Shape, UserCenterCellType.Question, UserCenterCellType.Phone]
    }
}
