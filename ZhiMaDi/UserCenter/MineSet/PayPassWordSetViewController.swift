//
//  PayPassWordSetViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/9.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//设置支付密码
class PayPassWordSetViewController: UIViewController ,UITextFieldDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol{
    var viewTop : CustomPassWordView!
    var viewbottom : CustomPassWordView!
    
    var passW = ""
    var passWAgain = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "确认", style: .Bordered, target: self, action: Selector("confige"))
        self.navigationItem.leftBarButtonItem = item
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: -  PrivateMethod
    func setupUI() {
        let labelTop = UILabel(frame: CGRectMake(20, 0, kScreenWidth - 40, 64))
        labelTop.font = defaultSysFontWithSize(14)
        labelTop.text = "请输入6位支付密码"
        labelTop.textColor = UIColor.grayColor()
        self.view.addSubview(labelTop)
        viewTop = CustomPassWordView(frame: CGRectMake(20, 64, kScreenWidth - 40, (kScreenWidth-40)/6))
        viewTop.finish = { (ps) -> Void in
            print(ps)
            self.passW = ps
        }
        viewTop.startKeyBoard()
        self.view.addSubview(viewTop)
        
        let labelBottom = UILabel(frame: CGRectMake(20, 64 + (kScreenWidth-40)/6, kScreenWidth - 40, 64))
        labelBottom.font = defaultSysFontWithSize(14)
        labelBottom.text = "请再次输入6位支付密码"
        labelBottom.textColor = UIColor.grayColor()
        self.view.addSubview(labelBottom)
        
        viewbottom = CustomPassWordView(frame: CGRectMake(20, 128 + (kScreenWidth-40)/6, kScreenWidth - 40, (kScreenWidth-40)/6))
        viewbottom.finish = { (ps) -> Void in
            print(ps)
            self.passWAgain = ps
            if self.passW != self.passWAgain {
                ZMDTool.showPromptView("新密码与原密码不相同，重置失败")
            } else {
                ZMDTool.showPromptView("跳转")
            }
        }
        self.view.addSubview(viewbottom)
    }
    func confige() {
        
    }
}
