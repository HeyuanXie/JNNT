//
//  QNNetworkTool.swift
//  SleepCare
//
//  Created by haijie on 15/12/15.
//  Copyright © 2015年 juxi. All rights reserved.
//

import UIKit
import Alamofire

/// 服务器地址
private let kServerAddress = { () -> String in
    "http://115.159.28.132:8080"
}()
// 芝麻地后台接口配置文件
/*private*/let ZMDInterface = { () -> NSDictionary in
    let plistPath = NSBundle.mainBundle().pathForResource("ZMDInterface", ofType: "plist")
    return NSDictionary(contentsOfFile: plistPath!)!
}()

class QNNetworkTool: NSObject {
}
// MARK: - 网络基础处理
private extension QNNetworkTool {
    /**
     生产共有的 URLRequest，如果是到巨细的服务器请求数据，必须使用此方法创建URLRequest
     
     :param: url    请求的地址
     :param: method 请求的方式， Get Post Put ...
     */
    private class func productRequest(url: NSURL!, method: NSString!) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method as String
//        request.addValue(g_currentGroup?.auth ?? "", forHTTPHeaderField: "AUTH") // 用户身份串,在调用/api/login 成功后会返回这个串;未登录时为空
        
        
        return request
    }
    /**
     后台返回的数据错误，格式不正确 的 NSError
     */
    private class func formatError() -> NSError {
        return NSError(domain: "后台返回的数据错误，格式不正确", code: 10087, userInfo: nil)
    }
    /**
     Post请求通用简化版
     
     :param: urlString         请求的服务器地址
     :param: parameters        请求的参数
     :param: completionHandler 请求完成后的回掉
     */
    private class func requestPOST(urlString: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?,  dictionary: NSDictionary?, error: NSError?) -> Void) {
        let url: NSURL! = NSURL(string: urlString)
        assert((url != nil), "输入的url有问题")
        requestForSelf(url, method: "POST", parameters: parameters, completionHandler: completionHandler)
    }
    /**
     Get请求通用简化版
     
     :param: urlString         请求的服务器地址
     :param: parameters        请求的参数
     :param: completionHandler 请求完成后的回掉
     */
    private class func requestGET(urlString: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?,  dictionary: NSDictionary?, error: NSError?) -> Void) {
        let url: NSURL! = NSURL(string: urlString)
        assert((url != nil), "输入的url有问题")
        requestForSelf(url, method: "GET", parameters: parameters, completionHandler: completionHandler)
    }
    /**
     将输入参数转换成字符传
     */
    private class func paramsToJsonDataParams(params: [String : AnyObject]) -> [String : AnyObject] {
        do {
//            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
//            let jsonDataString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return  params
        } catch {
        }
        return ["jsonData" : ""]
    }
    /**
     Request 请求通用简化版
     
     :param: url               请求的服务器地址
     :param: method            请求的方式 Get/Post/Put/...
     :param: parameters        请求的参数
     :param: completionHandler 请求完成后的回掉， 如果 dictionary 为nil，那么 error 就不可能为空
     */
    private class func requestForSelf(url: NSURL?, method: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, dictionary: NSDictionary?, error: NSError?) -> Void) {
        request(ParameterEncoding.URL.encode(self.productRequest(url, method: method), parameters: parameters).0).response{
            if $3 != nil {  // 直接出错了
                completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: $3); return
            }
            do {
                let jsonObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData($2! as NSData, options: NSJSONReadingOptions.MutableContainers)
                let dictionary = jsonObject as? NSDictionary
                if dictionary == nil {  // Json解析结果出错
                    completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: NSError(domain: "JSON解析错误", code: 10086, userInfo: nil)); return
                }
                completionHandler(request: $0!, response: $1, data: $2, dictionary: dictionary, error: nil)
            }
            catch {
                println("Json解析过程出错")
            }
        }
    }
}
// MARK: -
extension QNNetworkTool {
    /**
     获得此厂商所有的用户信息
     
     :param: corpId       注册成功时返回的用户ID
     */
    class func getCorpAllUserInfo(corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getCorpAllUserInfo.action", parameters: paramsToJsonDataParams(["corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     获得就寝活动信息
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getSleepActivityInfo(userId: String,date: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getSleepActivityInfo.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     获得呼吸心拍信息
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getBreathStatus(userId: String,date: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getBreathStatus.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     获得当前睡眠状态
     
     :param: userId       使用者id
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getCurrentSleepStatus(userId: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getCurrentSleepStatus.action", parameters: paramsToJsonDataParams(["userId" : userId,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     获得心跳信息
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getHeartbeatStatus(userId: String,date: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getHeartbeatStatus.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     历史生命体征数据
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: period       Int	天数（7，14，28）
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getPeriodBodyStatus(userId: String,date: String,period: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getPeriodBodyStatus.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"period" : period,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     历史睡眠状态
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: period       Int	天数（7，14，28）
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getPeriodInBed(userId: String,date: String,period: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getPeriodInBed.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"period" : period,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     历史睡眠质量
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: period       Int	天数（7，14，28）
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getPeriodSleepQuilty(userId: String,date: String,period: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getPeriodSleepQuilty.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"period" : period,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     历史睡眠质量
     
     :param: userId       使用者id
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getSleepRemind(userId: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getSleepRemind.action", parameters: paramsToJsonDataParams(["userId" : userId,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     详细--睡眠信息
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getSleepLevel(userId: String,date: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getSleepLevel.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"corpId" : corpId])) { (_, response, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     详细—睡眠阶段
     
     :param: userId       使用者id
     :param: date         时间字符串，格式是YYYY-MM-DD
     :param: corpId       厂商的id（咨询博创海云获取）
     */
    class func getSleepRange(userId: String,date: String,corpId: String,completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/SleepCareIIServer/getSleepRange.action", parameters: paramsToJsonDataParams(["userId" : userId,"date" : date,"corpId" : corpId])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                completion(dictionary, nil, nil)
            }else {
                completion(nil, self.formatError(), dictionary?["errorMsg"] as? String)
            }
        }
    }
    // MARK:test
    class func login(){
        requestPOST("http://api.ccw.cn/api/auth/login", parameters: paramsToJsonDataParams(["mobile" : "13713368658","password" : "123456"])) { (_,response, _, dictionary, error) -> Void in
            
            let head = response?.allHeaderFields
            let cookieTmp = head!["Set-Cookie"]
            // set cookie
            let properties = [NSHTTPCookieOriginURL: "http://api.ccw.cn",
                NSHTTPCookieName: "cookie_name",
                NSHTTPCookieValue: cookieTmp as! String,
                NSHTTPCookiePath : "/"]
            let cookie : NSHTTPCookie = NSHTTPCookie(properties: properties )!
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
            // get cookie
//            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        }
    }
    
}