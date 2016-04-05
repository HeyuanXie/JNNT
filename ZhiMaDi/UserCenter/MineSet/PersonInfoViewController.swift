//
//  PersonInfoViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/1.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//个人资料
class PersonInfoViewController:UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {
    enum UserCenterCellType{
        case Head
        case NickN
        case RealName
        case ChangePs
        case Address
        case Clean
        
        init(){
            self = Head
        }
        
        var title : String{
            switch self{
            case Head:
                return "头像"
            case NickN:
                return "昵称"
            case RealName :
                return "实名认证"
            case ChangePs:
                return "修改登陆密码"
            case Address:
                return "管理收货地址"
                
            case Clean:
                return "清理缓存"
            }
        }

        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Head:
                viewController = UIViewController()
            case NickN:
                viewController = UIViewController()
            case RealName :
                viewController = RealAuthenticationViewController()
            case ChangePs:
                viewController = UIViewController()
            case Address:
                viewController = AddressViewController.CreateFromMainStoryboard() as! AddressViewController
            case Clean:
                viewController = PersonIntroductionViewController()
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
    var sexLB: UILabel!
    var addressLB: UILabel!
    var descriptionLB: UILabel!
    var moreView :UIView!
    var picker: UIImagePickerController?
    
    var userCenterData: [UserCenterCellType]!
    
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
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == self.userCenterData.count - 1) ? 16 : 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 85 : tableViewCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell\(indexPath.row)\(indexPath.section)"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            ZMDTool.configTableViewCellDefault(cell)
            cell.selectionStyle = .None
        }
        
        let content = self.userCenterData[indexPath.section]
        
        cell.textLabel?.text = content.title
        switch content {
        case .Head:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if self.headerView == nil {
                self.headerView = UIImageView(frame: CGRectMake(kScreenWidth - 60 - 38 - 19 , 17, 60, 60))
                self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                self.headerView.layer.masksToBounds = true
                self.headerView.layer.cornerRadius = self.headerView.frame.width/2
                self.headerView.image = UIImage(named: "Home_Buy_PeopleTest")
            }
            cell.contentView.addSubview(self.headerView)
        case .NickN:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.nameLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38 , 0, 100, tableViewCellDefaultHeight))
            self.nameLB.font = UIFont.systemFontOfSize(17)
            self.nameLB.text = "张三"
            self.nameLB.textAlignment = NSTextAlignment.Right
            self.nameLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.nameLB)
        case .RealName:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.sexLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38, 0,100, tableViewCellDefaultHeight))
            self.sexLB.font = UIFont.systemFontOfSize(17)
            self.sexLB.textAlignment = NSTextAlignment.Right
            self.sexLB.text = "未认证"
            self.sexLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.sexLB)
        case .Address:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.addressLB = UILabel(frame: CGRectMake(kScreenWidth - 100 - 38,0,100,tableViewCellDefaultHeight))
            self.addressLB.font = UIFont.systemFontOfSize(17)
            self.addressLB.text = "松山湖"
            self.addressLB.textAlignment = NSTextAlignment.Right
            self.addressLB.textColor = defaultDetailTextColor
            cell.contentView.addSubview(self.addressLB)
        case .ChangePs:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case .Clean:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        ZMDTool.configTableViewCellDefault(cell)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let type = self.userCenterData[indexPath.section]
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
        self.title = "个人设置"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.Head,UserCenterCellType.NickN,UserCenterCellType.RealName, UserCenterCellType.Address, UserCenterCellType.ChangePs, UserCenterCellType.Clean]
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
