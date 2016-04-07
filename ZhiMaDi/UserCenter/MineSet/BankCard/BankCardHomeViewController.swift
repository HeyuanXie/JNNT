//
//  MineBankCardHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/7.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 银行卡
class BankCardHomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    
    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = []//["企业","",""]
        self.subViewInit()
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
        if self.dataArray.count == 0 {
            return 1
        }
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.dataArray.count == 0 {
            return 95+140+30
        }
        return 105
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.dataArray.count == 0  {
            let cellId = "NoCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = tableViewdefaultBackgroundColor
            }
            let imgV = UIImageView(frame: CGRect(x: (kScreenWidth - 140)/2, y: 95, width: 140, height: 140))
            imgV.image = UIImage(named: "none_bankcard")
            cell?.contentView.addSubview(imgV)
            return cell!
        }
        let cellId = "CardCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = tableViewdefaultBackgroundColor
            
            let bgV = UIView(frame: CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 105))
            bgV.tag = 100000
            bgV.backgroundColor = UIColor.whiteColor()
            cell?.contentView.addSubview(bgV)
            let imgV = UIImageView(frame: CGRect(x: 12+15, y: 17, width: 38, height: 38))
            imgV.tag = 100001
            cell?.contentView.addSubview(imgV)
            let bankLbl = UILabel(frame: CGRect(x: 12+15+38+20, y: 17, width: 200, height: 17))//ZMDTool.getLabel(CGRect(x: 15+38+20, y: 17, width: 200, height: 17), text: "", fontSize: 17)
            bankLbl.tag = 100002
            cell?.contentView.addSubview(bankLbl)
            let bankDetailLbl = ZMDTool.getLabel(CGRect(x: 12+15+38+20, y: 17+17+6, width: 200, height: 14), text: "", fontSize: 14)
            bankDetailLbl.tag = 100003
            cell?.contentView.addSubview(bankDetailLbl)
            let cardNumLbl = ZMDTool.getLabel(CGRect(x: 12+15+38+20, y: 17+17+6+14+20, width: 200, height: 16), text: "", fontSize: 16)
            cardNumLbl.tag = 100004
            cell?.contentView.addSubview(cardNumLbl)
            
            let typeImgV = UIImageView(frame: CGRect(x: kScreenWidth-12-16-20, y: 0, width: 20, height: 40))
            typeImgV.tag = 100005
            cell?.contentView.addSubview(typeImgV)
        }
        let bgV = cell?.viewWithTag(100000)
        let imgV = cell?.viewWithTag(100001) as! UIImageView
        let bankLbl = cell?.viewWithTag(100002) as! UILabel
        let bankDetailLbl = cell?.viewWithTag(100003) as! UILabel
        let cardNumLbl = cell?.viewWithTag(100004) as! UILabel
        let typeImgV = cell?.viewWithTag(100005) as! UIImageView
        
        ZMDTool.configViewLayer(bgV!)
        imgV.image = UIImage(named: "bank_gs")
        bankLbl.text = "中国工商银行"
        bankDetailLbl.text = "储蓄卡"
        cardNumLbl.text = "**** **** **** 0496"
        typeImgV.image = indexPath.section == 0 ?  UIImage(named: "user_bankcard_personal") : UIImage(named: "user_bankcard_company")
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "银行卡"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
        
        let footV = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        footV.backgroundColor = UIColor.clearColor()
        let addBtn = ZMDTool.getButton(CGRect(x: 12, y: 35, width: kScreenWidth - 24, height: 50), textForNormal: "+ 添加银行卡", fontSize: 16,textColorForNormal:defaultDetailTextColor, backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            
        }
        addBtn.setImage(UIImage(named: ""), forState: .Normal)
        ZMDTool.configViewLayerWithSize(addBtn, size: 25)
        ZMDTool.configViewLayerFrameWithColor(addBtn, color: RGB(174,174,174,1.0))
        footV.addSubview(addBtn)
        self.currentTableView.tableFooterView = footV
    }
    
}
