//
//  DataCenterViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/18.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//数据中心 - 今日数据
class DataCenterViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {

    enum UserCenterCellType{
        case SalePrice
        case SaleAccount
        case GuestPrice
        case GuestAccount
        case TransferPrice
        case TransferAccount
        
        init(){
            self = SalePrice
        }
        
        var title : String{
            switch self{
            case SalePrice:
                return "销售额（元）"
            case SaleAccount:
                return "销售量（kg）"
            case GuestPrice :
                return "客单价（元）"
            case GuestAccount:
                return "客单量（kg）"
            case TransferPrice :
                return "转让额（元）"
            case TransferAccount :
                return "转让量（kg）"
            }
        }
    }

    var currentTableView: UITableView!
    
    var userCenterData: [UserCenterCellType]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.subViewInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = kScreenWidth/2
        let height = width*200/375
        return height * 4
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 44))
        headView.backgroundColor = UIColor.clearColor()
        let letfLabel = UILabel(frame: CGRectMake(12,0,150,44))
        letfLabel.font = defaultSysFontWithSize( 14)
        letfLabel.text = "今日实时数据"
        headView.addSubview(letfLabel)
        let rightLabel = UILabel(frame: CGRectMake(kScreenWidth - 180,0,160,44))
        rightLabel.font = defaultSysFontWithSize( 14)
        rightLabel.text = "2015-11-17 18:38:20"
        rightLabel.textAlignment = .Right
        rightLabel.textColor = UIColor.grayColor()
        headView.addSubview(rightLabel)
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            cell!.contentView.backgroundColor = tableViewdefaultBackgroundColor
        }
        for var i=0;i<self.userCenterData.count;i++ {
            let dataType = self.userCenterData[i]
            let width = kScreenWidth/2
            let height = width*200/375
            let x = i%2 == 0 ? 0 : width
            let index = i/2
            let y = CGFloat(index) * height
            let btn = UIButton(frame:  CGRectMake(x,y,width,height))
            btn.backgroundColor = UIColor.whiteColor()
            cell?.contentView.addSubview(btn)
            
            let topLabel = UILabel(frame: CGRectMake(0,height/2 - 36,width,24))
            topLabel.font = defaultSysFontWithSize( 14)
            topLabel.text = dataType.title
            topLabel.textAlignment = .Center
            let midLabel = UILabel(frame: CGRectMake(0,height/2 - 36 + 24,width,26))
            midLabel.font = defaultSysFontWithSize( 16)
            midLabel.text = "242.00"
            midLabel.textAlignment = .Center

            let bottmoLabel = UILabel(frame: CGRectMake(0,height/2 - 36 + 24 + 26,width,22))
            bottmoLabel.font = defaultSysFontWithSize( 10)
            bottmoLabel.text = "32232.00"
            bottmoLabel.textColor = UIColor.greenColor()
            bottmoLabel.textAlignment = .Center

            btn.addSubview(topLabel)
            btn.addSubview(midLabel)
            btn.addSubview(bottmoLabel)
 
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            })
        }
        let lineView = UIView(frame: CGRectMake(0 , 50, kScreenWidth/3, 2))
        view.addSubview(lineView)
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "帐户安全"
        self.currentTableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.currentTableView.backgroundColor = defaultBackgroundGrayColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.SalePrice,UserCenterCellType.SaleAccount,UserCenterCellType.GuestPrice, UserCenterCellType.GuestAccount, UserCenterCellType.TransferPrice, UserCenterCellType.TransferAccount]
    }
   

}
