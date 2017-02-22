//
//  MyNet.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/4/7.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//
import Foundation
import Alamofire
class RegisterModel:NSObject {
    static var Model:RegisterModel?
    static var predicate:dispatch_once_t = 0
    class func sharedRegisterModel()->RegisterModel?{
        dispatch_once(&predicate) { () -> Void in
            Model = RegisterModel()
        }
        return Model
    }
    
    typealias NetworkBlock = (dataInfo:String)->Void
    
    func conNet(zhuceData:[String:String],block:NetworkBlock?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/register.php"
        Alamofire.request(.POST, urlString, parameters: zhuceData)
            .responseJSON{ response in
                print("数据")
                let str = (response.result.value)as?String
                print(str)
                print(response.result.value)
                print("数据end")
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    
                    if(str == "昵称已存在")
                    {
                        print("昵称已存在")
                        block!(dataInfo:"昵称已存在")
                    }
                    else if(str == "注册失败")
                    {
                        print("注册失败")
                        block!(dataInfo:"注册失败")
                    }
                    else if(str == "注册成功")
                    {
                        print("注册成功")
                        //初始化用户数据库
                        print("初始化数据库")
                        MySQL.shareMySQL().initUser(zhuceData)
                        print("是否插入成功")
                        MySQL.shareMySQL().searchUser(zhuceData["username"]!)
                        block!(dataInfo:"注册成功")
                        //初始化用户文件夹
                    zhiyeDirectory.sharezhiyeDir().zhiyeInitDirectory(zhuceData["username"]!)
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    //model.info = ["uid":-2,"username":"网络错误","pwd":"error"]
                    block!(dataInfo:"网络连接错误")
                    break
                }
        }
    }
    
    
    func registerName(zhuceData:[String:String],block:NetworkBlock?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/registerName.php"
        
        Alamofire.request(.POST, urlString, parameters: zhuceData)
            .responseJSON{ response in
                let str = (response.result.value)as?String
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    
                    if(str == "昵称已存在")
                    {
                        block!(dataInfo:"昵称已存在")
                    }
                    else if(str == "昵称可用")
                    {
                        block!(dataInfo:"昵称可用")
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    block!(dataInfo:"网络连接错误")
                    //model.info = ["uid":-2,"username":"网络错误","pwd":"error"]
                    break
                }
        }
        
    }
}

