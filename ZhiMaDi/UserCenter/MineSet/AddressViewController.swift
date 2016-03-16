//
//  AddressViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//收货地址
class AddressViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var AddAddressBtn: UIButton!
    
    var selectAddressFinished : ((address : String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
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
        return 106
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
            
            ZMDTool.configTableViewCellDefault(cell!)
        }
        let selectBtn = cell?.viewWithTag(10003) as! UIButton
        selectBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            self.selectAddressFinished!(address: "test")
            self.navigationController?.popViewControllerAnimated(true)
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = AddressEditOrAddViewController.CreateFromMainStoryboard() as! AddressEditOrAddViewController
        vc.isAdd = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func updateUI() {
        ZMDTool.configViewLayer(self.AddAddressBtn)
    }
}
