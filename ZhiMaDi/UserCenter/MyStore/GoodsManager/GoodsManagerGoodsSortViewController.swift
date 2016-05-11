//
//  GoodsManagerGoodsSortViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/9.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品分类
class GoodsManagerGoodsSortViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    @IBOutlet weak var currentTableView: UITableView!
    var rightItem : UIBarButtonItem!

    var isEdit = false
    var datas = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        datas = ["","","",""]
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
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
        return 56
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OtherCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! GoodsManagerGoodsSortCell
        ZMDTool.configTableViewCellDefault(cell)
        cell.titleLbl.text = "家俱"
        if !self.isEdit {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.deleteBtnWidthCon.constant = 0
                cell.titleLblWidthCon.constant = 12
                cell.layoutIfNeeded()
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.titleLblWidthCon.constant = 0
                cell.deleteBtnWidthCon.constant = 60
                cell.layoutIfNeeded()
            })
            cell.deleteBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                return RACSignal.empty()
            })
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
//        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        if self.rightItem == nil {
            self.rightItem = UIBarButtonItem(title:"编辑", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
            rightItem.customView?.tintColor = defaultDetailTextColor
            rightItem.rac_command = RACCommand(signalBlock: { [weak self](sender) -> RACSignal! in
                if let StrongSelf = self {
                    StrongSelf.isEdit = !StrongSelf.isEdit
                    StrongSelf.currentTableView.reloadData()
                    StrongSelf.rightItem.title = StrongSelf.isEdit ? "保存" : "编辑"
                }
                return RACSignal.empty()
                })
            self.navigationItem.rightBarButtonItem = rightItem
        }
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
}

