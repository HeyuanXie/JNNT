//
//  PersonIntroductionViewController.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/2.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//个人简介
class PersonIntroductionViewController: UIViewController ,UITextViewDelegate {
    
    private var inputTextView: UITextView!
    var countLbl : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人简介"
        self.view.backgroundColor = defaultBackgroundGrayColor
        self.inputTextView = UITextView(frame: CGRectMake(0, 10, self.view.frame.width, 180))
        self.inputTextView.backgroundColor = UIColor.whiteColor()
        self.inputTextView.returnKeyType = UIReturnKeyType.Done
        self.inputTextView.text = "称"
        self.inputTextView.font = UIFont.systemFontOfSize(15)
        self.inputTextView.layer.masksToBounds = true
        self.inputTextView.layer.borderColor = defaultLineColor.CGColor
        self.inputTextView.layer.borderWidth = 0.5
        self.inputTextView.delegate = self
        self.inputTextView.returnKeyType = UIReturnKeyType.Default
        self.view.addSubview(self.inputTextView)
        
        self.countLbl = UILabel(frame: CGRectMake(self.view.frame.width - 40 , CGRectGetMaxY(self.inputTextView.frame) , 30, 13))
        let count =  (("称") as NSString).length
        self.countLbl.text = "\(100 - count)/100"
        self.countLbl.font = UIFont.systemFontOfSize(13)
        self.countLbl.textColor = UIColor.grayColor()
        self.view.addSubview(self.countLbl)
        // 保存按钮
        let saveItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        saveItem.tintColor = appThemeColor
        saveItem.rac_command = RACCommand(signalBlock: { [weak self](input) -> RACSignal! in
            if let _ = self {
                self!.view.endEditing(true)
            }
            return RACSignal.empty()
            })
        self.navigationItem.rightBarButtonItem = saveItem
        
        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tap)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UItextViewdDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true;
    }
    func textViewDidChange(textView: UITextView) {
        let mulStr = NSMutableString(string: textView.text)
        self.countLbl.text = (500 - mulStr.length).description
        self.countLbl.textColor = UIColor.grayColor()
        if  500 - mulStr.length < 0 {
            self.countLbl.textColor = UIColor.redColor()
        }
    }
    //MARK:- Private Method?
    // 保存个人简介
    class func saveDocIntroduce(resume: String?, viewController: UIViewController? = nil) -> Bool {
        var tmpResume = resume as NSString?
        tmpResume = tmpResume?.stringByReplacingOccurrencesOfString(" ", withString: "")
        if tmpResume == nil || tmpResume!.length == 0 {
            ZMDTool.showPromptView("请输入内容")
            return false
        }
        if  tmpResume!.length > 100 {
            ZMDTool.showPromptView("个人简介超过100字")
            return false
        }
        // 限制输入范围在10以内
        if tmpResume!.length > 500 {
            tmpResume = tmpResume!.substringToIndex(500)
        }
        
        ZMDTool.showActivityView(nil, inView: viewController?.view)
//        QNNetworkTool.saveDocIntroduce(g_doctor!.doctorId, introduce: tmpResume as! String) { (dictionry, error, string) -> Void in
//            QNTool.hiddenActivityView()
//            if dictionry?["errorCode"] as? String == "0"  {
//                QNTool.showPromptView("保存成功", nil)
//                g_doctor!.introduce = tmpResume as? String
//                viewController!.navigationController?.popViewControllerAnimated(true)
//            }else {
//                QNTool.showErrorPromptView(nil, error: error, errorMsg: dictionry?["errorMsg"] as? String)
//            }
//        }
        
        return true
    }
}
