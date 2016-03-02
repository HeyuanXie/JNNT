//
//  AddressEditOrAddViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//编辑或增加收货地址
class AddressEditOrAddViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    @IBOutlet weak var currentTableView: UITableView!
    var isAdd : Bool = true
    var address : String! = "芝麻地"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subViewInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
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
        return 56
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let titles = ["收货人","手机号码","所在地区","详细地址"]
            let cellId = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            
            if let lbl = cell?.viewWithTag(10001) as? UILabel {
                lbl.text = titles[indexPath.row]
            }
            if let textV = cell?.viewWithTag(10002) as? UITextView {
                textV.text = address
                textV.editable = indexPath.row == 2 ? false : true
            }
            if indexPath.row == 2 {
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            return cell!
        } else {
            let cellId = "SeclectedCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            if let btn = cell?.viewWithTag(10003) as? UIButton {
                btn.rac_signalForControlEvents(.TouchDragInside).subscribeNext({ (sender) -> Void in
                    
                })
            }
            return cell!
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let dataArray = ["芝","麻","2人","3人","4人","5人","6人","7人","8人"]
            let data = ["0","1","2","3","4","5","6","7","8"]
            let pickView = CustomPickView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight))
            pickView.dataArray = NSMutableArray(array: dataArray)
            pickView.showAsPop()
            pickView.finished = { (index) -> Void in
                self.address = dataArray[index]
                self.currentTableView.reloadData()
            }
        }
    }
    //MARK:- Private Method
    private func subViewInit(){
        if self.isAdd {
            self.title = "编辑收货地址"
        }
    }
    private func dataInit(){
      
    }
}
