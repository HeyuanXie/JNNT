//
//  BusinessAuthenticationViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/4.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//企业认证
class BusinessAuthenticationViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    enum UserCenterCellType{
        case Name
        case Area
        case Controller
        case License
        case Card1
        case Card2
        case Card3
        case Introduce
        case Confirm
        init(){
            self = Name
        }
        
        var title : String{
            switch self{
            case Name:
                return "企业名称 ："
            case Area :
                return "经营范围 ："
            case Controller:
                return "运营负责人 ："
            case License:
                return "营业执照 ："
            case Card1:
                return "组织机构代码证 ："
            case Card2:
                return "税务登记证 ："
            case Card3:
                return "开户许可证 ："
            case Introduce:
                return "认证说明 ："
            case Confirm :
                return ""
            }
        }
        
        //
        //        var pushViewController :UIViewController{
        //            let viewController: UIViewController
        //            switch self{
        //            case Name:
        //                viewController = UIViewController()
        //            case Specs:
        //                viewController = SignPSSetViewController.CreateFromMainStoryboard() as! SignPSSetViewController
        //            case Location :
        //                viewController = PhoneSetViewController.CreateFromMainStoryboard() as! PhoneSetViewController
        //            case Detail:
        //                viewController = UIViewController()
        //            case Time:
        //                viewController = UIViewController()
        //            case Area:
        //                viewController = RealAuthenticationViewController.CreateFromMainStoryboard() as! RealAuthenticationViewController
        //            case Output:
        //                viewController = RealAuthenticationViewController.CreateFromMainStoryboard() as! RealAuthenticationViewController
        //            case CanSell:
        //                viewController = RealAuthenticationViewController.CreateFromMainStoryboard() as! RealAuthenticationViewController
        //            }
        //            viewController.hidesBottomBarWhenPushed = true
        //            return viewController
        //        }
        //        
        func didSelect(navViewController:UINavigationController){
            //           navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    let getTextField = { (enable : Bool!,placeholder : String!) -> UITextField in
        let width = enable! ? kScreenWidth - 152 : kScreenWidth - 170
        let textField = UITextField(frame: CGRectMake(140, 0, width, 50))
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.systemFontOfSize(15)
        textField.textAlignment = .Left
        textField.enabled = enable
        textField.placeholder = placeholder
        return textField
    }
    var nameTextField : UITextField!
    var areaTextField : UITextField!
    var controllerextField : UITextField!
    var userCenterData : [[UserCenterCellType]]!
    
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
            return userCenterData[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 3 ? 1 : 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let type = self.userCenterData[indexPath.section][indexPath.row]
        if type == .Introduce {
            let text = "认证说明\n1、照片内容真实有效,清晰,不得做任何修改\n2、支持jpg、jpeg、bmp、gif格式照片,大小不超过2M"
            let size = text.sizeWithFont(UIFont.systemFontOfSize(16), maxWidth: kScreenWidth - 24)
            return size.height + 24
        }
        if type == .Confirm {
            return 124
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let type = self.userCenterData[indexPath.section][indexPath.row]
            if type == .Confirm {
                let cellId = "confirmCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    ZMDTool.configTableViewCellDefault(cell!)
                }
                _ = cell?.viewWithTag(10001) as! UIButton
                return cell!
            }
            let cellId = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = type.title
            switch type {
            case .Name :
                self.nameTextField = getTextField(true,"请输入有效的企业名称")
                cell?.addSubview(self.nameTextField)
            case .Area :
                self.areaTextField = getTextField(true,"请输入企业经营范围")
                cell?.addSubview(self.areaTextField)
            case .Controller :
                self.controllerextField = getTextField(true,"请输入运营负责人姓名")
                cell?.addSubview(self.controllerextField)
            case .License:
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            case .Card1:
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            case .Card2:
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            case .Card3:
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            case .Introduce :
                cell?.textLabel?.text = ""
                let text1 = NSString(string: "认证说明\n")
                let text = "认证说明\n1、照片内容真实有效,清晰,不得做任何修改\n2、支持jpg、jpeg、bmp、gif格式照片,大小不超过2M"
                let attributeStr = NSMutableAttributedString(string: text)
                attributeStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(0, text1.length))
                
                let size = text.sizeWithFont(UIFont.systemFontOfSize(16), maxWidth: kScreenWidth - 24)
                let textV = UILabel(frame: CGRectMake(12, 12, kScreenWidth - 24, size.height))
                textV.numberOfLines = 0
                textV.font = UIFont.systemFontOfSize(14)
                textV.attributedText = attributeStr
                cell?.addSubview(textV)
                break
            default :
                break
            }
            return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }

    //MARK: -  PrivateMethod
    private func dataInit(){
        self.userCenterData = [[UserCenterCellType.Name,UserCenterCellType.Area,UserCenterCellType.Controller], [UserCenterCellType.License, UserCenterCellType.Card1, UserCenterCellType.Card2,UserCenterCellType.Card3],[UserCenterCellType.Introduce],[UserCenterCellType.Confirm]]
    }
}
