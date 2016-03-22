//
//  FindDoctorPopView.swift
//  QooccHealth
//
//  Created by haijie on 15/8/29.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import UIKit
import ReactiveCocoa

class FindDoctorCityPopView: UIView , ZMDInterceptorProtocol, UITableViewDataSource, UITableViewDelegate{
   
    var leftTableView : UITableView!
    var rightTableView : UITableView!
    var  leftArrays : NSMutableArray = NSMutableArray()
    var  rightArrays : NSMutableArray = NSMutableArray()
    var selectIndex :Int = 0
    var  bgColor : UIColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)//249,249,249
    var widthLeftTb : CGFloat!
    var lineColor : UIColor = UIColor(red: 0.87450980392156863, green: 0.87450980392156863, blue: 0.87450980392156863, alpha: 1.0)
    var titleLbl : UILabel!
    var selectLeftArea : QN_Area!
    func initWith(frame : CGRect)  -> AnyObject {
        let nibView = NSBundle.mainBundle().loadNibNamed("FindDoctorCityPopView", owner: nil, options: nil) as NSArray
        areaInit()
        return (nibView.objectAtIndex(0) as? UIView)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let head = UIView(frame: CGRectMake(0, 0, frame.width, 40))
        self.addSubview(head)
        let titleLabel = UILabel(frame: CGRectMake(16, 13, frame.width - 16, 14))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor  = UIColor.blackColor()
        head.addSubview(titleLabel)
        self.titleLbl = titleLabel
        
        let line01 = UILabel(frame: CGRectMake(0, 39, frame.width , 1))
        line01.backgroundColor = defaultLineColor
        head.addSubview(line01)
        
        let leftTableView = UITableView(frame: CGRectMake(0, 40, frame.width / 3, frame.height - 50))
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.addSubview(leftTableView)
        self.leftTableView = leftTableView
        
        let rightTableView = UITableView(frame: CGRectMake(frame.width / 3, 40, frame.width / 3 * 2, frame.height - 50))
        rightTableView.delegate = self
        rightTableView.dataSource = self
        self.addSubview(rightTableView)
        self.rightTableView = rightTableView
        
        let line02 = UILabel(frame: CGRectMake(0, frame.height - 9, frame.width , 1))
        line02.backgroundColor = defaultLineColor
        self.addSubview(line02)
        
        areaInit()
        initTableView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: UITableViewDataSource & UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        if (tableView  == leftTableView) {
            print(leftArrays.count)
            return leftArrays.count
        }else if (tableView  == rightTableView) {
            return self.rightArrays.count  / 2  + self.rightArrays.count % 2
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
       
        if (tableView  == leftTableView) {
            let cellIdentifier = "leftcell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) 
            
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                cell?.accessoryType = UITableViewCellAccessoryType.None
                tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                
                ZMDTool.configTableViewCellDefault(cell!)
                //设置选中时颜色
                let bgView = UIView(frame: cell!.bounds)
                bgView.backgroundColor = bgColor
                cell!.selectedBackgroundView = bgView
                
                let lineLabel = UILabel(frame: CGRectMake(0, 39,tableView.frame.size.width, 1))
                lineLabel.backgroundColor = lineColor
                cell?.addSubview(lineLabel)
                
                let lineLabel02 = UILabel(frame: CGRectMake(tableView.frame.size.width - 1, 0 ,1,tableView.frame.size.height))
                lineLabel02.backgroundColor = lineColor
                cell?.addSubview(lineLabel02)
                
                let label : UILabel = UILabel(frame: CGRectMake(2, 0, tableView.frame.size.width - 20, 40))
                label.textColor = UIColor.grayColor()
                label.textAlignment = NSTextAlignment.Center
                label.font = UIFont.systemFontOfSize(13)
                label.tag = 10001
                cell?.addSubview(label)
                
                let imgV = UIImageView(frame: CGRect(x: tableView.frame.size.width - 18, y: 13, width: 14, height: 14))
                imgV.image = UIImage(named: "btn_Arrow_TurnRight1")
                cell!.addSubview(imgV)
            }
            if indexPath.row < self.leftArrays.count {
                let area = self.self.leftArrays[indexPath.row] as! QN_Area
                let label : UILabel =  cell?.viewWithTag(10001) as! UILabel
                label.text = area.name
            }
           
            return cell!
        }else if (tableView  == rightTableView) {
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            let cellIdentifier = "rightcell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) 
            
            if cell == nil{
                let cellIdentifier = "rightcell"
               cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                
                let leftBtn : UIButton = UIButton(frame: CGRectMake(0, 0, tableView.frame.size.width / 2 ,  40))
                leftBtn.setTitle("东莞", forState: UIControlState.Normal)
                leftBtn.setTitleColor(UIColor.blackColor(),forState: .Normal) //普通状态下文字的颜色
                leftBtn.titleLabel!.font = UIFont.systemFontOfSize(14)
                leftBtn.backgroundColor = bgColor
                leftBtn.tag = 10001
                cell?.addSubview(leftBtn)
                
                let rightbtn : UIButton = UIButton(frame: CGRectMake(tableView.frame.size.width / 2, 0, tableView.frame.size.width / 2 ,  40))
                rightbtn.setTitle("东莞", forState: UIControlState.Normal)
                rightbtn.setTitleColor(UIColor.blackColor(),forState: .Normal) //普通状态下文字的颜色
                rightbtn.titleLabel!.font = UIFont.systemFontOfSize(13)
                rightbtn.backgroundColor = bgColor
                rightbtn.tag = 10002
                cell?.addSubview(rightbtn)
                cell?.backgroundColor = bgColor
            }
             if (indexPath.row * 2 < self.rightArrays.count) {
                let leftBtn : UIButton =  cell?.viewWithTag(10001) as! UIButton
                let cityLeft = self.self.rightArrays[indexPath.row * 2] as! QN_City
                leftBtn.setTitle(cityLeft.name, forState: .Normal)
               
                leftBtn.rac_command = RACCommand(signalBlock: { [weak self](sender) -> RACSignal! in
                    if let strongSelf = self {
                        strongSelf.titleLbl.text = "\(strongSelf.selectLeftArea.name)>\(cityLeft.name)"
                    }
                    return RACSignal.empty()
                })
            }
            if (indexPath.row * 2 + 1 < self.rightArrays.count) {
                let rightBtn : UIButton =  cell?.viewWithTag(10002 ) as! UIButton
                let cityRight = self.self.rightArrays[indexPath.row * 2 + 1] as! QN_City
                rightBtn.setTitle(cityRight.name, forState: .Normal)
                rightBtn.rac_command = RACCommand(signalBlock: { [weak self](sender) -> RACSignal! in
                    if let strongSelf = self {
                    }
                    return RACSignal.empty()
                    })
            }
            return cell!
        }else {
            let cellIdentifier = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) 
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell?.selectionStyle = UITableViewCellSelectionStyle.Default
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        }
       
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (tableView == leftTableView) {
            self.selectLeftArea = self.leftArrays[indexPath.row] as! QN_Area
            self.rightArrays =  self.selectLeftArea.citys
            self.rightTableView.reloadData()
        }
    }
    //MARK: Private Method
    //地区初始化
    func areaInit() {
        var areaFile : NSArray!
        if let areaFilePath = NSBundle.mainBundle().pathForResource("area", ofType: "txt"), let areaData = NSData(contentsOfFile: areaFilePath) {
            do {
                areaFile = try NSJSONSerialization.JSONObjectWithData(areaData, options: NSJSONReadingOptions()) as? NSArray
                for(var i : Int = 0 ;i < areaFile.count; i++ ) {
                    let dic : NSDictionary = areaFile[i] as! NSDictionary
                    self.leftArrays.addObject(QN_Area(dic))
                }
                self.selectLeftArea = self.leftArrays[0] as! QN_Area
                self.titleLbl.text = "\(self.selectLeftArea.name)>\((self.selectLeftArea.citys[0] as! QN_City).name)"
            }catch{}
        }
    } 
    
    func initTableView() {
        let index = NSIndexPath(forRow: 0, inSection: 0)
        self.leftTableView.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        let selectArea = self.leftArrays[0] as! QN_Area
        self.rightArrays =  selectArea.citys
        self.leftTableView.frame.size.width = self.frame.size.width / 3
        self.rightTableView.frame.size.width = self.frame.size.width / 3 * 2
    }
}
