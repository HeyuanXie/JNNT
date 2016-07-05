//
//  MyOrderViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/30.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 订单状态
enum OrderStatu {
    case All                //  全部
    case UnPay              //  待支付
    case UnShipping         //  待发货
    case WaitShipping       //  待收货
    case UnComment          //  待收货
    init() {
        self = UnPay
    }
    init(value : Int) {
        switch value {
        case 0 :
            self = All
        case 1 :
            self = UnPay
        case 2 :
            self = UnShipping
        case 3 :
            self = WaitShipping
        case 4 :
            self = UnComment
        default :
            self = All
        }
    }
    init(OrderStatusId:Int,ShippingStatusId:Int?,PaymentStatusId:Int?) {
        self = UnPay
        if OrderStatusId == 10 {
             self = UnPay
        }
        if OrderStatusId == 20 && (ShippingStatusId ?? 0) == 20 && (PaymentStatusId ?? 0) == 30 {
             self = UnShipping
        }
        if OrderStatusId == 20 && (ShippingStatusId ?? 0) == 30 && (PaymentStatusId ?? 0) == 30 {
             self = WaitShipping
        }
        if OrderStatusId == 20 && (ShippingStatusId ?? 0) == 40 && (PaymentStatusId ?? 0) == 30 {
             self = UnComment
        }
    }
    func url(skip:Int) -> String {
        let tmp = NSMutableString(string: "/Orders?$top=10")
        switch self {
        case .All:
            tmp.appendString("&$filter= CustomerId eq \(g_customerId!)")
        case .UnPay:
            tmp.appendString("&$filter=OrderStatusId eq 10 and CustomerId eq \(g_customerId!)")
        case .UnShipping:
            tmp.appendString("&$filter=OrderStatusId eq 20 and ShippingStatusId eq 20 and PaymentStatusId eq 30 and CustomerId eq \(g_customerId!)")
        case .WaitShipping:
            tmp.appendString("&$filter=OrderStatusId eq 20 and ShippingStatusId eq 30 and PaymentStatusId eq 30 and CustomerId eq \(g_customerId!)")
        case .UnComment:
            tmp.appendString("&$filter=OrderStatusId eq 20 and ShippingStatusId eq 40 and PaymentStatusId eq 30 and CustomerId eq \(g_customerId!)")
        }
        tmp.appendString("&$expand=OrderItems,OrderItems/Product,OrderItems/Product/ProductPictures&$select=OrderTotal,OrderItems/Product/Name,OrderItems/UnitPriceInclTax,OrderItems/UnitPriceExclTax,OrderItems/Quantity,Id,OrderItems/AttributeDescription,OrderItems/Product/ProductPictures/PictureId,OrderStatusId,ShippingStatusId,PaymentStatusId&$skip=\(skip)")
        return tmp as String
    }
}
// 我的订单
class MyOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {
    @IBOutlet weak var currentTableView: UITableView!
    var dataArray = NSMutableArray()
    var currentOrderStatu = OrderStatu.All
    var skip = 0
    var hasNext = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.updateData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let order = self.dataArray[section] as! ZMDOrderDetail
        return 2 + order.OrderItems.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let order = self.dataArray[indexPath.section] as! ZMDOrderDetail

