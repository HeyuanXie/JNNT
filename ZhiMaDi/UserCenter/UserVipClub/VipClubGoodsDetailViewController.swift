//
//  VipClubGoodsDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/21.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 详情
class VipClubGoodsDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    @IBOutlet weak var tuiBtn: UIButton!
    
    @IBOutlet weak var currentTableView: UITableView!
    let detail01 = "手感柔软 ：\n\n 服用性好 \n\n适用性广"
    let detail02 = "手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错手感不错"
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
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VipClubGoodsDetailTableViewCell.heightForVipClubGoodsDetailCell(self.detail01, detail02: self.detail02)
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return VipClubGoodsDetailTableViewCell.configVipClubGoodsDetailCell(tableView, detail01: detail01, detail02: detail02)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "棉袄详情"
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        ZMDTool.configViewLayerWithSize(self.tuiBtn, size: 17)
        self.tuiBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            return RACSignal.empty()
        })
        
    }
}

