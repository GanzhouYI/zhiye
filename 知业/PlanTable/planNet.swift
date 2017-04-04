import Foundation
import Alamofire

class PlanNet:NSObject {
    static var Model:PlanNet?
    //下载更新中的数量
    static var UpdateNumber:Int = 0
    //上传的数量
    static var UpLoadNumber:Int = 0
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
                    print("DownPlan 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "已经是最新的")
                    {
                        print("已经是最新的")
                        block!(dataInfo:"不更改",data:[[""]])
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
                            
                            //服务器端数据和本地对比
                            SqlReturnInfo = MySQL.shareMySQL().DataFromNet(infoDataItem)
                            if(SqlReturnInfo == "本地需要更新")
                            {
                                infoData.append(infoDataItem)
                                block!(dataInfo:"要更改",data: infoData)
                            }
                            else if(SqlReturnInfo == "本地需要上传")
                            {
                                print("本地需要上传")
                                block!(dataInfo:"要更改",data: infoData)
                            }
                            else
                            {
                                print("本地不用更新")
                                block!(dataInfo:"不更改",data: infoData)
                            }
                        }
                        print(infoData)
                        print("以上输出更新的数据")
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
        print("Step:5")
    }
    
    //服务器是否存在该表,不存在则创建
    func ServerIsExistPlan(uid:String,tid:String,block:NetworkBlockInfo?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/IsExistPlan.php"
        var PlanInfo:[String] = MySQL.shareMySQL().ReturnPlanInfoToServer(tid, uid: uid)
        var mysql = "insert into zhiye_Table (tid,uid,name,tip,status,create_time,last_time,alarm_time,Table_yanjin_Num,Table_pinglun_Num,ttid,ttid_row) values("
        mysql += tid+","
        mysql += uid+","
        mysql += "'"+PlanInfo[0]+"'"+","
        mysql += "'"+PlanInfo[1]+"'"+","
        mysql += PlanInfo[2]+","
        mysql += "'"+PlanInfo[3]+"'"+","
        mysql += "'"+PlanInfo[4]+"'"+","
        mysql += "'"+PlanInfo[5]+"'"+","
        mysql += PlanInfo[6]+","
        mysql += PlanInfo[7]+","
        mysql += PlanInfo[8]+","
        mysql += PlanInfo[9]+")"

        //var parameter:[String:String] = ["mysql":mysql]
        var parameter:[String:String] = ["uid":uid,"tid":tid,"name":PlanInfo[0],"tip":PlanInfo[1],"status":PlanInfo[2],"create_time":PlanInfo[3],"last_time":PlanInfo[4],"alarm_time":PlanInfo[5],"Table_yanjin_Num":PlanInfo[6],"Table_pinglun_Num":PlanInfo[7],"ttid":PlanInfo[8],"ttid_row":PlanInfo[9]]
        print("ServerIsExistPlan")
        print(parameter)
        Alamofire.request(.POST, urlString, parameters: parameter)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("UpLoadPlan 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    print(str)
                    
                    if(str == "创建成功")
                    {
                        print("server创建plan成功")
                        block?(dataInfo:"创建成功")
                    }
                    else if(str == "创建失败")
                    {
                        print("创建失败")
                        block?(dataInfo:"创建失败")
                    }
                    break
                case .Failure:
                    print("网络连接错误")
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
    
    //上传planCell到服务器
    func UpLoadPlanCell(uid:String,tid:String,block:NetworkBlockInfo?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/UpLoadPlanCell.php"
        //var parameter:[String:AnyObject] = ["cellCount":"10","1":["uid":"1","tid":"0","ttid":"0","ttid_row":"1","row_type":"987","left_data":"gai","left_alarm":"06,00,一二","left_connect":"-1","right_data":"gai","right_alarm":"06,00,二四","right_connect":"-1"]]
        var parameter:[String:String] = ["uid":uid,"tid":tid,"sqlServer":MySQL.shareMySQL().UpLoadUpdateCell(uid, tid: tid)]
        
        //因为之前ServerIsExistPlan在服务器创建了表，但是cell里是空的所以更新成功
        if(parameter["sqlServer"] == "0")
        {
            print("更新成功")
            MySQL.shareMySQL().UpdatePlanStatus("0", tid: Int(tid)!)
            block?(dataInfo:"更新成功")
            return
        }
        Alamofire.request(.POST, urlString, parameters: parameter)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("UpLoadPlan 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    print(str)
                    
                    if(str == "更新成功")
                    {
                        print("更新成功")
                        MySQL.shareMySQL().UpdatePlanStatus("0", tid: Int(tid)!)
                        block?(dataInfo:"更新成功")
                    }
                    else if(str == "更新失败")
                    {
                        print("upLoad更新失败")
                        block?(dataInfo:"更新失败")
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

    func DownPlanDataCell(tid:Int,msgItem:PlanTableMessageItem)
    {
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        let urlString:String = "http://www.loveinbc.com/zhiye/downPlanCell.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.returnMyUid()),"tid":String(tid)]
        
        print(LoginModel.sharedLoginModel()?.returnMyUid())
        print("输出更新动态请求的lastDate")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("DownPlanDataCell 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if let JSON = response.result.value as? NSArray
                    {
                        print("有多少张子表")
                        print(JSON.count)
                        print("输出更新的数据")
                        
                        var infoDataItem = [String]()
                        var infoData=[[String]]()
                        var SqlReturnInfo:String = ""

                        //多少张表
                        for i in 0..<JSON.count
                        {
                            infoDataItem.removeAll()
                            //表中列
                            for n in 0..<JSON[i].count
                            {
                                if(n<=JSON[i].count)
                                {
                                    //var Item = String(JSON[i][n])
                                    //Item.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                                    if(String(JSON[i][n]) == "<null>")
                                    {
                                        print(String(i)+String(n)+" 是null")
                                        infoDataItem.append("''")
                                    }
                                    else
                                    {
                                        infoDataItem.append(String(JSON[i][n]))
                                    }
                                }
                                else
                                {
                                    infoDataItem.append("")
                                }
                            }
                            
                            //
                            MySQL.shareMySQL().insertPlanCell(infoDataItem)
                        }
                    }

                    //下载完成
                    MySQL.shareMySQL().UpdatePlanStatus(String(0), tid: tid)
                    msgItem.status=0
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

