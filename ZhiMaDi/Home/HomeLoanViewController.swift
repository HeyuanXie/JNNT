//
//  HomeLoanViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/3.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class HomeLoanViewController: UIViewController,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarHiddenProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(frame: self.view.bounds)
        btn.contentMode = .ScaleAspectFit
        btn.setImage(UIImage(named: "Home_Loan_Tmp"), forState: .Normal)
        self.view.addSubview(btn)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
