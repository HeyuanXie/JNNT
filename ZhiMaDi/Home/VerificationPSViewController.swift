//
//  PayViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 验证密码
class VerificationPSViewController: UIViewController,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    var psView : CustomPassWordView!
    
    var passW = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func updateUI() {
        self.title = "验证密码"
        psView = CustomPassWordView(frame: CGRectMake(20, 64, kScreenWidth - 40, (kScreenWidth-40)/6))
        psView.finish = { (ps) -> Void in
            print(ps)
            self.passW = ps
        }
        psView.startKeyBoard()
        self.view.addSubview(psView)
    }
}
