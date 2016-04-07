//
//  BankCardSetPsViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 设置支付密码
class BankCardSetPsViewController: UIViewController,ZMDInterceptorProtocol {
    var viewTop : CustomPassWordView!
    var passW = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "设置支付密码"
        
        let btn = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            return RACSignal.empty()
        })
        btn.tintColor = defaultDetailTextColor
        self.navigationItem.rightBarButtonItem = btn
        
        let labelTop = UILabel(frame: CGRectMake(20, 84, kScreenWidth - 40, 17))
        labelTop.font = defaultSysFontWithSize(17)
        labelTop.text = "设置密码"
        labelTop.textColor = defaultTextColor
        
        self.view.addSubview(labelTop)
        viewTop = CustomPassWordView(frame: CGRectMake(20, 84+17+20, kScreenWidth - 40, (kScreenWidth-40)/6))
        viewTop.finish = { (ps) -> Void in
            print(ps)
            self.passW = ps
        }
        viewTop.startKeyBoard()
        self.view.addSubview(viewTop)
    }
    
}
