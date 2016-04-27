//
//  MyStoreSetViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/27.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 店铺设置
class MyStoreSetViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    enum UserCenterCellType{
        case Head
        case NickN
        case Notice
        case SendAddress
        case BackAddress
        case Help
        
        init(){
            self = Head
        }
        
        var title : String{
            switch self{
            case Head:
                return "店铺头像"
            case NickN:
                return "店铺名称"
            case Notice :
                return "发货地址"
            case SendAddress :
                return "发货地址"
            case BackAddress:
                return "退货地址"
            case Help:
                return "帮助反馈"
            }
        }
        
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Head:
                viewController = UIViewController()
            case NickN:
                viewController = UIViewController()
            case Notice :
                viewController = UIViewController()
            case SendAddress:
                viewController = UIViewController()
            case BackAddress:
                viewController = UIViewController()
            case Help:
                viewController = UIViewController()
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }
    
    var tableView : UITableView!
    var headerView: UIImageView!
    var nameLB: UILabel!
    var noticeLB: UILabel!
    var sendAddressLB: UILabel!
    var backAddressLB: UILabel!
    var helpLB: UILabel!
    var moreView :UIView!
    var picker: UIImagePickerController?
    
    var userCenterData: [[UserCenterCellType]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.subViewInit()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCenterData[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let content = self.userCenterData[indexPath.section][indexPath.row]
        if content == UserCenterCellType.Head {
            return 85
        }
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let content = self.userCenterData[indexPath.section][indexPath.row]
        let cellId = "cell\(indexPath.row)\(indexPath.section)"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            ZMDTool.configTableViewCellDefault(cell)
            cell.selectionStyle = .None
            cell.contentView.addSubview(ZMDTool.getLine(CGRect(x: 0, y: content == UserCenterCellType.Head ? 84.5 : 59.5, width: kScreenWidth, height: 0.5)))
        }
        cell.textLabel?.text = content.title
        switch content {
        case .Head:
            if self.headerView == nil {
                self.headerView = UIImageView(frame: CGRectMake(kScreenWidth - 60 - 38 - 19 , 17, 60, 60))
                self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                self.headerView.layer.masksToBounds = true
                self.headerView.layer.cornerRadius = self.headerView.frame.width/2
                self.headerView.image = UIImage(named: "Home_Buy_PeopleTest")
            }
            cell.contentView.addSubview(self.headerView)
        case .NickN:
            self.nameLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38 , 0, 100, 60))
            self.nameLB.font = UIFont.systemFontOfSize(17)
            self.nameLB.text = "张三"
            self.nameLB.textAlignment = NSTextAlignment.Right
            self.nameLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.nameLB)
        case .Notice:
            self.noticeLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38, 0,100, 60))
            self.noticeLB.font = UIFont.systemFontOfSize(17)
            self.noticeLB.textAlignment = NSTextAlignment.Right
            self.noticeLB.text = "1、满20减20.。。"
            self.noticeLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.noticeLB)
        case .SendAddress:
            self.sendAddressLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38,0,100,60))
            self.sendAddressLB.font = UIFont.systemFontOfSize(17)
            self.sendAddressLB.text = "松山湖"
            self.sendAddressLB.textAlignment = NSTextAlignment.Right
            self.sendAddressLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.sendAddressLB)
        case .BackAddress:
            self.backAddressLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38,0,100,60))
            self.backAddressLB.font = UIFont.systemFontOfSize(17)
            self.backAddressLB.text = "松山湖"
            self.backAddressLB.textAlignment = NSTextAlignment.Right
            self.backAddressLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.backAddressLB)
        case .Help:
            break
        }
        
        ZMDTool.configTableViewCellDefault(cell)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let type = self.userCenterData[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            switch type {
            case .Head :
                let actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
                actionSheet.addButtonWithTitle("从手机相册选择")
                actionSheet.addButtonWithTitle("拍照")
                actionSheet.rac_buttonClickedSignal().subscribeNext({ (index) -> Void in
                    if let indexInt = index as? Int {
                        switch indexInt {
                        case 1, 2:
                            if self.picker == nil {
                                self.picker = UIImagePickerController()
                                self.picker!.delegate = self
                            }
                            
                            self.picker!.sourceType = (indexInt == 1) ? .SavedPhotosAlbum : .Camera
                            self.picker!.allowsEditing = true
                            self.presentViewController(self.picker!, animated: true, completion: nil)
                        default: break
                        }
                    }
                })
                actionSheet.showInView(self.view)
            default: return
            }
        } else {
            type.didSelect(self.navigationController!)
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // 存储图片
        let size = CGSizeMake(image.size.width, image.size.height)
        let headImageData = UIImageJPEGRepresentation(self.imageWithImageSimple(image, scaledSize: size), 0.125) //压缩
        self.uploadUserFace(headImageData)
        self.picker?.dismissViewControllerAnimated(true, completion: nil)
        self.headerView.image = UIImage(data: headImageData!)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 上传头像
    private func uploadUserFace(imageData: NSData!) {
        if imageData == nil {
            ZMDTool.showPromptView( "上传图片数据损坏", nil)
            return
        }
        ZMDTool.showActivityView("正在上传...", inView: self.view, nil)
        
        //        QNNetworkTool.uploadDoctorImage(imageData, fileName: "" + ".jpg", type: "groupUserFace") { (dictionary, error) -> Void in
        ZMDTool.hiddenActivityView()
        //            if dictionary != nil, let errorCode = dictionary?["errorCode"] as? String where errorCode == "0" {
        //                let dict = dictionary!["data"] as! NSDictionary
        //                let urlStr = dict["url"] as! String
        //                let fileName = dict["fileName"] as! String
        //                for temp in g_currentGroup!.users {
        //                    if temp.id == self.user.id {
        //                        temp.photoURL = urlStr
        //                    }
        //                }
        //                self.updateGroupPhoto(fileName,url: urlStr)
        //                self.headerView.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "UserCenter_HeaderImage"))
        //                self.tableView.reloadData()
        //
        //            }else {
        //                QNTool.showPromptView( "上传失败,点击重试或者重新选择图片", nil)
        //            }
        //
        //        }
        
    }
    // 压缩图片
    private func imageWithImageSimple(image: UIImage, scaledSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0,0,scaledSize.width,scaledSize.height))
        let  newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    func updateGroupPhoto(fileName : String,url : String) {
        //        QNNetworkTool.updateGroupPhoto(fileName, userId: self.user.id) { (dictionary, error) -> Void in
        //            if dictionary != nil ,let errorCode = dictionary?["errorCode"] as? String where errorCode == "0"{
        //                var familys = g_currentGroup!.users
        //                familys[self.userIndex].photoURL = url
        //                g_currentGroup?.users = familys
        //                QNTool.showPromptView( "头像修改成功", nil)
        //            }else {
        //                QNTool.showErrorPromptView(dictionary, error: error, errorMsg: nil)
        //            }
        //        }
    }
    
    //MARK:- Private Method
    private func subViewInit(){
        self.title = "店铺设置"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    private func dataInit(){
        self.userCenterData = [[UserCenterCellType.Head,UserCenterCellType.NickN,UserCenterCellType.Notice, UserCenterCellType.SendAddress, UserCenterCellType.BackAddress], [UserCenterCellType.Help]]
    }
    func moreViewUpdate() {
        if self.moreView == nil {
            let titles = ["消息":UIImage(named: "common_more_message"),"首页":UIImage(named: "common_more_home")]
            let view = UIView(frame: CGRect(x:kScreenWidth-150-12, y: 0, width: 150, height: 48*CGFloat(titles.count)))
            self.moreView = view
            var i = 0
            for title in titles {
                let btn = UIButton(frame: CGRect(x: 0, y: 48*i, width: 150, height: 48))
                btn.backgroundColor = UIColor(white: 0, alpha: 0.5)
                btn.tag = i
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    self.tabBarController?.selectedIndex = 0
                })
                let imgV = UIImageView(frame: CGRect(x: 10, y: 14, width: 20, height: 20))
                imgV.image = title.1
                btn.addSubview(imgV)
                let label = UILabel(frame: CGRect(x: 40, y: 0, width: 110, height: 48))
                label.text = title.0
                label.textColor = UIColor.whiteColor()
                btn.addSubview(label)
                view.addSubview(btn)
                i++
            }
            let line = UIView(frame: CGRect(x:0, y: 48, width: 150, height: 1))
            line.backgroundColor = UIColor.whiteColor()
            self.moreView.addSubview(line)
        }
    }
    //重写
    override func gotoMore() {
        let containView = UIButton(frame: self.view.bounds)
        containView.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.dismissPopupView(self.moreView)
            containView.removeFromSuperview()
        }
        self.view.addSubview(containView)
        self.moreViewUpdate()
        self.presentPopupView(self.moreView, config: ZMDPopViewConfig())
    }
}
