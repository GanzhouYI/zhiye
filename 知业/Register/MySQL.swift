//
//  SQL.swift
//  getImage
//
//  Created by __________V|R__________ on 16/4/17.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation

//execute query区别 execute返回总行数，query返回一条执行语句的数据
class MySQL
{
    
    static var SQL:MySQL?
    static var predicate:dispatch_once_t = 0

    class func shareMySQL() -> MySQL {
        dispatch_once(&predicate) { () -> Void in
            SQL = MySQL()
            //获取数据库实例
        }
        return SQL!
    }
    
    func initBoot(){
        //如果数据库不存在则创建数据库
        var db:COpaquePointer = nil//这是swift里的一个c指针  如果不知道指针类型就可以这样定义
        
        let documentsPath:String = {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            return paths.first!
        }()
        
        let path:NSString = "\(documentsPath)/zhiye.sqlite.3"
        let filename = path.UTF8String//转换成c的字符串
        
        if sqlite3_open(filename,&db) != SQLITE_OK
        {
            print("create or open failed...\n")
            sqlite3_close(db)
        }
        else
        {
            print("open DB")
        }
        
        //如果表还不存在则创建表（其中uid为自增主键）
        SQLiteDB.sharedInstance().execute("create table if not exists zhiye_User(uid integer primary key,username varchar(30),pwd varchar(50),email varchar(30),phone varchar(20),gender varchar(4),intro text,diqu varchar(40),logo varchar(50))")
        
        let createStrDynamic = "create table if not exists zhiye_Dynamic(dynamic_id integer primary key,uid int,dynamic_image text,dynamic_text text,dynamic_num_people_watch int,dynamic_num_people_praise int,dynamic_date datetime,dynamic_title text,foreign key (uid) references zhiye_User(uid) on delete cascade)"
        //如果表还不存在则创建表（其中uid为自增主键）
        SQLiteDB.sharedInstance().execute(createStrDynamic)
        
        //创建时间、最后修改时间、最近的一次闹钟时间（包括在 哪个子表，哪一行的闹钟）
        let createStr_zhiyeTable = "create table if not exists zhiye_Table(tid integer primary key,uid int,name varchar(32),tip text,create_time datetime,last_time datetime,alarm_time datetime,Table_yanjin_Num integer,Table_pinglun_Num integer,ttid integer,ttid_row integer,ttidUpdated integer,foreign key (uid) references zhiye_User(uid) on delete cascade)"
        //如果表还不存在则创建表
        SQLiteDB.sharedInstance().execute(createStr_zhiyeTable)
        
        let createStr_zhiyeTableData = "create table if not exists zhiye_TableData(tid integer primary key,ttid int,row_type integer,foreign key (tid) references zhiye_Table(tid) on delete cascade)"
        //如果表还不存在则创建表
        SQLiteDB.sharedInstance().execute(createStr_zhiyeTableData)
        
        var str_left_data = "left_data_"
        var str_left_alarm = "left_alarm_"
        var str_left_connect = "left_connect_"
        
        var str_right_data = "right_data_"
        var str_right_alarm = "right_alarm_"
        var str_right_connect = "right_connect_"
        
        for(var i = 1;i <= 100;i += i)
        {
            str_left_data += String(i)
            str_left_alarm += String(i)
            str_left_connect += String(i)
            
            str_right_data += String(i)
            str_right_alarm += String(i)
            str_right_connect += String(i)
            
            var sql = "alter table zhiye_TableData add "+str_left_data+"text"
            SQLiteDB.sharedInstance().query(sql)
            sql = "alter table zhiye_TableData add "+str_left_alarm+"text"
            SQLiteDB.sharedInstance().query(sql)
            sql = "alter table zhiye_TableData add "+str_left_connect+"text"
            SQLiteDB.sharedInstance().query(sql)
            
            sql = "alter table zhiye_TableData add "+str_right_data+"text"
            SQLiteDB.sharedInstance().query(sql)
            sql = "alter table zhiye_TableData add "+str_right_alarm+"text"
            SQLiteDB.sharedInstance().query(sql)
            sql = "alter table zhiye_TableData add "+str_right_connect+"text"
            SQLiteDB.sharedInstance().query(sql)
        }
    }
    
//从SQLite加载数据
    func initUser(user:[String:String]) {
        let sqlString = "select * from zhiye_User where username ='"+user["username"]!+"'"
        let data = SQLiteDB.sharedInstance().query(sqlString)
        if data.count > 0 {
            //存在，更新数据
            print("init zhiye_User存在")
            updateUser(data[data.count-1]["username"]as!String, user: data[data.count-1])
        }
        else{
            //不存在，创建用户
            print("init zhiye_User不存在")
            let sql = "insert into zhiye_User(username,pwd,email,phone,gender,intro,diqu,logo) values('\(user["username"]!)','\(user["pwd"]!)','\(user["email"]!)','\(user["phone"]!)','\(user["gender"]!)','\(user["intro"]!)','\(user["diqu"]!)','\(user["logo"]!)')"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
            print(result)
        }
        
    }


    func searchUser(username:String)->Dictionary<String,AnyObject>
{
    let sqlString = "select * from zhiye_User where username ='"+username+"'"
    var data = SQLiteDB.sharedInstance().query(sqlString)
    var user:[String:AnyObject] = ["succeed":"false"]
    if data.count > 0 {
        //获取最后一行数据显示
        user = data[data.count - 1]
        user["succeed"] = "true"
    }
    print("searchUser")
    print(user)
    return user
}

    
    func updateUser(username:String,user:[String:AnyObject]){
        print("updateUser")
        let sql = "update zhiye_User set uid = '\(user["uid"]!)',username = '\(user["username"]!)',pwd = '\(user["pwd"]!)',email = '\(user["email"]!)',phone = '\(user["phone"]!)',gender = '\(user["gender"]!)',intro = '\(user["intro"]!)',diqu = '\(user["diqu"]!)',logo = '\(user["logo"]!)' where username = '\(username)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
}
        
    func deleteUser(username:String){
        let sql = "delete from zhiye_User where username = '\(username)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }
    
    func deleteOtherUser(username:String){
        //<>是!=的意思，<>通用，!=可能不通用
        let sql = "delete from zhiye_User where username <> '\(username)'"
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
        print(result)
    }
    
//保存数据到SQLite
func saveUser() {
//    let uname = self.txtUname.text!
//    let mobile = self.txtMobile.text!
//    //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
//    let sql = "insert into t_user(uname,mobile) values('\(uname)','\(mobile)')"
//    print("sql: \(sql)")
//    //通过封装的方法执行sql
//    let result = SQLiteDB.sharedInstance().execute(sql)
//    print(result)
}

}
