//
//  ConfirmOrderViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/30.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 确认订单
class ConfirmOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {
    
    enum UserCenterCellType{
        case AddressSelect
        
        case Store
        case Goods
        case Discount
        case freight
        case Mark
        case GoodsCount
        
        case Invoice
        case InvoiceType
        case InvoiceDetail
        case InvoiceFor
        
        case UseDiscount
        init(){
            self = AddressSelect
        }
        
        var title : String{
            switch self{
            case Discount:
                return "店铺优惠:"
            case freight:
                return "运费:"
            case Mark:
                return "备注:"
            case GoodsCount:
                return "共一件商品"

            case Invoice:
                return "是否开具发票"
            case InvoiceType:
                return "发票类型:"
            case InvoiceDetail:
                return "优惠明细:"
            case InvoiceFor:
                return "优惠抬头:"
                
            case UseDiscount:
                return "使用优惠券"
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
        case .AddressSelect :
            return 55
        case .Store:
            return 48
        case .Goods :
            return 110
        default :
            return 56
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType {
        case .AddressSelect:
            let cellId = "AddressSelectCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.imageView?.image = UIImage(named: "pay_select_adress")
            let numLbl = ZMDTool.getLabel(CGRect(x: 44, y: 0, width: 300, height: 55), text: "选择收获地址", fontSize: 17)
            cell?.contentView.addSubview(numLbl)
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
        case .Discount :
            let cellId = "DiscountCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell!.textLabel?.text = cellType.title
            let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "无", fontSize: 17)
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            return cell!
        case .Mark :
            let cellId = "MarkCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell!.textLabel?.text = cellType.title
            let textField = UITextField(frame: CGRect(x: 64, y: 0, width: kScreenWidth - 64 - 12, height: 55))
            textField.textColor = defaultDetailTextColor
            textField.font = defaultSysFontWithSize(17)
            textField.placeholder = "给商家留言"
            cell?.contentView.addSubview(textField)
            return cell!
        case .GoodsCount :
            let cellId = "GoodsCountCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell!.textLabel?.text = cellType.title
            let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "", fontSize: 17)
            label.attributedText = "合计 : ￥525.0".AttributedText("￥525", color: RGB(235,61,61,1.0))
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            return cell!
        case .Invoice :
            let cellId = "InvoiceCell"
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
       
        case .InvoiceType :
            let cellId = "InvoiceTypeCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
        
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "个人", fontSize: 17,textColor: defaultDetailTextColor)
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            cell!.textLabel?.text = cellType.title
            return cell!
        case .InvoiceDetail :
            let cellId = "InvoiceDetailCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 110, y: 0, width: 110, height: 55.5), text: "床上用品", fontSize: 17,textColor: defaultDetailTextColor)
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            cell!.textLabel?.text = cellType.title
            return cell!
        case .InvoiceFor :
            let cellId = "InvoiceForCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
              
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell!.textLabel?.text = cellType.title
            return cell!
        case .UseDiscount :
            let cellId = "UseDiscountCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 32 - 150, y: 0, width: 150, height: 55.5), text: "可使用优惠券：0张", fontSize: 17,textColor: defaultDetailTextColor)
            cell?.contentView.addSubview(label)
            cell!.textLabel?.text = cellType.title
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
        case .Invoice://发票
            let vc = InvoiceTypeViewController()
            vc.finished = {(indexType,IndexDetail)->Void in
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    //MARK:Private Method
 
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight - 64 - 58, width: kScreenWidth, height: 58))
        view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(view)

        let confirmBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 12 - 110, y: 12, width: 110, height: 34), textForNormal: "提交订单", fontSize: 15,textColorForNormal:UIColor.whiteColor(), backgroundColor:RGB(235,61,61,1.0)) { (sender) -> Void in
            let vc = CashierViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        ZMDTool.configViewLayerWithSize(confirmBtn, size: 15)
        view.addSubview(confirmBtn)
        let payLbl = ZMDTool.getLabel(CGRect(x: 12, y: 12, width: 200, height: 15), text: "实付：525.0（含运费39.0）", fontSize: 14,textColor: defaultDetailTextColor)
        view.addSubview(payLbl)
        let jifengLbl = ZMDTool.getLabel(CGRect(x: 12, y: 12 + 15 + 7, width: 200, height: 12), text: "可获得20积分", fontSize: 12,textColor: defaultDetailTextColor)
        view.addSubview(jifengLbl)
    }
    private func dataInit(){
        self.userCenterData = [[.AddressSelect],[.Store,.Goods,.Discount,.freight,.Mark,.GoodsCount], [.Invoice,.InvoiceType,.InvoiceDetail,.InvoiceFor],[.UseDiscount]]
    }
}
