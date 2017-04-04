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
        SQLiteDB.sharedInstance().execute("create table if not exists zhiye_User(uid int primary key,username varchar(30),pwd varchar(50),email varchar(30),phone varchar(20),gender varchar(4),intro text,diqu varchar(40),logo varchar(50))")
        
        //uid为自己 fuid为关注的好友uid   status 0 是陌生人 1是好友  2是黑名单
        SQLiteDB.sharedInstance().execute("create table if not exists zhiye_Friend(uid int,fuid int,status int,primary key(uid,fuid))")
        
        let createStrDynamic = "create table if not exists zhiye_Dynamic(dynamic_id int,uid int,dynamic_image text,dynamic_text text,dynamic_num_people_watch int,dynamic_num_people_praise int,dynamic_date datetime,dynamic_title text,primary key(dynamic_id,uid),foreign key (uid) references zhiye_User(uid) on delete cascade)"
        //如果表还不存在则创建表（其中uid为自增主键）
        SQLiteDB.sharedInstance().execute(createStrDynamic)
        
        //动态评论表
       // let createStrDynamicComment = "create table if not exists zhiye_DynamicComment(dynamic_id int,cuid int,cfloor int,crow int,ctuid int,comment text,comment_time datetime,hasRead int,primary key(dynamic_id,uid,cuid,cfloor,crow,ctuid))"
        //如果表还不存在则创建表（其中uid为自增主键）
       // SQLiteDB.sharedInstance().execute(createStrDynamicComment)
        
        //创建时间、最后修改时间、最近的一次闹钟时间（包括在 哪个子表，哪一行的闹钟）
        //status只在本地有，远端没有该字段
        //status (0、最新数据   1、需要更新   2、需要上传   3、已删除)
        let createStr_zhiyeTable = "create table if not exists zhiye_Table(tid int,uid int,name varchar(32),tip text,status int,create_time datetime,last_time datetime,alarm_time text,Table_yanjin_Num int default 0,Table_pinglun_Num int default 0,ttid int,ttid_row int,primary key(tid,uid),foreign key (uid) references zhiye_User(uid) on delete cascade)"
        //如果表还不存在则创建表
        SQLiteDB.sharedInstance().execute(createStr_zhiyeTable)
        
        
        //primary key(uid,tid,ttid,ttid_row)
        //row_type 二进制默认值  121
        //left_connect 默认值-1为无跳转   right_connect同left_connect
        let createStr_zhiyeTableData = "create table if not exists zhiye_TableData(uid int,tid int,ttid int,ttid_row int,row_type int default 121,left_data text,left_alarm text,left_connect int default -1,right_data text,right_alarm text,right_connect int default -1,primary key(uid,tid,ttid,ttid_row))"
        //如果表还不存在则创建表
        SQLiteDB.sharedInstance().execute(createStr_zhiyeTableData)
        
        
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

    func searchUserInfo(uid:String = String(LoginModel.sharedLoginModel()?.MyUid!))->Dictionary<String,String>
    {
        let sqlString = "select * from zhiye_User where uid ='"+uid+"'"
        var data = SQLiteDB.sharedInstance().query(sqlString)
        var user:[String:String] = [uid:"-1"]
        if data.count > 0 {
            //获取最后一行数据显示
            user = data[data.count - 1] as! [String:String]
        }
        print("searchUserInfo")
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
