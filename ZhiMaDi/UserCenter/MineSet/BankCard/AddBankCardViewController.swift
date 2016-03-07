//
//  AddBankCardViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class AddBankCardViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        let grayColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        self.dataArray = [""]
        let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 56))
        footView.backgroundColor = UIColor.clearColor()
        let btn = UIButton(frame: CGRectMake(12, 10, kScreenWidth - 24, 46))
        btn.backgroundColor = grayColor
        btn.setTitle("下一步", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            let vc = VerifyBankCardViewController.CreateFromMainStoryboard() as! VerifyBankCardViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        footView.addSubview(btn)
        self.currentTableView.tableFooterView = footView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellId = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}
