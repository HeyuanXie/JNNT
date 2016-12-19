//
//  TempViewController.swift
//  ZhiMaDi
//
//  Created by admin on 16/12/16.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//临时ViewController
class TempViewController: UIViewController,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    
    var vcTitle: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        // Do any additional setup after loading the view.
    }

    
    
    func initUI() -> Void {
        self.title = self.vcTitle
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
