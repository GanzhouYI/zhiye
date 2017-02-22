//
//  Directory.swift
//  getImage
//
//  Created by __________V|R__________ on 16/4/16.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation
//创建文件夹，操作文件

class zhiyeDirectory
{
    
    static var zhiyeDir:zhiyeDirectory?
    static var predicate:dispatch_once_t = 0
    
    class func sharezhiyeDir() -> zhiyeDirectory {
        dispatch_once(&predicate) { () -> Void in
            zhiyeDir = zhiyeDirectory()
            //获取数据库实例
        }
        return zhiyeDir!
    }

//除了本身文件夹，其他的删掉
func zhiyeDeleteOtherDirectory(username:String)
{
    let fileManager = NSFileManager.defaultManager()
    let myDirectory = NSHomeDirectory() + "/Documents/zhiye/user/"
    let contentsOfOtherPath = try? fileManager.contentsOfDirectoryAtPath(myDirectory)
    for filePath in contentsOfOtherPath!
    {
        print("开始删除")
        print(filePath)
        if filePath != username
        {
        print("删除username")
            
            //删除子文件夹
            let enumerator:NSDirectoryEnumerator! = fileManager.enumeratorAtPath(myDirectory+filePath)
            while let element = enumerator?.nextObject() as? String {
                do{
                    try fileManager.removeItemAtPath(myDirectory + filePath + "/" + "\(element)")
                }
                catch let err as NSError {
                    print("抛出错误")
                    print(err.description)
                }
            }
            //删除自身
            do{
                try fileManager.removeItemAtPath(myDirectory + filePath)
            }
            catch let err as NSError {
                print("抛出错误")
                print(err.description)
            }
//        let fileArray:[AnyObject] = fileManager.subpathsAtPath(myDirectory+filePath)!
//        for fn in fileArray{
//            
//            print(fn)
//                do{
//                    try fileManager.removeItemAtPath(myDirectory + filePath + "/" + "\(fn)")
//                }
//                catch let err as NSError {
//                    print("抛出错误")
//                    print(err.description)
//                }
//        }
        }
    }
}

func zhiyeInitDirectory(userDir:String)//如果没有以下文件夹则创建
{
    let dongtaiDirectory:String = NSHomeDirectory() + "/Documents/zhiye/user/"+userDir+"/dongtai"
    let dynamicDirectory:String = NSHomeDirectory() + "/Documents/zhiye/user/"+userDir+"/dynamic"

    let fileManager = NSFileManager.defaultManager()
    
    if(!fileManager.fileExistsAtPath(dongtaiDirectory))//如果zhiye/user不存在
    {
        //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
        try! fileManager.createDirectoryAtPath(dongtaiDirectory,withIntermediateDirectories: true, attributes: nil)
    }
    
    if(!fileManager.fileExistsAtPath(dynamicDirectory))//如果zhiye/tongzhi不存在
    {
        //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
        try! fileManager.createDirectoryAtPath(dynamicDirectory,withIntermediateDirectories: true, attributes: nil)
    }
    
    print(NSHomeDirectory())
}


}
//判断是否有文件夹，没有则创建

//                                                         /Document/zhiye
//          user
//      dynamic                                tongzhi

//user
//user1 user2
//touImage,plist(用户文字信息)


//dynamic
//


//tongzhi
//