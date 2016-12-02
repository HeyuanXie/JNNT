//
//  CodeScanViewController.swift
//  ZhiMaDi
//
//  Created by admin on 16/11/25.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import AVFoundation
//二维码扫描页面
class CodeScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var scanRect : CGRect!
    var scanRectView : UIView!
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var input: AVCaptureDeviceInput?
    
    var scanStringValue : String!
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configBackButton()
        self.configMoreButton()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.setupCamera()
        self.session.startRunning()
    }

    
    //MARK: PrivateMethod
    func initUI() {
        self.title = "二维码扫描"
        self.view.backgroundColor = defaultGrayColor
        //计算中间可探测区域
        let rect = UIScreen.mainScreen().bounds
        let width = kScreenWidth*3/5
        self.scanRectView = UIView(frame: CGRect(x: kScreenWidth/5, y: 60+64, width: width, height: width))
        self.view.addSubview(scanRectView)
        scanRectView.layer.borderColor = UIColor.greenColor().CGColor
        scanRectView.layer.borderWidth = 1;
        let frame = scanRectView.frame
        self.scanRect = CGRectMake(frame.origin.y/rect.height, frame.origin.x/rect.width, frame.height/rect.height, frame.width/rect.width)
    }
    
    
    //MARK:设置二维码扫描相机
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        do {
            self.input = try AVCaptureDeviceInput(device: self.device)
        }
        catch {
            
        }
        if (error != nil) {
            print(error!.description)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = self.view.bounds
        self.view.layer.insertSublayer(self.layer!, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        //设置可探测区域
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.rectOfInterest = self.scanRect
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
    }
    
    
    //MARK:相机捕获代理
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){

        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if let stringValue = metadataObject.stringValue {
                self.scanStringValue = stringValue
                self.commonAlertShow(true, title: "二维码", message: "扫到内容为\(stringValue),是否立即前往?", preferredStyle: .Alert)
            }
        }else{
            self.commonAlertShow(false, title: "二维码", message: "没有扫描到内容", preferredStyle: .Alert)
        }
        self.session.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func alertDestructiveAction() {
        if let urlStr = self.scanStringValue ,url = NSURL(string: urlStr) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func gotoMore() {
        //MARK:其他类型扫码
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
