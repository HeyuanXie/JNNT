//
//  BandCardVerifyPhoneViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 验证手机号
class BankCardVerifyPhoneViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol{
    var currentTableView: UITableView!
    var codeTextField : UITextField!
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
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 94
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 94))
        headView.backgroundColor = UIColor.clearColor()
        let topLbl = ZMDTool.getLabel(CGRect(x: 0, y: 25, width: kScreenWidth, height: 14), text: "验证短信已发送至手机", fontSize: 14, textColor: defaultDetailTextColor)
        topLbl.textAlignment = .Center
        headView.addSubview(topLbl)
        let phoneLbl = ZMDTool.getLabel(CGRect(x: 0, y: 25+14+18, width: kScreenWidth, height: 17), text: "136****2222", fontSize: 17, textColor: defaultTextColor)
        phoneLbl.textAlignment = .Center
        headView.addSubview(phoneLbl)
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        cell?.textLabel!.text = "验证码"
        if self .codeTextField == nil {
            self.codeTextField = ZMDTool.getTextField(CGRect(x: 88, y: 0, width: kScreenWidth - 100, height: 56), placeholder: "请输入验证码", fontSize: 17)
            // 获取验证码的按钮
            let btn = ZMDTool.getButton(CGRect(x: kScreenWidth - 92 - 12-12, y: 14, width: 92, height: 32), textForNormal: "获取验证码", fontSize: 13, textColorForNormal:defaultDetailTextColor,backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                
            })
            ZMDTool.configViewLayerWithSize(btn, size: 18)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = defaultLineColor.CGColor
            
            self.codeTextField.rightViewMode =  UITextFieldViewMode.Always
            self.codeTextField.rightView = btn
        }
        cell?.contentView.addSubview(self.codeTextField)

        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "验证手机号"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
        
        self.currentTableView.addFootBtn("下一步") { (sender) -> Void in
            let vc = BankCardSetPsViewController()
            self.navigationController!.pushViewController(vc, animated: true)
        }
        let btn = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            return RACSignal.empty()
        })
        btn.tintColor = defaultDetailTextColor
        self.navigationItem.rightBarButtonItem = btn
    }

}
