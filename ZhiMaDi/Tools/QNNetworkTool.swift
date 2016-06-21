//
//  QNNetworkTool.swift
//  SleepCare
//
//  Created by haijie on 15/12/15.
//  Copyright © 2015年 juxi. All rights reserved.
//

import Foundation
import Alamofire

/// 服务器地址
private let kServerAddress = { () -> String in
//  "http://od.ccw.cn"
//    "http://10.0.0.10"
    "http://xw.ccw.cn"  // 伟
}()
private let kOdataAddress = { () -> String in
    kServerAddress + "/odata/v1"
}()
// 图片地址
let kImageAddressMain = { () -> String in
    kServerAddress
}()
// 图片地址
let kImageAddressNew = { () -> String in
    kServerAddress + "/media"
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
                completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: NSError(domain: "JSON解析错误", code: 10086, userInfo: nil));
                println("Json解析过程出错")
            }
        }
    }
}
// MARK: - 网络基础处理(上传)
extension QNNetworkTool {
    
    /**
     生产一个用于上传的Request
     
     :param: url      上传的接口的地址
     :param: method   上传的方式， Get Post Put ...
     :param: data     需要被上传的数据
     :param: fileName 上传的文件名
     */
    private class func productUploadRequest(url: NSURL!, method: NSString, data: NSData, fileName: NSString) -> NSURLRequest {
        let request = self.productRequest(url, method: method)
        // 定制一post方式上传数据，数据格式必须和下面方式相同
        let boundary = "abcdefg"
        request.setValue(String(format: "multipart/form-data;boundary=%@", boundary), forHTTPHeaderField: "Content-Type")
        // 注意 ："face"这个字段需要看文档服务端的要求，他们要取该字段进行图片命名
        let str = NSMutableString(format: "--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",boundary, "face", fileName, "application/octet-stream")
        // 配置内容
        let bodyData = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as! NSMutableData
        bodyData.appendData(data)
        bodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        bodyData.appendData(NSString(format: "--%@--\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        request.HTTPBody = bodyData
        return request
    }
    //生产多参数上传Request
    private class func uploadRequest(url: NSURL!, method: NSString, data: NSData, fileName: NSString,customerId: Int) -> NSURLRequest {
        
        let request = self.productRequest(url, method: method)
        request.addValue("image/jpeg", forHTTPHeaderField: "ContentType")
        // 定制一post方式上传数据，数据格式必须和下面方式相同
        let boundary = "abcdefg"
        request.setValue(String(format: "multipart/form-data;boundary=%@", boundary), forHTTPHeaderField: "Content-Type")
        let str1 = NSMutableString(format: "--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%d\r\n",boundary, "customerId",customerId)
        let str = NSMutableString(format: "%@--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",str1,boundary, "file", fileName, "image/jpeg")  //  application/octet-stream
        // 配置内容
        let bodyData = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as! NSMutableData
        bodyData.appendData(data)
        bodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        bodyData.appendData(NSString(format: "--%@--\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        request.HTTPBody = bodyData
        return request
    }
}
//MARK:- 登陆相关
extension QNNetworkTool {
    // 验证手机验证码
    class func checkCode(mobile:String,code:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/api/v1/extend/Login/CheckCode", parameters: ["mobile" : mobile,"code" : code]) { (_,response, _, dictionary, error) -> Void in
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
        requestPOST(kServerAddress + "/api/v1/extend/Login/SendCode", parameters: paramsToJsonDataParams(["mobile" : phone])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary , let succeed = dic["Success"] as? NSNumber else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if succeed.boolValue {
                completion(success:true,error: nil,dictionary:nil)
            } else {
                completion(success:false,error: nil,dictionary:nil)
            }
        }
    }
    // 手机验证码注册并登录
    class func registerAndLogin(mobile:String,code:String,psw:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/api/v1/extend/Login//PhoneLogin", parameters: paramsToJsonDataParams(["mobile" : mobile,"code" : code,"psw" : psw])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["success"] as? NSNumber)!.boolValue {
                completion(success:true,error: nil,dictionary:nil)
            } else {
                completion(success:false,error: nil,dictionary:nil)
            }
        }
    }
    // 用户登录  /api/v1/extend/Login/
    class func loginAjax(Username:String,Password:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/api/v1/extend/Login/LoginAjax", parameters: ["Username" : Username,"Password" : Password]) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary,success = dic["success"] as? Bool where success else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if let customerId = dic["customerId"] as? Int {
                g_customerId = customerId
            }
            if let customerDic = dic["customer"] as? NSDictionary,customer = ZMDCustomer.mj_objectWithKeyValues(customerDic) {
                g_customer = customer
                if let url = g_customer?.Avatar?.AvatarUrl  {
                    g_customer?.Avatar?.AvatarUrl = kImageAddressMain + url
                }
            }
            completion(success:true,error: nil,dictionary:nil)
        }
    }
    // 手机验证码登录
    class func loginWithPhoneCode(mobile:String,code:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/api/v1/extend/Login/PhoneLogin", parameters: paramsToJsonDataParams(["mobile" : mobile,"code" : code])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            if (dic["success"] as? NSNumber)!.boolValue {
                if let customerId = dic["customerId"] as? Int {
                    g_customerId = customerId
                }
                completion(success:true,error: nil,dictionary:dictionary)
            } else {
                completion(success:false,error: nil,dictionary:dictionary)
            }
        }
    }
    // 修改密码
    class func changePassword(mobile:String,code:String,psw:String,completion: (success: Bool!,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/api/v1/extend/Login/ChangePassword", parameters: paramsToJsonDataParams(["mobile" : mobile,"code" : code,"psw":psw])) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary , succeed = dic["success"] as? Bool where succeed else {
                completion(success:false,error: error,dictionary:nil)
                return
            }
            saveAccountAndPassword(mobile, password: nil)
            completion(success:true,error: nil,dictionary:dictionary)
        }
    }
}
//MARK:- 用户中心
extension QNNetworkTool {
    /**
     修改头像
     
     - parameter file:       文件
     - parameter fileName:   文件名字
     - parameter customerId: customerId description
     - parameter completion: completion description
     */
    class func uploadCustomerHead(file: NSData, fileName: NSString,customerId: NSString, completion: (succeed : Bool,dic:NSDictionary?, error:NSError?) -> Void) {
        let url = NSURL(string: kServerAddress+"/api/v1/uploads/CustomerAvtar")
//        request(ParameterEncoding.URL.encode(self.uploadRequest(url, method: "POST", data: file, fileName: "file",customerId:g_customerId!), parameters: nil).0).response{
        request(self.uploadRequest(url, method: "POST", data: file, fileName: fileName,customerId:g_customerId!)).response{
            do {
                let jsonObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData($2!, options: NSJSONReadingOptions.MutableContainers)
                guard let data = jsonObject as? NSArray,dic = data[0] as? NSDictionary,url = dic["ImageUrl"] as? String else {
                    completion(succeed: false, dic: nil, error: $3)
                    return
                }
                g_customer?.Avatar?.AvatarUrl = url
                completion(succeed: true, dic: dic, error: $3)
            } catch {}
        }
    }

}
//MARK:- 产品相关
extension QNNetworkTool {
    /**
     产品列表
     
     - parameter Q:          关键词
     - parameter pagenumber: 页码
     - parameter orderby:    orderby description
     - parameter Cid:        Cid description
     - parameter completion: completion description
     */
    class func products(Q:String,pagenumber:String,orderby:Int?,Cid : String?,completion: (products : NSArray?,error:NSError?,dictionary:NSDictionary?) -> Void) {
        var urlStr = kServerAddress + "/catalog/searchajax?as=true&pagenumber=\(pagenumber)&q=\(Q)"
        if  orderby != nil {
            urlStr.appendContentsOf("&orderby=\(orderby!)")
        }
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
    /**
     获取详情页
     
     - parameter Id:         Id description
     - parameter completion: completion description
     */
    class func fetchProductDetail(Id:Int,completion: (productDetail: ZMDProductDetail?,error:NSError?,dictionary:NSDictionary?) -> Void){
        
