//
//  MyStoreOrderDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/27.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//
class MyStoreOrderDetailViewController: UIViewController,ZMDInterceptorProtocol {
    
    enum UserCenterCellType{
        case OrderNum
        case LogisticsMsg
        case AcceptMsg
        
        case Store
        case Goods
        case Service
        
        case Pay
        case Mark
        case Invoice
        case Discount
        case Jifeng
        
        case Total
        
        init(){
            self = OrderNum
        }
        
        var title : String{
            switch self{
            case Pay :
                return "支付方式:"
            case Mark :
                return "备注"
            case Invoice :
                return "发票:"
            case Discount:
                return "优惠:"
            case Jifeng:
                return "获得积分:"
            default :
                return ""
            }
        }
        //
        //        var pushViewController :UIViewController{
        //            let viewController: UIViewController
        //            switch self{
        //            case UserMyOrder:
        //                viewController = MyOrderViewController.CreateFromMainStoryboard() as! MyOrderViewController
        //            case UserMyOrderMenu:
        //                viewController = UIViewController()
        //            case UserWallet:
        //                viewController = UIViewController()
        //            case UserBankCard:
        //                viewController = UIViewController()
        //            case UserCardVolume:
        //                viewController = UIViewController()
        //            case UserMyCrowdFunding:
        //                viewController = UIViewController()
        //
        //            case UserMyStore:
        //                viewController = UIViewController()
        //            case UserVipClub:
        //                viewController = UIViewController()
        //            case UserCommission:
        //                viewController = UIViewController()
        //            case UserInvitation:
        //                viewController = UIViewController()
        //
        //            case UserHelp:
        //                viewController = UIViewController()
        //            default :
        //                viewController = UIViewController()
        //            }
        //            viewController.hidesBottomBarWhenPushed = true
        //            return viewController
        //        }
        //
        //        func didSelect(navViewController:UINavigationController){
        //            navViewController.pushViewController(pushViewController, animated: true)
        //        }
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    var userCenterData: [[UserCenterCellType]]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.updateUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCenterData[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType {
        case .OrderNum :
            return 54
        case .LogisticsMsg :
            return 118
        case .AcceptMsg :
            return 100
        case .Store:
            return 48
        case .Goods :
            return 110
        case .Service:
            return 62
        case .Total:
            return 75
        default :
            return 56
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType {
        case .OrderNum:
            let cellId = "OrderNumCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let numLbl = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: 300, height: 54), text: "订单编号 ： 1524235232342", fontSize: 17)
            cell?.contentView.addSubview(numLbl)
            let typeLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth  - 92, y: 0, width: 80, height: 54), text: "等待收货", fontSize: 17,textColor: RGB(235,61,61,1.0))
            cell?.contentView.addSubview(typeLbl)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 53.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
        case .LogisticsMsg :
            let cellId = "LogisticsMsgCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let arrowImgV = UIImageView(frame: CGRect(x: kScreenWidth - 27, y: 20, width: 9, height: 15))
            arrowImgV.image = UIImage(named: "common_forward")
            let numLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20, width: 300, height: 17), text: "查看物流", fontSize: 17)
            cell?.contentView.addSubview(numLbl)
            cell?.contentView.addSubview(arrowImgV)
            let wuliuLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+17+8, width: kScreenWidth-24, height: 15), text: "物流顺丰", fontSize: 15,textColor:defaultDetailTextColor)
            cell?.contentView.addSubview(wuliuLbl)
            let orderLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+17+8+15+8, width: kScreenWidth-24, height: 15), text: "下单时间 : 2016-02-20 15:3:23", fontSize: 15,textColor:defaultDetailTextColor)
            cell?.contentView.addSubview(orderLbl)
            let fahuoLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20+17+8+15+8 + 15 + 8, width: kScreenWidth-24, height: 15), text: "发货时间 : 2016-02-20 15:3:23", fontSize: 15,textColor:defaultDetailTextColor)
            cell?.contentView.addSubview(fahuoLbl)
            return cell!
        case .AcceptMsg :
            let cellId = "AcceptMsgCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let userLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 300, height: 17), text: "收货人 ：葫芦一娃", fontSize: 17)
            cell?.contentView.addSubview(userLbl)
            let phoneLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 120, y: 16, width: 300, height: 17), text: "13780338447", fontSize: 17)
            cell?.contentView.addSubview(phoneLbl)
            let addressStr = "收货地址:广东省东莞市松山湖高新技术产业园新新"
            let addressSize = addressStr.sizeWithFont(defaultSysFontWithSize(17), maxWidth: kScreenWidth - 24)
            let addressLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: addressSize.height), text: addressStr, fontSize: 17)
            addressLbl.numberOfLines = 2
            cell?.contentView.addSubview(addressLbl)
            return cell!
        case .Store :
            let cellId = "StoreCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 47.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
        case .Goods :
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            return cell
        case .AcceptMsg :
            let cellId = "AcceptMsgCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let userLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 300, height: 54), text: "收货人 ：葫芦一娃", fontSize: 17)
            cell?.contentView.addSubview(userLbl)
            let phoneLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 300, height: 54), text: "13780338447", fontSize: 17)
            cell?.contentView.addSubview(phoneLbl)
            let addressLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: 54), text: "收货地址:广东省东莞市松山湖高新技术产业园新新", fontSize: 17)
            addressLbl.numberOfLines = 2
            cell?.contentView.addSubview(addressLbl)
            return cell!
        case .Service :
            let cellId = "ServiceCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let contactBtn = ZMDTool.getButton(CGRect(x: (kScreenWidth-130)/2 , y: 12, width: 130, height: 40), textForNormal: "联系商家", fontSize: 16, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                
            })
            ZMDTool.configViewLayerFrameWithColor(contactBtn, color: defaultTextColor)
            ZMDTool.configViewLayer(contactBtn)
            contactBtn.setImage(UIImage(named: "product_chat"), forState: .Normal)
            cell?.contentView.addSubview(contactBtn)
            return cell!
        case .Total :
            let cellId = "TotalCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let leftLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 100, height: 17), text: "共一件商品", fontSize: 17)
            cell?.contentView.addSubview(leftLbl)
            let payLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 200, y: 20, width: 200, height: 17), text: "实付：525.0", fontSize: 17)
            payLbl.textAlignment = .Right
            cell?.contentView.addSubview(payLbl)
            let monnyLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20 + 17 + 10, width: kScreenWidth - 24, height: 15), text: "(含运费80.0)", fontSize: 15,textColor: defaultDetailTextColor)
            monnyLbl.textAlignment = .Right
            cell?.contentView.addSubview(monnyLbl)
            return cell!
        default :
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell!.textLabel?.text = cellType.title
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType{
        case .LogisticsMsg:
            let vc = OrderLogisticsMsgViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    //MARK:Private Method
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        let bottomView = UIView(frame: CGRect(x: 0, y: kScreenHeight - 64 - 58, width: kScreenWidth, height: 58))
        bottomView.backgroundColor = RGB(247,247,247,1.0)
        let checkBtn = ZMDTool.getButton(CGRect(x: 0, y: 0, width: kScreenWidth/2, height: 58), textForNormal: "查看物流", fontSize: 15,backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            
        }
        bottomView.addSubview(checkBtn)
        let confirmBtn = ZMDTool.getButton(CGRect(x: kScreenWidth/2, y: 0, width: kScreenWidth/2, height: 58), textForNormal: "确认签收", fontSize: 15, backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            
        }
        bottomView.addSubview(confirmBtn)
        let line = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.5))
        line.backgroundColor = RGB(209,209,209,1)
        bottomView.addSubview(line)
        self.view.addSubview(bottomView)
    }
    private func dataInit(){
        self.userCenterData = [[.OrderNum,.AcceptMsg], [.Goods,.Service],[.Pay,.Mark,.Invoice,.Discount,.Jifeng],[.Total]]
    }
}
