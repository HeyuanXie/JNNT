//
//  HomeBuyGoodsDetailViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/25.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import TYAttributedLabel
import MJRefresh
//商品详请
class HomeBuyGoodsDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,QNShareViewDelegate {
    enum GoodsCellType{
        case HomeContentTypeAd                      /* 广告显示页 */
        case HomeContentTypeDetail                   /* 菜单参数栏目 */
        case HomeContentTypeMenu                    /* 菜单选择栏目 */
        case HomeContentTypeDistribution             /* 商品配送栏目 */
        case HomeContentTypeStore                   /* 店家  */
        case HomeContentTypeDaPeiGou               /* 搭配购商品 */
        case HomeContentTypeNextMenu                /* 下面展示菜单 */
        init(){
            self = HomeContentTypeAd
        }
    }
    
    @IBOutlet weak var currentTableView: UITableView!
    var secondTableView: UITableView!
    var countForBounghtLbl : UIButton!               // 购买数量Lbl
    @IBOutlet weak var bottomV: UIView!
    
    var countForBounght = 0                         // 购买数量
    var goodsCellTypes: [GoodsCellType]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.updateUI()
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
        if tableView == self.secondTableView {
            return 1
        }
        
        let cellType = self.goodsCellTypes[section]
        switch cellType {
        case .HomeContentTypeAd :
            return 1
        case .HomeContentTypeMenu :
            return 3
        case .HomeContentTypeDaPeiGou :
            return 1
        default :
            return 1
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.secondTableView {
            return 1
        }

        return self.goodsCellTypes.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.secondTableView {
            return 10
        }

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
        if tableView == self.secondTableView {
            return 325
        }

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
        case .HomeContentTypeDaPeiGou :
            return 60 + 144 + 56
        case .HomeContentTypeNextMenu :
            return 60
        default :
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.secondTableView {
             return cellForSecond(tableView, indexPath: indexPath)
        }

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
        case .HomeContentTypeDaPeiGou :
            return cellForHomeDapeigou(tableView, indexPath: indexPath)
        case .HomeContentTypeNextMenu :
            return cellForHomeNextMenu(tableView, indexPath: indexPath)
        default :
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    //MARK: QNShareViewDelegate
    func qnShareView(view: ShareView) -> (image: UIImage, url: String, title: String?, description: String)? {
        return (UIImage(named: "Share_Icon")!, "http://www.baidu.com", self.title ?? "", "成为喜特用户，享有更多服务!")
    }
    //MARK: -  PrivateMethod
    //MARK: 广告 cell
    func cellForSecond(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "testCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let nibView = NSBundle.mainBundle().loadNibNamed("CommentView", owner: nil, options: nil) as NSArray
            let remarkV = nibView.objectAtIndex(0) as? UIView
            remarkV!.frame = CGRectMake(0,0, kScreenWidth, 325)
            cell?.contentView.addSubview(remarkV!)
        }
        return cell!
    }

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
    //MARK: 搭配购 cell
    func cellForHomeDapeigou(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "dapeigouCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        let datas = ["","","","","",""]
        if let scrollView = cell?.viewWithTag(10001) as? UIScrollView {
            var i = 0
            var scrollvWidth = CGFloat(0)
            for _ in datas {
                var x = 0
                if i == 0 {
                    x = 12
                } else {
                    x = 12 + 80 + (36 + 80) * (i-1)
                    let addLbl = UILabel(frame: CGRect(x: x, y: 46, width: 36, height: 15))
                    addLbl.textColor = UIColor.blackColor()
                    addLbl.text = "+"
                    addLbl.textAlignment = .Center
                    addLbl.font = defaultSysFontWithSize(15)
                    scrollView.addSubview(addLbl)
                }
                //主
                if i > 0 {
                    x += 36
                }
                let view = UIView(frame: CGRect(x: x, y: 0, width: 80, height: 144))
                let imgV = UIImageView(frame: CGRect(x: 0, y: 12, width: 80, height: 80))
                imgV.image = UIImage(named: "product_pic")
                view.addSubview(imgV)
                
                let priceLbl = UILabel(frame: CGRect(x: 0, y: 144 - 12 - 13, width: 80, height: 13))
                priceLbl.text = "原价：218.0"
                priceLbl.textColor = defaultTextColor
                priceLbl.font = defaultSysFontWithSize(12)
                view.addSubview(priceLbl)
                
                let titleLbl = UILabel(frame: CGRect(x: 0, y: 144 - 12 - 13 - 8 - 12, width: 80, height: 12))
                titleLbl.text = "家纺被"
                titleLbl.textAlignment = .Center
                titleLbl.textColor = defaultDetailTextColor
                titleLbl.font = defaultSysFontWithSize(12)
                view.addSubview(titleLbl)
                scrollView.addSubview(view)
                i++
                if i == datas.count-1 {
                    scrollvWidth = CGRectGetMaxX(view.frame) + 80 + 12
                }
                scrollView.contentSize = CGSize(width: scrollvWidth, height: 0)
            }
            
        }
        let textArray = ["组合价：","613.00","（已为你节省：100)"]
        let label = TYAttributedLabel(frame: CGRect(x: 12, y: 207 + 15, width: kScreenWidth - 24, height: 22))
        label.textColor = defaultTextColor
        label.backgroundColor = UIColor.clearColor()
        label.font = defaultSysFontWithSize(15)
        label.textAlignment = .Left
        label.characterSpacing = 0
        let colors = [defaultTextColor,UIColor.redColor(),defaultDetailTextColor]
        var i = 0
        for text in textArray {
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttributeTextColor(colors[i])
            attributedStr.addAttributeFont(defaultSysFontWithSize(15))
            label.appendTextAttributedString(attributedStr)
            i++
        }
        cell?.contentView.addSubview(label)
        return cell!
    }
    //MARK:  下一页菜单 cell
    func cellForHomeNextMenu(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "NextMenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        cell?.addSubview(self.createFilterMenu())
        return cell!
    }
    func createFilterMenu() -> UIView{
        let titles = ["图文详情","评分","相关推荐"]
        let view = UIView(frame: CGRectMake(0 , 0, kScreenWidth, 60))
        for var i=0;i<titles.count;i++ {
            let btn = UIButton(frame:  CGRectMake(CGFloat(i) * kScreenWidth/3 , 0, kScreenWidth/3, 60))
            btn.backgroundColor = UIColor.clearColor()
            btn.setTitle(titles[i], forState: .Normal)
            btn.setTitle(titles[i], forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(17)
            view.addSubview(btn)
            
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            })
            if i < 2{
                let lineView = UIView(frame: CGRectMake(CGFloat(i + 1) * kScreenWidth/3, 18, 0.5, 21))
                lineView.backgroundColor = defaultLineColor
                view.addSubview(lineView)
            }
        }
        return view
    }
    func setupNewNavigation() {
    }
    
    private func dataInit(){
        self.goodsCellTypes = [.HomeContentTypeAd,.HomeContentTypeDetail,.HomeContentTypeMenu,.HomeContentTypeDistribution,.HomeContentTypeStore,.HomeContentTypeDaPeiGou, .HomeContentTypeNextMenu]
    }

    func footerRefresh(){
        UIView.animateWithDuration(0.38, animations: { () -> Void in
            var frame = self.currentTableView.frame
            self.secondTableView.frame = frame
            frame.origin = CGPoint(x: 0, y: frame.origin.y - frame.size.height)
            self.currentTableView.frame = frame
            }, completion: { (bool) -> Void in
            self.currentTableView.mj_footer.endRefreshing()
        })
    }
    // 顶部刷新
    func headerRefresh(){
        UIView.animateWithDuration(0.38, animations: { () -> Void in
            var frame = self.secondTableView.frame
            self.currentTableView.frame = frame
            frame.origin = CGPoint(x: 0, y: 64 + frame.size.height)
            self.secondTableView.frame = frame
            }, completion: { (bool) -> Void in
            self.secondTableView.mj_header.endRefreshing()
        })

    }
    func updateUI() {
        // 底部刷新
        let footer = MJRefreshAutoNormalFooter()
        // 顶部刷新
        let header = MJRefreshNormalHeader()
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        
        self.currentTableView.backgroundColor  = tableViewdefaultBackgroundColor
        self.currentTableView.mj_footer = footer
       
        self.bottomV.backgroundColor = RGB(247,247,247,1)
        secondTableView = UITableView(frame: CGRect(x: 0, y: CGRectGetMaxY(self.currentTableView.frame), width: kScreenWidth, height: self.currentTableView.frame.size.height))
        secondTableView.dataSource = self
        secondTableView.delegate = self
        self.view.addSubview(secondTableView)
        self.secondTableView.mj_header = header
        
        let titles = ["咨询","分享赚佣金","购买"]
        var i = 0
        let colorsBg = [UIColor.clearColor(),RGB(225,188,42,1),RGB(232,61,60,1)]
        for title in titles {
            let bottomBtn = UIButton(frame: CGRect(x: kScreenWidth/3 * CGFloat(i) + 18, y: 12, width: kScreenWidth/3 - 36, height: 34))
            bottomBtn.backgroundColor = UIColor.clearColor()
            bottomBtn.setTitle(title, forState: .Normal)
            bottomBtn.titleLabel?.font = defaultSysFontWithSize(17)
            bottomBtn.backgroundColor = colorsBg[i]
            bottomBtn.tag = 1000 + i
            if i == 0 {
                bottomBtn.setTitleColor(defaultTextColor, forState: .Normal)
                bottomBtn.setImage(UIImage(named: "product_chat"), forState: .Normal)
            } else {
                ZMDTool.configViewLayer(bottomBtn)
                bottomBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
            bottomBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ [weak self](sender) -> Void in
                if (sender as! UIButton).titleLabel!.text == titles[0] {
                    
                } else if (sender as! UIButton).titleLabel?.text == titles[1] {
                    if let strongSelf = self {
                        let shareView = ShareView()
                        shareView.delegate = strongSelf
                        shareView.showShareView()
                    }
                } else if (sender as! UIButton).titleLabel?.text == titles[2] {
                    
                }
            })
            self.bottomV.addSubview(bottomBtn)
            i++
        }
    }
}