        requestPOST(kServerAddress + "/api/v1/extend/Product/ProductDetails", parameters: ["Id":Id,"customerId":g_customerId ?? 0]) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary ,let productDetail = ZMDProductDetail.mj_objectWithKeyValues(dic["produc"]) else {
                completion(productDetail:nil,error: error,dictionary:nil)
                return
            }
            completion(productDetail:productDetail,error: nil,dictionary:dictionary)
        }
    }
    // 产品详情信息 html
    class func fetchProductDetailView(productId:Int,completion: (succeed : Bool!,data:String?,error: NSError?) -> Void){
        let url = NSURL(string: kServerAddress + "/product/ProductDetailview?productId=\(productId)")
        request(ParameterEncoding.URL.encode(self.productRequest(url, method: "POST"), parameters: nil).0).responseString { (response) -> Void in
            guard let data = response.result.value else {
                completion(succeed:false,data: nil, error: response.result.error)
                return
            }
            completion(succeed:true,data: data, error: nil)
        }
    }
    //MARK: 首页数据
    class func fetchMainPageInto(completion: (advertisementAll: ZMDAdvertisementAll?,error:NSError?,dictionary:NSDictionary?) -> Void){
        requestPOST(kServerAddress + "/api/v1/extend/Advertisement/IndexAds", parameters: nil) { (_,response, _, dictionary, error) -> Void in
            guard let dic = dictionary ,let advertisementAll = ZMDAdvertisementAll.mj_objectWithKeyValues(dic) else {
                completion(advertisementAll:nil,error: error,dictionary:nil)
                return
            }
            completion(advertisementAll:advertisementAll,error: nil,dictionary:dictionary)
        }
    }
}
//MARK:- 订单相关
extension QNNetworkTool {
    /**
     下订单
     
     - parameter ItemIds:    订单id
     - parameter completion: completion description
     */
    class func selectCart(ItemIds: String,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Checkout/SelectCart", parameters: ["ItemIds" : ItemIds,"CustomerId":g_customerId!]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    /**
     选择地址
     
     - parameter AddressId:  产品Id
     - parameter completion: completion description
     */
    class func selectShoppingAddress(AddressId: Int,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Checkout/SelectShippingAddress", parameters: ["AddressId" : AddressId,"CustomerId":g_customerId!]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    // 获取发票信息
    class func fetchPublicInfo(completion: (publicInfo : ZMDPublicInfo?,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Invoices/PublicInfo", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            guard let publicInfo = ZMDPublicInfo.mj_objectWithKeyValues(dictionary) else {
                completion(publicInfo:nil,dictionary: dictionary, error: error)
                return
            }
            completion(publicInfo:publicInfo,dictionary: dictionary, error: nil)
        }
    }
    // 用户优惠券
    class func fetchCustomerCoupons(completion: (coupons : NSArray?,datas:NSData?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/CustomerCoupons/Coupons", parameters: ["customerId":1]) { (_, _, data, _, error) -> Void in
            do {
                let jsonObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.MutableContainers)
                guard let _ = jsonObject as? NSArray else {
                    completion(coupons:nil,datas: nil, error: error)
                    return
                }
                guard let coupons = ZMDCoupon.mj_objectArrayWithKeyValuesArray(jsonObject) else {
                    completion(coupons:nil,datas: nil, error: error)
                    return
                }
                completion(coupons:coupons,datas: data as? NSData, error: nil)
            }
            catch {

            }

        }
    }
    // 删除优惠券
    class func deleteCoupons(Id:Int,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/CustomerCoupons/Delete", parameters: ["Id":Id]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    // 结算的可用优惠券列表
    class func fetchCustomerCouponsForOrder(completion: (coupon : NSArray?,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/CustomerCoupons/PublicInfo", parameters: ["customerId":g_customerId!]) { (_, _, _, dictionary, error) -> Void in
            guard let coupon = ZMDCoupon.mj_objectArrayWithKeyValuesArray(dictionary) else {
                completion(coupon:nil,dictionary: dictionary, error: error)
                return
            }
            completion(coupon:coupon,dictionary: dictionary, error: nil)
        }
    }
    // 使用优惠券
    class func useDiscountCoupo(Discountcouponcode:String,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/CustomerCoupons/UseDiscountCoupon", parameters: ["customerId":g_customerId!,"Discountcouponcode":Discountcouponcode]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    // MARK: - 获取当前要结算订单的合计
    /**
    获取当前要结算订单的合计
    
    - parameter completion:      completion
    */
    class func getOrderTotals(completion: (OrderTotal : AnyObject?,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Checkout/OrderTotals", parameters: ["CustomerId":g_customerId!]) { (_, _, _, dictionary, error) -> Void in
            guard let orderTotal = dictionary?["OrderTotal"]  else {
                completion(OrderTotal:nil,dictionary: dictionary, error: error)
                return
            }
            completion(OrderTotal:orderTotal,dictionary: dictionary, error: nil)
        }
    }
    /**
     确认订单
     
     - parameter CustomerComment: 备注
     - parameter completion:      completion description
     */
    class func confirmOrder(CustomerComment: String,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Checkout/ConfirmOrder", parameters: ["CustomerComment" : CustomerComment,"CustomerId":g_customerId!]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    
    // 获取订单
    class func fetchOrder(completion: ( value: NSArray?,error: NSError?) -> Void) {
        var str = kOdataAddress + "/Orders?$top=1&$filter=OrderStatusId eq 10 and CustomerId eq 1 &$expand=OrderItems,OrderItems/Product,OrderItems/Product/ProductPictures&$select=OrderTotal,OrderItems/Product/Name,OrderItems/UnitPriceInclTax,OrderItems/UnitPriceExclTax,OrderItems/Quantity,Id,OrderItems/AttributeDescription,OrderItems/Product/ProductPictures/PictureId,OrderStatusId,ShippingStatusId,PaymentStatusId&$skip=9"
        str = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string:str)
        request(self.productRequest(url, method: "GET")).responseString { (response) -> Void in
            guard let data = response.result.value else {
                completion(value:nil, error: response.result.error)
                return
            }
            do {
                if let value = try NSJSONSerialization.JSONObjectWithData(data.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    completion(value:value["value"] as? NSArray,error: nil)
                }
            }
            catch {
                completion(value:nil, error: nil)
            }
        }
    }
    /**
     订单详情
     
     - parameter orderid:    订单ID
     - parameter completion: completion description
     */
    class func orderDetail(orderid: String,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/order/Details", parameters: ["orderid" : orderid]) { (_, _, _, dictionary, error) -> Void in
            guard let dic = dictionary else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dic, error: nil)
        }
    }
}
//MARK:- 购物车相关
extension QNNetworkTool {
    /**
     添加购物车
     */
    class func addProductToCart(formData: NSDictionary,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Product/AddProductToCart", parameters: formData as! [String : AnyObject]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    /**
    编辑
     
     - parameter formData:   formData description
     - parameter completion: completion description
     */
    class func editCartItemAttribute(formData: NSDictionary,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/ShoppingCart/EditCartItemAttribute", parameters: formData as! [String : AnyObject]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    /**
     查看购物车
     
     - parameter completion: 完成回调
     */
    class func fetchShoppingCart(completion: (shoppingItems : NSArray?,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/ShoppingCart/Cart", parameters: ["customerId":g_customerId!]) { (_, _, _, dictionary, error) -> Void in
            guard let Items = dictionary?["Items"],let shoppingItems = ZMDShoppingItem.mj_objectArrayWithKeyValuesArray(Items) else {
                completion(shoppingItems:nil,dictionary: dictionary, error: error)
                return
            }
            completion(shoppingItems:shoppingItems,dictionary: dictionary, error: nil)
        }
    }
    /**
     删除购物车item
     
     - parameter completion:
     */
    class func deleteCartItem(SciIds:String,completion: (succeed : Bool!,dictionary:NSDictionary?,error: NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/ShoppingCart/DeleteCartItems", parameters: ["customerId":g_customerId!,"SciIds":SciIds]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
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
//MARK: - 地址相关
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
        var parms : [String : AnyObject]!
        if address.Id == nil {
            parms = ["FirstName":address.FirstName,"Address1":address.Address1!,"Address2":address.Address2!,"IsDefault":(address.IsDefault.boolValue ? "true" : "false"),"PhoneNumber":address.PhoneNumber!,"AreaCode":address.AreaCode!,"customerId": g_customerId!,"CountryId":23,"City":address.City!]
        } else {
            parms = ["FirstName":address.FirstName,"Address1":address.Address1!,"Address2":address.Address2!,"IsDefault":(address.IsDefault.boolValue ? "true" : "false"),"PhoneNumber":address.PhoneNumber!,"AreaCode":address.AreaCode!,"CountryId":23,"City":address.City!,"customerId": g_customerId!,"id":address.Id!]
        }
        let url = address.Id == nil ? (kServerAddress + "/api/v1/extend/Customer/AddressAdd") : (kServerAddress + "/api/v1/extend/Customer/AddressEdit")
        requestPOST(url, parameters: parms) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary: dictionary, error: error)
                return
            }
            completion(succeed:true,dictionary: dictionary, error: nil)
        }
    }
    //
    //MARK: 地址 delete
    /**
    :param: id:1        (地址id）
    :param: customerId: 当前用户id
    */
    class func deleteAddress(id : Int,customerId:Int,completion: (succeed:Bool!,NSDictionary?, NSError?) -> Void) {
        requestPOST(kServerAddress + "/api/v1/extend/Customer/AddressDelete", parameters: ["customerId":customerId,"id":id]) { (_, _, _, dictionary, error) -> Void in
            guard let success = dictionary?["success"] as? NSNumber where success.boolValue else {
                completion(succeed:false,dictionary, error)
                return
            }
            completion(succeed:true,dictionary, nil)
        }
    }
}
// MARK: - 个人测试
extension QNNetworkTool {
    class func requestForGet() {
        let url = NSURL(string: kOdataAddress + "/Customers(\(g_customerId!))?$expand=Addresses")
        let request = self.productRequest(url, method: "GET")
        let session = NSURLSession()
        let sessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let tmp = data
            print(data)
        }
        sessionDataTask.resume()
    }
}