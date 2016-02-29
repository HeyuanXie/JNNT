//
//  HomeBuyGoodsSearchUIViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/26.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class HomeBuyGoodsSearchViewController: UIViewController, QNInterceptorProtocol, UITableViewDataSource, UITableViewDelegate {
    var tableView : UITableView!
    
    let goodses  = ["冰糖心苹果","西西","苹果","冰糖心苹果","西西","糖心苹果","糖心苹果"]
    var histories = g_SearchHistory == nil  ? [] : g_SearchHistory as!  NSArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.navigationController?.navigationBarHidden = false
        self.setupNewNavigation()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        histories = g_SearchHistory == nil  ? [] : g_SearchHistory as!  NSArray
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.histories.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let size = "热搜 ：".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100)
        let goodses  = ["冰糖心苹果","西西","苹果","冰糖心苹果","西西","糖心苹果","糖心苹果"]
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
        return indexPath.section == 0 ? CGFloat(y) : 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellId = "goodsCell"
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
            }
            
            let size = "热搜 ：".sizeWithFont(UIFont.systemFontOfSize(15), maxWidth: 100)
            let getBtn = { (text : String,index : Int) -> UIButton in
                let btn = UIButton(frame: CGRect.zero)
                btn.setTitle(text, forState: .Normal)
                btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                btn.layer.borderColor = UIColor.grayColor().CGColor;
                btn.layer.borderWidth = 0.5
                btn.layer.cornerRadius = 10
                btn.layer.masksToBounds = true
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    let goods = self.goodses[index]
                    let tmp = NSMutableArray(array: self.histories)
                    tmp.addObject(goods)
                    for history in self.histories {
                        if history as! String == goods {
                            tmp.removeObject(history)
                        }
                    }
                    saveSearchHistory(tmp)
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
            return cell!
        case 1 :
            let cellId = "historyCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
                
                let btn = UIButton(frame: CGRectMake(kScreenWidth-26, 18, 14, 14))
                btn.backgroundColor = UIColor.grayColor()
                btn.setImage(UIImage(named: "Home_Msg"), forState: .Normal)
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    let goods = self.goodses[indexPath.row]
                    let tmp = NSMutableArray()
                    for history in self.histories {
                        if goods != history as! String {
                            tmp.addObject(goods)
                        }
                    }
                    saveSearchHistory(tmp)
                    self.tableView.reloadData()
                })
                
                let label = UILabel(frame: CGRectMake(14, 18,100, 15))
                label.text = self.histories[indexPath.row] as! String
                label.textColor = UIColor.blackColor()
                label.font = UIFont.systemFontOfSize(15)
                
                cell?.contentView.addSubview(btn)
                cell?.contentView.addSubview(label)
            }
            return cell!
        default :
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: -  PrivateMethod
    func setupNewNavigation() {
        let searchView = UIView(frame: CGRectMake(0, 0, kScreenWidth - 74, 40))
        let searchBar = UISearchBar(frame: CGRectMake(0, 2, kScreenWidth - 74, 36))
        searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
        searchBar.placeholder = "商品查找"
        searchBar.layer.borderColor = UIColor.grayColor().CGColor;
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 6
        searchBar.layer.masksToBounds = true
        searchView.addSubview(searchBar)
        
        let searchBtn = UIButton(frame:  CGRectMake(0, 0, 40, 15))
        searchBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        searchBtn.setTitle("取消", forState:.Normal)
        searchBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
