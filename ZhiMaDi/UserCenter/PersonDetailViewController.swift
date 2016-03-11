//
//  PersonDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/10.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//个人主页
class PersonDetailViewController: UIViewController ,  UITableViewDataSource, UITableViewDelegate,ZMDInterceptorNavigationBarHiddenProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    var navView : UIView!
    var headerV : UIView!
    
    var cellWidth : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.setupNewNavigation()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navView.removePop()
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
        return 10 + 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return section == 0 ? 0 : 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
            let headView = UILabel(frame: CGRectMake(0, 0, kScreenWidth, 40))
            headView.backgroundColor = UIColor.clearColor()
            headView.text = "   全部商品（1）"
            headView.font = defaultSysFontWithSize(14)
            return headView
        } else {
            let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
            headView.backgroundColor = defaultBackgroundGrayColor
            return headView
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "headCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            if let personImgV = cell!.viewWithTag(10001) {
                personImgV.layer.cornerRadius = 43
                personImgV.layer.masksToBounds = true
            }
            return cell!
        }
        else {
            let cellId = "goodsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
    }
    //MARK:Private Method
    func setupNewNavigation() {
        let getBtn = { (frame:CGRect) -> UIButton in
            let btn = UIButton(frame: frame)
            btn.backgroundColor = UIColor.clearColor()
            btn.layer.opacity = 0.5
            ZMDTool.configViewLayerRound(btn)
            return btn
        }
        let navView = UIView(frame: CGRectMake(0 , 20, kScreenWidth, 44))
        navView.backgroundColor = UIColor.clearColor()
        let backBtn = getBtn(CGRectMake(12 , 8, 28, 28))
        let msnBtn = getBtn(CGRectMake(kScreenWidth - 40 , 8, 28, 28))
        
        backBtn.setImage(UIImage(named: "Navigation_Back"), forState:.Normal)
        msnBtn.setImage(UIImage(named: "Navi_Msg"), forState:.Normal)
        msnBtn.tintColor = UIColor.whiteColor()
        navView.addSubview(backBtn)
        navView.addSubview(msnBtn)
        navView.showAsPop(setBgColor: false)
        self.navView = navView
        
        backBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        msnBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    func configHead() {
        
    }
    func updateUI() {
        self.currentTableView.backgroundColor = defaultBackgroundGrayColor
    }


}
