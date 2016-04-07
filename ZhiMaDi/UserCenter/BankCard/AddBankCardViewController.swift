//
//  AddBankCardViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 填写银行卡信息
class AddBankCardViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol {
    enum CellType{
        case Card
        case Name
        case Identification
        case Phone
        
        case Company
        var title : String{
            switch self{
            case Card:
                return "卡号"
            case Name:
                return "姓名"
            case Identification :
                return "身份证"
            case Phone:
                return "手机号"
            case Company:
                return "开户名"
            }
        }
        init(){
            self = Card
        }
    }
    var tableView: UITableView!
    var cardNumTextField : UITextField!
    var nameTextField : UITextField!
    var identificationTextField : UITextField!
    var phoneTextField : UITextField!
    var companyTextField : UITextField!

    var personBtn : UIButton!,enterpriseBtn:UIButton!
    
    var dataArray : NSArray!
    var cellType: [CellType]!
    var isPersonCell = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData()
        self.subViewInit()
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
        return self.cellType.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return  54
        }
        return 0
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?  {
        if section == 0 {
            let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 54))
            footView.backgroundColor = UIColor.clearColor()
            let imgV = UIImageView(frame: CGRect(x: 12, y: 8, width: 20, height: 20))
            imgV.image = UIImage(named: "bank_gs")
            footView.addSubview(imgV)
            let label = ZMDTool.getLabel(CGRect(x: 24+20, y: 8, width: 200, height: 20), text: "中国工商银行 储蓄卡", fontSize: 14)
            footView.addSubview(label)
            return footView
        }
        let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        footView.backgroundColor = UIColor.clearColor()
        return footView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = self.isPersonCell ? "PersonCell\(indexPath.section)" : "OtherCell\(indexPath.section)"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        let type = self.cellType[indexPath.section]
        cell?.textLabel!.text = type.title
        switch type {
        case .Card :
            if self.cardNumTextField == nil {
                self.cardNumTextField = UITextField(frame: CGRect(x: 88, y: 0, width: kScreenWidth - 100, height: 60))
                self.cardNumTextField.textColor = defaultTextColor
                self.cardNumTextField.font = defaultSysFontWithSize(17)
                self.cardNumTextField.placeholder = "卡号"
            }
            cell?.contentView.addSubview(self.cardNumTextField)
        case .Name :
            if self.nameTextField == nil {
                self.nameTextField = UITextField(frame: CGRect(x: 88, y: 0, width: kScreenWidth - 100, height: 60))
                self.nameTextField.textColor = defaultTextColor
                self.nameTextField.font = defaultSysFontWithSize(17)
                self.nameTextField.placeholder = "持卡人姓名"
            }
            cell?.contentView.addSubview(self.nameTextField)
        case .Identification :
            if self.identificationTextField == nil {
                self.identificationTextField = UITextField(frame: CGRect(x: 88, y: 0, width: kScreenWidth - 100, height: 60))
                self.identificationTextField.textColor = defaultTextColor
                self.identificationTextField.font = defaultSysFontWithSize(17)
                self.identificationTextField.placeholder = "持卡人身份证号"
            }
            cell?.contentView.addSubview(self.identificationTextField)
        case .Phone :
            if self.phoneTextField == nil {
                self.phoneTextField = UITextField(frame: CGRect(x: 88, y: 0, width: kScreenWidth - 100, height: 60))
                self.phoneTextField.textColor = defaultTextColor
                self.phoneTextField.font = defaultSysFontWithSize(17)
                self.phoneTextField.placeholder = "银行预留手机号"
            }
            cell?.contentView.addSubview(self.phoneTextField)
        case .Company :
            if self.companyTextField == nil {
                self.companyTextField = UITextField(frame: CGRect(x: 88, y: 0, width: kScreenWidth - 100, height: 60))
                self.companyTextField.textColor = defaultTextColor
                self.companyTextField.font = defaultSysFontWithSize(17)
                self.companyTextField.placeholder = "输入公司名称"
            }
            cell?.contentView.addSubview(self.phoneTextField)
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "填写银行卡信息"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        self.tableView.addFootBtn("下一步") { (sender) -> Void in
            let vc = BankCardVerifyPhoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 80))
        headView.backgroundColor = UIColor.clearColor()
        let btnV = UIView(frame: CGRect(x: kScreenWidth/2 - 118, y: 20, width: 118*2, height: 40))
        btnV.backgroundColor = UIColor.clearColor()
        ZMDTool.configViewLayerFrameWithColor(btnV, color: RGB(235,61,61,1.0))
        ZMDTool.configViewLayer(btnV)
        self.personBtn = ZMDTool.getMutilButton(CGRect(x: 0, y: 0, width: 118, height: 40), textForNormal: "个人用户", textColorForNormal: defaultTextColor, textColorForSelect: UIColor.whiteColor(), fontSize: 17, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
            if !self.personBtn.selected {
                self.isPersonCell = true
                self.personBtn.selected = true
                self.enterpriseBtn.selected = false
                self.updateData()
                self.tableView.reloadData()
            }
        })
        self.personBtn.selected = true
        self.personBtn.setBackgroundImage(UIImage.colorImage(RGB(235,61,61,1.0)), forState: .Selected)
        btnV.addSubview(self.personBtn)
        self.enterpriseBtn = ZMDTool.getMutilButton(CGRect(x: 118, y: 0, width: 118, height: 40), textForNormal: "企业用户", textColorForNormal: defaultTextColor, textColorForSelect: UIColor.whiteColor(), fontSize: 17, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
            if !self.enterpriseBtn.selected {
                self.isPersonCell = false
                self.personBtn.selected = false
                self.enterpriseBtn.selected = true
                self.updateData()
                self.tableView.reloadData()
            }
        })
        self.enterpriseBtn.setBackgroundImage(UIImage.colorImage(RGB(235,61,61,1.0)), forState: .Selected)
        btnV.addSubview(self.enterpriseBtn)
        headView.addSubview(btnV)
        self.tableView.tableHeaderView = headView
    }
    private func updateData(){
        self.cellType = self.isPersonCell ? [.Card,.Name, .Identification, .Phone] : [.Card,.Company, .Phone]
    }
}
