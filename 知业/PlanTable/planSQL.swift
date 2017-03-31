import Foundation

extension MySQL{
    
    func createPlan(plan:[String:String]){
        let sqlString = "select * from zhiye_Table where name ='"+plan["name"]!+"'"
        let data = SQLiteDB.sharedInstance().query(sqlString)
        if data.count > 0 {
            //存在，更新数据
            print("init zhiye_Table存在")
            return
        }
        let sql = "insert into zhiye_Table(uid,name,tip,create_time,last_time,alarm_time) values('"+String(LoginModel.sharedLoginModel()?.returnMyUid())+"'\(plan["name"]!)','\(plan["tip"]!)','\(plan["create_time"]!)','\(plan["last_time"]!)','\(plan["alarm_time"]!)')"
        //通过封装的方法执行sql
        SQLiteDB.sharedInstance().execute(sql)
    }
    
    func searchAllPlan()-> [[String:AnyObject]]{
        let sql = "select * from zhiye_Table where uid ="+String(LoginModel.sharedLoginModel()?.returnMyUid())
        var data = SQLiteDB.sharedInstance().query(sql)
        return data
       // print(data)
}
    
    func searchPlan(tid:String) -> [String:String]{
        
        let sql = "select * from zhiye_Table where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and tid="+tid
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出查询tid的动态")
        print(data)
        print("以上输出所用有动态")
        var Item:[String:String] = ["tid":String(data[0]["tid"]!),"title":String(data[0]["name"]!),"tip":String(data[0]["tip"]!),"Table_yanjin_Num":String(data[0]["Table_yanjin_Num"]!),"Table_pinglun_Num":String(data[0]["Table_pinglun_Num"]!)]
        return Item
    }
    
    func ReturnPlanInfo(tid:Int,uid:Int = LoginModel.sharedLoginModel()!.returnMyUid())  ->[String] {
        let sql = "select * from zhiye_Table where uid ="+String(uid)+" and tid="+String(tid)
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出查询tid的Info")
        print(data)
        var Item:[String] = [String(data[0]["name"]),String(data[0]["tip"])]
        return Item
    }
    
    func ReturnPlanCellData(tid:Int,ttid:Int,uid:Int = LoginModel.sharedLoginModel()!.returnMyUid()) -> Array<PlanTableCellDataMessageItem>{
        
        let sql = "select * from zhiye_TableData where uid ="+String(uid)+" and tid="+String(tid)+" and ttid="+String(ttid)
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出查询tid的动态")
        print(data)
        print("以上输出所用有动态")
        var temp:Array<PlanTableCellDataMessageItem>=Array<PlanTableCellDataMessageItem>()
        
        for(var i=0;i<=data.count-1;i+=1)
        {
            var row_type:Int = Int(String(data[i]["row_type"]!))!
            var left_data:String = String(data[i]["left_data"]!)
            var left_alarm:String = String(data[i]["left_alarm"]!)
            var left_connect:String = String(data[i]["left_connect"]!)
            var right_data:String = String(data[i]["right_data"]!)
            var right_alarm:String = String(data[i]["right_alarm"]!)
            var right_connect:String = String(data[i]["right_connect"]!)
            
            var Item:PlanTableCellDataMessageItem = PlanTableCellDataMessageItem(row_type:row_type ,left_data:left_data,left_alarm:left_alarm,left_connect:left_connect,right_data:right_data,right_alarm:right_alarm,right_connect:right_connect)
            temp.append(Item)
        }
        return temp
    }
    
   /* func UpLoadPlan(tid:String) -> [String:String]{
        
        let sqlSet = "update zhiye_Table set ttidUpdated = 2 where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and tid='" + tid + "'"
        //通过封装的方法执行sql
        let Setresult = SQLiteDB.sharedInstance().execute(sqlSet)
        print(Setresult)
        
        let sql = "select * from zhiye_Table where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and tid="+tid
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出查询tid的动态")
        print(data)
        print("以上输出所用有动态")
        var Item:[String:String] = ["tid":String(data[0]["tid"]!),"title":String(data[0]["name"]!),"tip":String(data[0]["tip"]!)]
        return Item
    }*/
    

