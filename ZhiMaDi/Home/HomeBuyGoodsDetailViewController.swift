//
//  HomeBuyGoodsDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/25.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//商品详请
class HomeBuyGoodsDetailViewController: UIViewController,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol {
    enum GoodsCellType{
        case HomeContentTypeAd                      /* 广告显示页 */
        case HomeContentTypeDetail                   /* 菜单参数栏目 */
        case HomeContentTypeMenu                    /* 菜单选择栏目 */
        case HomeContentTypeDistribution             /* 商品配送栏目 */
        case HomeContentTypeStore                   /* 店家  */
        case HomeContentTypeRDaPeiGou               /* 推荐商品 */
        case HomeContentTypeNextMenu                /* 下面展示菜单 */
        init(){
            self = HomeContentTypeAd
        }
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    var countForBounghtLbl : UIButton!               // 购买数量Lbl

    var countForBounght = 0                         // 购买数量
    var goodsCellTypes: [GoodsCellType]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.dataInit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.setupNewNavigation()
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
        let cellType = self.goodsCellTypes[section]
        switch cellType {
        case .HomeContentTypeAd :
            return 1
        case .HomeContentTypeMenu :
            return 3
        default :
            return 1
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.goodsCellTypes.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellType = self.goodsCellTypes[section]
        switch cellType {
        case .HomeContentTypeAd :
            return 0
        
        default :
            return 16
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellType = self.goodsCellTypes[indexPath.section]
        switch cellType {
        case .HomeContentTypeAd :
            return kScreenWidth
        case .HomeContentTypeDetail :
            return 156
        case .HomeContentTypeMenu :
            return 60
        case .HomeContentTypeDistribution :
            return 106
        case .HomeContentTypeStore :
            return 120
        default :
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = self.goodsCellTypes[indexPath.section]
        switch cellType {
        case .HomeContentTypeAd :
            return cellForHomeAd(tableView, indexPath: indexPath)
        case .HomeContentTypeDetail :
            return cellForHomeDetail(tableView, indexPath: indexPath)
        case .HomeContentTypeMenu :
            return cellForHomeMenu(tableView, indexPath: indexPath)
        case .HomeContentTypeDistribution :
                return cellForHomeDistribution(tableView, indexPath: indexPath)
        case .HomeContentTypeStore :
            return cellForHomeStore(tableView, indexPath: indexPath)
        default :
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    //MARK: -  PrivateMethod
    //MARK: 广告 cell
    func cellForHomeAd(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "productImgCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth))
            cycleScroll.backgroundColor = UIColor.blueColor()
            let image = ["product_pic","product_pic"]
            cycleScroll.imgArray = image
            //            cycleScroll.delegate = self
            cycleScroll.autoScroll = true
            cycleScroll.autoTime = 2.5
            cell?.addSubview(cycleScroll)
        }
        return cell!
    }
    //MARK: 商品详请 cell
    func cellForHomeDetail(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "detailCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    //MARK: 商品购买选项 cell
    func cellForHomeMenu(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        if indexPath.row == 2 {
            let cellId = "menuCountCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = UIColor.whiteColor()
            }
            let label = UILabel(frame: CGRect(x: 12, y: 0, width: 200, height: 60))
            label.text = "购买数量（库存量: 15）"
            label.textColor = defaultTextColor
            label.font = defaultSysFontWithSize(17)
            cell?.contentView.addSubview(label)
            
            let viewBg = UIView(frame: CGRect(x: kScreenWidth - 12 - 120, y: 10, width: 120, height: 40))
            ZMDTool.configViewLayerFrame(viewBg)
            cell?.contentView.addSubview(viewBg)
            var titles = ["-","0","+"],i=0
            for title in titles {
                let btn = UIButton(frame: CGRect(x: 40*i, y: 0, width: 40, height: 40))
                if title == "0" {
                    self.countForBounghtLbl = btn
                }
                btn.titleLabel?.font = defaultSysFontWithSize(15)
                btn.setTitle(title, forState: .Normal)
                btn.setTitleColor(defaultTextColor, forState: .Normal)
                btn.tag = 1000+i
                viewBg.addSubview(btn)
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    if (btn.tag - 1000) == 0 && self.countForBounght != 0 {
                        self.countForBounght--
                    } else if (btn.tag - 1000) == 2 {
                        self.countForBounght++
                    }
                    self.countForBounghtLbl.setTitle("\(self.countForBounght)", forState: .Normal)
                })
                i++
            }
            return cell!
        } else {
            let cellId = "menuOtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
                cell!.selectionStyle = .None
                cell!.contentView.backgroundColor = UIColor.whiteColor()
                
                let label = UILabel(frame: CGRect(x: 12, y: 0, width: 200, height: 60))
                label.text = "规格"
                label.textColor = defaultTextColor
                label.font = defaultSysFontWithSize(16)
                cell?.contentView.addSubview(label)
                
                let size = "配送".sizeWithFont(label.font, maxWidth: 100)
                let sizeTmp = "90cm*190cm".sizeWithFont(label.font, maxWidth: 100)
                let btn = UIButton(frame: CGRect(x: 12 + size.width + 12 , y: 0, width: sizeTmp.width + 30, height: 60))
                btn.titleLabel?.font = defaultSysFontWithSize(16)
                btn.titleLabel?.textAlignment = .Center
                btn.setTitle(title, forState: .Normal)
                btn.setTitleColor(defaultTextColor, forState: .Normal)
                btn.tag = 10001
                cell?.contentView.addSubview(btn)
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                })
                btn.setTitle("90cm*190cm", forState: .Normal)
            }
            return cell!
        }
    }
    //MARK: 配送 cell HomeContentTypeDistribution
    func cellForHomeDistribution(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "DistributionCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        let label = UILabel(frame: CGRect(x: 12, y: 24, width: 200, height: 17))
        label.text = "配送"
        label.textColor = defaultTextColor
        label.font = defaultSysFontWithSize(17)
        cell?.contentView.addSubview(label)
        let size = "配送".sizeWithFont(label.font, maxWidth: 100)
        let detailLbl = UILabel(frame: CGRect(x: 12 + size.width + 20, y: 24, width: kScreenWidth - (12 + size.width + 20) - 20 , height: 40))
        detailLbl.numberOfLines = 2
        detailLbl.text = "此商品由芝麻地发货"
        detailLbl.textColor = defaultTextColor
        detailLbl.font = defaultSysFontWithSize(17)
        cell?.contentView.addSubview(detailLbl)
        return cell!
    }
    //MARK: 店家 cell
    func cellForHomeStore(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "storeCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    func createFilterMenu() -> UIView{
        let titles = ["交付标准","农场情况","交易记录"]
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 52))
        for var i=0;i<3;i++ {
            let index = i%4
            let btn = UIButton(frame:  CGRectMake(CGFloat(index) * kScreenWidth/3 , 0, kScreenWidth/3, 52))
            btn.backgroundColor = UIColor.clearColor()
            btn.setTitle(titles[i], forState: .Normal)
            btn.setTitle(titles[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(18)
            view.addSubview(btn)
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            })
        }
        let lineView = UIView(frame: CGRectMake(0 , 50, kScreenWidth/3, 2))
        view.addSubview(lineView)
        return view
    }
    func setupNewNavigation() {
    }
    
    private func dataInit(){
        self.goodsCellTypes = [.HomeContentTypeAd,.HomeContentTypeDetail,.HomeContentTypeMenu,.HomeContentTypeDistribution,.HomeContentTypeStore,.HomeContentTypeRDaPeiGou, .HomeContentTypeNextMenu]
    }
    func updateUI() {
    }

}
