//
//  MineCollectionViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/8.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 收藏的商品
class MineCollectionViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    var data : NSArray!
    let goodses  = ["全部(5)","婴儿床","床垫","儿童椅","奶酪","七万"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subViewInit()
        self.data = ["","",""]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.data.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.section == 0 {
                return  ZMDMultiselectView.getHeight(goodses)
            }
        }
        return 150
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "HeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
            }
            let multiselectView = ZMDMultiselectView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: ZMDMultiselectView.getHeight(goodses)),titles: goodses)
            multiselectView.finished = { (index) ->Void in
                let title = self.goodses[index]
            }
            cell?.contentView.addSubview(multiselectView)
            return cell!
        }
        let cellId = "OtherCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CollectionGoodsCell
        if cell == nil {
            cell = CollectionGoodsCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        var tag = 10000
        let imgV = cell?.viewWithTag(tag++) as! UIImageView
        let goodsLbl = cell?.viewWithTag(tag++) as! UILabel
        let goodsPriceLbl = cell?.viewWithTag(tag++) as! UILabel
        let freightLbl = cell?.viewWithTag(tag++) as! UILabel
        let cancelBtn = cell?.viewWithTag(tag++) as! UIButton
        
        imgV.image = UIImage(named: "product_pic")
        goodsLbl.text = "星球系列毛毛虫"
        goodsPriceLbl.attributedText = "495.0 594.0".AttributedText("594.0", color: RGB(235,61,61,1.0))
        freightLbl.text = "运费 30"
        cancelBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = HomeBuyGoodsDetailViewController.CreateFromMainStoryboard() as! HomeBuyGoodsDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "收藏的商品"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
}
// 收藏商品  cell
class CollectionGoodsCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.None
        self.selectionStyle = .None
        
        ZMDTool.configTableViewCellDefault(self)
        var tag = 10000
        let imgV = UIImageView(frame: CGRect(x: 12, y: 12, width: 125, height: 125))
        imgV.backgroundColor = UIColor.clearColor()
        imgV.tag = tag++
        self.contentView.addSubview(imgV)
        
        let goodsLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y: 12, width: kScreenWidth - 12-125-10-12, height: 15), text: "", fontSize: 15)
        goodsLbl.tag = tag++
        self.contentView.addSubview(goodsLbl)
        
        let goodsPriceLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y: 150-12-14-14-15, width: kScreenWidth - 12-125-10-12, height: 15), text: "", fontSize: 15,textColor: RGB(235,61,61,1.0))
        goodsPriceLbl.tag = tag++
        self.contentView.addSubview(goodsPriceLbl)
        
        let freightLbl = ZMDTool.getLabel(CGRect(x: 12+125+10, y: 150-12-14, width: kScreenWidth - 12-125-10-100, height: 15), text: "", fontSize: 15,textColor: defaultDetailTextColor)
        freightLbl.tag = tag++
        self.contentView.addSubview(freightLbl)
        
        let cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 80, y: 150-12-15, width: 80, height: 15), textForNormal: "取消收藏", fontSize: 15,textColorForNormal:defaultDetailTextColor, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
        })
        cancelBtn.tag = tag++
        self.contentView.addSubview(cancelBtn)
        
        self.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 149.5, width: kScreenWidth, height: 0.5)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
