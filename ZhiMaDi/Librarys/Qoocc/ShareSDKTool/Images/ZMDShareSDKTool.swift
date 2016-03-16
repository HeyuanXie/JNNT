//
//  ZMDShareSDKTool.swift
//  ZhiMaDi
//
//  Created by haijie on 16/3/15.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
//单例
private let shareSDKTool = ZMDShareSDKTool()
class ZMDShareSDKTool: NSObject {
    class func startShare() {
        shareSDKTool
    }
    override init() {
        super.init()
        ShareSDK.registerApp("c46314899f04",
            activePlatforms: [SSDKPlatformType.TypeWechat.rawValue,],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform{
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                    break
                    
                default:
                    break
                    
                }
        })

    }
    class func share() {
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Image)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.TypeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            switch state{
            case SSDKResponseState.Success:
                println("分享成功")
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
                alert.show()
            case SSDKResponseState.Fail:    println("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  println("分享取消")
            default:
                break
            }
        }
    }
}
