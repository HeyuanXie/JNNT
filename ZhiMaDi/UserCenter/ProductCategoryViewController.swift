//
//  ProductCategoryViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/10.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//产品选择
class ProductCategoryViewController: UIViewController, ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate  {

    var tableViewLeft : UITableView!
    var tableViewRight : UITableView!
    
    var dataArray = [["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""],["","","","","","","","","","",""]]
    var leftIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品选择"
        
        self.tableViewLeft = UITableView(frame: CGRectMake(0, 0, 96, kScreenHeight), style: UITableViewStyle.Plain)
        self.tableViewLeft.backgroundColor = defaultBackgroundGrayColor
        self.tableViewLeft.separatorStyle = .None
        self.tableViewLeft.dataSource = self
        self.tableViewLeft.delegate = self
        self.view.addSubview(self.tableViewLeft)
        
        self.tableViewRight = UITableView(frame: CGRectMake(96, 0, kScreenWidth - 96, kScreenHeight), style: UITableViewStyle.Plain)
        self.tableViewRight.backgroundColor = defaultBackgroundGrayColor
        self.tableViewRight.separatorStyle = .None
        self.tableViewRight.dataSource = self
        self.tableViewRight.delegate = self
        self.view.addSubview(self.tableViewRight)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableViewLeft :
            return 1
        case self.tableViewRight :
            return 1
        default :
            return 0
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
        case self.tableViewLeft :
            return dataArray.count
        case self.tableViewRight :
            return 1
        default :
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case self.tableViewLeft :
            return 0.5
        case self.tableViewRight :
            return 0
        default :
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case self.tableViewLeft :
            return 60
        case self.tableViewRight :
            let marginTop = CGFloat(14)
            let marginLeft = CGFloat(16)
            let width = (kScreenWidth - 96 - 4 * marginLeft)/3
            let height = (marginTop + width) * CGFloat(self.dataArray[self.leftIndex].count/3 + 1)
            return height
        default :
            return 0
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 0))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableView {
        case self.tableViewLeft :
            let cellId = "leftCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                let btn = UIButton(frame: CGRectMake(6, 0, 90, 60))
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn.setTitleColor(appThemeColor, forState: .Selected)
                btn.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(),size: CGSizeMake(90,60)), forState: .Normal)
                btn.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(),size: CGSizeMake(90, 60)), forState: .Selected)
                btn.tag = 10001
                cell?.contentView.addSubview(btn)
            }
            
            if let btn = cell?.contentView.viewWithTag(10001) as? UIButton {
                btn.setTitle("苹果", forState: .Normal)
                btn.setTitle("苹果", forState: .Selected)
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    self.leftIndex = indexPath.section
                    self.tableViewLeft.reloadData()
                    self.tableViewRight.reloadData()
                })
                if self.leftIndex == indexPath.section {
                    cell?.contentView.backgroundColor = appThemeColor
                    btn.selected = true
                } else {
                    cell?.contentView.backgroundColor = UIColor.whiteColor()
                    btn.selected = false
                }
            }
            return cell!
        case self.tableViewRight :
                let cellId = "rightCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                let count = self.dataArray[self.leftIndex].count
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    cell?.contentView.backgroundColor = defaultBackgroundGrayColor
                    for var i=0;i<count;i++  {
                        let marginTop = CGFloat(14)
                        let marginLeft = CGFloat(16)
                        let width = (kScreenWidth - 96 - 4 * marginLeft)/3
                        let height = width
                        let x = marginLeft + (marginLeft + width) * CGFloat(i%3)
                        let y = marginTop + (marginTop + width) * CGFloat(i/3)
                        let btn = UIButton(frame: CGRectMake(x, y, width, height))
                        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                        btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
                        btn.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(),size: CGSizeMake(width, height)), forState: .Normal)
                        btn.setBackgroundImage(UIImage.colorImage(appThemeColor,size: CGSizeMake(width, height)), forState: .Selected)
                        btn.tag = 1000 + i
                        btn.titleLabel?.numberOfLines = 0
                        btn.titleLabel?.textAlignment = .Center
                        btn.titleLabel?.font = defaultSysFontWithSize(14)
                        ZMDTool.configViewLayerRound(btn)
                        ZMDTool.configViewLayerFrame(btn)
                        cell?.contentView.addSubview(btn)
                    }
                }
                for var i=0;i<count;i++  {
                    let btn = cell?.contentView.viewWithTag(1000+i) as! UIButton
                    btn.setTitle("红玖瑰\n苹果", forState: .Normal)
                    btn.setTitle("美国\n青苹果", forState: .Selected)
                    btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                        btn.selected = !btn.selected
                    })
                }

                return cell!
        default :
            let cellId = "leftCell"
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
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
}
