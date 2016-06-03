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
    var isEdit = false
    var addresses = NSMutableArray()
    var selectIndex = 0
    var finished : ((addressId:Int)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.fetchData()
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
        return self.addresses.count
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
        let address = self.addresses[indexPath.section] as! ZMDAddress
        AdressTableViewCell.configCell(cell, address: address)
        cell.selectedBtn.selected = indexPath.section == self.selectIndex
        if !self.isEdit {
            cell.editBtn.hidden = true
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.editBtnWidthConstraint.constant = 12
                cell.selectedBtn.setImage(UIImage(named: "common_01unselected"), forState: .Normal)
                cell.selectedBtn.setImage(UIImage(named: "common_02selected"), forState: .Selected)
                cell.layoutIfNeeded()
            })
            //delete
            cell.selectedBtn.tag = 1000 + indexPath.section
            cell.selectedBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                self.selectIndex = sender.tag - 1000
                self.currentTableView.reloadData()
                return RACSignal.empty()
            })
        } else {
            // 编辑
            cell.editBtn.hidden = false
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.editBtnWidthConstraint.constant = 60
                cell.selectedBtn.setImage(UIImage(named: "btn_delete"), forState: .Normal)
                cell.selectedBtn.setImage(UIImage(named: "btn_delete"), forState: .Selected)
                cell.layoutIfNeeded()
            })
            cell.editBtn.tag = 1000 + indexPath.section
            cell.editBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                let address = self.addresses[sender.tag - 1000] as! ZMDAddress
                let vc = AddressEditOrAddViewController()
                vc.isAdd = false
                vc.address = address
                self.navigationController?.pushViewController(vc, animated: true)
                return RACSignal.empty()
            })
            //delete
            cell.selectedBtn.tag = 1000 + indexPath.section
            cell.selectedBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                let address = self.addresses[sender.tag - 1000] as! ZMDAddress
                QNNetworkTool.deleteAddress(address.Id!.integerValue, customerId: g_customerId!, completion: { (succeed, dictionary,error) -> Void in
                    if error == nil {
                        self.fetchData()
                        ZMDTool.showPromptView("删除成功")
                    } else {
                        ZMDTool.showErrorPromptView(nil, error: error, errorMsg: "")
                    }
                })
                return RACSignal.empty()
            })
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    //MARK: -  Action
    @IBAction func addAddressBtnCli(sender: UIButton) {
        let vc = AddressEditOrAddViewController()
        vc.isAdd = true
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
    func fetchData() {
        QNNetworkTool.fetchAddresses { (addresses, error, dictionary) -> Void in
            if addresses != nil {
                self.addresses.removeAllObjects()
                self.addresses.addObjectsFromArray(addresses! as [AnyObject])
                var index = -1
                for address in self.addresses {
                    index++
                    if (address as! ZMDAddress).IsDefault.boolValue {
                        self.selectIndex = index
                    }
                }
                self.currentTableView.reloadData()
            } else {
                ZMDTool.showErrorPromptView(nil, error: error, errorMsg: "")
            }
        }
    }
    override func back() {
        if self.addresses.count != 0 {
            let address = self.addresses[self.selectIndex] as! ZMDAddress
            if self.finished != nil {
                self.finished!(addressId: address.Id!.integerValue)
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
