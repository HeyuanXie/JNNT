//
//  MyStoreCusDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 客户消费详情
class MyStoreCusDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    enum CellType {
        case DisName , DisLeve ,DisGoodsCount,DisCommission,DisSellCount,DisGoods
        var title : String {
            switch self {
            case DisName :
                return "用户名 ："
            case DisLeve :
                return "等级 ："
            case DisGoodsCount :
                return "上一次购买时间 ："
            case DisCommission :
                return "累计消费 ："
            case  DisSellCount :
                return "购买次数 ："
            case DisGoods :
                return "商品列表"
            }
        }
    }
    let cellType = [[CellType.DisName,.DisLeve,.DisGoodsCount],[.DisCommission,.DisSellCount]]
    var goods = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData()
        self.subViewInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? cellType[section].count : cellType[section].count + self.goods.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellType.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row > 1 {
            return 150
        }
        return 60
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row > 1 {
            let cellId = "GoodsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? DisGoodsCell
            if cell == nil {
                cell = DisGoodsCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell!.imgV.image = UIImage(named: "product_pic")
            cell!.goodsLbl.text = "星球系列毛毛虫"
            cell!.goodsPriceLbl.text = "594.0"
            return cell!
        } else {
            let cellType = self.cellType[indexPath.section][indexPath.row]
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                cell!.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 59.5, width: kScreenWidth, height: 0.5)))
            }
            cell?.textLabel?.text = cellType.title
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "客户消费详情"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
    func updateData() {
        self.goods = ["","",""]
    }
}