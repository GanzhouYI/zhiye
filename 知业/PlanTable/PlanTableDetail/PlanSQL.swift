//
//  dynamicSQL.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/4/21.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation

extension MySQL{
    
    func lastDateDynamic() -> String {
//        let sql = "SELECT * from zhiye_Dynamic where dynamic_date=(select max(dynamic_date) from zhiye_Dynamic)"
        let sql = "select dynamic_date from zhiye_Dynamic order by dynamic_date desc"
        var data = SQLiteDB.sharedInstance().query(sql)
        let date:String!
        print("输出最后的更新时间lastDate")
        if(data.count==0)
        {
            date="2016-04-19 0:0:0"
        }
        else
        {
        print(data[0])
        print("以上输出最后的更新时间lastDate")
        date=String(data[0]["dynamic_date"]!)
        }
        return date
    }
    
    func searchAllDynamic() {
        //let sql = "select * from zhiye_Dynamic"
        //let data = SQLiteDB.sharedInstance().query(sql)
        //print(data)
        
}
    
    func searchDynamic() -> [FirstTableMessageItem] {
        var FirstMessage = Array<FirstTableMessageItem>()
        
        let sql = "select * from zhiye_Dynamic order by dynamic_date desc"
        var data = SQLiteDB.sharedInstance().query(sql)
        print("输出所有动态")
        print(data)
        print("以上输出所用动态")
        //取本地数据库20条数据
        for i in data.count-20...data.count-1 {
            if i>=0
            {
                let temp = FirstTableMessageItem(dynamic_id:String(data[i]["dynamic_id"]!),FirstTableImage: String(data[i]["dynamic_image"]!),FirstTableTitle: String(data[i]["dynamic_title"]!),FirstTableDetail: String(data[i]["dynamic_text"]!),FirstTable_yanjin_Num: Int(String(data[i]["dynamic_num_people_watch"]!))!,FirstTable_pinglun_Num: Int(String(data[i]["dynamic_num_people_praise"]!))!)
                FirstMessage.append(temp)
            }
        }
        return FirstMessage
    }
    


    
    func updateDynamic(dynamic:[String:String]){
        let sql = "update zhiye_Dynamic set uid = '\(dynamic["uid"]!)',dynamic_image = '\(dynamic["dynamic_image"]!)',dynamic_text = '\(dynamic["dynamic_text"]!)',dynamic_num_people_watch = '\(dynamic["dynamic_num_people_watch"]!)',dynamic_num_people_praise = '\(dynamic["dynamic_num_people_praise"]!)',dynamic_date = '\(dynamic["dynamic_date"]!)' ,dynamic_title = '\(dynamic["dynamic_title"]!)'where dynamic_id = '\(dynamic["dynamic_id"])'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("begin update")
        print(result)
    }
    
    func updateDynamic(dynamic:[String]){
        let sql = "update zhiye_Dynamic set uid = '\(dynamic[1])',dynamic_image = '\(dynamic[2])',dynamic_text = '\(dynamic[3])',dynamic_num_people_watch = '\(dynamic[4])',dynamic_num_people_praise = '\(dynamic[5])',dynamic_date = '\(dynamic[6])',dynamic_title = '\(dynamic[7])' where dynamic_id = '\(dynamic[0])'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("更新本地数据库，本地数据库存在几条动态")
        print(result)
    }
    
    func insertDynamic(dynamic:[String:String]) {
        if(isExitsDynamic(dynamic["dynamic_id"]!))
        {
            updateDynamic(dynamic)
        }
        else
        {
            let sql = "insert into zhiye_Dynamic(dynamic_id,uid,dynamic_image,dynamic_text,dynamic_num_people_watch,dynamic_num_people_praise,dynamic_date,dynamic_title) values('\(dynamic["dynamic"]!)','\(dynamic["uid"]!)','\(dynamic["dynamic_image"]!)','\(dynamic["dynamic_text"]!)','\(dynamic["dynamic_num_people_watch"]!)','\(dynamic["dynamic_num_people_praise"]!)','\(dynamic["dynamic_text"]!)','\(dynamic["dynamic_title"]!)')"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
            print(result)
        }
    }
    
    func StrToDate(str:String) -> NSDate {
        // 方式2：自定义日期格式进行转换
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Date 转 String
        //nowString = dateFormatter2.stringFromDate(now)          // 2015-03-24 21:00:00
        
        // String 转 Date
        let now = dateFormatter2.dateFromString(str)!
        return now
    }
    
    func insertDynamic(dynamic:[String]) {
        if(isExitsDynamic(dynamic[0]))
        {
            print("存在动态")
            print(dynamic)
            updateDynamic(dynamic)
        }
        else
        {
            print("插入动态")
            let sql = "insert into zhiye_Dynamic(dynamic_id,uid,dynamic_image,dynamic_text,dynamic_num_people_watch,dynamic_num_people_praise,dynamic_date,dynamic_title) values('\(dynamic[0])','\(dynamic[1])','\(dynamic[2])','\(dynamic[3])','\(dynamic[4])','\(dynamic[5])','\(dynamic[6])','\(dynamic[7])')"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
            print(result)
        }
    }
    
    func isExitsDynamic(dynamic_id:String) -> Bool {
        let sqlDynamic = "select * from zhiye_Dynamic where dynamic_id = '\(dynamic_id)'"
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
    
    func deleteDynamic(dynamic_id:String){
        let sql = "delete from zhiye_Dynamic where dynamic_id = '\(dynamic_id)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }

    
    func removeAllDynamic(){
        let sql = "delete from zhiye_Dynamic"
        //删除Dynamic所有数据
        let result = SQLiteDB.sharedInstance().execute(sql)
        print("Dynamic表中数据为")
        print(result)
        
    }
}