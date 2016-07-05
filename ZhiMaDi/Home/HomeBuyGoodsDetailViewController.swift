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
class HomeBuyGoodsDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,QNShareViewDelegate,ZMDInterceptorProtocol{
    enum GoodsCellType{
        case HomeContentTypeAd                      /* 广告显示页 */
        case HomeContentTypeDetail                   /* 菜单参数栏目 */
        case HomeContentTypeMenu                    /* 菜单选择栏目 */
        case HomeContentTypeDistribution             /* 商品配送栏目 */
        case HomeContentTypeStore                   /* 店家  */
        case HomeContentTypeDaPeiGou               /* 搭配购商品 */
        init(){
            self = HomeContentTypeAd
        }
    }
    enum SecondCellType {
        case SecondDetail,SecondScore,SecondParameter
        init(){
            self = SecondDetail
        }
    }
    @IBOutlet weak var currentTableView: UITableView!
    var secondTableView: UITableView!
    var countForBounghtLbl : UIButton!               // 购买数量Lbl
    @IBOutlet weak var bottomV: UIView!
    var productAttrV : ZMDProductAttrView!
    var kTagEditViewShow = 100001
    
    var countForBounght = 1                         // 购买数量
    var goodsCellTypes: [GoodsCellType]!
    var secondCellType = SecondCellType()
    var navBackView : UIView!
    var navLine : UIView!
    var productId : Int!
    var productDetail : ZMDProductDetail!
    var attrSelectArray = NSMutableArray()          // 属性选择
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.dataInit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.getBackView((self.navigationController?.navigationBar)!)
        self.setupNavigationWithBg()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navBackView.alpha = 1.0
        self.navLine.alpha = 1.0
        self.navLine.hidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Action
    @IBAction func AddProductToCard(sender: UIButton) {
        // 购物车
        let vc = ShoppingCartViewController.CreateFromMainStoryboard() as! ShoppingCartViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
            return 1
        case .HomeContentTypeDaPeiGou :
            return 1
        default :
            return 1
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.currentTableView && self.productDetail == nil {
            return 0
        }
        if tableView == self.secondTableView {
            return 2
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
            return indexPath.section == 0 ? 60 : kScreenHeight - 64 - 80 - 58
        }

        let cellType = self.goodsCellTypes[indexPath.section]
        switch cellType {
        case .HomeContentTypeAd :
            return kScreenWidth
        case .HomeContentTypeDetail :
            return 156
        case .HomeContentTypeMenu :
            return ZMDProductAttrView.getHeight(self.productDetail) + 60
        case .HomeContentTypeDistribution :
            return 106
        case .HomeContentTypeStore :
            return 120
        case .HomeContentTypeDaPeiGou :
            return 60 + 144 + 56
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.secondTableView {
            if indexPath.section == 0 {
               return cellForHomeNextMenu(tableView, indexPath: indexPath)
            } else {
                return cellForSecondDetail(tableView, indexPath: indexPath)
            }
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
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellType = self.goodsCellTypes[indexPath.section]
        switch cellType {
        case .HomeContentTypeStore :
            let vc = StoreShowHomeViewController.CreateFromMainStoryboard() as! StoreShowHomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default :
            break
        }
    }
    //MARK: - scrollView
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView != self.currentTableView {
            return
        }
        var alaph = (scrollView.contentOffset.y) / 150.0
        alaph = alaph > 1 ? 1 : alaph
        if self.navBackView != nil {
            if alaph == 0 {
                self.navLine.hidden = true
            } else {
                self.navLine.alpha = alaph
                self.navLine.hidden = false
            }
            if alaph > 0.5 {
                self.setupNavigation()
            } else {
                self.setupNavigationWithBg()
            }
            self.navBackView.alpha = alaph
        }
    }
    //MARK: QNShareViewDelegate
    func qnShareView(view: ShareView) -> (image: UIImage, url: String, title: String?, description: String)? {
        return (UIImage(named: "Share_Icon")!, "http://www.baidu.com", self.title ?? "", "成为喜特用户，享有更多服务!")
    }
    //MARK: -  PrivateMethod
    //MARK: Second cell
    
    func cellForSecondDetail(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "SecondDetailCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
            
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth - 64 - 70 - 58))
            cell?.contentView.addSubview(webView)
            //self.productId
            QNNetworkTool.fetchProductDetailView(34) { (succeed, data, error) -> Void in
                if succeed! {
                    webView.loadHTMLString(data!, baseURL: nil)
                }
            }
        }
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
            cell?.addSubview(self.createFilterMenu())
        }
        return cell!
    }

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
        }
        if let v = cell?.viewWithTag(10001) {
            v.removeFromSuperview()
        }
       
        if self.productDetail != nil && self.productDetail.DetailsPictureModel != nil {
            let arr = NSMutableArray()
            if let pictureModel = self.productDetail.DetailsPictureModel!.PictureModels {
                for pic in pictureModel {
                    let imgUrl = kImageAddressMain + (pic.ImageUrl ?? "")
                    arr.addObject(NSURL(string: imgUrl)!)
                }
            }
            let cycleScroll = CycleScrollView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth))
            cycleScroll.tag = 10001
            cycleScroll.backgroundColor = UIColor.clearColor()
            //            cycleScroll.delegate = self
            cycleScroll.autoScroll = true
            cycleScroll.autoTime = 2.5
            if arr.count != 0 {
                cycleScroll.urlArray = arr as [AnyObject]
            }
            cell?.addSubview(cycleScroll)
        }
        return cell!
    }
    //MARK: 商品详请 cell
    func cellForHomeDetail(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "detailCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! ContentTypeDetailCell
        if self.productDetail != nil {
            ContentTypeDetailCell.configProductDetailCell(cell, product: self.productDetail)
        }
        return cell
    }
    //MARK: 商品购买选项 cell
    func cellForHomeMenu(tableView: UITableView,indexPath: NSIndexPath)-> UITableViewCell {
        let cellId = "menuOtherCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.selectionStyle = .None
            cell!.contentView.backgroundColor = UIColor.whiteColor()
        }
        if self.view.viewWithTag(kTagEditViewShow) == nil {
            let editView = self.editViewShow(self.productDetail, SciId: 0)
            cell!.contentView.addSubview(editView)
        }
        return cell!
    }
    func editViewShow(productDetail:ZMDProductDetail,SciId:Int) -> UIView {
        let editView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: ZMDProductAttrView.getHeight(productDetail) + 60))
        editView.tag = kTagEditViewShow
        editView.backgroundColor = UIColor.whiteColor()
        
        productAttrV = ZMDProductAttrView(frame: CGRect.zero, productDetail: productDetail)
        productAttrV.SciId = SciId
        productAttrV.frame = CGRectMake(0, 0,kScreenWidth, productAttrV.getHeight())
        editView.addSubview(productAttrV)
        
        let countView = CountView(frame: CGRect(x: kScreenWidth - 12 - 120, y: CGRectGetMaxY(productAttrV.frame) + 10, width: 120, height: 40))
        countView.finished = {(count)->Void in
            self.countForBounght = count
        }
        countView.countForBounght = 1
        countView.updateUI()
        editView.addSubview(countView)
        
        let countLbl = UILabel(frame: CGRect(x: 12, y: CGRectGetMaxY(productAttrV.frame), width: 200, height: 60))
        let kucunText = "（库存量: 15）"
        let countText = "购买数量\(kucunText)"
        countLbl.attributedText = countText.AttributedMutableText(["购买数量",countText], colors: [defaultTextColor,defaultDetailTextColor])
        countLbl.font = defaultSysFontWithSize(16)
        editView.addSubview(countLbl)
        return editView
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
        if self.productDetail != nil && self.productDetail.BundledItems != nil {
            let datas = self.productDetail.BundledItems!
            if let scrollView = cell?.viewWithTag(10001) as? UIScrollView {
                var i = 0
                var scrollvWidth = CGFloat(0)
                for bundledItem in datas {
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
                    if let pictureModel = bundledItem.DetailsPictureModel?.DefaultPictureModel {
                        let imgUrl = kImageAddressMain + (pictureModel.ImageUrl ?? "")
                        imgV.sd_setImageWithURL(NSURL(string: imgUrl)!)
                    }
                    view.addSubview(imgV)
                    
                    let priceLbl = UILabel(frame: CGRect(x: 0, y: 144 - 12 - 13, width: 80, height: 13))
                    if let productPrice = bundledItem.ProductPrice {
                        priceLbl.text = "原价:\(productPrice.OldPrice ?? "")"
                    }
                    priceLbl.textColor = defaultTextColor
                    priceLbl.font = defaultSysFontWithSize(12)
                    view.addSubview(priceLbl)
                    
                    let titleLbl = UILabel(frame: CGRect(x: 0, y: 144 - 12 - 13 - 8 - 12, width: 80, height: 12))
                    titleLbl.text = bundledItem.Name
                    titleLbl.textAlignment = .Center
                    titleLbl.textColor = defaultDetailTextColor
                    titleLbl.font = defaultSysFontWithSize(12)
//                    titleLbl.adjustsFontSizeToFitWidth = true
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
        }
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
                self.secondCellType
            })
            if i < 2{
                let lineView = UIView(frame: CGRectMake(CGFloat(i + 1) * kScreenWidth/3, 18, 0.5, 21))
                lineView.backgroundColor = defaultLineColor
                view.addSubview(lineView)
            }
        }
        return view
    }
    func setupNavigation() {
        let item = UIBarButtonItem(image: UIImage(named: "Navigation_Back")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: self, action: Selector("back"))
        item.customView?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = item
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "product_collect_03")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: self, action: Selector("collect"))
        rightItem.customView?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func setupNavigationWithBg() {
        let item = UIBarButtonItem(image: UIImage(named: "product_return")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: self, action: Selector("back"))
        item.customView?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = item
        let rightItem = UIBarButtonItem(image: UIImage(named: "product_collect_01")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Done, target: self, action: Selector("collect"))
        rightItem.customView?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightItem
    }
    private func dataInit(){
        self.goodsCellTypes = [.HomeContentTypeAd,.HomeContentTypeDetail,.HomeContentTypeMenu,/*.HomeContentTypeDistribution,.HomeContentTypeStore,.HomeContentTypeDaPeiGou*/]
        QNNetworkTool.fetchProductDetail(self.productId) { (productDetail, error, dictionary) -> Void in
            if productDetail != nil {
                self.productDetail = productDetail
                if self.productDetail.ProductType?.integerValue == 15 {
                    // 搭配产品
                    self.goodsCellTypes = [.HomeContentTypeAd,.HomeContentTypeDetail,.HomeContentTypeMenu,/*.HomeContentTypeDistribution,.HomeContentTypeStore,*/.HomeContentTypeDaPeiGou]
                }
                self.currentTableView.reloadData()
            } else {
                ZMDTool.showErrorPromptView(nil, error: error)
            }
        }
    }
    func footerRefresh(){
        UIView.animateWithDuration(0.38, animations: { () -> Void in
            var frame = self.currentTableView.frame
            frame.origin = CGPoint(x: 0, y: frame.origin.y + 64)
            self.secondTableView.frame = frame
            frame.origin = CGPoint(x: 0, y: frame.origin.y - frame.size.height - 64)
            self.currentTableView.frame = frame
            }, completion: { (bool) -> Void in
                self.currentTableView.mj_footer.endRefreshing()
                if self.navBackView != nil {
                    self.navLine.hidden = false
                    self.setupNavigation()
                    self.navBackView.alpha = 1.0
                }
        })
    }
    // 顶部刷新
    func headerRefresh(){
        UIView.animateWithDuration(0.38, animations: { () -> Void in
            var frame = self.secondTableView.frame
            frame.origin = CGPoint(x: 0, y: frame.origin.y - 64)
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
        secondTableView.separatorStyle = .None
        secondTableView.dataSource = self
        secondTableView.delegate = self
        self.view.addSubview(secondTableView)
        self.secondTableView.mj_header = header
        self.secondTableView.reloadData()
        
        let titles = ["咨询","分享赚佣金","加入购物车"]
        var i = 0
        let colorsBg = [UIColor.clearColor(),RGB(225,188,42,1),RGB(232,61,60,1)]
        for title in titles {
            if i < 2 {
                i++
                continue
            }
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
                    if let strongSelf = self {
                        let postDic = strongSelf.productAttrV.getPostData(strongSelf.countForBounght,IsEdit: false)
                        if postDic == nil {
                            return
                        }
                        postDic!.setValue(strongSelf.productDetail.Id.integerValue, forKey: "Id")
                        postDic!.setValue(1, forKey: "carttype")
                        if g_isLogin! {
                            QNNetworkTool.addProductToCart(postDic!, completion: { (succeed, dictionary, error) -> Void in
                                if succeed! {
                                    ZMDTool.showPromptView("添加成功")
                                } else {
                                    ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: "添加失败")
                                }
                            })
                        }
                    }
                }
            })
            self.bottomV.addSubview(bottomBtn)
            i++
        }
    }
    // 配置navigationBar
    func getBackView(superView : UIView) {
        if superView.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
            for view in superView.subviews {
                //移除分割线
                if view.isKindOfClass(UIImageView.classForCoder()) {
                    self.navLine = view
                    self.navLine.hidden = true
                }
            }
            self.navBackView = superView
            self.navBackView.alpha = 0
            self.navBackView.backgroundColor = navigationBackgroundColor
        } else if superView.isKindOfClass(NSClassFromString("_UIBackdropView")!) {
            superView.hidden = true
        }
        for view in superView.subviews {
            self.getBackView(view)
        }
    }
    func collect() {
        if g_isLogin! {
            let dic = NSMutableDictionary()
            dic.setValue(g_customerId!, forKey: "CustomerId")
            dic.setValue(1, forKey: "Quantity")
            dic.setValue(productDetail.Id.integerValue, forKey: "Id")
            dic.setValue(2, forKey: "carttype")
            QNNetworkTool.addProductToCart(dic, completion: { (succeed, dictionary, error) -> Void in
                if succeed! {
                    ZMDTool.showPromptView("添加成功")
                } else {
                    ZMDTool.showErrorPromptView(dictionary, error: error, errorMsg: "添加失败")
                }
            })
        }
    }
}
class ContentTypeDetailCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceLblWidthcon: NSLayoutConstraint!
    @IBOutlet weak var oldPriceLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var isFreeLbl: UILabel!
    @IBOutlet weak var soldCountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    class func configProductDetailCell(cell:ContentTypeDetailCell!,product : ZMDProductDetail) {
        cell.nameLbl.text = product.Name
        if let productPrice = product.ProductPrice {
            cell.priceLbl.text = "\(productPrice.Price)"
            cell.priceLblWidthcon.constant = "\(productPrice.Price)".sizeWithFont(defaultSysFontWithSize(20), maxWidth: 200).width
            cell.layoutIfNeeded()
            cell.oldPriceLbl.text = "原价:\(productPrice.OldPrice ?? "")"
        }

        cell.soldCountLbl.text = "已售\(product.Sold)件"
        cell.skuLbl.text = "商品货号:\(product.Sku ?? "")"
        cell.isFreeLbl.text = product.IsFreeShipping!.boolValue ? "运费:免邮" : "运费:不免邮"
    }
}
