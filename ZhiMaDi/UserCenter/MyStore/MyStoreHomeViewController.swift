//
//  MyStoreHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/21.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 我的店铺首页
class MyStoreHomeViewController: UIViewController {
    enum CellType {
        case Head,Income,IncomeDetail,Menu
        var cellId : String {
            switch self {
            case Head:
                return "HeadCell"
            case Income:
                return "IncomeCell"
            case IncomeDetail:
                return "IncomeDetailCell"
            case  Menu:
                return "MenuCell"
            }
        }
        var height : CGFloat {
            switch self {
            case Head:
                return 360/750 * kScreenWidth
            case Income:
                return 136
            case IncomeDetail:
                return 144
            case  Menu:
                return 225
            }
        }
        
    }
    @IBOutlet weak var tableView: UITableView!
    var cellTypes = [[CellType.Head,.Income,.IncomeDetail],[.Menu]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypes[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellTypes.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellTypes[indexPath.section][indexPath.row].height
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = self.cellTypes[indexPath.section][indexPath.row]
        switch cellType {
        case .Head :
            let cellId = cellType.cellId
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            
            var tag = 10001
            let imgBg = cell?.viewWithTag(tag++) as! UIImageView
            let storeLbl = cell?.viewWithTag(tag++) as! UILabel
            let detailLbl = cell?.viewWithTag(tag++) as! UILabel
            let followBtn = cell?.viewWithTag(tag++) as! UIButton
            imgBg.image = UIImage.colorImage(RGB(72,72,69,1))
            ZMDTool.configViewLayerWithSize(followBtn, size: 18)
            followBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                return RACSignal.empty()
            })

            return cell!
        case .Income :
            let cellId = cellType.cellId
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            
            return cell!
        case .IncomeDetail :
            let cellId = cellType.cellId
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case .Menu :
            return self.cellForMenu(tableView,cellForRowAtIndexPath: indexPath)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MRAK: - ACtion
    @IBAction func addBtnCli(sender: UIButton) {
    }
    //MARK: -  PrivateMethod
    func cellForMenu(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cellType = self.cellTypes[indexPath.section][indexPath.row]
        let cellId = cellType.cellId
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
        }
//        let titleAndImgForMenuBtn = [("商品管理",UIImage(named: "shop_01product")),("订单管理",UIImage(named: "shop_02order")),("分销管理",UIImage(named: "shop_03fenxiao")),("物流管理",UIImage(named: "shop_04express")),("客户管理",UIImage(named: "shop_05customer")),("营销管理",UIImage(named: "shop_06activity"))]
//        var i = 0
//        for tmp in titleAndImgForMenuBtn {
//            let x = CGFloat(i)%3*(kScreenWidth/3)
//            let y = CGFloat(i)/3*100
//            let view = UIView(frame: CGRect(x: x, y: y, width: kScreenWidth/3, height: 100))
//            view.backgroundColor = UIColor.clearColor()
//            let btn = UIButton(frame: CGRect(x: x, y:y, width: 60, height: 45))
//            btn.setImage(UIImage(named: tmp.0), forState: .Normal)
//            view.addSubview(btn)
//            let lbl = ZMDTool.getLabel(CGRect(x: x, y: y, width: kScreenWidth/3, height: 15), text: tmp.0, fontSize: 15)
//            view.addSubview(lbl)
//            i++
//        }
//        cell?.contentView.addSubview(view)
        return cell!
    }
    func updateUI() {
        self.tableView.backgroundColor = tableViewdefaultBackgroundColor
        
    }
}
