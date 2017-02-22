import Foundation

extension MySQL{
    
    func lastDatePlan() -> [String] {
       /* let sql = "select last_time from zhiye_Table where uid ="+String(LoginModel.sharedLoginModel()?.returnMyUid())+" order by last_time desc"
        var data = SQLiteDB.sharedInstance().query(sql)
        var date:[String] = [""]
        print("输出最后的更新时间lastDate")
        if(data.count==0)
        {
            //date.append("0")
        }
        else
        {
            for(var i:Int=0;i<data.count;i++)
            {
                date.append(data[i])
                print(data[i])
            }
        print("以上输出最后的更新时间lastDate")
        }
        return date*/
        return [""]
    }
    
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
        let result = SQLiteDB.sharedInstance().execute(sql)
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
    
    func UpLoadPlan(tid:String) -> [String:String]{
        
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
    }
    
    /*
    func updatePlan(dynamic:[String:String]){
        
        let sql = "update zhiye_Dynamic set uid = '\(dynamic["uid"]!)',dynamic_image = '\(dynamic["dynamic_image"]!)',dynamic_text = '\(dynamic["dynamic_text"]!)',dynamic_num_people_watch = '\(dynamic["dynamic_num_people_watch"]!)',dynamic_num_people_praise = '\(dynamic["dynamic_num_people_praise"]!)',dynamic_date = '\(dynamic["dynamic_date"]!)' ,dynamic_title = '\(dynamic["dynamic_title"]!)'where dynamic_id = '\(dynamic["dynamic_id"])'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin update")
        print(result)
    }*/
    
    /*
    func updatePlan(dynamic:[String]){
        var LocalLastTime = ReturnLastTime(dynamic[4])
        var dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        var dateresult = dateformatter.dateFromString(LocalLastTime)
        
        var NetLastTime = dynamic[5]
        var dateformatter2 = NSDateFormatter()
        dateformatter2.dateFormat = "yyyy-MM-dd hh:mm:ss"
        var dateresult2 = dateformatter2.dateFromString(NetLastTime)
        
        //服务器上的最后修改时间比本地上的新，则update本地
        if(NetLastTime.compare(LocalLastTime) == NSComparisonResult.OrderedDescending)
        {
            print("本地的最后修改时间比服务器上的新")
            let sql = "update zhiye_Table set tid = '\(dynamic[0])',name = '\(dynamic[2])',tip = '\(dynamic[3])',create_time = '\(dynamic[4])',last_time = '\(dynamic[5])',Table_yanjin_Num = '\(dynamic[7])',Table_pinglunNum = '\(dynamic[8])' where dynamic_id = '\(dynamic[0])'"
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
            print("更新本地数据库，本地数据库存在几张表")
            print(result)
        }
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
    
    func updatePlan(dynamic:[String]){
        
        let sql = "update zhiye_Table set name = '\(dynamic[2])',tip = '\(dynamic[3])', last_time = '\(dynamic[5])',alarm_time = '\(dynamic[6])',Table_yanjin_Num = '\(dynamic[7])',Table_pinglun_Num = '\(dynamic[8])',ttid = '\(dynamic[9])' ,ttid_row = '\(dynamic[10])',ttidUpdated = 0 where uid ="+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time='" + dynamic[4] + "'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin update")
        print(result)
    }
    
    /*以创建时间为衡量标准
     如果是同一个时间， id也一样，则认为是同一个表，比较LastTime谁更新，update谁
     如果不同时间， id一样，则上传服务器，服务器返回新id值*/
    func insertPlan(dynamic:[String]) {
        print("插入Plan")
        let sql = "insert into zhiye_Table(tid,uid,name,tip,create_time,last_time,alarm_time,Table_yanjin_Num,Table_pinglun_Num,ttid,ttid_row,ttidUpdated) values('\(dynamic[0])','\(dynamic[1])','\(dynamic[2])','\(dynamic[3])','\(dynamic[4])','\(dynamic[5])','\(dynamic[6])','\(dynamic[7])','\(dynamic[8])','\(dynamic[9])','\(dynamic[10])',0)"
        print("sql: \(sql)")
            //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
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
        let sqlString = "select * from zhiye_Table where uid = "+String(LoginModel.sharedLoginModel()!.returnMyUid())+" and create_time = '" + data[4] + "'"
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
                
                var NetLastTime = data[5]
                var dateformatter2 = NSDateFormatter()
                dateformatter2.dateFormat = "yyyy-MM-dd hh:mm:ss"
                var dateresult2 = dateformatter2.dateFromString(NetLastTime)
                
                //服务器上的最后修改时间比本地上的新，则update本地
                if(NetLastTime.compare(LocalLastTime) == NSComparisonResult.OrderedDescending)
                {
                    updatePlan(data)
                    print("本地需要更新22222")
                    return "本地需要更新"
                }
                else if(LocalLastTime.compare(NetLastTime) == NSComparisonResult.OrderedDescending)
                {
                    print(LocalLastTime)
                    print(NetLastTime)
                    return "本地需要上传"
                }
                else
                {
                    print("本地不用更新22222")
                    return "本地不用更新"
                }
            }
            else//tid不同 证明离线时用户同时在另一个手机创建了新表
            {
                    print("tid不同")
            }
            return "本地不用更新"
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
    
    
    func searchLocalPlan() -> [PlanTableMessageItem] {
        var PlanMessage = Array<PlanTableMessageItem>()
        
        let sql = "select * from zhiye_Table order by create_time asc"
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出所有本地plan")
        print(data)
        for i in 0..<data.count
        {
            let temp = PlanTableMessageItem(tid:Int(String(data[i]["tid"]!))!,ttidUpdated:Int(String(data[i]["tid"]!))!,name:String(data[i]["name"]!),tip:String(data[i]["tip"]!),Table_yanjin_Num:Int(String(data[i]["Table_yanjin_Num"]!))!,Table_pinglun_Num:Int(String(data[i]["Table_pinglun_Num"]!))!)
                
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
    
    func deletePlan(dynamic_id:String){
        let sql = "delete from zhiye_Dynamic where dynamic_id = '\(dynamic_id)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }

    
    func removeAllPlan(){
        let sql = "delete from zhiye_Dynamic"
        //删除Dynamic所有数据
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("Dynamic表中数据为")
        print(result)
        
    }
}