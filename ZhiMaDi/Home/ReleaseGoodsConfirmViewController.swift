//
//  ReleaseGoodsConfirmViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/4.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 确认转卖信息
class ReleaseGoodsConfirmViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol{
    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认转卖信息"
        self.view.backgroundColor = defaultBackgroundGrayColor
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 70), style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let btn = UIButton(type: .Custom)
        btn.frame = CGRectMake(12, kScreenHeight - 64 - 70, kScreenWidth - 24, 54)
        btn.backgroundColor = UIColor(red: 238/255, green: 191/255, blue: 28/255, alpha: 1.0)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.setTitle("确认发布", forState: .Normal)
        self.view.addSubview(btn)
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
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let text = "转卖数量 ： 10吨\n转卖单价 ： 5.0元/kg\n(*为保证提货时间,转卖)\n支付方式 ：)"
        let size = text.sizeWithFont(UIFont.systemFontOfSize(16), maxWidth: kScreenWidth - 24)
        return  size.height + 24
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            let text1 = NSString(string: "转卖数量 ： 10吨\n转卖单价 ： 5.0元/kg\n")
            let text2 = NSString(string: "(*为保证提货时间,转卖)")
            let text = "转卖数量 ： 10吨\n转卖单价 ： 5.0元/kg\n(*为保证提货时间,转卖)\n支付方式 ：)"
            let attributeStr = NSMutableAttributedString(string: text)
            attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(text1.length, text2.length))
            attributeStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange(text1.length, text2.length))
            let size = text.sizeWithFont(UIFont.systemFontOfSize(16), maxWidth: kScreenWidth - 24)
            let textV = UILabel(frame: CGRectMake(12, 12, kScreenWidth - 24, size.height))
            textV.numberOfLines = 0
            textV.font = UIFont.systemFontOfSize(16)
            textV.attributedText = attributeStr
            cell?.addSubview(textV)
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
