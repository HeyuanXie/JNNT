//
//  QNNetworkTool.swift
//  SleepCare
//
//  Created by haijie on 15/12/15.
//  Copyright © 2015年 juxi. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

/// 服务器地址
private let kServerAddress = { () -> String in
//  "http://od.ccw.cn"
    "http://xw.ccw.cn"  // 伟
}()
private let kOdataAddress = { () -> String in
    kServerAddress + "/odata/v1"
}()
// 图片地址
let kImageAddressMain = { () -> String in
    kServerAddress
}()
//yyyy-MM-ddTHH:mm:ss.
let publicKey = "c81de5387d36d1ec6a4ad4d483ffae0a";
let secretKey = "6cb0c990dc6ec7e99e5cf3a9ec6260ae";
let method = "get";
let accept = "application/json, text/javascript, */*";
let timestamp = QNFormatTool.dateString02(NSDate(),format: "yyyy-MM-dd") + "T" + QNFormatTool.dateString02(NSDate(),format: "HH:mm:ss") + ".0000000+08:00"
let timestamp02 = QNFormatTool.dateString02(NSDate(),format: "yyyy-MM-dd") + "T" + QNFormatTool.dateString02(NSDate(),format: "HH:mm:ss") + ".0000000"
// string url = "http://od.ccw.cn/odata/v1/Orders?$top=10&$filter=CreatedOnUtc+lt+datetime'2016-02-20T00:00:00'";
let urlTmp = "http://od.ccw.cn/odata/v1/Orders?$top=10&$filter=CreatedOnUtc+lt+datetime'\(timestamp02)'";

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
        let tmp = [method as String,"",accept,urlTmp,timestamp,publicKey]
        var messageRepresentation = ""
        for str in tmp {
            if str != publicKey {
                messageRepresentation = messageRepresentation + str.lowercaseString + "&"
            } else {
                messageRepresentation = messageRepresentation + str.lowercaseString
            }
        }
//
        let signature = messageRepresentation.hmac(CryptoAlgorithm.SHA256, key: secretKey)
//        let data = NSString(string: signature).dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
//        signature = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        request.addValue("SmNetHmac1 \(signature)", forHTTPHeaderField: "Authorization")
        request.addValue("My shopping data consumer v.1.0", forHTTPHeaderField: "UserAgent")
        request.addValue(accept, forHTTPHeaderField: "Accept")
        request.addValue("Accept-Charset", forHTTPHeaderField: "UTF-8")
        request.addValue(publicKey, forHTTPHeaderField: "SmartStore-Net-Api-PublicKey")
        request.addValue(timestamp, forHTTPHeaderField: "SmartStore-Net-Api-Date")
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
                    guard let _ = jsonObject as? NSArray else {
                        completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: NSError(domain: "JSON解析错误", code: 10086, userInfo: nil));
                        return
                    }
                    completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: NSError(domain: "返回的为array", code: 10086, userInfo: nil));
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
        requestGET(urlTmp, parameters: nil) { (_, response, _, dictionary, error) -> Void in
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
    class func loginTest(){
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

//MARK:- 登陆相关
extension QNNetworkTool {
    // 验证手机验证码
    class func checkCode(mobile:String,code:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/CheckCode", parameters: paramsToJsonDataParams(["mobile" : mobile,"code" : code])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["Success"] as? NSNumber)!.boolValue {
                completion(success:true,error: nil,dictionary:nil)
            } else {
                completion(success:false,error: nil,dictionary:nil)
            }
        }
    }
    
    // 手机发送验证码
    class func sendCode(phone:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/SendCode", parameters: paramsToJsonDataParams(["mobile" : phone])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["Success"] as? NSNumber)!.boolValue {
                completion(success:true,error: nil,dictionary:nil)
            } else {
                completion(success:false,error: nil,dictionary:nil)
            }
        }
    }
    // 手机验证码注册并登录
    class func registerAndLogin(mobile:String,code:String,psw:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/PhoneLogin", parameters: paramsToJsonDataParams(["mobile" : mobile,"code" : code,"psw" : psw])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["Success"] as? NSNumber)!.boolValue {
                completion(success:true,error: nil,dictionary:nil)
            } else {
                completion(success:false,error: nil,dictionary:nil)
            }
        }
    }
    // 用户登录
    class func loginAjax(Username:String,Password:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/Customer/LoginAjax", parameters: paramsToJsonDataParams(["Username" : Username,"Password" : Password])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["Success"] as? String) == "0" {
                completion(success:true,error: nil,dictionary:nil)
            } else {
                completion(success:false,error: nil,dictionary:nil)
            }
        }
    }
    // 手机验证码登录
    class func loginWithPhoneCode(mobile:String,code:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/PhoneLogin", parameters: paramsToJsonDataParams(["mobile" : mobile,"code" : code])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["Success"] as? NSNumber)!.boolValue {
                if let customerId = dic["customerId"] as? Int {
                    g_customerId = customerId
                }
                completion(success:true,error: nil,dictionary:dictionary)
            } else {
                completion(success:false,error: nil,dictionary:dictionary)
            }
        }
    }
}
//MARK:- 产品相关
extension QNNetworkTool {
    class func products(Q:String,pagenumber:String,orderby:Int?,Cid : String?,completion: (products : NSArray?,error:NSError?,dictionary:NSDictionary?) -> Void) {
        var urlStr = orderby == nil ? kServerAddress + "/catalog/searchajax?as=true&pagenumber=\(pagenumber)&q=\(Q)" : kServerAddress + "/catalog/searchajax?as=true&pagenumber=\(pagenumber)&orderby=16&q=\(Q)"
        if Cid != nil && Cid != "" {
            urlStr.appendContentsOf("&Cid="+Cid!)
        }
        requestGET(urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil) { (_, _, _, dictionary, error) -> Void in //
            if dictionary != nil{
                let productsData = dictionary!["Products"]
                let products = ZMDProduct.mj_objectArrayWithKeyValuesArray(productsData)
                completion(products:products,error: nil,dictionary:dictionary)
            }else {
                completion(products:nil,error: error,dictionary:nil)
            }
        }
    }
    
