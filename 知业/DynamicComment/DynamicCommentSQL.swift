import Foundation

extension MySQL{

    //uid为自己 fuid为关注的好友uid   status 0 是陌生人 1是好友  2是黑名单
    func addComment(uid:String,fuid:String)  {
        let sqlSelect = "select * from zhiye_Friend where uid = "+String(uid) + " and fuid = " + fuid
        print("sqlSelect: \(sqlSelect)")
        //通过封装的方法执行sql
        let data = SQLiteDB.sharedInstance().query(sqlSelect)
        if(data.count > 0)
        {
            let sql = "update zhiye_Friend set status = 1 where uid = " + uid + " and fuid = " + fuid
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
        }
        else
        {
            let sql = "insert into zhiye_Friend values(\(uid),\(fuid),1)"
            print("sql: \(sql)")
            //通过封装的方法执行sql
            let result = SQLiteDB.sharedInstance().execute(sql)
        }
    }
    
    //uid为自己 fuid为关注的好友uid   status 0 是陌生人 1是好友  2是黑名单
    func deleteComment(uid:String,fuid:String)  {
        let sql = "update zhiye_Friend set uid = \(uid),fuid =  \(fuid), status = 0"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = SQLiteDB.sharedInstance().execute(sql)
    }
    
}