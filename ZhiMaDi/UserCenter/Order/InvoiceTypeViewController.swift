//
//  InvoiceTypeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/31.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 选择发票类型
class InvoiceTypeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {
    var tableView : UITableView!
    let datas = [["不开发票","个人","公司"],["床上用品","家具","日用品"]]
    var indexTypeRow = 0,indexDetailRow = 0
    var finished : ((indexType:Int,IndexDetail:Int)->Void)!
    var invoiceStrTextF : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择发票类型"
        let rightBar = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        rightBar.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            return RACSignal.empty()
        })
        rightBar.tintColor = defaultTextColor
        self.navigationController?.navigationItem.rightBarButtonItem = rightBar
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.datas.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 12 : 57
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 57))
            headView.backgroundColor = UIColor.clearColor()
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 30, width: 100, height: 17), text: "发票明细", fontSize: 17)
            headView.addSubview(label)
            return headView
        }
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 12))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell\(indexPath.section)\(indexPath.row)"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            let imgV = UIImageView(frame: CGRect(x: kScreenWidth - 12 - 14, y: 15, width: 14, height: 25))
            imgV.image = UIImage(named: "pay_selected")
            imgV.tag = 10001
            imgV.hidden = true
            cell?.contentView.addSubview(imgV)
            
            if indexPath.section == 0 && indexPath.row == 2 {
                let textField = UITextField(frame: CGRect(x: 64, y: 0, width: kScreenWidth - 64 - 12, height: 55))
                textField.textColor = defaultDetailTextColor
                textField.font = defaultSysFontWithSize(17)
                textField.placeholder = "输入发票台头"
                cell?.contentView.addSubview(textField)
                self.invoiceStrTextF = textField
            }
        }
        cell?.textLabel?.text = self.datas[indexPath.section][indexPath.row]

        if (indexPath.section == 0 && indexPath.row == self.indexTypeRow) || (indexPath.section == 1 && indexPath.row == self.indexDetailRow) {
            if let tmp = cell?.contentView.viewWithTag(10001) as? UIImageView {
                tmp.hidden = false
            }
            cell?.textLabel?.textColor = RGB(235,61,61,1.0)
        } else {
            cell?.textLabel?.textColor = defaultTextColor
            if let tmp = cell?.contentView.viewWithTag(10001) as? UIImageView {
                tmp.hidden = true
            }
        }
        
       
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.indexTypeRow = indexPath.row
        } else {
            self.indexDetailRow = indexPath.row
        }
        self.tableView.reloadData()
    }
    func updateUI() {
        tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = tableViewdefaultBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView)
    }
}
