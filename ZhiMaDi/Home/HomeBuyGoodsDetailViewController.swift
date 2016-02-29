//
//  HomeBuyGoodsDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/25.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//商品详请
class HomeBuyGoodsDetailViewController: UIViewController,QNInterceptorProtocol,QNInterceptorNavigationBarShowProtocol,QNInterceptorMsnProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    var navView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().statusBarHidden = false //info.plist  View controller-based status bar appearance = no
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
        return section == 4 ? 5 : 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0 :
            return kScreenWidth * 7/15
        case 1 :
            return 266
        case 2 :
            return 176
        case 3 :
            return 52
        case 4 :
            return 44
        default :
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0 :
            let cellId = "adCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 7/15))
                let image = ["Home_Top1_Advertisement","Home_Top2_Advertisement"]
                cycleScroll.imgArray = image
                //            cycleScroll.delegate = self
                cycleScroll.autoScroll = true
                cycleScroll.autoTime = 2.5
                cell?.addSubview(cycleScroll)
            }
            return cell!
        case 1 :
            let cellId = "detailCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 2 :
            let cellId = "commentCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 3 :
            let cellId = "menuCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(self.createFilterMenu())
            }
            return cell!
        case 4 :
            let cellId = "bottomCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        default :
            break
        }
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    //MARK: -  PrivateMethod
    func createFilterMenu() -> UIView{
        let titles = ["交付标准","农场情况","交易记录"]
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 52))
        for var i=0;i<3;i++ {
            let index = i%4
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * kScreenWidth/3 , 0, kScreenWidth/3, 52))
            btn.backgroundColor = UIColor.clearColor()
            btn.setTitle(titles[i], forState: .Normal)
            btn.setTitle(titles[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(18)
            view.addSubview(btn)
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            })
        }
        let lineView = UIView(frame: CGRectMake(0 , 50, kScreenWidth/3, 2))
        view.addSubview(lineView)
        return view
    }
    func setupNewNavigation() {
        let getBtn = { (frame:CGRect) -> UIButton in
            let btn = UIButton(frame: frame)
            btn.backgroundColor = UIColor.blackColor()
            btn.layer.opacity = 0.5
            ZMDTool.configViewLayerRound(btn)
            return btn
        }
        let navView = UIView(frame: CGRectMake(0 , 32, kScreenWidth, 38))
        navView.backgroundColor = UIColor.clearColor()
        let backBtn = getBtn(CGRectMake(12 , 0, 38, 38))//UIButton(frame: CGRectMake(12 , 12, 38, 38))
        let homeBtn = getBtn(CGRectMake(kScreenWidth - 50 , 0, 38, 38))
        let shareBtn =  getBtn(CGRectMake(kScreenWidth - 98 , 0, 38, 38))
        
        backBtn.setImage(UIImage(named: "Navigation_Back02"), forState:.Normal)
        homeBtn.setImage(UIImage(named: "Home_Buy_Home"), forState:.Normal)
        shareBtn.setImage(UIImage(named: "Home_Buy_Share"), forState:.Normal)
        navView.addSubview(backBtn)
        navView.addSubview(homeBtn)
        navView.addSubview(shareBtn)
        navView.showAsPop(setBgColor: false)
        self.navView = navView
        
        backBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        homeBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
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