    class func products(skip:Int,order : String?,isAsc : Bool? = true,completion: (products : NSArray?,error:NSError?,dictionary:NSDictionary?) -> Void) {
        let ascTmp = (isAsc == nil || isAsc!) ? "desc" : "asc"
        let urlTmp = order == nil ? "/Products?$top=20&$skip=\(skip*20)"  : "/Products?&$orderby=\(order!)+\(ascTmp)&$top=20&$skip=\(skip*20)"
        requestGET(kServerAddress + urlTmp, parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                let value = dictionary!["value"]
                let products = ZMDProduct.mj_objectArrayWithKeyValuesArray(value)
                completion(products:products,error: nil,dictionary:dictionary)
            }else {
                completion(products:nil,error: error,dictionary:nil)
            }
        }
    }

    
    class func categories(completion: (categories : NSArray?,error:NSError?,dictionary:NSDictionary?) -> Void) {
        //        "/Categories?$top=10"
        requestGET(kOdataAddress + "/Categories?$top=6", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                let value = dictionary!["value"]
                let categories = ZMDCategory.mj_objectArrayWithKeyValuesArray(value)
                completion(categories:categories,error: nil,dictionary:dictionary)
            }else {
                completion(categories:nil,error: error,dictionary:nil)
            }
        }
    }
}
//MARK:- 订单相关
extension QNNetworkTool {
    
}
//MARK:- 支付相关
extension QNNetworkTool {
    //MARK: 微信支付订单
    /**
    :param: orderNo     预约订单号
    */
    
