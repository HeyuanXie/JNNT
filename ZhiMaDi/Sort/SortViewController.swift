//
//  SortViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/29.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class SortViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,QNInterceptorProtocol,QNInterceptorNavigationBarShowProtocol,QNInterceptorMsnProtocol{
    
    var collectView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.title = "分类"
        self.configMsgButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UICollectionViewDataSource UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()

        let img = UIImage(named: "apple")
        let btn = ZMDTool.getBtn()
    
        btn.backgroundColor = UIColor.clearColor()
        btn.frame = cell.bounds
        //UIButton(frame: cell.bounds)
        btn.setTitle("苹果", forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setImage(img, forState:.Normal)
        cell.addSubview(btn)
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(kScreenWidth/3 - 8, kScreenWidth/3)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let homeBuyListViewController = HomeBuyListViewController.CreateFromMainStoryboard() as! HomeBuyListViewController
        self.navigationController?.pushViewController(homeBuyListViewController, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 0.0
        self.collectView = UICollectionView(frame: CGRectMake(0, 72,kScreenWidth,self.view.bounds.height - 60), collectionViewLayout: flowLayout)
        self.collectView.backgroundColor = UIColor.clearColor()
        self.collectView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectView.delegate = self
        self.collectView.dataSource = self
        self.view.addSubview(collectView)
        
        let searchBar = UISearchBar(frame: CGRectMake(12, 14, kScreenWidth - 24, 38))
        searchBar.backgroundImage = UIImage.imageWithColor(UIColor.clearColor(), size: searchBar.bounds.size)
        searchBar.placeholder = "商品搜索"
        searchBar.layer.borderColor = UIColor.grayColor().CGColor;
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 6
        searchBar.layer.masksToBounds = true
        self.view.addSubview(searchBar)
        
    }
}
