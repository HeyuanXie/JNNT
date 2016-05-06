//
//  GoodsManagerSearchViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import FMDB
// 商品名称/商品货号
class GoodsManagerSearchViewController: UIViewController, ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    var currentTableView: UITableView!
    var goodsHistory = NSMutableArray()
    let goodsData = ["",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subViewInit()
        self.setupNewNavigation()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.dataInit()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.goodsHistory.count + 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 16 : 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "HeadCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell!.textLabel!.text = "最近搜索："
            return cell!
        }
        
        if indexPath.row == self.goodsHistory.count {
            let cellId = "cleanCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
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
            
            return cell!
        }
        let cellId = "historyCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            
            cell!.contentView.backgroundColor = tableViewCellDefaultBackgroundColor
            cell?.textLabel?.textColor = defaultDetailTextColor
            let btn = UIButton(frame: CGRectMake(kScreenWidth-26, 20, 14, 14))
            btn.backgroundColor = UIColor.clearColor()
            btn.setImage(UIImage(named: "GoodsSearch_close"), forState: .Normal)
            btn.tag = indexPath.row
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                //delete
                self.deleteValueFromDB(self.createOrOpenDB(),text:(self.goodsHistory[(sender as! UIButton).tag] as! String))
                self.currentTableView.reloadData()
            })
            
            cell?.contentView.addSubview(btn)
            
            let line = UIImageView(frame: CGRect(x: 0, y: 54, width: kScreenWidth, height: 0.5))
            line.backgroundColor = defaultLineColor
            cell?.contentView.addSubview(line)
        }
        cell!.textLabel!.text = self.goodsHistory[indexPath.row] as? String
        return cell!
        
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
    private func subViewInit(){
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
    }
    func setupNewNavigation() {
        let searchView = UIView(frame: CGRectMake(0, 0, kScreenWidth - 120, 44))
        let searchBar = UISearchBar(frame: CGRectMake(0, 4, kScreenWidth - 120, 36))
        searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
        searchBar.placeholder = "商品名称/商品货号"
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
