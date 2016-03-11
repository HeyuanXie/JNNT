//
//  HomeMarketViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/10.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//行情趋势
class HomeMarketViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMsnProtocol {
    enum UserCenterCellType{
        case MarketContentTypeAd                        /* 广告显示页 */
        case MarketContentLook                          /*查看*/
        case MarketContentTypeMenu                      /* 菜单选择栏目 */
        case MarketContentTypeMore                      /* 查看更多 */
        case MarketContentTypeRecommendation            /* 推荐广告 */
        
        init(){
            self = MarketContentTypeAd
        }
    }
    @IBOutlet weak var currentTableView: UITableView!
    var dropDownMenuView : UIView!
    var lineDropDown : UIView!
    let goodses = ["苹果","苹果","苹果","苹果","苹果","苹果","苹果","苹果","苹果","苹果"]
    var userCenterData: [UserCenterCellType]!
    var selectIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        lineDropDown = UILabel(frame:CGRectZero)
        lineDropDown.hidden = false
        lineDropDown.tag = 1001
        lineDropDown.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 1
        }
        if section == 3 {
            return 10
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch  self.userCenterData[indexPath.section] {
        case .MarketContentTypeAd :
            return kScreenWidth * 7/15
        case .MarketContentLook :
            return 56
        case .MarketContentTypeMenu :
            let margin_Y = CGFloat(12)
            let height = CGFloat(30)
            let height_FirstMenu = 10 + (margin_Y + height) * CGFloat(goodses.count/4) + height
            
            let menuTitle = ["新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果"]
            let heightSecondMenu = 44 * menuTitle.count
            
            return self.selectIndex > 0 ? height_FirstMenu + CGFloat(heightSecondMenu) + 20 :  height_FirstMenu + 20
        case .MarketContentTypeMore :
            return 52
        case .MarketContentTypeRecommendation :
            return (kScreenWidth - 12*2 - 6*2)/3 * (460/355) + 14*2
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  self.userCenterData[indexPath.section] {
        case .MarketContentTypeAd :
            return self.cellForHomeAd(tableView, indexPath: indexPath)
        case .MarketContentLook :
            return self.cellForMarketLook(tableView, indexPath: indexPath)
        case .MarketContentTypeMenu :
            return self.cellForHomeMenu(tableView, indexPath: indexPath)
        case .MarketContentTypeMore :
            return self.cellForHomeMore(tableView, indexPath: indexPath)
        case .MarketContentTypeRecommendation :
            return self.cellForHomeRecommendation(tableView, indexPath: indexPath)
        default :
            return UITableViewCell()
        }
    }
    //MARK: private method
    //MARK: 广告 cell
    func cellForHomeAd(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "AdCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 7/15))
            let image = ["Home_Top1_Advertisement","Home_Top2_Advertisement"]
            cycleScroll.imgArray = image
            //            cycleScroll.delegate = self
            cycleScroll.autoScroll = true
            cycleScroll.autoTime = 2.5
            cell?.addSubview(cycleScroll)
        }
        return cell!
    }
    func cellForMarketLook(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "lookCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }

    func cellForHomeMenu(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "menuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        let margin_X = CGFloat(5)
        let margin_Y = CGFloat(12)
        let width = (kScreenWidth - 64 - 3 * margin_X - 12) / 4
        let height = CGFloat(30)
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            let label = UILabel(frame: CGRectMake(12, 10, 52, height))
            label.text = "筛选"
            cell?.contentView.addSubview(label)
            
            // 初始一级菜单
            for var i = 0;i<goodses.count;i++ {
                let x = 64 + (width + margin_X) * CGFloat(i%4)
                let y = 10 + (margin_Y + height) * CGFloat(i/4)
                let btn = UIButton(frame: CGRectMake(x, y, width, height))
                btn.setTitle(goodses[i], forState: .Normal)
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn.setTitle(goodses[i], forState: .Selected)
                btn.setTitleColor(appThemeColor, forState: .Selected)
                ZMDTool.configViewLayerFrame(btn)
                btn.tag = 10000 + i
                cell?.contentView.addSubview(btn)
            }
        }
        for var i = 0;i<10;i++ {
            if let btn = cell?.contentView.viewWithTag(10000 + i) as? UIButton {
                btn.selected = btn.tag == self.selectIndex ? true : false
                btn.layer.borderWidth = 0.5
                btn.layer.borderColor = btn.tag == self.selectIndex ? appThemeColor.CGColor : defaultLineColor.CGColor
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    self.lineDropDown.removeFromSuperview()
                    self.selectIndex = sender.tag
                    self.currentTableView.reloadData()
                })
                if self.selectIndex == -1 {
                    // 初始一级菜单
                    for var i = 0;i<goodses.count;i++ {
                        let x = 64 + (width + margin_X) * CGFloat(i%4)
                        let y = 10 + (margin_Y + height) * CGFloat(i/4)
                        if let btn = cell!.contentView.viewWithTag(10000 + i) as? UIButton {
                            btn.frame = CGRectMake(x, y, width, height)
                        }
                    }
                    if self.dropDownMenuView != nil {
                        self.dropDownMenuView.removeFromSuperview()
                    }
                }
                if btn.tag == self.selectIndex {
                    let menuTitle = ["新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果","新疆阿克苏冰糖心苹果"]
                    let menuHeight = 44 * menuTitle.count
                    if self.dropDownMenuView != nil {
                        self.dropDownMenuView.removeFromSuperview()
                    }
                    //重新部署一级菜单
                    for var i = 0;i < goodses.count ;i++ {
                        if  i/4 > (btn.tag - 10000)/4 {
                            if let btn = cell!.contentView.viewWithTag(10000 + i) as? UIButton {
                                let y = 10 + (margin_Y + height) * CGFloat(i/4)
                                let origin = CGPointMake(btn.frame.origin.x, y + CGFloat(menuHeight))
                                btn.frame.origin = origin
                            }
                        } else {
                            if let btn = cell!.contentView.viewWithTag(10000 + i) as? UIButton {
                                let y = 10 + (margin_Y + height) * CGFloat(i/4)
                                let origin = CGPointMake(btn.frame.origin.x, y)
                                btn.frame.origin = origin
                            }
                        }
                    }
                    let dropDown_Y = btn.frame.origin.y + 30
                    self.dropDownMenuView = UIView(frame: CGRectMake(64, dropDown_Y, kScreenWidth - 64 - 12, CGFloat(menuHeight)))
                    self.dropDownMenuView.backgroundColor = UIColor.whiteColor()
                    ZMDTool.configViewLayerFrameWithColor(self.dropDownMenuView,color: appThemeColor)
                    //create二级菜单
                    for var i = 0;i<menuTitle.count;i++ {
                        let btn = UIButton(frame: CGRectMake(0, 44 * CGFloat(i), kScreenWidth - 64 - 12,44))
                        btn.backgroundColor = UIColor.clearColor()
                        let label = UILabel(frame: CGRectMake(10, 0, kScreenWidth - 64 - 12 - 10,44))
                        label.backgroundColor = UIColor.clearColor()
                        label.textAlignment = .Left
                        label.text = menuTitle[i]
                        label.font = defaultSysFontWithSize(14)
                        label.textColor = UIColor.blackColor()
                        btn.addSubview(label)
                        let line = UIView(frame: CGRectMake(10, 43, kScreenWidth - 64 - 12 - 20,1))
                        line.backgroundColor = defaultBackgroundGrayColor
                        btn.addSubview(line)
                        let imgV = UIImageView(frame: CGRectMake(kScreenWidth - 64 - 12 - 10 - 16 , 14, 16,16))
                        imgV.image = UIImage(named: "btn_Arrow_TurnRight1")
                        btn.addSubview(imgV)
                        self.dropDownMenuView.addSubview(btn)
                    }
                    cell!.contentView.addSubview(self.dropDownMenuView)
                    //线
                    if let _ = cell!.contentView.viewWithTag(1001) as? UILabel {
                    } else {
                        self.lineDropDown.frame = CGRectMake(btn.frame.origin.x + 0.5, btn.frame.maxY - 1, width - 1, 2) //档住 选中btn 下标线
                        cell?.contentView.addSubview(self.lineDropDown)
                    }
                   
                }
            }
        }
        return cell!
    }
