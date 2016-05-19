//
//  ZMDAreaView.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/19.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 选择地址 - View
class ZMDAreaView: UIView,UITableViewDelegate,UITableViewDataSource {
    var tableView : UITableView!
    var areaMenuV : CustomJumpBtns!
    var width : CGFloat!,height : CGFloat!
    var finished : ((address:String,addressId:String)->Void)!
    var level = 0
    var currentData = NSArray()
    var indexForSelect = -1
    var hasNext = true
    var address = ""
    var addressId = ""
    var addresses = NSMutableArray()
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.width = CGRectGetWidth(frame)
        self.height = CGRectGetHeight(frame)
        self.backgroundColor = UIColor.whiteColor()
        self.updateHeadV()
        self.tableview()
        self.fetchData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OtherCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            cell!.textLabel?.font = UIFont.systemFontOfSize(13)
        }
        let area = self.currentData[indexPath.row] as! ZMDArea
        cell?.textLabel?.text = area.name
        cell?.textLabel?.textColor = indexPath.row == self.indexForSelect ?  RGB(235,61,61,1.0) : defaultTextColor
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let area = self.currentData[indexPath.row] as! ZMDArea
        self.addresses.addObject(area)
        self.level = self.level + 1
        address.appendContentsOf(area.name)
        self.addressId = area.id
        self.fetchData(area.id)
    }

    //MARK: -  PrivateMethod
    func updateHeadV() {
        // 75 - 25 = 50  12  38  19
        let closeBtn = UIButton(frame: CGRect(x: self.width-24, y: 19, width: 12, height: 12))
        closeBtn.setImage(UIImage(named: "GoodsSearch_close"), forState: .Normal)
        closeBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            self.finished(address:self.address,addressId:self.addressId)
            return RACSignal.empty()
        })
        self.addSubview(closeBtn)
        
        let titleLbl = ZMDTool.getLabel(CGRect(x: 24, y: 0, width: self.width-48, height: 50), text: "所在地区", fontSize: 13,textAlignment : .Center)
        self.addSubview(titleLbl)
    }

    func tableview() {
        if self.tableView == nil {
            self.tableView = UITableView(frame: CGRect(x: 0, y: 50, width: self.width, height: self.height-75))
            self.tableView.backgroundColor = tableViewdefaultBackgroundColor
            self.tableView.separatorStyle = .None
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.addSubview(self.tableView)
        }
    }
    func fetchData(id:String? = "") {
        QNNetworkTool.areas(id ?? "") { (areas, error, dictionary) -> Void in
            if areas != nil {
                if areas?.count == 0 {
                    self.hasNext = false
                    self.finished(address:self.address,addressId:self.addressId)
                } else {
                    self.currentData = areas!
                    self.tableView.reloadData()
                }
            }
        }
    }
}
