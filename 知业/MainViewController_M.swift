//
//  MyNet.swift
//  
//
//  Created by __________V|R__________ on 16/4/7.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//
import Foundation

import Alamofire
class MainModel:NSObject {
    static var Model:MainModel?
    static var predicate:dispatch_once_t = 0
    class func sharedMainModel()->MainModel?{
        
        dispatch_once(&predicate) { () -> Void in
            Model = MainModel()
        }
        return Model
    }
    
    func downloadImage(url:String)
    {
        Alamofire.download(.GET, url) {
            temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
                                                            inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            print("download")
            print(directoryURL.URLByAppendingPathComponent(pathComponent!))
            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        }
        

    }
    
    typealias NetworkBlock = (dataInfo:String)->Void
    
    func conNet(view:UIView,username:String,pwd:String,block:NetworkBlock?)
    {
        let urlString:String = "http://www.loveinbc.com/yiroote/login.php"
        let parameters = ["username": username,"pwd": pwd]
        print(parameters)
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                print("数据")
                MBProgressHUD.hideHUDForView(view, animated: true)
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "用户名或密码错误")
                    {
                        print("验证错误")
                        block!(dataInfo:"用户名或密码错误")
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("验证正确")
                        block!(dataInfo:"验证正确")
                        print(JSON)
                        //保存密码
                        let userDefault = NSUserDefaults.standardUserDefaults()//返回NSUserDefaults对象
                        userDefault.setObject(JSON[0], forKey: "uid")
                        userDefault.setObject(JSON[1], forKey: "username")
                        userDefault.setObject(JSON[2], forKey: "pwd")
                        userDefault.synchronize()//同步
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    block!(dataInfo:"网络错误")
                    break
                }
        }
        
        
    }
    
    
}

