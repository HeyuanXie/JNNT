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
    @IBOutlet weak var allSelectBtn: UIButton!
    var productAttrV : ZMDProductAttrView!
    var dataArray = NSArray()
    var hideStore = true
    var attrSelects = NSMutableArray()
    var scis = NSMutableArray()             // 选中的购物单
    var countForBounght = 0                 // 购买数量
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        ZMDTool.configViewLayerWithSize(settlementBtn,size: 16)
        let rightBtn = ZMDTool.getButton(CGRect(x: 0, y: 0, width: 62, height: 44), textForNormal: "删除", fontSize: 16,backgroundColor: UIColor.clearColor(), blockForCom: nil)
        rightBtn.setImage(UIImage(named: "common_delete"), forState: .Normal)
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        rightBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            if self.scis.count != 0 {
                self.deleteCartItem()
            }
            return RACSignal.empty()
        })
        let item = UIBarButtonItem(customView: rightBtn)
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
            cell.configCell(item,scis:self.scis)
            cell.editFinish = { (productDetail,SciId) -> Void in
                self.attrSelects.removeAllObjects()
                for var i = 0;i<productDetail.ProductVariantAttributes!.count;i++ {
                    self.attrSelects.addObject(";")
                }
                self.editViewShow(productDetail,SciId: SciId)
            }
            cell.selectFinish = { (Sci,isAdd) -> Void in
                if isAdd {
                    self.scis.addObject(Sci)
                } else {
                    self.scis.removeAllObjects()
                }
            }
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dataArray[indexPath.section] as! ZMDShoppingItem
        let vc = HomeBuyGoodsDetailViewController.CreateFromMainStoryboard() as! HomeBuyGoodsDetailViewController
        vc.hidesBottomBarWhenPushed = true
        vc.productId = item.ProductId.integerValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -Action
    //全选
    @IBAction func selectAllBtnCli(sender: UIButton) {
        self.allSelectBtn.selected = !self.allSelectBtn.selected
        if self.allSelectBtn.selected {
            for item in self.dataArray {
                self.scis.addObject(item)
            }
        } else {
             self.scis.removeAllObjects()
        }
        self.currentTableView.reloadData()
    }
    // 结算
    @IBAction func settlementBtnCli(sender: UIButton) {
        QNNetworkTool.selectCart(self.getSciids(),completion: { (succeed, dictionary, error) -> Void in
            if succeed! {
                let vc = ConfirmOrderViewController.CreateFromMainStoryboard() as! ConfirmOrderViewController
                vc.hidesBottomBarWhenPushed = true
                vc.scis = self.scis
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: nil)
            }
        })
    }
    //MARK: -  PrivateMethod
    func editViewShow(productDetail:ZMDProductDetail,SciId:Int) {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.whiteColor()
        // top
        let countLbl = UILabel(frame: CGRect(x: 12, y: 0, width: 200, height: 60))
        let kucunText = "（库存量: 15）"
        let countText = "购买数量\(kucunText)"
        countLbl.attributedText = countText.AttributedMutableText(["购买数量",countText], colors: [defaultTextColor,defaultDetailTextColor])
        countLbl.font = defaultSysFontWithSize(16)
        view.addSubview(countLbl)
        
        let countView = CountView(frame: CGRect(x: kScreenWidth - 12 - 120, y: 10, width: 120, height: 40))
        countView.finished = {(count)->Void in
            self.countForBounght = count
        }
        view.addSubview(countView)
       
        productAttrV = ZMDProductAttrView(frame: CGRect.zero, productDetail: productDetail)
        productAttrV.SciId = SciId
        productAttrV.frame = CGRectMake(0, 60,kScreenWidth, productAttrV.getHeight())
        view.addSubview(productAttrV)
        // bottom
        let okBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 14 - 110, y:CGRectGetMaxY(productAttrV.frame)+12, width: 110, height: 36), textForNormal: "确定", fontSize: 17,textColorForNormal: UIColor.whiteColor(), backgroundColor: RGB(235,61,61,1.0)) { (sender) -> Void in
            self.editCart()
            self.dismissPopupView(view)
        }
        ZMDTool.configViewLayerWithSize(okBtn, size: 18)
        view.addSubview(okBtn)
        let cancelBtn = ZMDTool.getButton(CGRect(x: kScreenWidth - 14 - 110 - 8 - 80, y: CGRectGetMaxY(productAttrV.frame)+12, width: 80, height: 36), textForNormal: "取消", fontSize: 17, backgroundColor: UIColor.clearColor()) { (sender) -> Void in
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
        view.frame = CGRect(x: 0, y: self.view.bounds.height - (CGRectGetMaxY(productAttrV.frame) + 60), width: kScreenWidth, height: CGRectGetMaxY(productAttrV.frame) + 60)
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
    func editCart() {
        let dic = self.productAttrV.getPostData(self.countForBounght)
        if dic == nil {
            return
        }
        if g_isLogin! {
            QNNetworkTool.editCartItemAttribute(dic!, completion: { (succeed, dictionary, error) -> Void in
                if succeed! {
                    self.dataUpdate()
                } else {
                    ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: "修改失败")
                }
            })
        }
    }
    func getSciids()  -> String {
        let items = NSMutableString()
        var index = -1
        for tmp in self.scis {
            index++
            let sciId = (tmp as! ZMDShoppingItem).Id
            let scid = index == self.scis.count - 1 ? "\(sciId)" : "\(sciId),"
            items.appendString(scid)
        }
        return items as String
    }
    func deleteCartItem() {
        let items = self.getSciids()
        if g_isLogin! {
            QNNetworkTool.deleteCartItem(items,completion: { (succeed, dictionary, error) -> Void in
                if succeed! {
                    self.scis.removeAllObjects()
                    self.allSelectBtn.selected = false
                    self.dataUpdate()
                } else {
                    ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: "删除失败")
                }
            })
        }
    }
}
