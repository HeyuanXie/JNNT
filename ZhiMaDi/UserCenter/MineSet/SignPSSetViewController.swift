//
//  SignPSSetViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/3.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class SignPSSetViewController: UIViewController {

    @IBOutlet weak var psTextF: UITextField!
    @IBOutlet weak var psAgainTextF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmBtnCli(sender: UIButton) {
    }

    func updateUI() {
        ZMDTool.configViewLayer(self.confirmBtn)
        let view = UIView(frame: CGRectMake(0, 0, 12, 20))
        self.psTextF.leftView = view
        self.psTextF.leftViewMode =  UITextFieldViewMode.Always
        self.psAgainTextF.leftView = view
        self.psAgainTextF.leftViewMode =  UITextFieldViewMode.Always
    }

}
