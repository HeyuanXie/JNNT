//
//  StoreShowHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/20.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 店铺首页
class StoreShowHomeViewController: UIViewController, ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    enum StoreHomeCellType {
        case Head
        case Notice
        case Discount
        case Coupon
        case Recommend
        case Other
        var height : CGFloat {
            switch self {
            case Head:
                return 360/750 * kScreenWidth
            case Notice:
                return 45
            case Discount:
                return 85
            case Coupon:
                return 260/750 * kScreenWidth
            case Recommend:
                return 325
            default:
                return 0
            }
        }
        func heightForSection(section : Int) -> CGFloat {
            switch section {
            case 2 :
                return 46
            default :
                return 16
            }
        }
        func viewForSection(section : Int) -> UIView {
            switch section {
            case 2 :
                let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
                headView.backgroundColor = UIColor.clearColor()
                let line = UIView(frame: CGRect(x: 12, y: 14, width: 5, height: 20))
                line.backgroundColor = RGB(235,61,61,1.0)
                headView.addSubview(line)
                let titleLbl = ZMDTool.getLabel(CGRect(x: CGRectGetMaxX(line.frame)+10, y: 15, width: 70, height: 15), text: "人气推荐", fontSize: 15)
                headView.addSubview(titleLbl)
                let hotLbl = ZMDTool.getLabel(CGRect(x: CGRectGetMaxX(titleLbl.frame), y: 16, width: 32, height: 16), text: "HOT", fontSize: 10,textColor: UIColor.whiteColor(),textAlignment: .Center)
                hotLbl.backgroundColor = RGB(235,61,61,1.0)
                headView.addSubview(hotLbl)
                return headView
            default :
                let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
                headView.backgroundColor = UIColor.clearColor()
                return headView
            }
        }
    }
    @IBOutlet weak var currentTableView: UITableView!
    var celltypes = [[StoreHomeCellType.Head,.Notice,.Discount],[.Coupon],[.Recommend]]
    let kTagPageControl = 10001
    let kTagScrollView = 10002
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.setupNewNavigation()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.currentTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.celltypes[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.celltypes.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return StoreHomeCellType.Other.heightForSection(section)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return StoreHomeCellType.Other.viewForSection(section)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.celltypes[indexPath.section][indexPath.row].height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let celltype = self.celltypes[indexPath.section][indexPath.row]
        switch celltype {
        case .Head :
            let cellId = "HeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            var tag = 10001
            let imgBg = cell?.viewWithTag(tag++) as! UIImageView
            let storeLbl = cell?.viewWithTag(tag++) as! UILabel
            let detailLbl = cell?.viewWithTag(tag++) as! UILabel
            let followBtn = cell?.viewWithTag(tag++) as! UIButton
            imgBg.image = UIImage.colorImage(RGB(72,72,69,1))
            ZMDTool.configViewLayerWithSize(followBtn, size: 18)
            followBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                return RACSignal.empty()
            })
            return cell!
        case .Notice :
            let cellId = "NoticeCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                let lbl = ZMDTool.getLabel(CGRect(x: 36, y: 0, width: kScreenWidth-36-44, height: 46), text: "", fontSize: 14)
                lbl.tag = 10001
                cell?.contentView.addSubview(lbl)
                //下部弹窗
                let downBtn = UIButton(frame: CGRect(x: kScreenWidth - 44, y: 0, width: 44, height: 46))
                downBtn.backgroundColor = UIColor.whiteColor()
                downBtn.setImage(UIImage(named: "home_down"), forState: .Normal)
                downBtn.setImage(UIImage(named: "home_up"), forState: .Selected)
                downBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                })
                cell?.contentView.addSubview(downBtn)
                cell?.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: 44.5, width: kScreenWidth, height: 0.5)))
            }
            let lbl = cell?.viewWithTag(10001) as! UILabel
            lbl.text = "店铺公告："
            return cell!
        case .Discount :
            //
            let cellId = "DiscountCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                self.scrollView(0,cell: cell!)
            }
            return cell!
        case .Coupon :
            let cellId = "CouponCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
            }
            let cycleScroll = CycleScrollView(frame: CGRectMake(12, 10, kScreenWidth-24, 260/750 * kScreenWidth-20))
            cycleScroll.backgroundColor = UIColor.blueColor()
            let image = ["home_banner01","home_banner02","home_banner03","home_banner04","home_banner05"]
            cycleScroll.imgArray = image
            //            cycleScroll.delegate = self
            cycleScroll.autoScroll = true
            cycleScroll.autoTime = 2.5
            cell?.addSubview(cycleScroll)
            return cell!
        case .Recommend :
            let cellId = "DoubleGoodsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! DoubleGoodsTableViewCell
            cell.goodsImgVLeft.image = UIImage(named: "home_banner02")
            return cell
            
        default :
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar)  {
        self.view.endEditing(true)
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: - Action
    @IBAction func goodsSortBtnCli(sender: UIButton) {
        let vc = StoreShowGoodsSortViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    func setupNewNavigation() {
        let searchView = UIView(frame: CGRectMake(0, 0, kScreenWidth - 120, 44))
        let searchBar = UISearchBar(frame: CGRectMake(0, 4, kScreenWidth - 120, 36))
        searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
        searchBar.placeholder = "搜索店铺商品"
        searchBar.layer.borderColor = UIColor.grayColor().CGColor
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 6
        searchBar.layer.masksToBounds = true
        searchBar.delegate = self
        searchView.addSubview(searchBar)
        self.navigationItem.titleView = searchView
    }
    func dataInit() {
    }
    func scrollView(y:CGFloat,cell:UITableViewCell) {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y:12, width: kScreenWidth, height: 60))
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollsToTop = false
        scrollView.pagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.tag = kTagScrollView
        cell.contentView.addSubview(scrollView)
        
        let width = CGFloat(140)
        let spacing = CGFloat(8)
        var i = 0
        for _ in ["","",""] {
            let projectV = self.projectView((width+spacing)*CGFloat(i))
            scrollView.addSubview(projectV)
            i++
        }
        scrollView.contentSize = CGSizeMake((width+spacing)*CGFloat(i), 0)
        scrollView.bounces = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        scrollView.contentOffset.x = -12
    }
    func projectView(x:CGFloat) -> UIView {
        let width = CGFloat(140),height = CGFloat(60)
        let view = UIButton(frame: CGRect(x: x, y: 0, width: width, height: height))
        view.backgroundColor = RGB(250,65,120,1)
        let titleLbl = ZMDTool.getLabel(CGRect(x: 12, y: 15, width: width-24, height: 13), text: "￥5满193使用", fontSize: 13)
        view.addSubview(titleLbl)
        let detailLbl = ZMDTool.getLabel(CGRect(x: 50, y: CGRectGetMaxY(titleLbl.frame)+8, width: width-62, height: 15), text: "￥立即领取>", fontSize: 10)
        detailLbl.backgroundColor = RGB(255,252,202,1)
        ZMDTool.configViewLayerWithSize(detailLbl, size: 7)
        view.addSubview(detailLbl)
        return view
    }

}
