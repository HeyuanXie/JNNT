//
//  HomeBuyGoodsSearchUIViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/26.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import FMDB
// 商品搜索
class HomeBuyGoodsSearchViewController: UIViewController, ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var currentTableView: UITableView!
    let goodses  = ["睡袋","婴儿床","床垫","儿童椅","奶酪","七万"]
    var goodsHistory = NSMutableArray()
    let goodsData = ["",""]
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
        if section == 1 {
            return self.goodsHistory.count + 1
        } else if section == 3 {
            return goodsData.count
        }
        return  1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1 :
            return 10
        case 1 :
            return 10
        case 2 :
            return 0
        case 3 :
            return 0
        default :
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 10))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let size = "热搜 ：".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100)
            var x = 14 + size.width
            var y = 50
            let space = CGFloat(12)
            for goods in goodses {
                let sizeTmp = goods.sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100) //名宽度
                let xTmp = x + space + sizeTmp.width + 20 + 12
                if xTmp > kScreenWidth {
                    y += 38
                    x = 14 + sizeTmp.width + 20
                } else {
                    x = x + space + sizeTmp.width + 20
                }
            }
            return  CGFloat(y)
        } else if indexPath.section == 1 {
            return  55
        } else if indexPath.section == 2 {
            return  80
        } else if indexPath.section == 3 {
            return  581/750 * kScreenWidth + 10
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellId = "goodsHotCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                ZMDTool.configTableViewCellDefault(cell!)
                
                let label = UILabel(frame: CGRectMake(14, 18,100, 15))
                label.text = "热搜 ："
                label.textColor = UIColor.blackColor()
                label.font = UIFont.systemFontOfSize(15)
                cell?.contentView.addSubview(label)
                
                
                let size = "热搜 ：".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100)
                let getBtn = { (text : String,index : Int) -> UIButton in
                    let btn = UIButton(frame: CGRect.zero)
                    btn.setTitle(text, forState: .Normal)
                    btn.setTitleColor(defaultTextColor, forState: .Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(17)
                    btn.layer.borderColor = UIColor.grayColor().CGColor;
                    btn.layer.borderWidth = 0.5
                    btn.layer.cornerRadius = 10
                    btn.layer.masksToBounds = true
                    btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                        let goods = self.goodses[index]
                        // save
                        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
                        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
                    })
                    return btn
                }
                var x = 14 + size.width
                var y = 12
                let space = CGFloat(12)
                var index = 0
                for goods in goodses {
                    let sizeTmp = goods.sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100) //名宽度
                    let xTmp = x + space + sizeTmp.width + 20  + 12
                    let btn = getBtn(goods,index)
                    btn.tag = index++
                    if xTmp < kScreenWidth {
                        btn.frame = CGRectMake(x + space , CGFloat(y),sizeTmp.width + 20, 26)
                        cell?.contentView.addSubview(btn)
                        x = x + space + sizeTmp.width + 20
                    } else {
                        y += 38
                        x = 14 + sizeTmp.width + 20
                        btn.frame = CGRectMake(14, CGFloat(y),sizeTmp.width + 20, 26)
                        cell?.contentView.addSubview(btn)
                    }
                }
            }
            
            return cell!
        case 1 :
            //记录
            if indexPath.row == self.goodsHistory.count {
                let cellId = "cleanCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    cell!.selectionStyle = .None
                    
                    ZMDTool.configTableViewCellDefault(cell!)
                    let title = "清除搜索记录"
                    let size = title.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: kScreenWidth)
                    let label = UILabel(frame: CGRectMake(kScreenWidth/2-size.width/2,0,size.width, 55))
                    label.text = title
                    label.textAlignment = .Center
                    
                    label.textColor = defaultDetailTextColor
                    label.font = UIFont.systemFontOfSize(14)
                    cell?.contentView.addSubview(label)
                    
                    let imgV = UIImageView(frame: CGRect(x: label.frame.origin.x - 29, y: 18, width: 19, height: 19))
                    imgV.image = UIImage(named: "GoodsSearch_Trash")
                    cell?.contentView.addSubview(imgV)
                }
                return cell!
            }
            let cellId = "historyCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                let btn = UIButton(frame: CGRectMake(kScreenWidth-26, 20, 14, 14))
                btn.backgroundColor = UIColor.clearColor()
                btn.setImage(UIImage(named: "GoodsSearch_close"), forState: .Normal)
                btn.tag = indexPath.row
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    //delete
                    self.deleteValueFromDB(self.createOrOpenDB(),text:(self.goodsHistory[(sender as! UIButton).tag] as! String))
                    self.currentTableView.reloadData()
                })
                
                let label = UILabel(frame: CGRectMake(14, 20,100, 16))
                label.text = self.goodsHistory[indexPath.row] as? String
                label.textColor = defaultDetailTextColor
                label.font = UIFont.systemFontOfSize(16)
                
                cell?.contentView.addSubview(btn)
                cell?.contentView.addSubview(label)
                
                let line = UIImageView(frame: CGRect(x: 0, y: 54, width: kScreenWidth, height: 0.5))
                line.backgroundColor = defaultLineColor
                cell?.contentView.addSubview(line)
            }
            return cell!
        case 2 :
            //
            let cellId = "doubleHeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 3 :
            //
            let cellId = "doubleGoodsCell"
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
        insertValueToDB(createOrOpenDB(),text: searchBar.text!)
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func setupNewNavigation() {
        let searchView = UIView(frame: CGRectMake(0, 0, kScreenWidth - 120, 44))
        let searchBar = UISearchBar(frame: CGRectMake(0, 4, kScreenWidth - 120, 36))
        searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
        searchBar.placeholder = "商品关键字"
        searchBar.layer.borderColor = UIColor.grayColor().CGColor;
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 6
        searchBar.layer.masksToBounds = true
        searchBar.delegate = self
        searchView.addSubview(searchBar)
        self.navigationItem.titleView = searchView

        let rightItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        rightItem.rac_command = RACCommand(signalBlock: { (input) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            return RACSignal.empty()
        })
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func dataInit() {
        self.queryValueToDB(self.createOrOpenDB())
    }
    func createOrOpenDB() -> FMDatabase {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Zmd.sqlite")
        let database = FMDatabase(path: fileURL.path)
        if !database.open() {
            print("Unable to open database")
            return database
        }
        do {
            try database.executeUpdate("create table if not exists GoodsHistory(id integer PRIMARY KEY AUTOINCREMENT,goodsTitle text)", values: nil)
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return database
    }
    func insertValueToDB(database:FMDatabase,text:String) {
        for tmp in self.goodsHistory {
            if tmp as? String == text {
                return
            }
        }
        do {
            try database.executeUpdate("insert into GoodsHistory (goodsTitle) values (?)", values: [text])
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    func deleteValueFromDB(database:FMDatabase,text:String) {
        do {
            try database.executeUpdate("delete from GoodsHistory where goodsTitle = \(text)",values:nil)
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        self.currentTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Bottom)
    }
    func queryValueToDB(database:FMDatabase) {
        do {
            let rs = try database.executeQuery("select goodsTitle from GoodsHistory", values: nil)
            self.goodsHistory.removeAllObjects()
            while rs.next() {
                let goodsTitle = rs.stringForColumn("goodsTitle")
                self.goodsHistory.addObject(goodsTitle)
            }
            self.currentTableView.reloadData()
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
}
