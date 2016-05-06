//
//  MyStoreAddLeaseViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/5/3.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import MWPhotoBrowser
// 添加出租商品
class MyStoreAddLeaseViewController:UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZMDInterceptorProtocol,ZMDInterceptorMoreProtocol,MWPhotoBrowserDelegate {
    enum CellType {
        case GoodsPhoto,Name,Sort,Old,Price,PackagePhoto,PackageContent,LeaseTime,GoodsId,Count,Add,PricePlan,OldPlan,FreightSet,Agree
        var title : String {
            switch self {
            case GoodsPhoto :
                return ""
            case Name :
                return "商品名称"
            case Sort :
                return "所属分类"
            case Old :
                return "新旧"
            case Price :
                return "原价(元)"
            case PackagePhoto :
                return "套餐商品图："
            case PackageContent :
                return "内容："
            case LeaseTime :
                return "租期："
            case GoodsId :
                return "商品货号："
            case Count :
                return "库存量(件)："
            case Add :
                return ""
            case PricePlan :
                return "租金方案："
            case OldPlan :
                return "折旧方案："
            case FreightSet :
                return "运费设置："
            case Agree :
                return "同意葫芦堡"
            }
        }
        var heigth : CGFloat {
            switch self {
            case GoodsPhoto :
                return 128
            case Name :
                return 56
            case Sort :
                return 56
            case Old :
                return 56
            case Price :
                return 56
            case PackagePhoto :
                return 56
            case PackageContent :
                return 56
            case LeaseTime :
                return 56
            case GoodsId :
                return 56
            case Count :
                return 56
            case Add :
                return 56
            case PricePlan :
                return 56
            case OldPlan :
                return 56
            case FreightSet :
                return 56
            case Agree :
                return 56
            }
        }

        
    }
    var currentTableView: UITableView!
    var pickBtn : UIButton!
    let picker: UIImagePickerController = UIImagePickerController()
    var photoView: UIView!
    var goodsNameTf,sortTf,packageContentTf,LeasePriceTf,CountTf,planTf,oldPlanTf : UITextField!
    var oldBtn,priceBtn : UIButton!
    var tmp : UIButton!
    var photos : NSMutableArray = NSMutableArray()
    let cellTypes = [[CellType.GoodsPhoto,.Name,.Sort],[.Old,.Price],[.PackagePhoto,.PackageContent,.LeaseTime,.GoodsId,.Count,.Add],[.PricePlan,.OldPlan],[.FreightSet,.Agree]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.subViewInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UITableViewDataSource.,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypes[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellTypes.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellTypes[indexPath.section][indexPath.row].heigth
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let type = self.cellTypes[indexPath.section][indexPath.row]
        switch type {
        case .GoodsPhoto :
            return self.cellForGoodsPhoto(tableView, cellForRowAtIndexPath: indexPath)
        case .Name :
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel!.text = type.title
            return cell!
        case .Sort :
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            if self.sortTf == nil {
                self.sortTf = ZMDTool.getTextField(CGRect(x: 110, y: 0, width: kScreenWidth - 100 - 12, height: 56), placeholder: "请输入商品名称", fontSize: 17)
                self.sortTf.textAlignment = .Right
                cell?.contentView.addSubview(self.sortTf)
            }
            return cell!
//        case Old :
//            return "新旧"
//        case Price :
//            return "原价(元)"
//        case PackagePhoto :
//            return "套餐商品图："
//        case PackageContent :
//            return "内容："
//        case LeaseTime :
//            return "租期："
//        case GoodsId :
//            return "商品货号："
//        case Count :
//            return "库存量(件)："
//        case Add :
//            return ""
//        case PricePlan :
//            return "租金方案："
//        case OldPlan :
//            return "折旧方案："
//        case FreightSet :
//            return "运费设置："
//        case Agree :
//            return "同意葫芦堡"
        default :
            let cellId = "OtherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.selectionStyle = .None
                
                ZMDTool.configTableViewCellDefault(cell!)
            }
            cell?.textLabel!.text = type.title
            return cell!
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
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
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let size = CGSizeMake(image.size.width, image.size.height)
        let headImageData = UIImageJPEGRepresentation(image.imageWithImageSimple(size), 0.125)
        photos.addObject(UIImage(data: headImageData!)!)
        self.currentTableView.reloadData()
        //        self.uploadImg(headImageData)
        self.picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: -  PrivateMethod
    //MARK: - cellForGoodsPhoto
    func cellForGoodsPhoto(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "GoodsPhotoCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell!.selectionStyle = .None
            cell?.contentView.backgroundColor = RGB(240,240,240,1)
            
            let spacing = CGFloat(12)
            let width = (kScreenWidth-12*6)/5
            let height = width
            var tag = 10001
            self.photoView = UIView(frame: CGRect(x: 0, y: 15, width: kScreenWidth, height: height))
            for var i = 0 ; i < 5; i++ {
                let x  =  width * CGFloat(i)  + spacing * (CGFloat(i) + 1)
                let btn: UIButton = UIButton(type: .Custom)
                btn.frame = CGRectMake(x, 0, width , height)
                btn.tag = tag++
                let deleteBtn = UIButton(frame: CGRect(x: width-3-18, y: 3, width: 18, height: 18))
                deleteBtn.setImage(UIImage(named: "common_delete_pho"), forState: .Normal)
                deleteBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
                    self.photos.removeObjectAtIndex(sender.tag - 11000)
                    self.currentTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                })
                deleteBtn.hidden = true
                deleteBtn.tag = 11000+i
                btn.addSubview(deleteBtn)
                self.photoView.addSubview(btn)
                btn.hidden = true
            }
            cell?.contentView.addSubview(self.photoView)
            let lbl = ZMDTool.getLabel(CGRect(x: 12, y: CGRectGetMaxY(self.photoView.frame)+8, width: kScreenWidth-24, height: 14), text: "上传商品图(按住拖动可更换顺序，最多可上传5张)", fontSize: 14)
            cell?.contentView.addSubview(lbl)
        }
        var tag = 10001
        for var i = 0 ; i < 5; i++ {
            let btn = self.photoView.viewWithTag(tag++) as! UIButton
            if i < self.photos.count {
                btn.hidden = false
                btn.viewWithTag(11000+i)?.hidden = false
                btn.setImage(self.photos[i] as? UIImage, forState: .Normal)
                btn.rac_command = RACCommand(signalBlock: { [weak self](input) -> RACSignal! in
                    if let strongSelf = self {
                        // Create browser
                        let browser = PhotoBroswerViewController(delegate: self)
                        browser.photos = strongSelf.photos.count
                        browser.setCurrentPhotoIndex(UInt((input as! UIButton).tag - 1))
                        browser.deleteImages = {(index)-> Void in
                            strongSelf.photos.removeObjectAtIndex(index)
                            strongSelf.currentTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                        strongSelf.navigationController?.pushViewController(browser, animated: true)
                    }
                    return RACSignal.empty()
                    });
            } else if i == self.photos.count {
                btn.hidden = false
                btn.viewWithTag(11000+i)?.hidden = true
                btn.backgroundColor = UIColor.clearColor()
                btn.setImage(UIImage(named: "common_add_pho"), forState: .Normal)
                btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
                    if let strongSelf = self {
                        let actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
                        actionSheet.addButtonWithTitle("从手机相册选择")
                        actionSheet.addButtonWithTitle("拍照")
                        actionSheet.rac_buttonClickedSignal().subscribeNext({ (index) -> Void in
                            if let indexInt = index as? Int {
                                switch indexInt {
                                case 1, 2:
                                    strongSelf.picker.delegate = self
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
            } else {
                btn.hidden = true
            }
            
        }
        return cell!
    }
    private func subViewInit(){
        self.title = "添加出租商品"
        self.currentTableView = UITableView(frame: self.view.bounds)
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
        self.currentTableView.separatorStyle = .None
        self.currentTableView.dataSource = self
        self.currentTableView.delegate = self
        self.view.addSubview(self.currentTableView)
        
        let btn = ZMDTool.getButton(CGRect(x: 0, y: 0, width: 72, height: 17), textForNormal: "预览", fontSize: 17, backgroundColor: UIColor.clearColor()) { (sender) -> Void in
            
        }
        let item = UIBarButtonItem(customView: btn)
        item.customView?.tintColor = defaultDetailTextColor
        self.navigationItem.rightBarButtonItem = item
    }
}