        if indexPath.row == order.OrderItems.count {
            return 56
        } else if indexPath.row == order.OrderItems.count + 1 {
            return 56
        } else {
            return 110
        }
        //        if indexPath.row == 2 {
        //            return 56
        //        } else if indexPath.row == 3 {
        //            return 56
        //        } else if indexPath.row == 4 {
        //            return 42
        //        }
        //        return  indexPath.row == 0 ? 48 : 110
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == self.dataArray.count - 1 && self.hasNext {
            self.skip += 1
            self.updateData()
        }
        let order = self.dataArray[indexPath.section] as! ZMDOrderDetail
        if indexPath.row <  order.OrderItems.count {
            return self.cellForgoods(tableView, cellForRowAtIndexPath: indexPath)
        }
        if indexPath.row == order.OrderItems.count {
            return self.cellForTotal(tableView, cellForRowAtIndexPath: indexPath)
        }
        if indexPath.row == order.OrderItems.count + 1 {
            return self.cellForMenu(tableView, cellForRowAtIndexPath: indexPath)
        }
        if indexPath.row == 0 {
            let cellId = "StoreCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 47.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
        } else if indexPath.row == 2 {
            let cellId = "TotalCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
                cell?.contentView.addSubview(line)
            }
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 55.5), text: "共2件商品,合计:318.0(含运费 : 0.00)", fontSize: 14)
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            
            return cell!
        } else if indexPath.row == 3 {
            let cellId = "MenuCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
                cell?.contentView.addSubview(line)
                
                let titles = ["到期归还","到期续租","评价","订单详情"]
                var i = 0,minX = CGFloat(0)
                for title in titles {
                    let size = title.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 100)
                    let width = size.width + 32 ,height = CGFloat(35)
                    let x = kScreenWidth - 12 - width - minX,y = CGFloat(12)
                    minX = kScreenWidth - x
                    let btn = ZMDTool.getMutilButton(CGRect(x: x, y: y, width: width, height: height), textForNormal: title, fontSize: 14, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                        if titles[sender.tag-1000] == "订单详情" {
                            let vc = MyOrderDetailViewController.CreateFromMainStoryboard() as! MyOrderDetailViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else if titles[sender.tag-1000] == "评价" {
                            let vc = OrderGoodsScoreViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                    btn.tag = 1000+i
                    i++
                    ZMDTool.configViewLayerFrame(btn)
                    ZMDTool.configViewLayer(btn)
                    cell?.contentView.addSubview(btn)
                }
            }
       
            
            return cell!

        } else if indexPath.row == 4 {
            let cellId = "ReturnCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 42), text: "剩余归还时间：47时:56分:10秒", fontSize: 14,textColor:RGB(235,61,61,1.0))
            label.textAlignment = .Right
            cell?.contentView.addSubview(label)
            return cell!
        } else {
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        let menuTitle = ["全部","待付款","待发货","待收货","待评价"]
        let customJumpBtns = CustomJumpBtns(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 55),menuTitle: menuTitle)
        customJumpBtns.finished = {(index)->Void in
            self.dataArray.removeAllObjects()
            self.currentTableView.reloadData()
            let orderStatus = OrderStatu(value: index)
            self.currentOrderStatu = orderStatus
            self.skip = 0
            self.hasNext = true
            self.updateData()
        }
        self.view.addSubview(customJumpBtns)
    }
    func updateData() {
        ZMDTool.showActivityView(nil)
        QNNetworkTool.fetchOrder(self.currentOrderStatu.url(self.skip*10)) { (value, error) -> Void in
            ZMDTool.hiddenActivityView()
            self.hasNext = false
            if value != nil && value?.count != 0 {
                let orders = ZMDOrderDetail.mj_objectArrayWithKeyValuesArray(value)
                if orders.count == 10 {
                    self.hasNext = true
                }
                self.dataArray.addObjectsFromArray(orders as [AnyObject])
            }
            self.currentTableView.reloadData()
        }
    }
    func cellForgoods(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "GoodsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
        let order = self.dataArray[indexPath.section] as! ZMDOrderDetail
        let orderItem = order.OrderItems[indexPath.row]
        cell.configCellForMyOrder(orderItem)
        return cell
    }
    func cellForTotal(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "TotalCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            
            let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 0, width: kScreenWidth - 24, height: 55.5), text: "共\(self.dataArray.count)件商品,合计:0.0", fontSize: 14) // (含运费 : 0.00)
            label.textAlignment = .Right
            label.tag = 10001
            cell?.contentView.addSubview(label)
        }
        let order = self.dataArray[indexPath.section] as! ZMDOrderDetail
        let lbl = cell?.viewWithTag(10001) as! UILabel
        lbl.text = "共\(order.OrderItems.count)件商品,合计:\(order.OrderTotal)"
        return cell!
    }
    func cellForMenu(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "MenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            ZMDTool.configTableViewCellDefault(cell!)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 55.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            
            let titles = ["取消订单","订单详情","",""]
            var i = 0,minX = CGFloat(0)
            for title in titles {
                let size = title.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 100)
                let width = size.width + 32 ,height = CGFloat(35)
                let x = kScreenWidth - 12 - width - minX,y = CGFloat(12)
                minX = kScreenWidth - x
                let btn = ZMDTool.getMutilButton(CGRect(x: x, y: y, width: width, height: height), textForNormal: title, fontSize: 14, backgroundColor: UIColor.whiteColor(), blockForCli: { (sender) -> Void in
                    //    let vc = OrderGoodsScoreViewController()
                    //    self.navigationController?.pushViewController(vc, animated: true)
                })
                btn.tag = 1000+i
                i++
                ZMDTool.configViewLayerFrame(btn)
                ZMDTool.configViewLayer(btn)
                cell?.contentView.addSubview(btn)
                btn.hidden = true
            }
        }
        let order = self.dataArray[indexPath.section] as! ZMDOrderDetail
        let orderStatusId = order.OrderStatusId.integerValue
        let shippingStatusId = order.ShippingStatusId.integerValue
        let paymentStatusId = order.PaymentStatusId.integerValue

        let orderStatu = OrderStatu(OrderStatusId: orderStatusId, ShippingStatusId: shippingStatusId, PaymentStatusId: paymentStatusId)
        switch orderStatu {
        case .UnPay :
            let titles = ["付款","取消订单","订单详情",""]
            self.doForOrderStatus(cell,titles: titles,order: order)
            break
        case .UnShipping :
            let titles = ["订单详情","","",""]
            self.doForOrderStatus(cell,titles: titles,order: order)
            break
        case .WaitShipping :
            let titles = ["订单详情","","",""]
            self.doForOrderStatus(cell,titles: titles,order: order)
            break
        case .UnComment :
            let titles = ["确认收货","订单详情","",""]
            self.doForOrderStatus(cell,titles: titles,order: order)
            break
        default:
            break
        }
        return cell!
    }
    func doForOrderStatus(cell:UITableViewCell?,titles : [String],order:ZMDOrderDetail) {
        var i = 0,minX = CGFloat(0)
        for title in titles {
            let size = title.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: 100)
            let width = size.width + 32 ,height = CGFloat(35)
            let x = kScreenWidth - 12 - width - minX,y = CGFloat(12)
            minX = kScreenWidth - x
            let btn = cell?.viewWithTag(1000+i) as! UIButton
            btn.setTitle(title, forState: .Normal)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                if titles[sender.tag-1000] == "订单详情" {
                    let vc = MyOrderDetailViewController.CreateFromMainStoryboard() as! MyOrderDetailViewController
                    vc.orderId = order.Id.integerValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if titles[sender.tag-1000] == "取消订单" {
                    let orderId = order.Id.integerValue
                    ZMDTool.showActivityView(nil)
                    QNNetworkTool.cancelOrder(orderId, completion: { (succeed, dictionary, error) -> Void in
                        ZMDTool.hiddenActivityView()
                        if succeed! {
                            
                        }
                    })
                }else if titles[sender.tag-1000] == "确认收货" {
                    let orderId = order.Id.integerValue
                    ZMDTool.showActivityView(nil)
                    QNNetworkTool.completeOrder(orderId, completion: { (succeed, dictionary, error) -> Void in
                        ZMDTool.hiddenActivityView()
                        if succeed! {
                            
                        }
                    })
                }else if titles[sender.tag-1000] == "付款" {
                    let orderId = order.Id.integerValue
                    ZMDTool.showActivityView(nil)
                    QNNetworkTool.fetchPaymentMethod { (paymentMethods, dictionary, error) -> Void in
                        ZMDTool.hiddenActivityView()
                        if paymentMethods != nil {
                            let vc = CashierViewController()
                            vc.total = order.OrderTotal
                            vc.orderId = orderId
                            vc.payMethods = NSMutableArray(array: paymentMethods)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                return RACSignal.empty()
            })
            i++
            btn.hidden = title == "" ? true : false
        }
    }
}
