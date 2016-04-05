//
//  AddressEditOrAddViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//编辑或增加收货地址
class AddressEditOrAddViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    var usrNameTextFidld : UITextField!,phoneTextFidld : UITextField!,areaTextFidld : UITextField!,codeTextFidld : UITextField!,addressTextFidld : UITextField!
    
    var isAdd : Bool = true
    let titles = ["收件人 : ","手机号码 : ","所在地区 : ","邮政编码 : ","街道地址 : ","设为默认地址 : "]

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return titles.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.titles[indexPath.section]
            let size = self.titles[indexPath.section].sizeWithFont(defaultSysFontWithSize(17), maxWidth: 320)
            if self.usrNameTextFidld == nil {
                self.usrNameTextFidld = UITextField(frame: CGRect(x: 20 + size.width, y: 0, width: kScreenWidth - 20 - size.width - 12, height: 56))
                self.usrNameTextFidld.font = defaultSysFontWithSize(17)
                cell?.contentView.addSubview(self.usrNameTextFidld)
            }
            return cell!
        case 1 :
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.titles[indexPath.section]
            let size = self.titles[indexPath.section].sizeWithFont(defaultSysFontWithSize(17), maxWidth: 320)
            if self.phoneTextFidld == nil {
                self.phoneTextFidld = UITextField(frame: CGRect(x: 20 + size.width, y: 0, width: kScreenWidth - 20 - size.width - 12, height: 56))
                self.usrNameTextFidld.font = defaultSysFontWithSize(17)
                cell?.contentView.addSubview(self.phoneTextFidld)
            }
            return cell!
        case 2 :
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.titles[indexPath.section]
            let size = self.titles[indexPath.section].sizeWithFont(defaultSysFontWithSize(17), maxWidth: 320)
            if self.areaTextFidld == nil {
                self.areaTextFidld = UITextField(frame: CGRect(x: 20 + size.width, y: 0, width: kScreenWidth - 20 - size.width - 12, height: 56))
                self.areaTextFidld.font = defaultSysFontWithSize(17)
                cell?.contentView.addSubview(self.areaTextFidld)
            }
            return cell!
        case 3 :
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.titles[indexPath.section]
            let size = self.titles[indexPath.section].sizeWithFont(defaultSysFontWithSize(17), maxWidth: 320)
            if self.codeTextFidld == nil {
                self.codeTextFidld = UITextField(frame: CGRect(x: 20 + size.width, y: 0, width: kScreenWidth - 20 - size.width - 12, height: 56))
                self.codeTextFidld.font = defaultSysFontWithSize(17)
                cell?.contentView.addSubview(self.codeTextFidld)
            }
            return cell!
        case 4 :
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.titles[indexPath.section]
            let size = self.titles[indexPath.section].sizeWithFont(defaultSysFontWithSize(17), maxWidth: 320)
            if self.addressTextFidld == nil {
                self.addressTextFidld = UITextField(frame: CGRect(x: 20 + size.width, y: 0, width: kScreenWidth - 20 - size.width - 12, height: 56))
                self.addressTextFidld.font = defaultSysFontWithSize(17)
                cell?.contentView.addSubview(self.addressTextFidld)
            }
            return cell!
        case 5 :
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = self.titles[indexPath.section]
            let swithBtn = UISwitch(frame: CGRect(x: kScreenWidth - 12 - 56, y: 14, width: 56, height: 28))
            cell?.contentView.addSubview(swithBtn)
            return cell!
        default :
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK:- Private Method
    private func subViewInit(){
        if self.isAdd {
            self.title = "编辑收货地址"
        }
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
        
        let fotView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        fotView.backgroundColor = UIColor.clearColor()
        let saveBtn = ZMDTool.getButton(CGRect(x: 12, y: 45, width: kScreenWidth - 24, height: 50), textForNormal: "保存", fontSize: 20, textColorForNormal: UIColor.whiteColor(), backgroundColor: RGB(235,61,61,1.0)) { (sender) -> Void in
            
        }
        ZMDTool.configViewLayerWithSize(saveBtn, size: 25)
        fotView.addSubview(saveBtn)
        self.currentTableView.tableFooterView = fotView
    }
    private func dataInit(){
    }
}
