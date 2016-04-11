//
//  CrowdfundingHomeViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/4/11.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 新品众筹
class CrowdfundingHomeViewController: UIViewController,ZMDInterceptorProtocol{

    enum ProjectType {
        case MyProject
        case HistoryType
        init(){
            self = MyProject
        }
    }
    var projectType = ProjectType()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -  PrivateMethod
    func updateUI() {
        self.title = "新品众筹"
        let lbl = ZMDTool.getLabel(CGRect(x: 0, y: 0, width: 70, height: 28), text: "了解众筹", fontSize: 14,textAlignment:.Center)
        lbl.backgroundColor = RGB(178,243,236,1)
        ZMDTool.configViewLayerWithSize(lbl, size: 7)
        let rightItem = UIBarButtonItem(customView: lbl)
        rightItem.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            
            return RACSignal.empty()
        })
        rightItem.customView?.tintColor = defaultTextColor
        self.navigationItem.rightBarButtonItem = rightItem
        
        let menuTitle = ["我参与的项目","历史项目"]
        let customJumpBtns = CustomJumpBtns(frame: CGRect(x: 0, y: 25, width: kScreenWidth, height: 55),menuTitle: menuTitle,textColorForNormal: UIColor.whiteColor(),textColorForSelect: UIColor.whiteColor())
        customJumpBtns.backgroundColor = UIColor.clearColor()
        customJumpBtns.addSeparatedLine(UIColor.whiteColor())
        customJumpBtns.redLine.backgroundColor = UIColor.clearColor()
        self.view.addSubview(customJumpBtns)
        customJumpBtns.finished = { (index) ->Void in
            self.projectType = [ProjectType.MyProject,ProjectType.HistoryType][index]
            
        }
        self.scrollView()
    }
    func scrollView() {
        let height = kScreenWidth - 100 + 142
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height))
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollsToTop = false
        scrollView.pagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: CGRectGetMaxY(scrollView.frame)+32, width: kScreenWidth, height: 20))
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        self.view.addSubview(pageControl)
        
        let width = kScreenWidth - 100

        
        var i = 0
        for _ in ["","",""] {
            let projectV = self.projectView((width+22)*CGFloat(i))
            scrollView.addSubview(projectV)
            i++
        }
        scrollView.contentSize = CGSizeMake(width*CGFloat(i), 0)
        pageControl.numberOfPages = i
    }
    func projectView(x:CGFloat) -> UIView {
        let width = kScreenWidth - 100,height = width + 142
        let view = UIView(frame: CGRect(x: x, y: 0, width: width, height: height))
        view.backgroundColor = UIColor.whiteColor()
        let imgV = UIImageView(frame: CGRect(x: 8, y: 8, width: width-16, height: width-16))
        imgV.backgroundColor = UIColor.grayColor()
        view.addSubview(imgV)
        
        let titleLbl = ZMDTool.getLabel(CGRect(x: 8, y: CGRectGetMaxY(imgV.frame), width: width-16, height: 17), text: "", fontSize: 17)
        view.addSubview(titleLbl)
        let hasMoneyLbl = ZMDTool.getLabel(CGRect(x: 0, y: CGRectGetMaxY(titleLbl.frame), width: width/2, height: 44), text: "", fontSize: 13,textAlignment: .Center)
        view.addSubview(hasMoneyLbl)
        view.addSubview(ZMDTool.getLine(CGRect(x: 0, y: height-44.5, width: width, height: 0.5)))
        let targetMoneyLbl = ZMDTool.getLabel(CGRect(x: 32, y: height-45, width: width - 40, height: 44), text: "", fontSize: 15)
        view.addSubview(targetMoneyLbl)
        return view
    }
    func test() {
        let ivar = class_copyIvarList(HomePageViewController.classForCoder(),nil)
        let iva = ivar[1]
        let name = ivar_getName(iva)
        
    }
}
