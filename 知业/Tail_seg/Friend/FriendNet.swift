import Foundation
import Alamofire

class FriendNet:NSObject {
    static var Model:FriendNet?
    static var predicate:dispatch_once_t = 0
    class func sharedFriend()->FriendNet?{
        
        dispatch_once(&predicate) { () -> Void in
            Model = FriendNet()
        }
        return Model
    }
    
    typealias NetworkBlockInfo = (dataInfo:String)->Void
    typealias NetworkBlock = (dataInfo:String,data:[[String]])->Void
    
    func SearchMyFriend(Searchblock:NetworkBlock?)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/searchMyFriend.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.returnMyUid())]
        print("SearchMyFriend")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                switch response.result
                {
                case .Success:
                    print("SearchMyFriend 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "无好友")
                    {
                        print("用户无好友")
                        Searchblock!(dataInfo:"无好友",data:[[""]])
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有好友数据多少条")
                        print(JSON.count)
                        print("输出好友数据")
                        var uidArrayString = "SELECT * FROM zhiye_User WHERE uid IN ("
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
                            if(i<JSON.count-1)
                            {
                                uidArrayString += infoDataItem[1]
                                uidArrayString += ","
                            }
                            else
                            {
                                uidArrayString += infoDataItem[1]
                                uidArrayString += ")"
                            }
                            infoData.append(infoDataItem)
                        }
                        
                        FriendNet.sharedFriend()!.DownFriendInfo(true,uidArrayString: uidArrayString,block: {(dataInfo,data) -> Void in
                            if dataInfo == "无好友"
                            {
                                Searchblock!(dataInfo:"无好友",data: data)
                            }
                            else if dataInfo == "好友存在"
                            {
                                FriendManager.shareFriendManager().RefreshFriend(true,data:data)
                                Searchblock!(dataInfo:"好友存在",data: data)
                            }
                            else if dataInfo == "网络错误"
                            {
                                Searchblock!(dataInfo:"网络错误",data: data)
                            }
                        })

                        
                        print(infoData)
                        print("以上输出用户的数据")
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    Searchblock!(dataInfo:"网络错误",data:[[""]])
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
    
    func DeleteMyFriend(fuid:String,block:NetworkBlock?)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/deleteMyFriend.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.returnMyUid()),"fuid":fuid]
        print("DeleteMyFriend")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                switch response.result
                {
                case .Success:
                    print("DeleteMyFriend 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "删除成功")
                    {
                        print("用户删除成功")
                        block!(dataInfo:"删除成功",data:[[""]])
                    }
                    else
                    {
                        print("删除失败")
                        block!(dataInfo:"删除失败",data:[[""]])
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

    
    func SearchFriendMe(Searchblock:NetworkBlock?)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/searchFriendMe.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.returnMyUid())]
        print("SearchFriendMe")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                switch response.result
                {
                case .Success:
                    print("SearchFriendMe 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "无好友")
                    {
                        print("用户无好友")
                        Searchblock!(dataInfo:"无好友",data:[[""]])
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有好友数据多少条")
                        print(JSON.count)
                        print("输出好友数据")
                        var uidArrayString = "SELECT * FROM zhiye_User WHERE uid IN ("
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
                            if(i<JSON.count-1)
                            {
                                uidArrayString += infoDataItem[0]
                                uidArrayString += ","
                            }
                            else
                            {
                                uidArrayString += infoDataItem[0]
                                uidArrayString += ")"
                            }
                            infoData.append(infoDataItem)
                        }
                        
                        FriendNet.sharedFriend()!.DownFriendInfo(false,uidArrayString: uidArrayString,block: {(dataInfo,data) -> Void in
                            if dataInfo == "无好友"
                            {
                                Searchblock!(dataInfo:"无好友",data: data)
                            }
                            else if dataInfo == "好友存在"
                            {
                                FriendManager.shareFriendManager().RefreshFriend(false,data:data)
                                Searchblock!(dataInfo:"好友存在",data: data)
                            }
                            else if dataInfo == "网络错误"
                            {
                                Searchblock!(dataInfo:"网络错误",data: data)
                            }
                        })
                        
                        
                        print(infoData)
                        print("以上输出用户的数据")
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    Searchblock!(dataInfo:"网络错误",data:[[""]])
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

    
    func DownFriendInfo(IsMyFriend:Bool,uidArrayString:String,block:NetworkBlock?)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/downFriendInfo.php"
        let parameters = ["uidArray":uidArrayString]
        print("DownFriendInfo")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                switch response.result
                {
                case .Success:
                    print("DownFriendInfo 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "无好友")
                    {
                        print("用户无好友")
                        block!(dataInfo:"无好友",data:[[""]])
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有好友数据多少条")
                        print(JSON.count)
                        print("输出好友数据")
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
                        FriendManager.shareFriendManager().RefreshFriend(IsMyFriend,data:infoData)
                        block!(dataInfo:"好友存在",data: infoData)
                        print(infoData)
                        print("以上输出用户的数据")
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

    
    
}

