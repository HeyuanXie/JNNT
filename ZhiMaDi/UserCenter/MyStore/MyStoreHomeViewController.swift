//
//  MyStoreHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/21.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 我的店铺首页
class MyStoreHomeViewController: UIViewController,ZMDInterceptorProtocol {
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
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            
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
        self.viewShowWithBgForNav(self.viewForAddGoods(), showAnimation: ZMDPopupShowAnimation.FadeIn, dismissAnimation: ZMDPopupDismissAnimation.FadeOut)
    }
    //MARK: -  PrivateMethod
    func cellForMenu(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cellType = self.cellTypes[indexPath.section][indexPath.row]
        let cellId = cellType.cellId
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
        }
        
        let titleAndImgForMenuBtn = [("商品管理",UIImage(named: "shop_01product"),UIViewController()),
            ("订单管理",UIImage(named: "shop_02order"),MyStoreOrderHomeViewController.CreateFromStoreStoryboard() as! MyStoreOrderHomeViewController),
            ("分销管理",UIImage(named: "shop_03fenxiao"),MyStoreDistributionHomeViewController.CreateFromStoreStoryboard() as! MyStoreDistributionHomeViewController),
            ("物流管理",UIImage(named: "shop_04express"),UIViewController()),
            ("客户管理",UIImage(named: "shop_05customer"),MyStoreCustomerViewController.CreateFromStoreStoryboard() as! MyStoreCustomerViewController),
            ("营销管理",UIImage(named: "shop_06activity"),UIViewController())]
        var i = 0
        for tmp in titleAndImgForMenuBtn {
            let x = CGFloat(i)%3*(kScreenWidth/3)
            let row = i/3
            let y = CGFloat(row)*100
            let btn = UIButton(frame: CGRect(x: x, y: y,width: kScreenWidth/3-10, height: 100-10))//ZMDTool.getBtn(CGRect(x: x, y: y,width: kScreenWidth/3, height: 100))
            btn.setImage(tmp.1, forState: .Normal)
            btn.setTitle(tmp.0, forState: .Normal)
            btn.setTitleColor(defaultTextColor, forState: .Normal)
            btn.titleLabel?.font = defaultSysFontWithSize(15)
            btn.tag = i++
            btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                let tag = (sender as! UIButton).tag
                self.navigationController?.pushViewController(titleAndImgForMenuBtn[tag].2, animated: true)
                return RACSignal.empty()
            })
            cell?.contentView.addSubview(btn)
        }
        return cell!
    }
    func updateUI() {
        self.tableView.backgroundColor = tableViewdefaultBackgroundColor
        let rightItem = UIBarButtonItem(image: UIImage(named: "shop_set"), style: .Done, target: nil, action: nil)
        rightItem.tintColor = defaultTextColor
        rightItem.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            let vc = MyStoreSetViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return RACSignal.empty()
        })
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func viewForAddGoods() -> UIView{
        let titlesAndImg = [("添加出售商品",UIImage(named: "")),("添加出租商品",UIImage(named: ""))]
        let view = UIView(frame: CGRect(x: 36, y: kScreenHeight/2-125, width: kScreenWidth-72, height: 125*2))
        view.backgroundColor = UIColor.whiteColor()
        ZMDTool.configViewLayer(view)
        var i = 0
        for tmp in titlesAndImg {
            let btn = ZMDTool.getButton(CGRect(x: 0, y: CGFloat(i++) * 125, width: CGRectGetWidth(view.frame), height: 125), textForNormal: tmp.0, fontSize: 17, textColorForNormal: defaultTextColor, backgroundColor: UIColor.clearColor(), blockForCli: { (sender) -> Void in
                
            })
            btn.setImage(tmp.1, forState: .Normal)
            view.addSubview(btn)
            if i < titlesAndImg.count - 1 {
                let line = ZMDTool.getLine(CGRect(x: 0, y: 124.5, width: CGRectGetWidth(view.frame), height: 0.5))
                btn.addSubview(line)
            }
        }
        return view
    }
}
