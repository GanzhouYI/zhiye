//
//  download.swift
//  getImage
//
//  Created by __________V|R__________ on 16/4/17.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation
import Alamofire
//execute query区别 execute返回总行数，query返回一条执行语句的数据
class download
{
    
    static var down:download?
    static var predicate:dispatch_once_t = 0
    
    class func shareMyDownload() -> download {
        dispatch_once(&predicate) { () -> Void in
            down = download()
            //获取数据库实例
        }
        return down!
    }
    
    func downImage(url:String,dir:String,fileName:String,fileType:String){

        Alamofire.download(.GET, url) {
            wuyongdeURL,response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0]
            let folder = directoryURL.URLByAppendingPathComponent(dir, isDirectory: true)
            //判断文件夹是否存在，不存在则创建

        
            let exist = fileManager.fileExistsAtPath(folder.path!)
            if !exist {
                try! fileManager.createDirectoryAtURL(folder, withIntermediateDirectories: true,
                                                      attributes: nil)
            }
            print("downImage  out")
            return folder.URLByAppendingPathComponent(fileName+fileType)
        }
        
    }
    
    
    
    func downImageShowDetail(url:String,dir:String)  {
        let destination = Alamofire.Request.suggestedDownloadDestination(
            directory: .DocumentDirectory, domain: .UserDomainMask)
        
        Alamofire.download(.POST, url, destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                let percent = totalBytesRead*100/totalBytesExpectedToRead
                print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
            }
            .response { (request, response, _, error) in
                print(response)
        }
    }
    
}
