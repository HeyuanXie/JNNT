//
//  ProductSpecsViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/4.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class ProductSpecsViewController: UIViewController ,  UITableViewDataSource, UITableViewDelegate,ZMDInterceptorNavigationBarHiddenProtocol{
    
    let getLabel = { (y : CGFloat!) -> UILabel in
        let label = UILabel(frame: CGRectMake(12, y, 200, 52))
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 52*6 : 52
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            
            let view = cell?.viewWithTag(10001)
            ZMDTool.configViewLayerFrame(view!)
            ZMDTool.configViewLayer(view!)
            let title = ["甜度 ：","平均果径 ：","光/套果 ：","含冰糖心概率 ：","固定参数 ："]
            for index in [0,1,2,3,4] {
                let tmpLbl = getLabel(CGFloat(index * 52))
                tmpLbl.text = title[index]
                tmpLbl.backgroundColor = UIColor.whiteColor()
                cell?.contentView.addSubview(tmpLbl)
            }
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
