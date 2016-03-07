//
//  AccoutSafeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//帐户安全
class AccoutSafeViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    enum UserCenterCellType{
        case Account
        case SignPS
        case Phone
        case PayPs
        case Card
        case Identification
        
        init(){
            self = Account
        }
        
        var title : String{
            switch self{
            case Account:
                return " 交易帐号"
            case SignPS:
                return "登录密码"
            case Phone :
                return "绑定手机号"
            case PayPs:
                return "支付密码"
            case Card:
                return "我的银行卡"
            case Identification:
                return "实名认证"
            }
        }
        
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Account:
                viewController = UIViewController()
            case SignPS:
                viewController = SignPSSetViewController.CreateFromMainStoryboard() as! SignPSSetViewController
            case Phone :
                viewController = PhoneSetViewController.CreateFromMainStoryboard() as! PhoneSetViewController
            case PayPs:
                viewController = UIViewController()
            case Card:
                viewController = MineBankCardHomeViewController.CreateFromMainStoryboard() as! MineBankCardHomeViewController
            case Identification:
                viewController = RealAuthenticationViewController.CreateFromMainStoryboard() as! RealAuthenticationViewController
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    
    var tableView : UITableView!
    var nameLB: UILabel!
    var sexLB: UILabel!
    var addressLB: UITextView!
    var descriptionLB: UILabel!
    
    var picker: UIImagePickerController?
    
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
        return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 4) ? 10 : 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  tableViewCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            ZMDTool.configTableViewCellDefault(cell)
            cell.selectionStyle = .None
            
            let lbl = UILabel(frame: CGRectMake(70, 0, kScreenWidth - 120, tableViewCellDefaultHeight))
            lbl.font = UIFont.systemFontOfSize(16)
            lbl.textAlignment = NSTextAlignment.Right
            lbl.textColor = UIColor.grayColor()
            lbl.tag = 10001
            cell.contentView.addSubview(lbl)
        }
        
        let content = self.userCenterData[indexPath.section]
        cell.textLabel?.text = content.title
        let lbl = cell.viewWithTag(10001) as! UILabel
        switch content {
        case .Account :
            cell?.accessoryType = UITableViewCellAccessoryType.None
            self.nameLB = UILabel(frame: CGRectMake(0, 0, tableView.bounds.width - 120, tableViewCellDefaultHeight))
            self.nameLB.font = UIFont.systemFontOfSize(16)
            self.nameLB.text = "张三"
            self.nameLB.textAlignment = NSTextAlignment.Right
            self.nameLB.textColor = UIColor(white: 66/255, alpha: 1)
            cell.accessoryView = self.nameLB
        case .SignPS:
           lbl.text = "未设置"
        case .Phone:
            lbl.text = "123****122"
        case .PayPs:
            lbl.text = "未设置"
        case .Card:
            break
        case .Identification:
            lbl.text = "未认证"
        default :
            break
        }
        
        ZMDTool.configTableViewCellDefault(cell)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let type = self.userCenterData[indexPath.section]
        type.didSelect(self.navigationController!)
    }
    
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "帐户安全"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.Account,UserCenterCellType.SignPS,UserCenterCellType.Phone, UserCenterCellType.PayPs, UserCenterCellType.Card, UserCenterCellType.Identification]
    }
}