    func ReturnLastTime(create_time:String) -> String {
        let sql = "select last_time from zhiye_Table where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time='" + create_time + "'"
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出最后的更新时间lastDate")
        if(data.count==0)
        {
            print("ReturnLastTime函数返回   不存在改表")
            return ""
        }
        else
        {
            print(data[0])
            print("以上输出最后的更新时间lastDate")
            return String(data[0]["create_time"])
        }
    }
    
    //status (0、最新数据   1、需要更新   2、需要上传   3、已删除)
    func UpdatePlanStatus(status:String,create_time:String){
    let sql = "update zhiye_Table set status = '\(status)' where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time='" + create_time + "'"
    //通过封装的方法执行sql
    let result = SQLiteDB.sharedInstance().execute(sql)
    print("begin updateStatus")
    print(result)
    }

    //status (0、最新数据   1、需要更新   2、需要上传   3、已删除)
    func UpdatePlanStatus(status:String,tid:Int){
        let sql = "update zhiye_Table set status = '\(status)' where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and tid='" + String(tid) + "'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin updateStatus")
        print(result)
    }
    
    //从服务器端 更新到本地
    func updatePlan(dynamic:[String]){
        let sql = "update zhiye_Table set name = '\(dynamic[2])',tip = '\(dynamic[3])', last_time = '\(dynamic[5])',alarm_time = '\(dynamic[6])',Table_yanjin_Num = '\(dynamic[7])',Table_pinglun_Num = '\(dynamic[8])',ttid = '\(dynamic[9])' ,ttid_row = '\(dynamic[10])',ttidUpdated = 0 where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time='" + dynamic[4] + "'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin update")
        print(result)
    }
    
    //set本地数据库，设置last_time、status
    func setLocalPlan(dynamic:[String],uid:String = String(LoginModel.sharedLoginModel()!.returnMyUid())){
        let sql = "update zhiye_Table set name = '\(dynamic[1])',tip = '\(dynamic[2])' where uid ="+uid+" and tid='" + dynamic[0] + "'"
        //通过封装的方法执行sql
        print(sql)
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin setLoaclPlan")
        print(result)
        
        setLocalStatus(dynamic[0],status: String(2),uid: uid)
        
    }
    
    //set本地数据库，设置left_data、right_data、row_type
    //tid,ttid,ttid_row
    func setLocalPlanCellData(dynamic:[String],uid:String = String(LoginModel.sharedLoginModel()!.returnMyUid())){
        let sql = "update zhiye_TableData set row_type = '\(dynamic[3])',left_data = '\(dynamic[4])',right_data = '\(dynamic[5])' where uid = "+uid+" and tid = '" + dynamic[0] + "' and ttid = '" + dynamic[1] + "' and ttid_row = '" + dynamic[2] + "'"
        //通过封装的方法执行sql
        print(sql)
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("setLocalPlanCellData")
        print(result)
        
        // dynamic 为tid
        setLocalStatus(dynamic[0],status: String(2),uid: uid)
    }
    
    //set本地数据库，设置left_alarm、right_alarm、row_type
    //tid,ttid,ttid_row
    func setLocalPlanCellAlarm(dynamic:[String],uid:String = String(LoginModel.sharedLoginModel()!.returnMyUid())){
        let sql = "update zhiye_TableData set row_type = '\(dynamic[3])',left_alarm = '\(dynamic[4])',right_alarm = '\(dynamic[5])' where uid = "+uid+" and tid = '" + dynamic[0] + "' and ttid = '" + dynamic[1] + "' and ttid_row = '" + dynamic[2] + "'"
        //通过封装的方法执行sql
        print(sql)
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("setLocalPlanCellAlarm")
        print(result)
        
        let sql1 = "select * from zhiye_TableData"
        var data1 = SQLiteDB.sharedInstance().query(sql1)
        print(data1)
        // dynamic 为tid
        setLocalStatus(dynamic[0],status: String(2),uid: uid)
    }
    
    func setLocalStatus(tid:String,status:String,uid:String=String(LoginModel.sharedLoginModel()!.returnMyUid())) {
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        let sql = "update zhiye_Table set last_time = '\(strNowTime)',status = "+status+" where uid ="+uid+" and tid='" + tid + "'"
        //通过封装的方法执行sql
        print(sql)
        let result = SQLiteDB.sharedInstance().execute(sql)
        
        PlanTableMessageManage.sharePlanMessageManage().SetPlanStatus(Int(tid)!, status: Int(status)!)
        print("begin setLocalStatus")
        print(result)
    }
    
    func updatePlanCell(dynamic:[String]){
        
        let sql = "update zhiye_TableData set name = '\(dynamic[2])',tip = '\(dynamic[3])', last_time = '\(dynamic[5])',alarm_time = '\(dynamic[6])',Table_yanjin_Num = '\(dynamic[7])',Table_pinglun_Num = '\(dynamic[8])',ttid = '\(dynamic[9])' ,ttid_row = '\(dynamic[10])',ttidUpdated = 0 where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time='" + dynamic[4] + "'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin update")
        print(result)
    }
    
    func DeletePlan(tid:Int,uid:Int = (LoginModel.sharedLoginModel()?.MyUid!)!) {
        print("DeletePlan")
        print("zhiye_TableData")
        
        setLocalStatus(String(tid), status: String(3),uid: String(uid))
        /*let sqlCell = "delete from zhiye_TableData where tid = " + String(tid) + " and uid = " + String(uid)
        print("sql: \(sqlCell)")
        //通过封装的方法执行sql
        let resultCell = SQLiteDB.sharedInstance().execute(sqlCell)
        
        let sqlPlan = "delete from zhiye_Table where tid = " + String(tid) + " and uid = " + String(uid)
        print("sql: \(sqlPlan)")
        //通过封装的方法执行sql
        let resultPlan = SQLiteDB.sharedInstance().execute(sqlPlan)
        print(resultPlan)*/
    }
    
    /*以创建时间为衡量标准
     如果是同一个时间， id也一样，则认为是同一个表，比较LastTime谁更新，update谁
     如果不同时间， id一样，则上传服务器，服务器返回新id值*/
    // 服务器上的status只有两种情况 最新和删除
    //    status (0、最新数据   1、需要更新   2、需要上传   3、已删除  4、正在上传   5、正在下载  6、需要下载)
    
    //本地不存在该plan是第一次下载
    //插入表头
    func insertPlan(dynamic:[String]) {
        print("插入Plan")
        let sql = "insert into zhiye_Table(tid,uid,name,tip,status,create_time,last_time,alarm_time,Table_yanjin_Num,Table_pinglun_Num,ttid,ttid_row) values('\(dynamic[0])','\(dynamic[1])','\(dynamic[2])','\(dynamic[3])',6,'\(dynamic[5])','\(dynamic[6])','\(dynamic[7])','\(dynamic[8])','\(dynamic[9])','\(dynamic[10])','\(dynamic[11])')"
        print("sql: \(sql)")
            //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }
    
    //插入表头
    func insertEmptyPlan(uid:Int!=LoginModel.sharedLoginModel()?.MyUid!) {
        print("插入insertEmptyPlan")
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        // 2015-03-24 21:00:00
        var name:String = "请输出表名"
        var tip:String = ""
        var status:String = "2"
        var tid:Int = 0
        
        let sqlSelect = "select Max(tid) from zhiye_Table where uid = "+String(uid)
        print("sqlSelect: \(sqlSelect)")
        //通过封装的方法执行sql
        let data = SQLiteDB.sharedInstance().query(sqlSelect)
        if(data.count > 0)
        {
            tid = Int(String(data[0]["Max(tid)"]!))! + 1
        }
        
        let sql = "insert into zhiye_Table(tid,uid,name,status,create_time,last_time) values('\(String(tid))','\(String(uid))','\(name)','\(status)','\(strNowTime)','\(strNowTime)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
        
        let sqlSelect1 = "select * from zhiye_Table where uid = "+String(uid)
        print("sqlSelect: \(sqlSelect1)")
        //通过封装的方法执行sql
        let data1 = SQLiteDB.sharedInstance().query(sqlSelect1)
        print(data1)
        
    }
    
    //插入子表
    func insertPlanCell(dynamic:[String]) {
        print("插入PlanCell")
        var strDynamic = ""
        strDynamic += dynamic[0]
        for(var i=1; i<=dynamic.count-1; i++)
        {
            strDynamic += ","
            strDynamic += "'"
            strDynamic += dynamic[i]
            strDynamic += "'"
        }
        
        let sql = "insert into zhiye_TableData values(\(strDynamic))"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }
    
    
    //插入空子表，需要有uid、tid、ttid、ttid_row
    func insertPlanEmptyCell(dynamic:[String]) {
        print("插入PlanCell")
        var strDynamic = ""
        strDynamic += dynamic[0]
        for(var i=1; i<=dynamic.count-1; i++)
        {
            strDynamic += ","
            strDynamic += "'"
            strDynamic += dynamic[i]
            strDynamic += "'"
        }
        
        strDynamic += ","
        strDynamic += "'"
        //因为新建空表格需要上传 row_type = 1001111001 = 633
        strDynamic += "633"
        strDynamic += "'"
        //应该设置一个变量，记录表的字段数目，此时为11，则循环11次
        for(var i=1; i<=6; i++)
        {
            strDynamic += ","
            strDynamic += "'"
            strDynamic += "'"
        }
        
        let sql = "insert into zhiye_TableData values(\(strDynamic))"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
        
        setLocalStatus(dynamic[1], status: String(2),uid: dynamic[0])
        
        let sql1 = "select * from zhiye_TableData"
        var data = SQLiteDB.sharedInstance().query(sql1)
        print(data)
    }
    
    func searchLocalPlanCell() -> [PlanTableMessageItem] {
        var PlanMessage = Array<PlanTableMessageItem>()
        
        let sql = "select * from zhiye_Table order by create_time asc"
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出所有本地plan")
        print(data)
        for i in 0..<data.count
        {
            let temp = PlanTableMessageItem(tid:Int(String(data[i]["tid"]!))!,status:Int(String(data[i]["status"]!))!,name:String(data[i]["name"]!),tip:String(data[i]["tip"]!),Table_yanjin_Num:Int(String(data[i]["Table_yanjin_Num"]!))!,Table_pinglun_Num:Int(String(data[i]["Table_pinglun_Num"]!))!)
            
            PlanMessage.append(temp)
        }
        return PlanMessage
    }
    
    //检查是否是需要更新的表
    //如果create_time存在，则查看last_time是否需要更新
    //如果create_time不存在，则插入
    //发生了更新操作
    
    /*  服务器zhiye_Table结构
        0 tid   1uid    2 name   3 tip  
       4 create_time  5 last_time 
        6 alarm_time 
        7 Table_yanjin_Num
        8 Table_pinglun_Num    
        9 ttid    10  ttid_row
        11 ttidUpdated   是否更新完成ttid子表，0代表没有，1代表更新完成
     */
    
    func DataFromNet(data:[String]) -> String
    {
        let sqlString = "select * from zhiye_Table where uid = "+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time = '" + data[5] + "'"
        let MysqlData = SQLiteDB.sharedInstance().query(sqlString)
        
        //存在这条动态
        if MysqlData.count > 0
        {
            //存在这条数据
            print("init zhiye_Table存在")
            print(data[0])
            print(String(MysqlData[0]["tid"]))
            //并且tid相同
            if(data[0] == String(MysqlData[0]["tid"]!))
            {
                var LocalLastTime = String(MysqlData[0]["last_time"]!)
                LocalLastTime=LocalLastTime.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                var dateformatter = NSDateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                var dateresult = dateformatter.dateFromString(LocalLastTime)
                
                var NetLastTime = data[6]
                var dateformatter2 = NSDateFormatter()
                dateformatter2.dateFormat = "yyyy-MM-dd hh:mm:ss"
                var dateresult2 = dateformatter2.dateFromString(NetLastTime)
                
                //服务器上的最后修改时间比本地上的新，则update本地
                if(NetLastTime.compare(LocalLastTime) == NSComparisonResult.OrderedDescending)
                {
                    UpdatePlanStatus(String(1), create_time: data[5])
                    print("本地需要更新22222")
                    return "本地需要更新"
                }//本地比服务器新，需要上传
                else if(LocalLastTime.compare(NetLastTime) == NSComparisonResult.OrderedDescending)
                {
                    print(LocalLastTime)
                    print(NetLastTime)
                    UpdatePlanStatus(String(2), create_time: data[5])
                   /* var planData = UpLoadPlan(data[0])
                    
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
                    })*/
                    return "本地需要上传"
                }
                else
                {
                    UpdatePlanStatus(String(0), create_time: data[5])
                    print("本地不用更新22222")
                    return "本地不用更新"
                }
            }
            else//tid不同 证明离线时用户同时在另一个手机创建了新表
            {
                    print("tid不同")
                return "本地不用更新"
            }
        }
        else//不存在这条动态
        {
            print("不存在该动态")
            let sqlString_1 = "select * from zhiye_Table where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and tid=" + data[0]
            let MysqlData_1 = SQLiteDB.sharedInstance().query(sqlString_1)
            
            //本地存在该tid
            if(MysqlData_1.count>0)
            {
                
            }
            else//本地不存在该tid，则直接插入
            {
                insertPlan(data)
                return "本地需要更新"
            }
        }
        return "本地不用更新"
    }
    
    
    func searchLocalPlan(uid:Int=LoginModel.sharedLoginModel()!.returnMyUid()) -> [PlanTableMessageItem] {
        var PlanMessage = Array<PlanTableMessageItem>()
        
        let sql = "select * from zhiye_Table where uid="+String(uid)+" and status != 3 order by create_time asc"
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出所有本地plan")
        print(data)
        for i in 0..<data.count
        {
            var tip:String = data[i]["tip"] != nil ? String(data[i]["tip"]!) : ""
            var Table_yanjin_Num:Int = String(data[i]["Table_yanjin_Num"]) != nil ? Int(String(data[i]["Table_yanjin_Num"]!))! : 0
            var Table_pinglun_Num:Int = String(data[i]["Table_pinglun_Num"]) != nil ? Int(String(data[i]["Table_pinglun_Num"]!))! : 0
            
            let temp = PlanTableMessageItem(tid:Int(String(data[i]["tid"]!))!,status:Int(String(data[i]["status"]!))!,name:String(data[i]["name"]!),tip:tip,Table_yanjin_Num:Table_yanjin_Num,Table_pinglun_Num:Table_pinglun_Num)
                
                PlanMessage.append(temp)
        }
        return PlanMessage
    }

    
    
    /*
    func insertPlan(dynamic:[String:String]) {
        if(isExitsPlan(dynamic["dynamic_id"]!))
        {
            updateDynamic(dynamic)
            print("存在此Plan，不需要插入操作，执行完了update")
        }
        else
        {
            let sql = "insert into zhiye_Dynamic(dynamic_id,uid,dynamic_image,dynamic_text,dynamic_num_people_watch,dynamic_num_people_praise,dynamic_date,dynamic_title) values('\(dynamic["dynamic"]!)','\(dynamic["uid"]!)','\(dynamic["dynamic_image"]!)','\(dynamic["dynamic_text"]!)','\(dynamic["dynamic_num_people_watch"]!)','\(dynamic["dynamic_num_people_praise"]!)','\(dynamic["dynamic_text"]!)','\(dynamic["dynamic_title"]!)')"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
            print(result)
        }
    }*/
    
    func PlanStrToDate(str:String) -> NSDate {
        // 方式2：自定义日期格式进行转换
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Date 转 String
        //nowString = dateFormatter2.stringFromDate(now)          // 2015-03-24 21:00:00
        
        // String 转 Date
        let now = dateFormatter2.dateFromString(str)!
        return now
    }
    
    
    
    //
    func isExitsPlan(tid:String,create_time:String) -> Bool {
        let sqlDynamic = "select * from zhiye_Table where uid = "+String(LoginModel.sharedLoginModel()?.returnMyUid())+" and create_time = '\(create_time)' and tid = '\(tid)'"
        let dataDynamic = SQLiteDB.sharedInstance().query(sqlDynamic)
        if dataDynamic.count > 0
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //func deleteDynamic(dynamic_id:String){
    //    let sql = "delete from zhiye_Dynamic where dynamic_id = '\(dynamic_id)'"
        //通过封装的方法执行sql
//        let result = SQLiteDB.sharedInstance().execute(sql)
  //      print(result)
  //  }

    
    func removeAllPlan(){
        let sql = "delete from zhiye_Dynamic"
        //删除Dynamic所有数据
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("Dynamic表中数据为")
        print(result)
        
    }
}