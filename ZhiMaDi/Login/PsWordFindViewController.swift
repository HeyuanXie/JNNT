//
//  PsWordFindViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/1.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 找回登录密码
class PsWordFindViewController: UIViewController, ZMDInterceptorNavigationBarHiddenProtocol, UITextFieldDelegate{
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var psTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var getVerificationBtn: UIButton!  //  getVerificationBtn == nil ？ 密码登录 ： 验证码登录
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // 如果有本地账号了，就自动登录
        self.autoLogin()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == .Next {
            self.verificationTextField.becomeFirstResponder()
        }
        else if textField.returnKeyType == .Done {
            self.login()
        }
        return false
    }
    
    // @IBAction
    // MARK: 登录
    //    @IBAction func login(sender: UIButton) {
    //        self.login()
    //    }
    //    @IBAction func goBack(sender: UIButton) {
    //        if self.getVerificationBtn == nil {
    //            self.navigationController?.popToRootViewControllerAnimated(true)
    //        } else {
    //            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    //            ZMDTool.enterRootViewController(vc!)
    //        }
    //    }
    
    //MARK: - PrivateMethod
    func updateUI() {
        // 进一步配置账号和密码输入UI
        let accountImageView = UIImageView(frame: CGRectMake(10, 0, 40, 20))
        accountImageView.contentMode = UIViewContentMode.ScaleAspectFit
        accountImageView.image = UIImage(named: "login_account")
        self.accountTextField.leftView = accountImageView
        self.accountTextField.leftViewMode =  UITextFieldViewMode.Always
        self.accountTextField.text = g_Account
        
        let passwordImageView = UIImageView(frame: CGRectMake(10, 0, 40, 20))
        passwordImageView.contentMode = UIViewContentMode.ScaleAspectFit
        passwordImageView.image = UIImage(named: "login_password")
        self.verificationTextField.leftView = passwordImageView
        self.verificationTextField.leftViewMode =  UITextFieldViewMode.Always
       
        let tmpV = UIImageView(frame: CGRectMake(10, 0, 20, 20))
        tmpV.contentMode = UIViewContentMode.ScaleAspectFit
        self.accountTextField.leftView = tmpV
        self.psTextField.leftViewMode =  UITextFieldViewMode.Always
        
        ZMDTool.configViewLayerWithSize(self.confirmBtn, size: 12)

        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tap)
        
        
        // 获取验证码的按钮
        let btn = ZMDTool.getButton(CGRect(x: kScreenWidth - 92 - 12-12, y: 14, width: 92, height: 32), textForNormal: "获取验证码", fontSize: 13, textColorForNormal:defaultDetailTextColor,backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
            
        })
        ZMDTool.configViewLayerWithSize(btn, size: 18)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = defaultLineColor.CGColor
        
        self.accountTextField.rightViewMode =  UITextFieldViewMode.Always
        self.accountTextField.rightView = btn
        self.getVerificationBtn = btn
        
        LoginViewController.waitingAuthCode(self.getVerificationBtn, start: false)
        self.getVerificationBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
            if let strongSelf = self {
                LoginViewController.fetchAuthCode(strongSelf, phone: { () -> String? in
                    if strongSelf.accountTextField.text!.checkStingIsPhone()  {
                        ZMDTool.showPromptView( "请填写手机号码")
                        strongSelf.accountTextField.text = nil; strongSelf.accountTextField.becomeFirstResponder()
                        return nil
                    }
                    else {
                        return strongSelf.accountTextField.text!
                    }
                    }, authCodeButton: strongSelf.getVerificationBtn, isRegister: true)
            }
        }
    }
    func login() {
        if !self.checkAccountPassWord() {return}
        if let groupId = self.accountTextField.text, let groupPassword = self.verificationTextField.text {
            //            QNNetworkTool.login(GroupId: groupId, GroupPassword: groupPassword)
        }
    }
    
    // MARK: 登录，并把accoutn和password写入的页面上
    func login(account: String, password: String) {
        self.accountTextField.text = account
        self.verificationTextField.text = password
        self.login()
    }
    
    // MARK: 自动登录，获取本机保存的账号密码进行登录
    func autoLogin() {
        if let account = g_Account, password = g_Password {
            self.login(account, password: password)
        }
    }
    
    // 判断输入的合法性
    private func checkAccountPassWord() -> Bool {
        if (self.accountTextField.text?.characters.count == 0 && self.verificationTextField.text?.characters.count == 0) {
            ZMDTool.showPromptView("请输入账号与密码")
            self.accountTextField.becomeFirstResponder()
            return false
        }else if(self.accountTextField.text?.characters.count == 0) {
            ZMDTool.showPromptView("请输入密码")
            self.verificationTextField.becomeFirstResponder()
            return false
            
        }else if (self.verificationTextField.text?.characters.count == 0){
            ZMDTool.showPromptView("请输入账号")
            self.accountTextField.becomeFirstResponder()
            return false
        }
        return true
    }
}
