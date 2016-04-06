//
//  ShoppingCartViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 购物车
class ShoppingCartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var settlementBtn: UIButton!

    var dataArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = [["","","",""],[""],[""]]
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        ZMDTool.configViewLayerWithSize(settlementBtn,size: 16)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return  indexPath.row == 0 ? 48 : 110
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellId = "StoreCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 47.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
        } else {
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            (cell.editBtn as UIButton).rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.editViewShow()
            })
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    //MARK: -Action
    
    @IBAction func selectAllBtnCli(sender: UIButton) {
    }
    // 结算
    @IBAction func settlementBtnCli(sender: UIButton) {
    }
    //MARK: -  PrivateMethod
    func editViewShow() {
        let bg = UIButton(frame: self.view.bounds)
        bg.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) //半透明色值
        let config = ZMDPopViewConfig()
        config.dismissCompletion = { (view) ->Void in
            bg.removeFromSuperview()
        }
        self.presentPopupView(bg,config: config)
        
        let view = UIView(frame: CGRect(x: 0, y: self.view.bounds.height - 300, width: kScreenWidth, height: 300))
        view.backgroundColor = UIColor.whiteColor()
        
        let countLbl = UILabel(frame: CGRect(x: 12, y: 0, width: 200, height: 60))
        let kucunText = "（库存量: 15）"
        let countText = "购买数量\(kucunText)"
        countLbl.attributedText = countText.AttributedMutableText(["购买数量",countText], colors: [defaultTextColor,defaultDetailTextColor])
        countLbl.font = defaultSysFontWithSize(16)
        view.addSubview(countLbl)
        
        let countView = CountView(frame: CGRect(x: kScreenWidth - 12 - 120, y: 10, width: 120, height: 40))
        view.addSubview(countView)
        
        let colorlabel = ZMDTool.getLabel(CGRect(x: 12, y: 60, width: 200, height: 60), text: "颜色", fontSize: 16)
        view.addSubview(colorlabel)
        let colorLblSize = "蓝色".sizeWithFont(colorlabel.font, maxWidth: 100)
        let colorbtn = ZMDTool.getButton(CGRect(x: 220 , y: 120, width: colorLblSize.width + 30, height: 60), textForNormal: "蓝色", fontSize: 16, backgroundColor: UIColor.whiteColor()) { (sender) -> Void in
        }
        colorbtn.titleLabel?.textAlignment = .Center
        colorbtn.tag = 10001
        view.addSubview(colorbtn)
        
        let guigelabel = ZMDTool.getLabel(CGRect(x: 12, y: 120, width: 200, height: 60), text: "规格", fontSize: 16)
        view.addSubview(guigelabel)
        let sizeTmp = "90cm*190cm".sizeWithFont(guigelabel.font, maxWidth: 100)
        let btn = ZMDTool.getButton(CGRect(x: 220 , y: 120, width: sizeTmp.width + 30, height: 60), textForNormal: "90cm*190cm", fontSize: 16, backgroundColor: UIColor.whiteColor()) { (sender) -> Void in
        }
        btn.titleLabel?.textAlignment = .Center
        btn.tag = 10001
        view.addSubview(btn)
        
        let okBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 14 - 110, y: 4*60+12, width: 110, height: 36), textForNormal: "确定", fontSize: 17,textColorForNormal: UIColor.whiteColor(), backgroundColor: RGB(235,61,61,1.0)) { (sender) -> Void in
            self.dismissPopupView(view)
        }
        ZMDTool.configViewLayerWithSize(okBtn, size: 18)
        view.addSubview(okBtn)
        let cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 14 - 110 - 8 - 80, y: 4*60+12, width: 80, height: 36), textForNormal: "取消", fontSize: 17, backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            self.dismissPopupView(view)
        }
        view.addSubview(cancelBtn)
        var i = 0
        for _ in ["","","",""] {
            i++
            let line = ZMDTool.getLine(CGRect(x: 0, y: 60*CGFloat(i), width: kScreenWidth, height: 0.5))
            view.addSubview(line)
        }
        config.showAnimation = .SlideInFromBottom
        config.dismissAnimation = .SlideOutToBottom
        self.presentPopupView(view,config: config)
        
    }
}