// 更多 cell
func cellForHomeMore(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
    let cellId = "moreCell"
    var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
    if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        cell!.selectionStyle = .None
        cell!.contentView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(0, 0, kScreenWidth,52))
        label.text = "查看更多"
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        label.font = defaultSysFontWithSize(14)
        cell?.addSubview(label)
    }
    return cell!
}
//MARK: - 底部 cell
func cellForHomeRecommendation(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
    let cellId = "recommendationCell"
    var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
    if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        cell!.selectionStyle = .None
        cell!.contentView.backgroundColor = UIColor.whiteColor()
    }
    let imgVLeft = cell?.contentView.viewWithTag(10001) as! UIImageView
    let imgVBot = cell?.contentView.viewWithTag(10002) as! UIImageView
    let imgVRight = cell?.contentView.viewWithTag(10003) as! UIImageView
    imgVLeft.image = UIImage(named: "HomeMarket_BottomLeft")
    imgVBot.image = UIImage(named: "HomeMarket_BottomMiddle")
    imgVRight.image = UIImage(named: "HomeMarket_BottomRight")
    return cell!
    }
    
    
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.MarketContentTypeAd,UserCenterCellType.MarketContentLook,UserCenterCellType.MarketContentTypeMenu,UserCenterCellType.MarketContentTypeMore, UserCenterCellType.MarketContentTypeRecommendation]
    }
}
