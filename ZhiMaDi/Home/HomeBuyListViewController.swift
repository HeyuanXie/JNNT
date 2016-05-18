//
//  HomeBuyListViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/24.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import ReactiveCocoa
//商品列表
class HomeBuyListViewController: UIViewController ,ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{

    enum TypeSetting {
        case Horizontal
        case vertical
    }
    @IBOutlet weak var currentTableView: UITableView!
    var popView : UIView!
    var cityPop : FindDoctorCityPopView!
    
    var isLease = false             //租赁
    var typeSetting = TypeSetting.Horizontal      // 横屏
    var dataArray = NSMutableArray()
    var isStore = false  //商店展示搜索
    var indexSkip = 0
    var IndexFilter = 0
    var isHasNext = true
    let filters = ["","Sold","Price","UpdatedOnUtc",""]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.setupNewNavigation()
        self.updateData(nil, isAsc: nil,indexSkip:nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
        let tmp01 = self.dataArray.count/2
        let tmp02 = self.dataArray.count%2
        return self.typeSetting == .Horizontal ? (tmp01 + tmp02) : self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 52 + 16 : 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.typeSetting == .Horizontal ? 581/750 * kScreenWidth + 10 : 300/750 * kScreenWidth
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.createFilterMenu()
        } else {
            let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
            headView.backgroundColor = UIColor.clearColor()
            return headView
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = self.typeSetting == .Horizontal ? "doubleGoodsCell" : "goodsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! DoubleGoodsTableViewCell
        if self.typeSetting == .Horizontal {
            let productL = self.dataArray[indexPath.section*2] as! ZMDProduct
            cell.leftBtn.superview!.tag = indexPath.section
            cell.leftBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                let product = self.dataArray[sender.superview!!.tag] as! ZMDProduct
                self.pushDetailVc(product)
                return RACSignal.empty()
            })
            if indexPath.section*2+1 <= self.dataArray.count - 1{
                let productR = self.dataArray[indexPath.section+1] as! ZMDProduct
                DoubleGoodsTableViewCell.configCell(cell, product: productR,productR:productR)
                cell.rightBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                    let product = self.dataArray[sender.superview!!.tag+1] as! ZMDProduct
                    self.pushDetailVc(product)
                    return RACSignal.empty()
                })
                self.updateFilter(indexPath.section*2+1)
            } else {
                DoubleGoodsTableViewCell.configCell(cell, product: productL,productR:nil)
            }
        } else {
            let productL = self.dataArray[indexPath.section] as! ZMDProduct
            DoubleGoodsTableViewCell.configCell(cell, product: productL,productR:nil)
            self.updateFilter(indexPath.section)
        }
    
        return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.typeSetting == .vertical {
            var product = self.dataArray[indexPath.section] as! ZMDProduct
            self.pushDetailVc(product)
        }
    }
    func pushDetailVc(product : ZMDProduct) {
        let vc = HomeBuyGoodsDetailViewController.CreateFromMainStoryboard() as! HomeBuyGoodsDetailViewController
        vc.hidesBottomBarWhenPushed = true
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar)  {
        self.view.endEditing(true)
    }
    //MARK: -  PrivateMethod
    func updateFilter(index : Int) {
        if index == self.dataArray.count - 1 && self.isHasNext {
            let filter = self.filters[self.IndexFilter]
            if filter == "" {
                self.updateData(nil, isAsc: nil, indexSkip: self.indexSkip)
            } else {
                self.updateData(filter, isAsc: true, indexSkip: self.indexSkip)
            }
        }
    }
    func createFilterMenu() -> UIView{
        let filterTitles = self.isLease ? ["默认","人气","价格","筛选",""] : ["默认","销量","价格","最新",""]
        let countForBtn = CGFloat(filterTitles.count) - 1
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 52 + 16))
        view.backgroundColor = UIColor.clearColor()
        for var i=0;i<filterTitles.count;i++ {
            let index = i%filterTitles.count
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * (kScreenWidth-54)/countForBtn , 0, (kScreenWidth-54)/countForBtn, 52))
            btn.backgroundColor = UIColor.whiteColor()
            btn.selected = i == self.IndexFilter ? true : false
            if filterTitles[i] == "" {
                btn.frame = CGRectMake(CGFloat(index) * (kScreenWidth-54)/countForBtn, 0, 54, 52)
                btn.setImage(UIImage(named: "list_hengpai"), forState: .Normal)
                btn.setImage(UIImage(named: "list_shupai"), forState: .Selected)
                btn.selected = self.typeSetting == .Horizontal ? false : true
            } else {
                btn.setTitle(filterTitles[i], forState: .Normal)
                btn.setTitle(filterTitles[i], forState: .Normal)
            }
            btn.setTitleColor(defaultTextColor, forState: .Normal)
            btn.setTitleColor(RGB(235,61,61,1.0), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            btn.tag = 1000 + i
            view.addSubview(btn)
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.IndexFilter = sender.tag - 1000
                if (sender.tag - 1000) == filterTitles.count - 1 {
                    self.typeSetting = self.typeSetting == .Horizontal ? .vertical : .Horizontal
                    (sender as! UIButton).selected = !(sender as! UIButton).selected
                    self.currentTableView.reloadData()
                    return
                }
                let title = filterTitles[sender.tag - 1000]
                switch title {
                case "默认" :
                    self.updateData(nil, isAsc: nil,indexSkip:0)
                    break
                case "销量" :
                    self.updateData("Sold", isAsc: true,indexSkip:0)
                    break
                case "价格" :
                    self.updateData("Price", isAsc: true,indexSkip:0)
                case "最新" :
                    self.updateData("UpdatedOnUtc", isAsc: true,indexSkip:0)
                    break
                default :
                    break
                }
                
            })
            let line = ZMDTool.getLine(CGRectMake(CGRectGetMaxX(btn.frame)-1, 20, 1, 13))
            btn.addSubview(line)
        }
        return view
    }
    func setupNewNavigation() {
        if self.isStore {
            let searchView = UIView(frame: CGRectMake(0, 0, kScreenWidth - 120, 44))
            let searchBar = UISearchBar(frame: CGRectMake(0, 4, kScreenWidth - 120, 36))
            searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
            searchBar.placeholder = "搜索商品"
            searchBar.layer.borderColor = UIColor.grayColor().CGColor;
            searchBar.layer.borderWidth = 0.5
            searchBar.layer.cornerRadius = 6
            searchBar.layer.masksToBounds = true
            searchBar.delegate = self
            searchView.addSubview(searchBar)
            self.navigationItem.titleView = searchView
            
            let item = UIBarButtonItem(image: UIImage(named: "common_more")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: self, action: Selector("gotoMore"))
            item.customView?.tintColor = UIColor.blackColor()
            
            self.navigationItem.rightBarButtonItem = item
        } else {
            let rightItem = UIBarButtonItem(image: UIImage(named: "home_search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
            rightItem.tintColor = navigationTextColor
            rightItem.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
                self.navigationController?.popViewControllerAnimated(true)
                return RACSignal.empty()
            })
            rightItem.customView?.tintColor = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }

    func popWindow () {
        self.popView = UIView(frame: CGRectMake(0 , 64+52, kScreenWidth,  self.view.bounds.height - 100))
        self.popView.backgroundColor = UIColor.blueColor()
        self.popView.showAsPopAndhideWhenClickGray()
    }
    
    func updateData(order:String?,isAsc:Bool?,indexSkip:Int?) {
        let skip = indexSkip == nil ? self.indexSkip : indexSkip
        QNNetworkTool.products("\(skip)") { (products, error, dictionary) -> Void in
            if let products = products {
                if skip == 0 {
                    self.dataArray.removeAllObjects()
                }
                self.dataArray.addObjectsFromArray(products as [AnyObject])
                self.indexSkip = indexSkip ?? self.indexSkip + 1
                self.isHasNext = products.count < 20 ? false : true
                self.currentTableView.reloadData()
            } else {
                ZMDTool.showErrorPromptView(nil, error: error)
            }
        }
//        QNNetworkTool.products(skip!, order: order, isAsc: isAsc) { (products, error, dictionary) -> Void in
//            if let products = products {
//                if skip == 0 {
//                    self.dataArray.removeAllObjects()
//                }
//                self.dataArray.addObjectsFromArray(products as [AnyObject])
//                self.indexSkip = indexSkip ?? self.indexSkip + 1
//                self.isHasNext = products.count < 20 ? false : true
//                self.currentTableView.reloadData()
//            } else {
//                ZMDTool.showErrorPromptView(nil, error: error)
//            }
//        }
    }
}
