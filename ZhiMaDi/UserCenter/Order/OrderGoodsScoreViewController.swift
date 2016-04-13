//
//  OrderGoodsScoreViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/13.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import MWPhotoBrowser
// 商品评分
class OrderGoodsScoreViewController: UIViewController,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate {
    
    var scoreTextField : UITextField!
    var pickBtn : UIButton!
    let picker: UIImagePickerController = UIImagePickerController()
    var photoView: UIView!
    var tmp : UIButton!
    var goodsScoreRigthLbl : UILabel!
    var logisticsScoreRigthLbl : UILabel!
    var photos : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let size = CGSizeMake(image.size.width, image.size.height)
        let headImageData = UIImageJPEGRepresentation(image.imageWithImageSimple(size), 0.125)
        photos.addObject(UIImage(data: headImageData!)!)
        self.configurePhotoBtn()
//        self.uploadImg(headImageData)
        self.picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - MWPhotoBrowserDelegate
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photos.count)
    }
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < self.photos.count {
            let photo:MWPhoto = MWPhoto(image: self.photos[Int(index)] as! UIImage)
            return photo
        }
        return nil
    }
    func photoBrowserDidFinishModalPresentation(photoBrowser:MWPhotoBrowser) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "商品评分"
        self.view.backgroundColor = RGB(245,245,245,1)
        self.picker.delegate = self
        let headViewBg = UIView(frame: CGRect(x: 12, y: 15, width: kScreenWidth-24, height: 270))
        headViewBg.backgroundColor = UIColor.whiteColor()
        ZMDTool.configViewLayer(headViewBg)
        ZMDTool.configViewLayerFrame(headViewBg)
        self.view.addSubview(headViewBg)
        self.scoreTextField = ZMDTool.getTextField(CGRect(x: 16, y: 15, width: CGRectGetWidth(headViewBg.frame), height: 150), placeholder: "感谢您的宝贵评价~", fontSize: 17)
        self.scoreTextField.contentVerticalAlignment = .Top //方向
        headViewBg.addSubview(self.scoreTextField)
        
        photoView = UIView(frame: CGRect(x: 0, y: 150, width: kScreenWidth-24, height: 116))
        photoView.backgroundColor = UIColor.clearColor()
        headViewBg.addSubview(photoView)
        self.configurePhotoBtn()
        let goodsScoreTitleLbl = ZMDTool.getLabel(CGRect(x: 12, y: CGRectGetMaxY(headViewBg.frame)+27, width: 96, height: 17), text: "商品质量", fontSize: 17)
        self.view.addSubview(goodsScoreTitleLbl)
        let goodsScoreView = GoodsScoreView(frame: CGRect(x: 108, y: CGRectGetMaxY(headViewBg.frame)+22, width: 32*5, height: 26)){(str) ->Void in
            self.goodsScoreRigthLbl.text = str as String
        }
        self.view.addSubview(goodsScoreView)
        self.goodsScoreRigthLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 96, y: CGRectGetMaxY(headViewBg.frame)+27, width: 96, height: 17), text: "满意", fontSize: 17,textColor: defaultDetailTextColor,textAlignment: .Right)
        self.view.addSubview(goodsScoreRigthLbl)
        
        // 物流评分
        let logisticsitleLbl = ZMDTool.getLabel(CGRect(x: 12, y: CGRectGetMaxY(goodsScoreTitleLbl.frame)+32, width: 96, height: 17), text: "物流服务", fontSize: 17)
        self.view.addSubview(logisticsitleLbl)
        let logisticsScoreView = GoodsScoreView(frame: CGRect(x: 108, y: CGRectGetMaxY(goodsScoreTitleLbl.frame)+22, width: 32*5, height: 26)){(str) ->Void in
            self.logisticsScoreRigthLbl.text = str as String
        }
        self.view.addSubview(logisticsScoreView)
        self.logisticsScoreRigthLbl = ZMDTool.getLabel(CGRect(x: kScreenWidth - 12 - 96, y: CGRectGetMaxY(goodsScoreTitleLbl.frame)+32, width: 96, height: 17), text: "满意", fontSize: 17,textColor: defaultDetailTextColor,textAlignment: .Right)
        self.view.addSubview(logisticsScoreRigthLbl)
    }
    func configurePhotoBtn(){
        if self.pickBtn == nil {
            self.pickBtn = UIButton(type: .Custom)
            pickBtn.backgroundColor = UIColor.clearColor()
            pickBtn.frame =  CGRectMake(8, 10, 75 , 75)
            pickBtn.setImage(UIImage(named: "common_add_pho"), forState: .Normal)
            self.pickBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
                if let strongSelf = self {
                    let actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
                    actionSheet.addButtonWithTitle("从手机相册选择")
                    actionSheet.addButtonWithTitle("拍照")
                    actionSheet.rac_buttonClickedSignal().subscribeNext({ (index) -> Void in
                        if let indexInt = index as? Int {
                            switch indexInt {
                            case 1, 2:
                                strongSelf.picker.sourceType = (indexInt == 1) ? .SavedPhotosAlbum : .Camera
                                //strongSelf.picker.allowsEditing = true
                                strongSelf.presentViewController(strongSelf.picker, animated: true, completion: nil)
                            default: break
                            }
                        }
                    })
                    actionSheet.showInView(strongSelf.view)
                }
            }
            self.photoView.addSubview(self.pickBtn)
        }
        if self.photos.count > 0 {
            let y: CGFloat = 10
            let padding = (CGRectGetWidth(photoView.frame) - 75*3) / 4
            for var i = 0 ; i < self.photos.count; i++ {
                let x : CGFloat =  CGFloat(75 * i  + Int(padding) * (i + 1) )
                let imgV: UIButton = UIButton(type: .Custom)
                imgV.frame = CGRectMake(x, y, 75 , 75)
                imgV.tag = i+1
                imgV.setImage(self.photos[i] as? UIImage, forState: .Normal)
                imgV.rac_command = RACCommand(signalBlock: { [weak self](input) -> RACSignal! in
                    if let strongSelf = self {
                        // Create browser
                        let  browser = PhotoBroswerViewController(delegate: self)
                        browser.photos = strongSelf.photos.count
                        browser.setCurrentPhotoIndex(UInt((input as! UIButton).tag - 1))
                        browser.deleteImages = {(index)-> Void in
                            strongSelf.photos.removeObjectAtIndex(index)
                            strongSelf.configurePhotoBtn()
                        }
                        strongSelf.navigationController?.pushViewController(browser, animated: true)
                    }
                    return RACSignal.empty()
                    });
                
                self.photoView.addSubview(imgV)
                self.pickBtn.frame = CGRectMake(x + 75 + padding, y, 75 , 75)
                self.pickBtn.hidden = i == 2 ? true : false
                //
                self.tmp = imgV
            }
        }else {
            self.pickBtn.frame = CGRectMake(8, 10, 75 , 75)
            self.pickBtn.hidden = false
        }
    }
}
