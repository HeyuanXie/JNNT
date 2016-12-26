//
//  StoreShowGoodsSortViewController.swift
//  ZhiMaDi
//
//  Created by admin on 16/10/20.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 商品分类
//TableView
class SortViewController2: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol {
    var currentTableView: UITableView!
    
    //    let dataArray = [["全部商品"],["租赁商品"],["床上用品","家具","日用品"]]
    //    let dataArray = [["所有商品"],["农药","化肥","种子"]]
    //    let dataArray2 = ["所有商品","农药","化肥","种子"]
    //    let itemes = [["杀虫剂","杀虫剂","杀虫剂","杀虫剂","杀虫剂","杀虫剂杀虫剂"],["尿素","尿素","尿素","尿素","氯化铵","氯化钾"],["小麦种子","小麦种子","小麦种子","小麦种子","小麦种子","小麦种子"]]
    var categories = NSMutableArray()          //从店铺页面传递过来的所有的分类
    var dataArray1 = NSMutableArray()  //大分类的数组     ["全部商品",""]
    var dataArray2 = NSMutableArray()  //小分类的二维数组
    var dataArray3 = NSMutableArray()   //大分类的Id
    
    var dataArray = NSMutableArray()
    
    var storeId : Int!
    var isTabBar = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategories()
        self.subViewInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return 2
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count + 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 16
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else if indexPath.row == 0 {
            return 40
        } else {
            var x = CGFloat(12)
            var y = 30
            let categories = (self.dataArray[indexPath.section-1] as! ZMDSortCategory).SubCategories
            for item in categories {
                let item = item.Name
                let sizeTmp = item!.sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 120) //名宽度
                let xTmp = x + sizeTmp.width + 20
                if xTmp > kScreenWidth {
                    y += 30
                    x = 12 + sizeTmp.width + 20
                } else {
                    x = x + sizeTmp.width + 20
                }
            }
            return  CGFloat(y)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = tableViewdefaultBackgroundColor
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cellId = "allCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell?.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel?.text = "所有商品"
            return cell!
        } else {
            if indexPath.row == 0 {
                let cellId = "headCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell?.selectionStyle = .None
                    
                    let cellHeight = 40
                    let text = (self.dataArray[indexPath.section-1] as! ZMDSortCategory).Name
                    let size = "食品/饮料".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: CGFloat(200))
                    let leftBtn = UIButton(frame: CGRect(x: MarginLeft, y: cellHeight/4, width: Int(size.width)+10, height: cellHeight/2))
                    leftBtn.backgroundColor = UIColor(red: 62/255, green: 182/255, blue: 35/255, alpha: 1.0)
                    leftBtn.setTitle(text, forState: .Normal)
                    leftBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
                    leftBtn.userInteractionEnabled = false
                    ZMDTool.configViewLayerWithSize(leftBtn, size: 10)
                    
                    let rightBtn = UIButton(frame: CGRect(x: CGFloat(kScreenWidth) - 70, y: CGFloat(cellHeight/4), width: 40, height: CGFloat(cellHeight/2)))
                    rightBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                        //点击 “农产品、农用物资”等通过 Cid请求数据
                        let vc = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                        vc.titleForFilter = text
                        vc.As = "true"
                        vc.Cid = "\((self.dataArray[indexPath.section-1] as! ZMDSortCategory).Id)"
                        vc.titleForFilter = (self.dataArray[indexPath.section-1] as! ZMDSortCategory).Name
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController( vc, animated: true)
                        return RACSignal.empty()
                    })
                    rightBtn.backgroundColor = UIColor.clearColor()
                    rightBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                    rightBtn.setTitle("全部", forState: .Normal)
                    rightBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
                    cell?.contentView.addSubview(leftBtn)
                    cell?.contentView.addSubview(rightBtn)
                }
                return cell!
            }
            
            let cellId = "btnsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell?.selectionStyle = .None
                
                let getBtn = { (text : String,index : Int) -> UIButton in
                    let btn = UIButton(frame: CGRect.zero)
                    btn.setTitle(text, forState: .Normal)
                    btn.setTitleColor(defaultTextColor, forState: .Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(15)
                    btn.backgroundColor = UIColor.clearColor()
                    
                    btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                        //得到btn上的标题，通过标题进入对应的HomeBuyListViewController更新UI
                        let subCategory = (self.dataArray[indexPath.section-1] as! ZMDSortCategory).SubCategories[index]
                        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                        homeBuyListViewController.As = "true"
                        homeBuyListViewController.Cid = "\(subCategory.Id)"
                        homeBuyListViewController.titleForFilter = subCategory.Name
                        homeBuyListViewController.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
                    })
                    return btn
                }
                var x = CGFloat(12)
                var y = 2
                var index = 0
                let categories = (self.dataArray[indexPath.section-1] as! ZMDSortCategory).SubCategories
                for item in categories {
                    let item = item.Name
                    let sizeTmp = item!.sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100) //名宽度
                    //xTmp用于判断当前btn是否跑出屏幕外
                    let xTmp = x + sizeTmp.width + 20   //sizeTmp.width为btn.width
                    let btn = getBtn(item!,index)
                    btn.tag = index++
                    if xTmp < kScreenWidth {
                        btn.frame = CGRectMake(x, CGFloat(y),sizeTmp.width + 20, 26)
                        cell?.contentView.addSubview(btn)
                        x = x + sizeTmp.width + 20
                    } else {
                        y += 30
                        x = 12 + sizeTmp.width + 20
                        btn.frame = CGRectMake(12, CGFloat(y),sizeTmp.width + 20, 26)
                        cell?.contentView.addSubview(btn)
                    }
                    //当btn加到cell.contentView上后，根据btn来加上分割线
                    let lineLbl = UILabel(frame: CGRect(x: btn.frame.width-1, y: (btn.frame.height-15)/2, width: 1, height: 15))
                    lineLbl.backgroundColor = defaultLineColor
                    btn.addSubview(lineLbl)
                    
                    cell?.addLine()
                }
            }
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
            homeBuyListViewController.titleForFilter = ""
            homeBuyListViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
        }else if indexPath.row == 0 {
            let sortCategory = self.dataArray[indexPath.section-1] as! ZMDSortCategory
            let vc = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
            vc.titleForFilter = sortCategory.Name
            vc.As = "true"
            vc.Cid = "\(sortCategory.Id.integerValue)"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController( vc, animated: true)
        }
    }
    
    //MARK:getCategories
    func getCategories() {
        ZMDTool.showActivityView(nil)
        QNNetworkTool.sortCategories({ (categories, error, dictionary) -> Void in
            ZMDTool.hiddenActivityView()
            if let categories = categories {
                self.dataArray.addObjectsFromArray(categories as [AnyObject])
                self.currentTableView.reloadData()
            }
        })
    }
    
    
    //MARK: dataINit()
    func dataInit() {
        var text = ""
        for item in self.categories {
            let storeCategory = item as! ZMDStoreCategory
            let array = storeCategory.Text.componentsSeparatedByString(" > ")
            if text != array[0]{
                self.dataArray1.addObject(array[0])
                self.dataArray3.addObject(storeCategory.Value)
                self.dataArray2.addObject(NSMutableArray())
                text = array[0]
            }
        }
        for item in self.categories {
            let category = item as! ZMDStoreCategory
            let cid = category.Value
            let array = category.Text.componentsSeparatedByString(" > ")
            var count = 0
            for str in self.dataArray1 {
                if str as! String == array[0] && array.count != 1 && array.count != 3 {
                    (self.dataArray2[count] as! NSMutableArray).addObject(category/*array.last!*/)
                    break
                }
                count++
            }
        }
        self.dataArray2.removeObjectAtIndex(0)
        var index = 0
        for arr in self.dataArray2 {
            if (arr as! NSArray).count == 0 {
                let category = ZMDStoreCategory()
                category.Text = self.dataArray1[index+1] as! String
                category.Value = self.dataArray3[index+1] as! String
                arr.addObject(category)
            }
            index++
        }
    }
    
    //MARK: -  PrivateMethod
    private func subViewInit(){
        self.title = "商品分类"
        let height = self.isTabBar ? self.view.bounds.height-64-49 : self.view.bounds.height-64
        self.currentTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height), style: .Plain)
        self.currentTableView.backgroundColor = UIColor.whiteColor() //tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
    
    //MARK: gotoMore
    override func gotoMore() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
