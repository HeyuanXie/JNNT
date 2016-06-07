//
//  CashierViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/31.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 收银台
class CashierViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {
    var tableView : UITableView!
    let datas = [["余额支付","货到付款"],["支付宝支付","微信"]]
    let images = ["pay_alipay","pay_wechat"]
    var indexTypeRow = 0
    var finished : ((indexType:Int,IndexDetail:Int)->Void)!
    var mark = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收银台"
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.datas.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 12 : 57
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 55 : 70
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 57))
            headView.backgroundColor = UIColor.clearColor()
            let label = ZMDTool.getLabel(CGRect(x: 12, y: 30, width: 150, height: 17), text: "选择其它支付方式", fontSize: 17)
            headView.addSubview(label)
            let paylbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 150, y: 30, width: 150, height: 17), text: "仍需支付：25.0", fontSize: 17,textColor: RGB(235,61,61,1.0))
            paylbl.textAlignment = .Right
            headView.addSubview(paylbl)
            return headView
        }
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 12))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "cell\(indexPath.section)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                let imgV = UIImageView(frame: CGRect(x: kScreenWidth - 12 - 20, y: 17, width: 20, height: 20))
                imgV.tag = 10001
                cell?.contentView.addSubview(imgV)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 54.5, width: kScreenWidth, height: 0.5)))

                let label = ZMDTool.getLabel(CGRect(x: kScreenWidth - 45 - 100, y: 0, width: 100, height: 54), text: "余额：500", fontSize: 15)
                label.textAlignment = .Right
                cell?.contentView.addSubview(label)
            }
            cell?.textLabel?.text = self.datas[indexPath.section][indexPath.row]
            let imgV = cell?.contentView.viewWithTag(10001) as! UIImageView
            imgV.image = self.indexTypeRow == indexPath.row ?  UIImage(named: "common_02selected") : UIImage(named: "common_01unselected")
            
            return cell!
        } else {
            let cellId = "cell\(indexPath.section)\(indexPath.row)"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 69.5, width: kScreenWidth, height: 0.5)))
            }
            cell?.textLabel?.text = self.datas[indexPath.section][indexPath.row]
            cell?.imageView?.image = UIImage(named: self.images[indexPath.row])
            cell?.detailTextLabel!.text = "描述下呗"
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.indexTypeRow = indexPath.row
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            // 支付宝
            ZMDTool.showActivityView(nil)
            QNNetworkTool.confirmOrder(mark, completion: { (succeed, dictionary, error) -> Void in
                ZMDTool.hiddenActivityView()
                if succeed! {
                } else {
                    ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: nil)
                }
            })
        }
        self.tableView.reloadData()
    }
    func updateUI() {
        tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = tableViewdefaultBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView)
        let footV = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 36+50))
        footV.backgroundColor = UIColor.clearColor()
        let btn = ZMDTool.getButton(CGRect(x: 12, y: 36, width: kScreenWidth - 24, height: 50), textForNormal: "确认支付", fontSize: 20, textColorForNormal:UIColor.whiteColor(),backgroundColor: UIColor.redColor()) { (sender) -> Void in
            self.submitAliOrder(NSDictionary())
        }
        ZMDTool.configViewLayer(btn)
        footV.addSubview(btn)
        tableView.tableFooterView = footV
    }
    //支付宝支付
    private func aliPayCheck(){
        //self.order!.orderNo
        QNNetworkTool.alipayOrderCheck("orderId", completion: { (dictionary, error, errorMsg) -> Void in
            if dictionary != nil {
                self.submitAliOrder(dictionary!)
            }else {
                ZMDTool.showPromptView( errorMsg!)
            }
        })
    }
    private func submitAliOrder(dic: NSDictionary){
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        let appScheme: String = "alisdkforHLB"
        let orderString = "_input_charset=\"utf-8\"&body=\"支付葫芦堡订单：0615100039\"&notify_url=\"http://localhost:2726/Plugins/AliPay/AppNotify\"&out_trade_no=\"39\"&partner=\"2088411055133951\"&payment_type=\"1\"&seller_id=\"2088411055133951\"&service=\"mobile.securitypay.pay\"&subject=\"葫芦堡订单：0615100039\"&total_fee=\"0.01\"&sign=\"RNoYCPH%2fSpp%2fxWQnmhd8kkKmobosYtzzwuYyn3jJQJHZg8GN4qKmghfdMM38roe014WjSuKimF7%2fwUukQgq%2b2vsMrTw0HrkH%2b2V6ksM%2bz5KzZBzToOzv%2fL79DdfKVt4327s89%2fMM8ypbD9t6dcFYDn6o1floUJMFo6RStPp6rdQ%3d\"&sign_type=\"RSA\""
        //dic["payInfo"] as! String
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) -> Void in
            if let Alipayjson = resultDic as? NSDictionary {
                let resultStatus = Alipayjson.valueForKey("resultStatus") as! String
                if resultStatus == "9000"{
                    let vc = OrderPaySucceedViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
//                    ZMDTool.showPromptView( "支付成功")
                }else if resultStatus == "8000" {
                    ZMDTool.showPromptView( "正在处理中")
                }else if resultStatus == "4000" {
                    ZMDTool.showPromptView( "订单支付失败")
                }else if resultStatus == "6001" {
                    ZMDTool.showPromptView( "用户中途取消")
                }else if resultStatus == "6002" {
                    ZMDTool.showPromptView( "网络连接出错")
                }
            }
        })
    }
}
