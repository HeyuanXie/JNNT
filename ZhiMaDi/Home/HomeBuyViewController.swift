
//
//  HomeBuyViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/24.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//我要买
class HomeBuyViewController: UIViewController, ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate {
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我要买"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .SingleLine
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.navigationController?.navigationBarHidden = false 
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
        return 4
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return 84
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let imgV = UIImageView(frame: CGRectMake(12, 16, 52, 52))
            imgV.image = UIImage(named: "apple")
            cell?.contentView.addSubview(imgV)
            let titleLabel = UILabel(frame: CGRectMake(86, 24, 100, 18))
            titleLabel.text = "苹果"
            titleLabel.textColor = UIColor.blackColor()
            titleLabel.font = UIFont.systemFontOfSize(18)
            cell?.contentView.addSubview(titleLabel)
            
            let detailLbl = UILabel(frame: CGRectMake(86, 48, 100, 14))
            detailLbl.text = "卖家数"
            detailLbl.textColor = UIColor.grayColor()
            detailLbl.font = UIFont.systemFontOfSize(14)
            cell?.contentView.addSubview(detailLbl)
            
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }


}
