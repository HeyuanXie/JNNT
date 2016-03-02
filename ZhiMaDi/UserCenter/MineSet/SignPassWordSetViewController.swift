//
//  SignPassWordSetViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//设置登录密码
class SignPassWordSetViewController: UIViewController {

    @IBOutlet weak var psTextF: UITextField!
    @IBOutlet weak var psAgainTextF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirmBtnClick(sender: UIButton) {
        
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        ZMDTool.configViewLayer(self.confirmBtn)
        let view = UIView(frame: CGRectMake(0, 0, 12, 20))
        self.psTextF.leftView = view
        self.psTextF.leftViewMode =  UITextFieldViewMode.Always
        self.psAgainTextF.leftView = view
        self.psAgainTextF.leftViewMode =  UITextFieldViewMode.Always
    }
}
