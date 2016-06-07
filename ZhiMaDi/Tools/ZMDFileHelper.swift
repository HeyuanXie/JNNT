//
//  ZMDFileHelper.swift
//  ZhiMaDi
//
//  Created by haijie on 16/6/6.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit
// 沙盒
let productDetailFile = "productDetail"
class ZMDFileHelper: NSObject {
    class func getDocumentPath() -> String {
        // NSHomeDirectory() + "/Documents"
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
    class func write(data:String,fileName:String) -> Bool{
        let filePath = NSHomeDirectory() + "/Documents/product/\(fileName).html"
        //创建文件可以通过writeToFile方法将一些对象写入到文件中
        do {
            try data.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            return true
        } catch{
            return false
        }
    }
    //删除文件
    class func deleteFile(fileName:String) {
        let filePath = NSHomeDirectory() + "/Documents/product/\(fileName).html"
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(filePath)
        } catch{
        }
    }
    class func getFilePath(fileName:String) -> String {
        return NSHomeDirectory() + "/Documents/product/\(fileName).html"
    }
}
