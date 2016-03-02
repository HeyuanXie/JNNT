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
        case Name
        case Sex
        case Address
        case Resume
        
        init(){
            self = Head
        }
        
        var title : String{
            switch self{
            case Head:
                return "头像"
            case NickN:
                return "昵称"
            case Name :
                return "姓名"
            case Sex:
                return "性别"
            case Address:
                return "收货地址"
            case Resume:
                return "简介"
            }
        }

        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case Head:
                viewController = UIViewController()
            case NickN:
                viewController = UIViewController()
            case Name :
                viewController = UIViewController()
            case Sex:
                viewController = UIViewController()
            case Address:
                viewController = AddressViewController.CreateFromMainStoryboard() as! AddressViewController
            case Resume:
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
    var addressLB: UITextView!
    var descriptionLB: UILabel!
    
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
        return (section == self.userCenterData.count - 1) ? 10 : 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : tableViewCellDefaultHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
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
                self.headerView = UIImageView(frame: CGRectMake(cell.contentView.bounds.size.width - 70, 15, 50, 50))
                self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                self.headerView.layer.masksToBounds = true
                self.headerView.layer.cornerRadius = self.headerView.frame.width/2
                self.headerView.image = UIImage(named: "Home_Buy_PeopleTest")
            }
            cell.contentView.addSubview(self.headerView)
        case .NickN:
            self.nameLB = UILabel(frame: CGRectMake(0, 0, tableView.bounds.width - 120, tableViewCellDefaultHeight))
            self.nameLB.font = UIFont.systemFontOfSize(16)
            self.nameLB.text = "张三"
            self.nameLB.textAlignment = NSTextAlignment.Right
            self.nameLB.textColor = UIColor(white: 66/255, alpha: 1)
            cell.accessoryView = self.nameLB
        case .Sex:
            self.sexLB = UILabel(frame: CGRectMake(0, 0, tableView.bounds.width - 120, tableViewCellDefaultHeight))
            self.sexLB.font = UIFont.systemFontOfSize(14)
            self.sexLB.textAlignment = NSTextAlignment.Right
            
            self.sexLB.text = "女"
            self.sexLB.textColor = UIColor(white: 66/255, alpha: 1)
            cell.accessoryView = self.sexLB
        case .Address:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.addressLB = UITextView(frame: CGRectMake(0, 0, tableView.bounds.width - 120, size.height + 16))
            self.addressLB.font = UIFont.systemFontOfSize(16)
            self.addressLB.text = "松山湖"
            self.addressLB.textAlignment = NSTextAlignment.Right
            self.addressLB.textColor = UIColor(white: 66/255, alpha: 1)
            self.addressLB.editable = false
            cell.accessoryView = self.addressLB
        case .Resume:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.descriptionLB = UILabel(frame: CGRectMake(70, 20, kScreenWidth - 120, 16))
            self.descriptionLB.font = UIFont.systemFontOfSize(16)
            self.descriptionLB.text = "技术男"
            self.descriptionLB.textAlignment = NSTextAlignment.Right
            self.descriptionLB.textColor = UIColor(white: 66/255, alpha: 1)
            cell.contentView.addSubview(self.descriptionLB)
        default :
            break
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
        self.title = "个人资料"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.Head,UserCenterCellType.NickN,UserCenterCellType.Name, UserCenterCellType.Sex, UserCenterCellType.Address, UserCenterCellType.Resume]
    }
}
