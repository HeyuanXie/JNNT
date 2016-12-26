//
//  MineCollectionViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/8.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 关注的店铺
class MineFollowViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!

    lazy var datas : NSMutableArray = {
        let tmp = NSMutableArray()
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subViewInit()
        self.fetchData()
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
        return zoom(16)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return zoom(85)
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, zoom(16)))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OtherCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        let store = self.datas[indexPath.row] as! ZMDStoreDetail
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
            var tag = 10000
            let imgV = UIImageView(frame: CGRect(x: zoom(12), y: zoom(12), width: zoom(60), height: zoom(60)))
            imgV.backgroundColor = UIColor.clearColor()
            imgV.tag = tag++
            cell?.contentView.addSubview(imgV)
            
            let storeLbl = ZMDTool.getLabel(CGRect(x: zoom(12+60+10), y: zoom(20), width: kScreenWidth - 82-75-10, height: zoom(15)), text: "", fontSize: 15)
            storeLbl.tag = tag++
            cell?.contentView.addSubview(storeLbl)
            
            let storeGoodsLbl = ZMDTool.getLabel(CGRect(x: zoom(12+60+10), y: zoom(85-35), width: kScreenWidth - 82-75-10, height: zoom(15)), text: "", fontSize: 15,textColor: defaultDetailTextColor)
            storeGoodsLbl.tag = tag++
            cell?.contentView.addSubview(storeGoodsLbl)
            
            let goToBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 75, y: zoom(20), width: zoom(75), height: zoom(15)), textForNormal: "进入店铺", fontSize: 14, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                let vc = StoreShowHomeViewController.CreateFromMainStoryboard() as! StoreShowHomeViewController
                vc.storeId = store.Id
                self.pushToViewController(vc, animated: true, hideBottom: true)
            })
            goToBtn.tag = tag++
            cell?.contentView.addSubview(goToBtn)
            
            let cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 75, y: zoom(85-20-15), width: zoom(75), height: zoom(15)), textForNormal: "取消关注", fontSize: 14,textColorForNormal:defaultTextColor, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                self.cancelCollect(store)
            })
            cancelBtn.tag = tag++
            cell?.contentView.addSubview(cancelBtn)
            cell?.addLine()
        }
        var tag = 10000
        let imgV = cell?.viewWithTag(tag++) as! UIImageView
        let storeLbl = cell?.viewWithTag(tag++) as! UILabel
        let storeGoodsLbl = cell?.viewWithTag(tag++) as! UILabel
        let cancelBtn = cell?.viewWithTag(tag++) as! UIButton
        let goToBtn = cell?.viewWithTag(tag++) as! UIButton
        
        if let urlStr = store.PictureUrl, url = NSURL(string: kImageAddressMain+urlStr) {
            imgV.sd_setImageWithURL(url, placeholderImage: nil)
        }
        if let name = store.Name {
            storeLbl.text = name
        }
        if let host = store.Host {
            storeGoodsLbl.text = "主营: \(host)"
        }
        storeGoodsLbl.text = "注意： 大发发"
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let store = self.datas[indexPath.row] as! ZMDStoreDetail
        let vc = StoreShowHomeViewController.CreateFromMainStoryboard() as! StoreShowHomeViewController
        vc.storeId = store.Id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "关注的店铺"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
    
    func fetchData() {
        QNNetworkTool.collectStoresList { (success, stores, error) -> Void in
            if success {
                self.datas.removeAllObjects()
                self.datas.addObjectsFromArray(stores as! [AnyObject])
                self.currentTableView.reloadData()
            }else{
                ZMDTool.showErrorPromptView(nil, error: error, errorMsg: nil)
            }
        }
    }
    
    func cancelCollect(store:ZMDStoreDetail) {
        if store.Id == nil {
            ZMDTool.showPromptView("店铺Id为空")
            return
        }
        QNNetworkTool.cancelCollectStores(store.Id.integerValue) { (succeed, error, dictionary) -> Void in
            if succeed! {
                ZMDTool.showPromptView("取消关注成功")
                self.fetchData()
            }else{
                ZMDTool.showPromptView("取消关注失败")
            }
        }
    }
}
