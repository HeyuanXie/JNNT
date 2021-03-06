//
//  MyWebViewController.swift
//  ZhiMaDi
//
//  Created by admin on 16/9/8.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
import WebKit

class MyWebViewController: UIViewController,WKNavigationDelegate,WKScriptMessageHandler,ZMDInterceptorProtocol {
    var webView : WKWebView!
    var webUrl :String!
    var userCC : WKUserContentController!
    ///如果webView自带返回按钮，是否隐藏
    var hideWebNavi = false
    
    //MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initUI()
        self.loadWebView()
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    func initUI() {
        self.configBackButton()
        self.configMoreButton()
        let titleLbl = ZMDTool.getLabel(CGRect(x: 0, y: 0, width: kScreenWidth, height: 20), text: "", fontSize: 17)
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.textAlignment = .Center
        self.navigationItem.titleView = titleLbl
    
        self.userCC = WKUserContentController()
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);user-scalable=no;"
        let userScript = WKUserScript(source: jScript, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        userCC.addUserScript(userScript)
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = userCC
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-64), configuration: config)
        self.webView.scrollView.zoomScale = 0
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(webView)
        if self.hideWebNavi {
            self.webView.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(-44)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(55)
            })
        }else{
            self.webView.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(-44)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
            })
        }
    }
    
    func loadWebView() {
        if let url = NSURL(string: self.webUrl) {
            let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 20.0)
            webView.loadRequest(request)
            ZMDTool.showActivityView(nil)
            self.addScriptMessage(self.userCC)
        }
    }
    
    func addScriptMessage(userCC:WKUserContentController) {
        userCC.addScriptMessageHandler(self, name: "openNative")
    }
    
    
    //MARK: - WKNavigationDelegate
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        ZMDTool.hiddenActivityView()
        if let title = webView.title {
            (self.navigationItem.titleView as! UILabel).text = title
        }
        NSURLCache.sharedURLCache()
    }
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        ZMDTool.hiddenActivityView()
        ZMDTool.showPromptView("数据加载错误,请稍后重试!")
    }
    
    
    //MARK: - WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == "openNative" {
            
        }
    }
    //MARK: - OverrideMethod
    override func back() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
