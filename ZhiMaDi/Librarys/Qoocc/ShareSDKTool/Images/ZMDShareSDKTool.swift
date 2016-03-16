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
            activePlatforms: [
                SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,
                SSDKPlatformType.TypeQQ.rawValue,
                ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform{
                    
                case SSDKPlatformType.TypeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("568898243",
                        appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
                        redirectUri : "http://www.sharesdk.cn",
                        authType : SSDKAuthTypeBoth)
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wxc59280c42692603a", appSecret: "3cfd85fd1dd235f1ec572bb885d8c271")
                case SSDKPlatformType.TypeQQ:
                    //设置QQ应用信息
                    appInfo.SSDKSetupQQByAppId("100371282",
                        appKey : "aed9b0303e3ed1e27bae87c33761161d",
                        authType : SSDKAuthTypeWeb)
                default:
                    break
                }
        })
    }
    //分享菜单 默认形式
    class func shareWithMenu(view : UIView!) {
        //1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Auto)
        //2.进行分享
        ShareSDK.showShareActionSheet(view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("分享成功")
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    }
    class func simpleShare() {
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
                print("分享成功")
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
                alert.show()
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    }

}