    class func wxpayOrderCheck(orderNo: NSString, completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/api/payment/wxpayOrderCheck", parameters: paramsToJsonDataParams(["orderNo" : orderNo])) { (_, _, _, dictionary, error) -> Void in
            print(dictionary)
            if dictionary != nil, let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1000{
                completion(dictionary, nil, nil);
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    //MARK: 微信支付订单 第三步：去后台确认支付结果
    /**
    :param: outTradeNo     商户订单号，看第一步
    */
    class func queryWxpayResult(outTradeNo: NSString, completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/api/payment/queryWxpayResult", parameters: paramsToJsonDataParams(["outTradeNo" : outTradeNo])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1000{
                completion(dictionary, nil, nil);
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    
    //MARK: 支付宝支付订单
    /**
    :param: orderNo     预约订单号
    */
    class func alipayOrderCheck(orderNo: NSString, completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/api/payment/aliPayOrderCheck", parameters: paramsToJsonDataParams(["orderNo" : orderNo])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1000{
                completion(dictionary, nil, nil);
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    //MARK: 获取余额支付订单验证码
    /**
    */
    class func payCheckCode(completion: (NSDictionary?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/api/payment/checkcode", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil {
                if let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1000 {
                    completion(dictionary, nil, nil);
                } /*else if let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1007 {
                    //短信获取过于频繁
                    completion(nil, error, "1007")
                } */else {
                    completion(nil, error, dictionary?["errorMsg"] as? String)
                }
            } else {
                completion(nil, error, nil)
            }
        }
    }
    //MARK: 余额支付订单
    /**
    :param: orderNo     预约订单号
    :param: checkCode   验证码
    */
    class func balancePayOrder(orderNo : String,checkCode : String,completion: (succeed : Bool!,NSDictionary?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/api/payment/balancePayOrder", parameters: paramsToJsonDataParams(["orderNo" : orderNo,"checkCode" : checkCode])) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil {
                if let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1000 {
                    completion(succeed: true,dictionary, nil, nil);
                }  else if let errorCode = dictionary!["errorCode"]?.integerValue where errorCode == 1010 { //验证码有误
                    completion(succeed:false,dictionary, nil, nil);
                }  else {
                    completion(succeed:false,nil, error, dictionary?["errorMsg"] as? String)
                }
            } else {
                completion(succeed:false,nil, error, nil)
            }
        }
    }
}
// MARK : - 地址相关
extension QNNetworkTool {
    // 获取地址列表
    class func areas(id:String,completion: (areas : NSArray?,error: NSError?,dictionary:NSDictionary?) -> Void) {
        requestGET(kServerAddress + "/admin/Area/GetChildAreas?id=\(id)", parameters: nil) { (_, _, data, _, error) -> Void in
            if data != nil{
                do {
                    let jsonObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.MutableContainers)
                    guard let array = jsonObject as? NSArray else {
                        completion(areas:nil,error: error,dictionary:nil)
                        return
                    }
                    let areas = ZMDArea.mj_objectArrayWithKeyValuesArray(array)
                    completion(areas:areas,error: nil,dictionary:nil)
                } catch {
                    println("Json解析过程出错")
                }
            }else {
                completion(areas:nil,error: error,dictionary:nil)
            }
        }
    }
    
    class func fetchAddresses(completion: (addresses : NSArray?,error:NSError?,dictionary:NSDictionary?) -> Void) {
        requestGET(kOdataAddress + "/Customers(\(g_customerId!))?$expand=Addresses", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil{
                let value = dictionary!["Addresses"]
                let addresses = ZMDAddress.mj_objectArrayWithKeyValuesArray(value)
                completion(addresses:addresses,error: nil,dictionary:dictionary)
            }else {
                completion(addresses:nil,error: error,dictionary:nil)
            }
        }
    }
    // add
    class func addOrEditAddress(address : ZMDAddress,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        var parms : [NSObject : AnyObject]!
        if address.Id == nil {
            parms = ["model[Address][FirstName]":address.FirstName,"model[Address][Address1]":address.Address1!,"model[Address][Address2]":address.Address2!,"model[Address][IsDefault]":(address.IsDefault.boolValue ? "true" : "false"),"model[Address][PhoneNumber]":address.PhoneNumber!,"model[Address][AreaCode]":address.AreaCode!,"customerId": g_customerId!,"model[Address][CountryId]":23,"model[Address][City]":address.City!]
        } else {
            parms = ["model[Address][FirstName]":address.FirstName,"model[Address][Address1]":address.Address1!,"model[Address][Address2]":address.Address2!,"model[Address][IsDefault]":(address.IsDefault.boolValue ? "true" : "false"),"model[Address][PhoneNumber]":address.PhoneNumber!,"model[Address][AreaCode]":address.AreaCode!,"model[Address][CountryId]":23,"model[Address][City]":address.City!,"model[Address][Id]":address.Id!,"customerId": g_customerId!,"id":address.Id!]
        }
        let url = address.Id == nil ? NSURL(string: kServerAddress + "/Customer/AddressAddAjax") : NSURL(string: kServerAddress + "/Customer/AddressEditAjax")
        let tmp = self.productRequest(url, method: "POST")
        QNNetworkToolTest.setFormDataRequest(tmp, fromData: parms as [NSObject : AnyObject])
        request(ParameterEncoding.URL.encode(tmp, parameters: nil).0).response {
            do {
                let jsonObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData($2!, options: NSJSONReadingOptions.MutableContainers)
                let dictionary = jsonObject as? NSDictionary
                guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                    completion(succeed:false,dictionary: dictionary, error: $3)
                    return
                }
                completion(succeed:true,dictionary: dictionary, error: $3)
            } catch {
                completion(succeed:false,dictionary: nil, error: $3)
            }
        }
    }
    //
    //MARK: 地址 delete
    /**
    :param: id:1        (地址id）
    :param: customerId: 当前用户id
    */
    class func deleteAddress(id : Int,customerId:Int,completion: (succeed:Bool!,NSDictionary?, NSError?) -> Void) {
        let url = NSURL(string: kServerAddress + "/Customer/AddressDeleteAjax")
        let tmp = self.productRequest(url, method: "POST")
        QNNetworkToolTest.setFormDataRequest(tmp, fromData: ["customerId":customerId,"id":id])
        request(tmp).response {
            do {
                let jsonObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData($2!, options: NSJSONReadingOptions.MutableContainers)
                let dictionary = jsonObject as? NSDictionary
                guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                    completion(succeed:false,dictionary, $3)
                    return
                }
                completion(succeed:true,dictionary, $3)
            } catch {
                completion(succeed:false,nil, $3)
            }
        }
    }
}
