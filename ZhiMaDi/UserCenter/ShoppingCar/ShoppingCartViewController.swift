//
//  ShoppingCartViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 购物车
class ShoppingCartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var settlementBtn: UIButton!

    var dataArray = NSArray()
    var hideStore = true
    var attrSelects = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        ZMDTool.configViewLayerWithSize(settlementBtn,size: 16)
        let rightBtn = ZMDTool.getButton(CGRect(x: 0, y: 0, width: 62, height: 44), textForNormal: "删除", fontSize: 16,backgroundColor: UIColor.clearColor(), blockForCom: nil)
        rightBtn.setImage(UIImage(named: "common_delete"), forState: .Normal)
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        let item = UIBarButtonItem(customView: rightBtn)
        item.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            
            return RACSignal.empty()
        })
        item.customView?.tintColor = defaultDetailTextColor
        self.navigationItem.rightBarButtonItem = item
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.dataUpdate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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

        return 110//indexPath.row == 0 ? 48 : 110
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !hideStore/*indexPath.row == 0*/ {
            let cellId = "StoreCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            let line = ZMDTool.getLine(CGRect(x: 0, y: 47.5, width: kScreenWidth, height: 0.5))
            cell?.contentView.addSubview(line)
            return cell!
        } else {
            let cellId = "GoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! OrderGoodsTableViewCell
            let item = self.dataArray[indexPath.section] as! ZMDShoppingItem
            cell.configCell(item)
            cell.editFinish = { (productDetail) -> Void in
                self.attrSelects.removeAllObjects()
                for var i = 0;i<productDetail.ProductVariantAttributes!.count;i++ {
                    self.attrSelects.addObject(";")
                }
                self.editViewShow(productDetail)
            }
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: -Action
    
    @IBAction func selectAllBtnCli(sender: UIButton) {
    }
    // 结算
    @IBAction func settlementBtnCli(sender: UIButton) {
    }
    //MARK: -  PrivateMethod
    
    func editViewShow(productDetail:ZMDProductDetail) {
        let view = UIView(frame: CGRect(x: 0, y: self.view.bounds.height - 300, width: kScreenWidth, height: 300))
        view.backgroundColor = UIColor.whiteColor()
        // top
        let countLbl = UILabel(frame: CGRect(x: 12, y: 0, width: 200, height: 60))
        let kucunText = "（库存量: 15）"
        let countText = "购买数量\(kucunText)"
        countLbl.attributedText = countText.AttributedMutableText(["购买数量",countText], colors: [defaultTextColor,defaultDetailTextColor])
        countLbl.font = defaultSysFontWithSize(16)
        view.addSubview(countLbl)
        
        let countView = CountView(frame: CGRect(x: kScreenWidth - 12 - 120, y: 10, width: 120, height: 40))
        view.addSubview(countView)
       
        let productAttrV = ZMDProductAttrView(frame: CGRectMake(0, 60,kScreenWidth, 60*3), productDetail: productDetail)
        view.addSubview(productAttrV)
        // bottom
        let okBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 14 - 110, y: 4*60+12, width: 110, height: 36), textForNormal: "确定", fontSize: 17,textColorForNormal: UIColor.whiteColor(), backgroundColor: RGB(235,61,61,1.0)) { (sender) -> Void in
            self.dismissPopupView(view)
        }
        ZMDTool.configViewLayerWithSize(okBtn, size: 18)
        view.addSubview(okBtn)
        let cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 14 - 110 - 8 - 80, y: 4*60+12, width: 80, height: 36), textForNormal: "取消", fontSize: 17, backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            self.dismissPopupView(view)
        }
        view.addSubview(cancelBtn)
        var i = 0
        for _ in ["","","",""] {
            i++
            let line = ZMDTool.getLine(CGRect(x: 0, y: 60*CGFloat(i), width: kScreenWidth, height: 0.5))
            view.addSubview(line)
        }
        self.viewShowWithBg(view,showAnimation: .SlideInFromBottom,dismissAnimation: .SlideOutToBottom)
    }
    
    func nowSelectStr(attrSelects:NSMutableArray) -> String{
        let str = NSMutableString()
        for attrStr in attrSelects {
            if (attrStr as? String) != "" {
                str.appendString(attrStr as! String)
                str.appendString(";")
            }
        }
        return str as String
    }
    func hideIndexs() {
        
    }
    func dataUpdate() {
        QNNetworkTool.fetchShoppingCart { (shoppingItems, dictionary, error) -> Void in
            if shoppingItems != nil {
                self.dataArray = shoppingItems!
                self.currentTableView.reloadData()
            } else {
                ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: nil)
            }
        }
    }

    func viewForMenu(cell:UITableViewCell,indexPath: NSIndexPath) {
//        let attr = productDetail.ProductVariantAttributes![indexPath.row]
//        let size = attr.TextPrompt!.sizeWithFont(defaultSysFontWithSize(16), maxWidth: 100)
//        let label = ZMDTool.getLabel(CGRectMake(0, 0,size.width + 16, 60), text: attr.TextPrompt!, fontSize: 16,textAlignment:.Center)
//        label.tag = 10002
//        cell.contentView.addSubview(label)
//        
//        let valueNames = NSMutableArray()
//        for value in attr.Values! {
//            valueNames.addObject(value.Name!)
//        }
//        let menuTitle = valueNames as! [String]
//        let attrStr = NSMutableString()
//        let multiselectView = ZMDAttrView(frame:CGRect(x: CGRectGetMaxX(label.frame), y: 0, width: kScreenWidth - CGRectGetMaxX(label.frame), height: 60),titles: menuTitle,attrStr: attrStr as String)
//        multiselectView.tag = indexPath.row
//        multiselectView.finished = { (index) ->Void in
//            let tmpForPost = "product_attribute_\(attr.ProductId)_\(attr.BundleItemId)_\(attr.ProductAttributeId)_\(attr.Id):\(attr.Values![index].Id)"
//            let indexT = indexPath.row
//            self.attrSelects.insertObject(tmpForPost, atIndex: indexPath.row)
//        }
//        cell.contentView.addSubview(multiselectView)
    }
}
