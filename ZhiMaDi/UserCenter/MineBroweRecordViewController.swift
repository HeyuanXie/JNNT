//
//  MineBroweRecordViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/14.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 浏览记录
class MineBrowseRecordViewController: UIViewController,ZMDInterceptorProtocol {
    
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataArray = ["","",""]
        self.updateUI()
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
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OtherCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
//        var i = 10001
//        let headImgV = cell?.viewWithTag(i++) as! UIImageView
//        let titleLbl = cell?.viewWithTag(i++) as! UILabel
//        let moneyLbl = cell?.viewWithTag(i++) as! UILabel
//        let freightLbl = cell?.viewWithTag(i++) as! UILabel
//        let deleteBtn = cell?.viewWithTag(i++) as! UIButton
//        deleteBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
//            
//        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = HomeBuyGoodsDetailViewController.CreateFromMainStoryboard() as! HomeBuyGoodsDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 22))
        let moreBtn = UIButton(frame: CGRect(x: 48, y: 0, width: 22, height: 22))
        moreBtn.setImage(UIImage(named: "common_more"), forState: .Normal)
        moreBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.gotoMore()
        }
        rightView.addSubview(moreBtn)
        let clearBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 22))
        clearBtn.setTitle("清空", forState: .Normal)
        clearBtn.setTitleColor(defaultDetailTextColor, forState: .Normal)
        clearBtn.titleLabel?.font = defaultSysFontWithSize(17)
        clearBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
        }
        rightView.addSubview(clearBtn)
        let rightItem = UIBarButtonItem(customView: rightView)
        self.navigationItem.rightBarButtonItem = rightItem
    }
}
