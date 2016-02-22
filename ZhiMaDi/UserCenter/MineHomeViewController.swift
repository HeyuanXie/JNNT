//
//  MineViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/22.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class MineHomeViewController: UIViewController,QNInterceptorProtocol,UICollectionViewDelegate,UICollectionViewDataSource{
    enum UserCenterCellType{
        case NewProduct
        case Exchange
        case Goods
        case OfferCenter
        case Financia
        case Customer
        case Data
        case Order
        
        init(){
            self = NewProduct
        }
        
        var title : String{
            switch self{
            case NewProduct:
                return "新品发布"
            case Exchange:
                return "我要换手"
            case Goods:
                return "商品管理"
            case OfferCenter:
                return "报价中心"
            case Financia:
                return "财务管理"
            case Customer:
                return "客户管理"
            case Data:
                return "数据中心"
            case Order:
                return "订单管理"
            }
        }
        
        var image : UIImage?{
            switch self{
            case NewProduct:
                return UIImage(named: "MineHome_NewProduct")
            case Exchange:
                return UIImage(named: "MineHome_Exchange")
            case Goods:
                return UIImage(named: "MineHome_GoodsManagement")
            case OfferCenter:
                return UIImage(named: "MineHome_OfferCenter")
            case Financia:
                return UIImage(named: "MineHome_FinancialManagement")
            case Customer:
                return UIImage(named: "MineHome_CustomerManagement")
            case Data:
                return UIImage(named: "MineHome_DataCenter")
            case Order:
                return UIImage(named: "MineHome_OrderManagement")
            }
        }
        
        var pushViewController :UIViewController{
            let viewController: UIViewController
            switch self{
            case NewProduct:
                viewController = UIViewController()
            case NewProduct:
                viewController = UIViewController()
            case Exchange:
                viewController = UIViewController()
            case Goods:
                viewController = UIViewController()
            case OfferCenter:
                viewController = UIViewController()
            case Financia:
                viewController = UIViewController()
            case Customer:
                viewController = UIViewController()
            case Data:
                viewController = UIViewController()
            case Order:
                viewController = UIViewController()
            }
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        
        func didSelect(navViewController:UINavigationController){
            navViewController.pushViewController(self.pushViewController, animated: true)
        }
    }

    var currentCollectionV : UICollectionView!
    var cellWidth : CGFloat!
    var userCenterData: [UserCenterCellType]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentCollectionV?.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.configureUI()
        self.dataInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MineCollectionViewCell
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let userCellType = self.userCenterData[indexPath.row]
        cell.button.setImage(userCellType.image, forState: .Normal)
        return cell
    }
    //返回HeadView的宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: kScreenWidth/3, height: kScreenWidth/3)
    }
    //返回自定义HeadView或者FootView，我这里以headview为例
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        var v = MineHomeHeadView()
        if kind == UICollectionElementKindSectionHeader{
            v = currentCollectionV!.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headView", forIndexPath: indexPath) as! MineHomeHeadView
        }
        return v
    }
    //返回cell 上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0,0,0)
    }
    //MARK:
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let userCellType = self.userCenterData[indexPath.row]
        userCellType.didSelect(self.navigationController!)
    }
    //MARK:Private Method
    func configureUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(kScreenWidth/3, kScreenWidth/3)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing       = 0.0;
        layout.minimumInteritemSpacing  = 0.0;
        currentCollectionV = UICollectionView(frame: CGRectMake(0, 0, kScreenWidth, self.view.bounds.height - 44), collectionViewLayout: layout)
        //注册一个cell
        currentCollectionV! .registerClass(MineCollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        //注册一个headView
        currentCollectionV! .registerClass(MineHomeHeadView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        currentCollectionV?.delegate = self;
        currentCollectionV?.dataSource = self;
        
        currentCollectionV?.backgroundColor = UIColor.whiteColor()
        //设置每一个cell的宽高
        self.view .addSubview(currentCollectionV!)
//        self .getData()
    }
    private func dataInit(){
        self.userCenterData = [UserCenterCellType.NewProduct,UserCenterCellType.Exchange,UserCenterCellType.Goods, UserCenterCellType.OfferCenter, UserCenterCellType.Financia, UserCenterCellType.Customer,UserCenterCellType.Data,UserCenterCellType.Order]
    }
}
