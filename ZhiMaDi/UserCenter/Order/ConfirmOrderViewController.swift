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
                return "发票明细:"
            case InvoiceFor:
                return "发票抬头:"
                
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
    var markTF : UITextField!
    var payLbl : UILabel!
    var totalLbl : UILabel!
    var userCenterData: [[UserCenterCellType]]!
    var scis : NSArray!
    var publicInfo : NSDictionary?
    var total = ""
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
        let cellType = self.userCenterData[section][0]
        if cellType == .Goods {
            return self.scis.count
        }
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
        if self.userCenterData[indexPath.section][0] == .Goods {
            return 110
        }
        let cellType = self.userCenterData[indexPath.section][indexPath.row]
        switch cellType {
        case .AddressSelect :
            return 55
        case .Store:
            return 48
        default :
            return 56
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.userCenterData[indexPath.section][0] == .Goods {
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            let item = self.scis[indexPath.row] as! ZMDShoppingItem
            cell.configCellForConfig(item)
            return cell
        }
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
                
                cell?.imageView?.image = UIImage(named: "pay_select_adress")
                let numLbl = ZMDTool.getLabel(CGRect(x: 44, y: 0, width: 300, height: 55), text: "选择收获地址", fontSize: 17)
                cell?.contentView.addSubview(numLbl)
            }
            return cell!
        case .Store :
            let cellId = "StoreCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 47.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
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
            if self.markTF == nil {
                let textField = UITextField(frame: CGRect(x: 64, y: 0, width: kScreenWidth - 64 - 12, height: 55))
                textField.textColor = defaultDetailTextColor
                textField.font = defaultSysFontWithSize(17)
                textField.tag = 10001
                textField.placeholder = "给商家留言"
                cell?.contentView.addSubview(textField)
                self.markTF = textField
            }
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
                
                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "", fontSize: 17)
                label.attributedText = "合计 : ￥525.0".AttributedText("￥525", color: RGB(235,61,61,1.0))
                label.textAlignment = .Right
                cell?.contentView.addSubview(label)
                self.totalLbl = label
            }
            cell!.textLabel?.text = "共\(self.scis.count)件商品"
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
                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "", fontSize: 17,textColor: defaultDetailTextColor)
                label.textAlignment = .Right
                label.tag = 10000 + indexPath.section*10 + indexPath.row
                cell?.contentView.addSubview(label)
            }
            cell!.textLabel?.text = cellType.title
            if let category = self.publicInfo?["Category"] as? String {
                let lbl = cell?.viewWithTag(10000 + indexPath.section*10 + indexPath.row) as! UILabel
                lbl.text = category
            }
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
                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "", fontSize: 17,textColor: defaultDetailTextColor)
                label.textAlignment = .Right
                label.tag = 10000 + indexPath.section*10 + indexPath.row
                cell?.contentView.addSubview(label)
            }
            cell!.textLabel?.text = cellType.title
            if let body = self.publicInfo?["Body"] as? String {
                let lbl = cell?.viewWithTag(10000 + indexPath.section*10 + indexPath.row) as! UILabel
                lbl.text = body
            }
            return cell!
        case .InvoiceFor :
            let cellId = "InvoiceForCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 0, width: 150, height: 55.5), text: "", fontSize: 17,textColor: defaultDetailTextColor)
                label.textAlignment = .Right
                label.tag = 10000 + indexPath.section*10 + indexPath.row
                cell?.contentView.addSubview(label)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
            }
            cell!.textLabel?.text = cellType.title
            if let body = self.publicInfo?["HeadTitle"] as? String {
                let lbl = cell?.viewWithTag(10000 + indexPath.section*10 + indexPath.row) as! UILabel
                lbl.text = body
            }
            return cell!
        case .UseDiscount :
            let cellId = "UseDiscountCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5)))
                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 32 - 150, y: 0, width: 150, height: 55.5), text: "可使用优惠券：0张", fontSize: 17,textColor: defaultDetailTextColor)
                cell?.contentView.addSubview(label)
            }
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
            if self.publicInfo != nil {
                vc.invoiceFinish = self.publicInfo
            }
            vc.finished = {(dic)->Void in
                self.publicInfo = dic
                self.currentTableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: .None)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .AddressSelect :
            let vc = AddressViewController.CreateFromMainStoryboard() as! AddressViewController
            vc.finished = { (addressId) -> Void in
                ZMDTool.showActivityView(nil)
                QNNetworkTool.selectShoppingAddress(addressId) { (succeed, dictionary, error) -> Void in
                    ZMDTool.hiddenActivityView()
                    if succeed! {
                        self.getTotal()
                        if let message = dictionary?["message"] as? String {
                            ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: message)
                        }
                    } else {
                        ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: nil)
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .UseDiscount:
            let vc = DiscountCardViewController()
            vc.finished = {(couponcode)->Void in
                QNNetworkTool.useDiscountCoupo(couponcode, completion: { (succeed, dictionary, error) -> Void in
                    if !succeed! {
                       ZMDTool.showErrorPromptView(nil, error: error, errorMsg: nil)
                    } else {
                        self.getTotal()
                    }
                })
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
            self.view.endEditing(true)
            var mark = ""
            if self.markTF != nil {
                mark = self.markTF!.text!
            }
            let vc = CashierViewController()
            vc.mark = mark
            self.navigationController?.pushViewController(vc, animated: true)
        }
        ZMDTool.configViewLayerWithSize(confirmBtn, size: 15)
        view.addSubview(confirmBtn)
        let payLbl = ZMDTool.getLabel(CGRect(x: 12, y: 12, width: 200, height: 15), text: "实付：525.0（含运费39.0）", fontSize: 14,textColor: defaultDetailTextColor)
        view.addSubview(payLbl)
        self.payLbl = payLbl
        let jifengLbl = ZMDTool.getLabel(CGRect(x: 12, y: 12 + 15 + 7, width: 200, height: 12), text: "可获得20积分", fontSize: 12,textColor: defaultDetailTextColor)
        view.addSubview(jifengLbl)
    }
    private func dataInit(){
        self.userCenterData = [[.AddressSelect],[.Goods],[.GoodsCount,.Mark], [.Invoice,.InvoiceType,.InvoiceDetail,.InvoiceFor],[.UseDiscount]]
    }
    func getTotal() {
        ZMDTool.showActivityView(nil)
        QNNetworkTool.getOrderTotals { (orderTotal, dictionary, error) -> Void in
            ZMDTool.hiddenActivityView()
            if orderTotal != nil {
                self.total = "\(orderTotal!)"
                self.payLbl.text = "实付：\(self.total)（含运费39.0）"
                self.totalLbl.attributedText = "合计 : \(self.total)".AttributedText("\(self.total)", color: RGB(235,61,61,1.0))
            } else {
                ZMDTool.showErrorPromptView(nil, error: error, errorMsg: nil)
            }
        }
    }
}
