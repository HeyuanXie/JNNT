//
//  VerifyBankCardViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//验证银行卡信息
class VerifyBankCardViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    enum UserCenterCellType{
        case BankCard
        case CardNum
        case Name
        case Id
        case PhoneNum
        init(){
            self = Name
        }
        
        var title : String{
            switch self{
            case BankCard:
                return "银行卡 ： "
            case CardNum :
                return "卡号 ："
            case Name:
                return "姓名 ："
            case Id:
                return "身份证 ："
            case PhoneNum:
                return "手机号 ："
            }
        }
        var placeHolder : String{
            switch self{
            case BankCard:
                return ""
            case CardNum :
                return ""
            case Name:
                return "持卡人姓名"
            case Id:
                return "持卡人身份证号"
            case PhoneNum:
                return "持卡人预留手机号"
            }
        }
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    var userCenterData : [UserCenterCellType]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        let grayColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 70))
        footView.backgroundColor = UIColor.clearColor()
        let btn = UIButton(frame: CGRectMake(12, 24, kScreenWidth - 24, 46))
        btn.backgroundColor = grayColor
        btn.setTitle("下一步", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            
        }
        footView.addSubview(btn)
        self.currentTableView.tableFooterView = footView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCenterData.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        let userType = userCenterData[indexPath.row]
        let leftLbl = cell?.viewWithTag(10001) as! UILabel
        let rightTextField = cell?.viewWithTag(10002) as! UITextField
        leftLbl.text = userType.title
        rightTextField.placeholder = userType.placeHolder
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.BankCard,UserCenterCellType.CardNum,UserCenterCellType.Name,UserCenterCellType.Id,UserCenterCellType.PhoneNum]
    }
}
