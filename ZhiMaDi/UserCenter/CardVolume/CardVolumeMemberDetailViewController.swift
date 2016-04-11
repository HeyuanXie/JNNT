//
//  CardVolumeCostmViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/11.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 会员卡详情
class CardVolumeMemberDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    enum CellType {
        case Head
        case Method
        case Explain
        
        var height : CGFloat {
            switch self {
            case Head :
                return 100
            case Method:
                return 80
            case Explain:
                return 170
            }
        }
        
    }
    var currentTableView: UITableView!
    var cellType = [CellType.Head,CellType.Method,.Explain]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellType.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let type = self.cellType[indexPath.row]
        return type.height
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let type = self.cellType[indexPath.row]
        switch type {
        case .Head :
            let cellId = "HeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = tableViewdefaultBackgroundColor
                
                
                let bgV = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
                bgV.tag = 100000
                bgV.backgroundColor = UIColor.clearColor()
                cell?.contentView.addSubview(bgV)
                let imgV = UIImageView(frame: CGRect(x: 34, y: 22, width: 60, height: 60))
                imgV.tag = 100001
                cell?.contentView.addSubview(imgV)
                let titleLbl = ZMDTool.getLabel(CGRect(x: 115, y: 32, width: 200, height: 18), text: "", fontSize: 18,textColor: UIColor.whiteColor())
                titleLbl.tag = 100002
                cell?.contentView.addSubview(titleLbl)
                let conditionLbl = ZMDTool.getLabel(CGRect(x: 115, y: 32+18+10, width: 200, height: 13), text: "", fontSize: 13,textColor: UIColor.whiteColor())
                conditionLbl.tag = 100003
                cell?.contentView.addSubview(conditionLbl)
                let vipCardLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth-24-200, y:14, width: 200, height: 13), text: "", fontSize: 13,textColor: UIColor.whiteColor(),textAlignment: .Right)
                vipCardLbl.tag = 100004
                cell?.contentView.addSubview(vipCardLbl)
            }
            let bgV = cell?.viewWithTag(100000) as! UIImageView
            _ = cell?.viewWithTag(100001) as! UIImageView
            let titleLbl = cell?.viewWithTag(100002) as! UILabel
            let conditionLbl = cell?.viewWithTag(100003) as! UILabel
            let vipCardLbl = cell?.viewWithTag(100004) as! UILabel
            
            ZMDTool.configViewLayer(bgV)
            bgV.image = UIImage(named: "user_vipcard_bg")
            bgV.contentMode = .ScaleToFill
            titleLbl.text = "葫芦堡旗舰店"
            conditionLbl.text = "有效期：长期有效"
            vipCardLbl.text = "VIP 银卡"
            return cell!

        case .Method :
            let cellId = "MethodCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel!.text = "获得途径"
            cell?.detailTextLabel!.text = "新用户下载APP获赠"
            cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 79.5, width: kScreenWidth, height: 0.5)))
            return cell!
        case .Explain :
            let cellId = "ExplainCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = UIColor.whiteColor()
            }
            let titleLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20, width: kScreenWidth, height: 16), text: "使用说明", fontSize: 17)
            cell?.contentView.addSubview(titleLbl)
            let detailLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+16+12, width: kScreenWidth, height: 40), text: "VIP银卡购物9.5折；\n不可与其他优惠方式同时使用", fontSize: 15,textColor: defaultDetailTextColor)
            detailLbl.numberOfLines = 2
            cell?.contentView.addSubview(detailLbl)
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "详情"
        let rightBtn = ZMDTool.getButton(CGRect(x: 0, y: 0, width: 62, height: 44), textForNormal: "删除", fontSize: 16,backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
        })
        rightBtn.setImage(UIImage(named: "common_delete"), forState: .Normal)
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        let item = UIBarButtonItem(customView: rightBtn)
        item.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            return RACSignal.empty()
        })
        item.customView?.tintColor = defaultDetailTextColor
        self.navigationItem.rightBarButtonItem = item
        
        self.currentTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.view.bounds.size.height-64-58))
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
        
        self.view.addSubview(ZMDTool.getLine(CGRect(x: 0, y: self.view.bounds.height - 64-58-0.5, width: kScreenWidth, height: 0.5)))
        let goBtn = ZMDTool.getButton(CGRect(x: 0, y: self.view.bounds.height - 64-58, width: kScreenWidth, height: 58), textForNormal: "去购物", fontSize: 17, backgroundColor:RGB(247,247,247,1)) { ( sender) -> Void in
        }
        goBtn.setImage(UIImage(named: "pay_goshopping"), forState: .Normal)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:0)
        self.view.addSubview(goBtn)
        
    }
}
