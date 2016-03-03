//
//  PersonAuthenticationViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class PersonAuthenticationViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol{
   
    var leftPhotoBtn : UIButton!
    var midPhotoBtn : UIButton!
    var rightPhotoBtn : UIButton!
    
    var picker : UIImagePickerController?
    
    var photoSelectbtn : UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 4
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 180
        case 2:
            return 620
        case 3:
            return 200
        default :
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellId = "topCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            return cell!
        case 1 :
            let cellId = "cardCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let leftPhotoBtn = cell?.viewWithTag(10001) as! UIButton
            let midPhotoBtn = cell?.viewWithTag(10002) as! UIButton
            let rightPhotoBtn = cell?.viewWithTag(10003) as! UIButton
            self.leftPhotoBtn = leftPhotoBtn
            self.midPhotoBtn = midPhotoBtn
            self.rightPhotoBtn = rightPhotoBtn
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
            self.leftPhotoBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.photoSelectbtn = leftPhotoBtn
                actionSheet.showInView(self.view)
            })
            self.midPhotoBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.photoSelectbtn = midPhotoBtn
                actionSheet.showInView(self.view)
            })
            self.rightPhotoBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                self.photoSelectbtn = rightPhotoBtn
                actionSheet.showInView(self.view)
            })

            return cell!
        case 2 :
            let instructions = "1、照片内容真实有效,清晰,不得做任何修改\n2、支持jpg、jpeg、bmp、gif格式照片,大小不超过2M\n3、合照需按照图例方式双手持身份证, 手指不可遮挡身份证信息\n4、照片需免冠,未化妆,五官清晰可见"
            let sizeInstructions = instructions.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: kScreenWidth - 24)
            let cellId = "InstructionCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            let instructionLbl = cell?.viewWithTag(10001) as! UILabel
            instructionLbl.text = instructions
            return cell!
        case 3 :
            let instructions = "1、照片内容真实有效,清晰,不得做任何修改\n2、支持jpg、jpeg、bmp、gif格式照片,大小不超过2M\n3、合照需按照图例方式双手持身份证, 手指不可遮挡身份证信息\n4、照片需免冠,未化妆,五官清晰可见"
            let sizeInstructions = instructions.sizeWithFont(UIFont.systemFontOfSize(14), maxWidth: kScreenWidth - 24)
            let cellId = "ConfirmCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            
            return cell!
        default :
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // 存储图片
        let size = CGSizeMake(image.size.width, image.size.height)
        let headImageData = UIImageJPEGRepresentation(self.imageWithImageSimple(image, scaledSize: size), 0.125) //压缩
        self.uploadUserFace(headImageData)
        self.picker?.dismissViewControllerAnimated(true, completion: nil)
//        self.headerView.image = UIImage(data: headImageData!)
        self.photoSelectbtn?.setImage(UIImage(data: headImageData!), forState: .Normal)
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
}
