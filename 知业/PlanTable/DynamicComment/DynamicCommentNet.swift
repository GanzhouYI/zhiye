import Foundation
import Alamofire

class DynamicCommentNet:NSObject {
    static var Model:DynamicCommentNet?
    static var predicate:dispatch_once_t = 0
    class func sharedDynamicComment()->DynamicCommentNet?{
        
        dispatch_once(&predicate) { () -> Void in
            Model = DynamicCommentNet()
        }
        return Model
    }
    
    typealias NetworkBlockInfo = (dataInfo:String)->Void
    typealias NetworkBlock = (dataInfo:String,data:[[String]])->Void
    typealias NetworkBlockName = (dataInfo:String,data:String)->Void

    //下载评论人的名字
    func DownCommentName()
    {
        for n1 in 0...DynamicCommentManager.shareDynamicCommentManager().dataMessageItem.count-1
        {
            for n2 in 0...DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1].count-1
            {
                //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
                let urlString:String = "http://www.loveinbc.com/zhiye/downCommentName.php"
                var cuid = DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1][n2].cuid
                var ctuid = DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1][n2].ctuid
                let cparameters = ["uid":cuid]
                print("DownCommentName")
                print(cparameters)
        
                Alamofire.request(.POST, urlString, parameters: cparameters)
                    .responseJSON{ response in
                        switch response.result
                        {
                        case .Success:
                            print("DownCommentName 网络连接正常")
                            print(response.result.value!)
                            let str = (response.result.value!)as?String
                    
                            if(str == "外星人")
                            {
                                print("外星人")
                                DynamicCommentManager.shareDynamicCommentManager().SetCName(cuid, Cname: "外星人")
                            }
                            else if let JSON = response.result.value as? NSArray
                            {
                                var name:String = String(JSON[0][1])
                                print("存在此人")
                                DynamicCommentManager.shareDynamicCommentManager().SetCName(cuid, Cname: name)
                            }
                            break
                        case .Failure:
                            print("网络连接错误")
                            DynamicCommentManager.shareDynamicCommentManager().SetCName(cuid, Cname: "网络连接错误")
                            break
                        }
                    }
                
                let ctparameters = ["uid":ctuid]
                print("DownCommentName")
                print(ctparameters)
                Alamofire.request(.POST, urlString, parameters: ctparameters)
                    .responseJSON{ response in
                        switch response.result
                        {
                        case .Success:
                            print("DownCommentName 网络连接正常")
                            print(response.result.value!)
                            let str = (response.result.value!)as?String
                            
                            if(str == "外星人")
                            {
                                print("外星人")
                                DynamicCommentManager.shareDynamicCommentManager().SetCTName(ctuid, CTname: "外星人")
                            }
                            else if let JSON = response.result.value as? NSArray
                            {
                                var name:String = String(JSON[0][1])
                                print("存在此人")
                                DynamicCommentManager.shareDynamicCommentManager().SetCTName(ctuid, CTname: name)
                            }
                            break
                        case .Failure:
                            print("网络连接错误")
                            DynamicCommentManager.shareDynamicCommentManager().SetCTName(ctuid, CTname: "网络连接错误")
                            break
                        }
                }
            }//  n2
        }//      n1
    }

    
    //动态的id和动态创始人的id
    func DownDynamicComment(dynamic_id:String,block:NetworkBlock?)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/downDynamicComment.php"
        let parameters = ["dynamic_id":dynamic_id]
        print("DownDynamicComment")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                switch response.result
                {
                case .Success:
                    print("DownDynamicComment 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "没有评论")
                    {
                        print("没有评论")
                        block!(dataInfo:"没有评论",data:[[""]])
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有评论数据多少条")
                        print(JSON.count)
                        print("输出评论数据")
                        var infoDataItem = [String]()
                        var infoData=[[String]]()
                        var HasNewPlan:Bool = false
                        var SqlReturnInfo:String = ""
                        print(JSON[0])
                        for i in 0..<JSON.count
                        {
                            infoDataItem.removeAll()
                            for n in 0..<JSON[i].count
                            {
                                if(String(JSON[i][n]) == "<null>")
                                {
                                    print(String(i)+String(n)+" 是null")
                                    infoDataItem.append("")
                                    print(JSON[i][n])
                                }
                                else
                                {
                                    infoDataItem.append(String(JSON[i][n]))
                                }
                            }
                            infoData.append(infoDataItem)
                        }
                        
                       DynamicCommentManager.shareDynamicCommentManager().RefreshComment(infoData)
                        block!(dataInfo:"存在评论",data: infoData)
                        print(infoData)
                        print("以上输出存在评论的数据")
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    block!(dataInfo:"网络错误",data:[[""]])
                    break
                }
            }.progress { (bytesWrite:Int64, totalBytesWrite:Int64, totalBytesExpectedToWrite:Int64) in
                print("bytesWrite:",bytesWrite)
                print("totalBytesWrite:",totalBytesWrite)
                print("totalBytesExpectedToWrite:",totalBytesExpectedToWrite)
                /*
                 监听文件下载进度，此 block 在子线程中执行。
                 */
        }
    }
    
    
    //上传plan到服务器
    func UpLoadDynamicComment(dynamic_id:String,cuid:String,cfloor:String,ctuid:String,crow:String,comment:String,block:NetworkBlockInfo?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/UpLoadDynamicComment.php"
        var parameter:[String:AnyObject] = ["dynamic_id":dynamic_id,"cuid":cuid,"cfloor":cfloor,"ctuid":ctuid,"crow":crow,"comment":comment]
        Alamofire.request(.POST, urlString, parameters: parameter)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("UpLoadDynamicComment 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    print(str)
                    
                    if(str == "评论失败")
                    {
                        print("UpLoadDynamicComment评论失败")
                        block?(dataInfo:"评论失败")
                    }
                    else if(str == "评论成功")
                    {
                        print("UpLoadDynamicComment评论成功")
                        block?(dataInfo:"评论成功")
                    }
                    break
                case .Failure:
                    print("upLoad网络连接错误")
                    block?(dataInfo:"网络错误")
                    break
                }
            }
            .progress { (bytesWrite:Int64, totalBytesWrite:Int64, totalBytesExpectedToWrite:Int64) in
                print("bytesWrite:",bytesWrite)
                print("totalBytesWrite:",totalBytesWrite)
                print("totalBytesExpectedToWrite:",totalBytesExpectedToWrite)
                /*
                 监听文件下载进度，此 block 在子线程中执行。
                 */
        }
    }

    
}

