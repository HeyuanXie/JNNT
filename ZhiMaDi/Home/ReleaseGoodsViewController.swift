//
//  ReleaseGoodsViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/3.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class ReleaseGoodsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    
    @IBOutlet weak var currentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRectMake(12, 0, kScreenWidth - 30, 50))
        label.text = "特别说明：系统会根据转卖货品的总额，按20%的比例计算出需交付保证金的费用。"
        label.font = tableViewCellDefaultDetailTextFont
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        self.currentTableView.tableFooterView = label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
        if indexPath.section == 0 {
            let cellId = "topCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let titles = ["转卖数量","转卖单价","转卖时效"]
            let placeholders = ["请输入转卖数量","请输入转卖单价","请选择转卖时效"]
            let label = cell?.viewWithTag(10001) as! UILabel
            let textField = cell?.viewWithTag(10002) as! UITextField
            label.text = titles[indexPath.row]
            textField.placeholder = placeholders[indexPath.row]
            return cell!
        } else {
            let cellId = "payCell"
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
    //MARK: - Action
    @IBAction func nextBtnCli(sender: UIButton) {
        let vc = ReleaseGoodsConfirmViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
