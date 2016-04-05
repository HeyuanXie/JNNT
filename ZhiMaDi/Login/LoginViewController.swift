//
//  LoginViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 登录
class LoginViewController: UIViewController , ZMDInterceptorNavigationBarHiddenProtocol, UITextFieldDelegate{

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var otherLoginBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var rightBar: UIBarButtonItem!
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
    //回到帐户登录
    @IBAction func accountBtnCli(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
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
        
        ZMDTool.configViewLayerWithSize(self.loginBtn, size: 25)
        
        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tap)
        
        
        if self.otherLoginBtn != nil {
            // 获取验证码的按钮
            let btn = ZMDTool.getButton(CGRect(x: kScreenWidth - 92 - 12-12, y: 14, width: 92, height: 32), textForNormal: "获取验证码", fontSize: 13, textColorForNormal:defaultDetailTextColor,backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                
            })
            ZMDTool.configViewLayerWithSize(btn, size: 18)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = defaultLineColor.CGColor
            
            self.accountTextField.rightViewMode =  UITextFieldViewMode.Always
            self.accountTextField.rightView = btn
            self.getVerificationBtn = btn
        }
       
        
        if self.otherLoginBtn != nil {
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
        
        let thirdTitle = ["微信","微博","QQ"]
        let thirdImage = ["common_share_wechat","common_share_weibo","common_share_qq"]
        var i = CGFloat(0)
        for title in thirdTitle {
            //105 50 50 
            let width = CGFloat(50),height = CGFloat(75)
            let x = 25+width*i + 50*i
            let btn = ZMDTool.getBtn(CGRect(x: x, y: 0, width: width, height: height))
            btn.setImage(UIImage(named:thirdImage[Int(i)]), forState: .Normal)
            btn.setTitle(title, forState: .Normal)
            btn.setTitleColor(defaultTextColor, forState: .Normal)
            btn.titleLabel?.font = defaultSysFontWithSize(15)
            self.thirdView.addSubview(btn)
            i++
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
// MARK: - 获取验证码UI 显示的超时时间
private let overTimeMax = 60
// MARK: - 获取验证码的支持
extension LoginViewController {
    // MARK: 验证码
    // 从服务器获取验证码
    class func fetchAuthCode(viewController: UIViewController, phone: (() -> String?), authCodeButton: UIButton?, isRegister: Bool) {
        //        if let phoneNum = phone() where count(phoneNum) > 0 {
        ZMDTool.showActivityView("正在获取验证码...", inView: viewController.view)
        if isRegister {
            //                QNNetworkTool.registeredSmscode(phoneNum, completion: { [weak viewController](succeed, error, errorMsg) -> Void in
            //                    if let _ = viewController {
            ZMDTool.hiddenActivityView()
            //                        if succeed {
            ZMDTool.showPromptView( "验证码已发送到你手机", nil)
            self.waitingAuthCode(authCodeButton, start: true)
            //                        }
            //                        else {
            //                            QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
            //                        }
            //                    }
            //                    })
        }else{
            //                QNNetworkTool.getCheckcode(phoneNum, completion: { [weak viewController](succeed, error, errorMsg) -> Void in
            //                    if let _ = viewController {
            //                        QNTool.hiddenActivityView()
            //                        if succeed {
            //                            QNTool.showPromptView( "验证码已发送到你手机", nil)
            self.waitingAuthCode(authCodeButton, start: true)
            //                        }
            //                        else {
            //                            QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
            //                        }
            //                    }
            //                    })
            
        }
        //        }
    }
    // 显示获取验证码倒计时
    class func waitingAuthCode(button: UIButton!, start: Bool = false) {
        if button == nil { return } // 验证码的UI变化，如果没有button，则不会有变化
        
        let overTimer = button.tag
        if overTimer == 0 && start {
            button.tag = overTimeMax
        }
        else {
            button.tag = max(overTimer - 1, 0)
        }
        
        if button.tag == 0 {
            button.setTitle("获取验证码", forState: .Normal)
            button.backgroundColor = UIColor.clearColor()
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
            button.enabled = true
        }
        else {
            button.setTitle("\(button.tag)S", forState: .Normal)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(appThemeColor, forState: .Normal)
            button.enabled = false
            button.setNeedsLayout()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue(), { () in
                self.waitingAuthCode(button)
            })
        }
    }
}


