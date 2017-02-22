import Foundation
import Alamofire

class PlanNet:NSObject {
    static var Model:PlanNet?
    static var predicate:dispatch_once_t = 0
    class func sharedPlan()->PlanNet?{
        
        dispatch_once(&predicate) { () -> Void in
            Model = PlanNet()
        }
        return Model
    }
    
    typealias NetworkBlockInfo = (dataInfo:String)->Void
    typealias NetworkBlock = (dataInfo:String,data:[[String]])->Void
    
    func DownPlan(dynamic_date:[String],block:NetworkBlock?)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/downPlan.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.returnMyUid())]
        
        print(LoginModel.sharedLoginModel()?.returnMyUid())
        print("输出更新动态请求的lastDate")
        print(parameters)
        
        print("Step:2")
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                print("数据")
                print("Step:3")
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "已经是最新的")
                    {
                        print("已经是最新的")
                        block!(dataInfo:"已经是最新的",data:[[""]])
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有更新数据多少条")
                        print(JSON.count)
                        print("输出更新的数据")
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
                            SqlReturnInfo = MySQL.shareMySQL().DataFromNet(infoDataItem)
                            if(SqlReturnInfo == "本地需要更新")
                            {
                                infoData.append(infoDataItem)
                                HasNewPlan = true
                            }
                            else if(SqlReturnInfo == "本地需要上传")
                            {
                                var planData = MySQL.shareMySQL().UpLoadPlan(String(JSON[i][0]))
                                
                                PlanNet.sharedPlan()?.UpLoadPlan(planData,block:{(dataInfo) -> Void in
                                    if dataInfo == "传输成功"
                                    {
                                        print("本地上传服务器传输成功")
                                    }
                                    else if dataInfo == "传输失败"
                                    {
                                        print("本地上传服务器传输失败")
                                    }
                                    else if dataInfo == "网络错误"
                                    {
                                        print("本地上传服务器网络错误")
                                    }
                                })
                            }
                            else
                            {
                                print("本地不用更新")
                            }
                        }
                        print(infoData)
                        print("以上输出更新的数据")
                        if(HasNewPlan == true)
                        {
                            block!(dataInfo:"有更新数据",data: infoData)
                        }
                        else
                        {
                            block!(dataInfo:"已经是最新的",data: infoData)
                        }
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    block!(dataInfo:"网络错误",data:[[""]])
                    break
                }
        }
        print("Step:5")
    }
    
    //上传plan到服务器
    func UpLoadPlan(planData:[String:String],block:NetworkBlockInfo?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/UpLoadPlan.php"
        
        Alamofire.request(.POST, urlString, parameters: planData)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "传输失败")
                    {
                        print("upLoad传输失败")
                        block?(dataInfo:"传输失败")
                    }
                    else if(str == "传输成功")
                    {
                        print("upLoad传输成功")
                        block?(dataInfo:"传输成功")
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

    func DownPlanDataCell(inout IsLoading:Bool,inout PlanCell:PlanTableViewCell)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/downPlan.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.returnMyUid())]
        
        print(LoginModel.sharedLoginModel()?.returnMyUid())
        print("输出更新动态请求的lastDate")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "已经是最新的")
                    {
                        print("已经是最新的")
                    }
                    else if let JSON = response.result.value as? NSArray
                    {
                        print("有更新数据多少条")
                        print(JSON.count)
                        print("输出更新的数据")
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
                            SqlReturnInfo = MySQL.shareMySQL().DataFromNet(infoDataItem)
                            if(SqlReturnInfo == "本地需要更新")
                            {
                                infoData.append(infoDataItem)
                                HasNewPlan = true
                            }
                            else if(SqlReturnInfo == "本地需要上传")
                            {
                                var planData = MySQL.shareMySQL().searchPlan(String(JSON[i][0]))
                                
                                PlanNet.sharedPlan()?.UpLoadPlan(planData,block:{(dataInfo) -> Void in
                                    if dataInfo == "传输成功"
                                    {
                                        print("本地上传服务器传输成功")
                                    }
                                    else if dataInfo == "传输失败"
                                    {
                                        print("本地上传服务器传输失败")
                                    }
                                    else if dataInfo == "网络错误"
                                    {
                                        print("本地上传服务器网络错误")
                                    }
                                })
                            }
                            else
                            {
                                print("本地不用更新")
                            }
                        }
                        print(infoData)
                        print("以上输出更新的数据")
                        if(HasNewPlan == true)
                        {
                        }
                        else
                        {
                        }
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    break
                }
            }.progress { (bytesWrite:Int64, totalBytesWrite:Int64, totalBytesExpectedToWrite:Int64) in
                print("bytesWrite:",bytesWrite)
                print("totalBytesWrite:",totalBytesWrite)
                print("totalBytesExpectedToWrite:",totalBytesExpectedToWrite)
        }
    }
    
    
    func downDynamicImage(url:String,dynamic_id:String){
        //按动态id命名图片
        var userDirForDynamic="/zhiye/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic"
        print("downkaishi ")
        print(userDirForDynamic)
        download.shareMyDownload().downImage(url,dir:userDirForDynamic,fileName:dynamic_id,fileType:".jpg")
    }
}

