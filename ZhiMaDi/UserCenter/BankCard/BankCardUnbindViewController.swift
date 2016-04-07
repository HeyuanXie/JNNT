//
//  BankCardUnbindViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 安全验证
class BankCardUnbindViewController: UIViewController,ZMDInterceptorProtocol {
    var viewTop : CustomPassWordView!
    var passW = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -  PrivateMethod
    func setupUI() {
        self.title = "安全验证"
        let labelTop = UILabel(frame: CGRectMake(20, 84, kScreenWidth - 40, 17))
        labelTop.font = defaultSysFontWithSize(17)
        labelTop.text = "请输入支付密码,以解绑银行卡"
        labelTop.textColor = defaultTextColor
        
        self.view.addSubview(labelTop)
        viewTop = CustomPassWordView(frame: CGRectMake(20, 84+17+20, kScreenWidth - 40, (kScreenWidth-40)/6))
        viewTop.finish = { (ps) -> Void in
            print(ps)
            self.passW = ps
        }
        viewTop.startKeyBoard()
        self.view.addSubview(viewTop)
        let size = "忘记密码".sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 300)
        let btn = ZMDTool.getButton(CGRect(x: kScreenWidth - 20 - size.width, y:CGRectGetMaxY(self.viewTop.frame)+12, width: size.width, height: 14), textForNormal: "忘记密码", fontSize: 14,textColorForNormal:RGB(54,147,233,1), backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            
        }
        self.view.addSubview(btn)
        let nextBtn = ZMDTool.getButton(CGRect(x: 12, y: CGRectGetMaxY(btn.frame)+44, width: kScreenWidth - 24, height: 50), textForNormal: "下一步", fontSize: 20, textColorForNormal: UIColor.whiteColor(), backgroundColor: RGB(235,61,61,1.0)) { (sender) -> Void in
            let vc = BankCardVerifyPhoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        ZMDTool.configViewLayerWithSize(nextBtn, size: 25)
        self.view.addSubview(nextBtn)

    }

}
