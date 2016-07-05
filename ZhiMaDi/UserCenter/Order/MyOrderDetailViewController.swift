//
//  OrderDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/30.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 我的订单详请
class MyOrderDetailViewController: UIViewController,ZMDInterceptorProtocol {
    
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
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    var userCenterData: [[UserCenterCellType]]!
    var orderId = 0
    var address : ZMDAddress!
    var products = NSMutableArray()
    var dic : NSDictionary!

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
            return self.products.count
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
        if self.userCenterData[indexPath.section][0] == .Goods {
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            let product = self.products[indexPath.row] as! ZMDProductForOrderDetail
            cell.configCellForOrderDetail(product)
            return cell
        }
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
                
                let numLbl = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: 240, height: 54), text: "订单编号 ： 1524235232342", fontSize: 17)
                numLbl.tag = 10001
                cell?.contentView.addSubview(numLbl)
                let typeLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth  - 92, y: 0, width: 80, height: 54), text: "等待收货", fontSize: 17,textColor: RGB(235,61,61,1.0),textAlignment:.Right)
                typeLbl.tag = 10002
                cell?.contentView.addSubview(typeLbl)
                
                let line = ZMDTool.getLine(CGRect(x: 0, y: 53.5, width: kScreenWidth, height: 0.5))
                cell?.contentView.addSubview(line)
            }
            let numLbl = cell?.viewWithTag(10001) as! UILabel
            let typeLbl = cell?.viewWithTag(10002) as! UILabel
            if let orderNumber = self.dic?["OrderNumber"] as? String {
                numLbl.text = "订单编号 ：\(orderNumber)"
            }
            if let orderStatus = self.dic?["OrderStatus"] as? String {
                typeLbl.text = orderStatus
            }
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
                
                var tag = 10001
                let userLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 300, height: 17), text: "", fontSize: 17)
                userLbl.tag = tag++
                cell?.contentView.addSubview(userLbl)
                let phoneLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 120, y: 16, width: 300, height: 17), text: "", fontSize: 17)
                phoneLbl.tag = tag++
                cell?.contentView.addSubview(phoneLbl)
                let addressStr = ""
                let addressSize = addressStr.sizeWithFont(defaultSysFontWithSize(17), maxWidth: kScreenWidth - 24)
                let addressLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: addressSize.height), text: addressStr, fontSize: 17)
                addressLbl.numberOfLines = 2
                addressLbl.tag = tag++
                cell?.contentView.addSubview(addressLbl)
            }
            var tag = 10001
            let userLbl = cell?.viewWithTag(tag++) as! UILabel
            let phoneLbl = cell?.viewWithTag(tag++) as! UILabel
            let addressLbl = cell?.viewWithTag(tag++) as! UILabel

            if let dicForAddress = self.dic?["ShippingAddress"] as? NSDictionary,address = ZMDAddress.mj_objectWithKeyValues(dicForAddress) {
                userLbl.text = "收货人 ：\(address.FirstName)"
                phoneLbl.text = "\(address.PhoneNumber)"
                addressLbl.text = "收货地址:\(address.Address1!)\(address.Address2!)"
                let addressStr = addressLbl.text
                let addressSize = addressStr!.sizeWithFont(defaultSysFontWithSize(17), maxWidth: kScreenWidth - 24)
                addressLbl.frame = CGRect(x: 12, y: 16 + 17 + 15, width: kScreenWidth - 24, height: addressSize.height)
            }
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
            let product = self.products[indexPath.row] as! ZMDProductForOrderDetail
            cell.configCellForOrderDetail(product)
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
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let contactBtn = ZMDTool.getButton(CGRect(x: kScreenWidth/2-14-130 , y: 12, width: 130, height: 40), textForNormal: "联系商家", fontSize: 16, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                
            })
            ZMDTool.configViewLayerFrameWithColor(contactBtn, color: defaultTextColor)
            ZMDTool.configViewLayer(contactBtn)
            contactBtn.setImage(UIImage(named: "product_chat"), forState: .Normal)
            cell?.contentView.addSubview(contactBtn)
            let fefundBtn = ZMDTool.getButton(CGRect(x: kScreenWidth/2+14 , y: 12, width: 130, height: 40), textForNormal: "退款/售后", fontSize: 16, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                let vc = AfterSalesHomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            ZMDTool.configViewLayerFrameWithColor(fefundBtn, color: defaultTextColor)
            ZMDTool.configViewLayer(fefundBtn)
            fefundBtn.setImage(UIImage(named: "pay_shouhou"), forState: .Normal)
            cell?.contentView.addSubview(fefundBtn)
            return cell!
        case .Total :
            let cellId = "TotalCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                var tag = 10001
                let leftLbl = ZMDTool.getLabel(CGRect(x: 12, y: 16, width: 100, height: 17), text: "共一件商品", fontSize: 17)
                leftLbl.tag = tag++
                cell?.contentView.addSubview(leftLbl)
                let payLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 200, y: 20, width: 200, height: 17), text: "实付：525.0", fontSize: 17)
                payLbl.textAlignment = .Right
                payLbl.tag = tag++
                cell?.contentView.addSubview(payLbl)
                let monnyLbl = ZMDTool.getLabel(CGRect(x: 12, y: 20 + 17 + 10, width: kScreenWidth - 24, height: 15), text: "(含运费80.0)", fontSize: 15,textColor: defaultDetailTextColor)
                monnyLbl.textAlignment = .Right
                monnyLbl.tag = tag++
                cell?.contentView.addSubview(monnyLbl)
            }
            var tag = 10001
            let leftLbl = cell?.viewWithTag(tag++) as! UILabel
            let payLbl = cell?.viewWithTag(tag++) as! UILabel
            let monnyLbl = cell?.viewWithTag(tag++) as! UILabel
            leftLbl.text = "共\(self.products.count)件商品"
            if let total = self.dic?["OrderTotal"] as? String {
                payLbl.text = "实付：\(total)"
            }
            monnyLbl.text = "(含运费0.0)"
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
                let lbl = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38, 0,100, 56))
                lbl.tag = 10001
                lbl.font = UIFont.systemFontOfSize(17)
                lbl.textAlignment = NSTextAlignment.Right
                lbl.textColor = defaultDetailTextColor
                cell!.contentView.addSubview(lbl)
            }
            cell!.textLabel?.text = cellType.title
            let lbl = cell?.viewWithTag(10001) as! UILabel
            if cellType == .Pay {
                if let paymentMethod = self.dic?["PaymentMethod"] as? String {
                    lbl.text = paymentMethod
                }
            }

            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.userCenterData[indexPath.section][0] == .Goods {
            return
        }
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
    func fetchData() {
        QNNetworkTool.orderDetail(self.orderId) { (succeed, dictionary, error) -> Void in
            if succeed!  {
                if let dicForAddress = dictionary!["ShippingAddress"] as? NSDictionary,address = ZMDAddress.mj_objectWithKeyValues(dicForAddress) {
                    self.address = address
                }
                if let items = dictionary!["Items"] as? NSArray,products = ZMDProductForOrderDetail.mj_objectArrayWithKeyValuesArray(items) {
                    self.products.addObjectsFromArray(products as [AnyObject])
                }
                self.dic = dictionary
                self.currentTableView.reloadData()
                self.updateFoot()
            }
        }
    }
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
    func updateFoot() {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight - 64 - 58, width: kScreenWidth, height: 58))
        view.backgroundColor = RGB(247,247,247,1.0)
        let confirmBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 12 - 90, y: 12, width: 90, height: 34), textForNormal: "", fontSize: 15,textColorForNormal:RGB(235,61,61,1.0), backgroundColor: UIColor.whiteColor()) { (sender) -> Void in
            
        }
        ZMDTool.configViewLayerFrameWithColor(confirmBtn, color: RGB(235,61,61,1.0))
        ZMDTool.configViewLayer(confirmBtn)
        view.addSubview(confirmBtn)
        //        let checkBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 12 - 90 - 10 - 90, y: 12, width: 90, height: 34), textForNormal: "查看物流", fontSize: 15,backgroundColor: UIColor.whiteColor()) { (sender) -> Void in
        //
        //        }
        //        ZMDTool.configViewLayerFrameWithColor(checkBtn, color: defaultTextColor)
        //        ZMDTool.configViewLayer(checkBtn)
        //        view.addSubview(checkBtn)
        self.view.addSubview(view)
        var titles = ""
        guard let orderStatusId = self.dic["OrderStatusId"] as? Int else {
            return
        }
        let shippingStatusId = self.dic["ShippingStatusId"] as? Int
        let paymentStatusId = self.dic["PaymentStatusId"] as? Int
        let orderStatu = OrderStatu(OrderStatusId: orderStatusId, ShippingStatusId: shippingStatusId, PaymentStatusId: paymentStatusId)
        switch orderStatu {
        case .UnPay :
            titles = "去付款"
            break
        case .UnShipping :
            titles = ""
            break
        case .WaitShipping :
            titles = ""
            break
        case .UnComment :
            titles = "确认收货"
            break
        default:
            break
        }
        confirmBtn.setTitle(titles, forState: .Normal)
    }
    private func dataInit(){
        self.userCenterData = [[.OrderNum,.AcceptMsg], [.Goods],[.Pay,.Mark,.Invoice],[.Total]]
        self.fetchData()
    }
}
