//
//  MyFollowViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/10.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//我的关注
class MyFollowViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var goodsBtn: UIButton!
    @IBOutlet weak var sellerBtn: UIButton!
    
    var dataGoods = ["","","",""]
    var dataSeller = ["","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.updateUI()
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
        if self.goodsBtn.selected {
            return self.dataGoods.count
        } else {
            return self.dataSeller.count
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.goodsBtn.selected ?  10 : 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.goodsBtn.selected {
            return 198
        } else {
            return 76
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.goodsBtn.selected {
            let cellId = "goodsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        } else {
            let cellId = "sellerCell"
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
    //MARK: - Actions
    @IBAction func goodsBtnCli(sender: UIButton) {
        self.goodsBtn.selected = !self.goodsBtn.selected
        self.sellerBtn.selected = !self.sellerBtn.selected
        self.currentTableView.reloadData()
    }
    @IBAction func releaseBtnCli(sender: UIButton) {
        self.goodsBtn.selected = !self.goodsBtn.selected
        self.sellerBtn.selected = !self.sellerBtn.selected
        self.currentTableView.reloadData()
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        let color = UIColor(red: 237/255, green: 191/255, blue: 28/255, alpha: 1.0)
        self.goodsBtn.setBackgroundImage(UIImage.colorImage(color, size: self.goodsBtn.bounds.size), forState: .Selected)
        self.sellerBtn.setBackgroundImage(UIImage.colorImage(color, size: self.sellerBtn.bounds.size), forState: .Selected)
        self.goodsBtn.selected = true
        self.btnView.layer.borderWidth = 0.5
        self.btnView.layer.borderColor = color.CGColor
        ZMDTool.configViewLayer(self.btnView)
    }
    private func dataInit(){
        self.goodsBtn.selected = true
    }
}
