//
//  OrderDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//订单详情
class OrderDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {

    enum UserCenterCellType{
        case Address
        case User
        case Detail
        case LogisticsCost
        case Cost
        case Total
        
        init(){
            self = User
        }
        
        var title : String{
            switch self{
            case Address:
                return "收货人"
            case User:
                return "货主"
            case Detail:
                return "详请"
            case LogisticsCost:
                return "物流费"
            case Cost:
                return "金额"
            case Total:
                return "合计"
            }
        }
    }
    @IBOutlet weak var currentTableView: UITableView!
    
    var cellType : [[UserCenterCellType]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellType = [[UserCenterCellType.Address],[UserCenterCellType.User],[UserCenterCellType.Detail],[UserCenterCellType.LogisticsCost,UserCenterCellType.Cost,UserCenterCellType.Total]]
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.updateFootView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellType[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellType.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let type = self.cellType[indexPath.section][indexPath.row]
        switch type {
        case .Address :
            return 76
        case .Detail :
            return 140
        default :
            return tableViewCellDefaultHeight
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        footView.backgroundColor = UIColor.clearColor()
        return footView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let type = self.cellType[indexPath.section][indexPath.row]
        switch type {
        case .Address :
            let cellId = "addressCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case .Detail :
            let cellId = "goodsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        
        default :
            let cellId = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel!.text = type.title
            let label = UILabel(frame: CGRectMake(kScreenWidth - 220, 0, 200, tableViewCellDefaultHeight))
            label.font = tableViewCellDefaultTextFont
            cell?.contentView.addSubview(label)
            switch type {
            case .LogisticsCost :
                label.text = "根据提货数量自动计算"
            case .Cost :
                label.text = "0.00"
            case .Total :
                label.text = "16500.00"
            default :
                break
            }
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: -  PrivateMethod
    func updateFootView() {
        let footView = UIView(frame: CGRectMake(0,0,kScreenWidth,42))
        footView.backgroundColor = UIColor.clearColor()
        let payBtn = UIButton(frame: CGRectMake(kScreenWidth - 70 - 20, 10,70, 32))
        payBtn.backgroundColor = UIColor.redColor()
        payBtn.setTitle("立即付款", forState: .Normal)
        payBtn.titleLabel?.font = defaultSysFontWithSize(12)
        payBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        footView.addSubview(payBtn)
        ZMDTool.configViewLayer(payBtn)
        payBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.navigationController?.pushViewController(VerificationPSViewController(), animated: true)
        }
        
        let cancleBtn = UIButton(frame: CGRectMake(kScreenWidth - 70 - 20 - 10 - 70 , 10,70, 32))
        cancleBtn.backgroundColor = UIColor(red: 237/255.0, green: 191/255.0, blue: 28/255.0, alpha: 1.0)
        cancleBtn.setTitle("取消订单", forState: .Normal)
        cancleBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancleBtn.titleLabel?.font = defaultSysFontWithSize(12)
        footView.addSubview(cancleBtn)
        ZMDTool.configViewLayer(cancleBtn)
        self.currentTableView.tableFooterView = footView
        cancleBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in

        }
    }
}
