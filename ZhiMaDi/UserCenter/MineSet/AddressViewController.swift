//
//  AddressViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//管理收货地址
class AddressViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,ZMDInterceptorProtocol,ZMDInterceptorNavigationBarShowProtocol,ZMDInterceptorMoreProtocol {

    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var AddAddressBtn: UIButton!
    var rightItem : UIBarButtonItem!
    
    var selectAddressFinished : ((address : String)->Void)?
    var indexDefault = 0
    var isEdit = false
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
        return 16
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 106
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 16))
        headView.backgroundColor = UIColor.clearColor()
        return headView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! AdressTableViewCell
        if !self.isEdit {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.editBtnWidthConstraint.constant = 0
                cell.selectedBtn.setImage(UIImage(named: "common_01unselected"), forState: .Normal)
                cell.selectedBtn.setImage(UIImage(named: "common_02selected"), forState: .Selected)
                cell.layoutIfNeeded()
            })
            if self.indexDefault == indexPath.section {
                cell.selectedBtn.selected = true
            }
            cell.selectedBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.editBtnWidthConstraint.constant = 60
                cell.selectedBtn.setImage(UIImage(named: "btn_delete"), forState: .Normal)
                cell.selectedBtn.setImage(UIImage(named: "btn_delete"), forState: .Selected)
                cell.layoutIfNeeded()
            })
            cell.editBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            })
            //delete
            cell.selectedBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in

            }
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK: -  Action
    @IBAction func addAddressBtnCli(sender: UIButton) {
        let vc = AddressEditOrAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -  PrivateMethod
    func updateUI() {
        if self.rightItem == nil {
            self.rightItem = UIBarButtonItem(title:"编辑", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
            rightItem.customView?.tintColor = defaultDetailTextColor
            rightItem.rac_command = RACCommand(signalBlock: { [weak self](sender) -> RACSignal! in
                if let StrongSelf = self {
                    StrongSelf.isEdit = !StrongSelf.isEdit
                    StrongSelf.currentTableView.reloadData()
                    StrongSelf.rightItem.title = StrongSelf.isEdit ? "取消" : "编辑"
                }
                return RACSignal.empty()
            })
            self.navigationItem.rightBarButtonItem = rightItem
        }
        self.currentTableView.backgroundColor = tableViewdefaultBackgroundColor
    }
}
