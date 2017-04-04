import UIKit
class CommentItem
{
    /*
     
     */
    var status:Int!
    var uid:Int!
    var username:String = ""
    var email:String = ""
    var phone:String = "-1"
    var gender:String = ""
    var intro:String = ""
    
    //构造空文本消息体
    init()
    {
        status = 0
        uid = -1
        username = ""
        email = ""
        phone = "-1"
        gender = ""
        intro = ""
    }
    
    init(status:Int,uid:Int,
         username:String,email:String,phone:String,
         gender:String,intro:String)
    {
        self.status = status
        self.uid = uid
        self.username = username
        self.email = email
        self.phone = phone
        self.gender = gender
        self.intro = intro
    }
}

class CommentManager
{
    static var CommentTableData:CommentManager?
    static var predicate:dispatch_once_t = 0
    
    //输入的手机号\邮箱\名字
    var searchInfo:String = ""
    var dataMessageItem:Array<CommentItem>
    
    class func shareCommentManager() -> CommentManager {
        dispatch_once(&predicate) { () -> Void in
            CommentTableData = CommentManager()
            //获取数据库实例
        }
        return CommentTableData!
    }
       //构造空文本消息体
    init()
    {
        self.dataMessageItem = Array<CommentItem>()
    }
    
    init(dataMessageItem:Array<CommentItem>)
    {
        self.dataMessageItem = dataMessageItem
    }
    
    func InitData(CommentInfo:String)
    {
        self.searchInfo = CommentInfo
    }
    
    func RefreshComment(data:[[String]])  {
        self.dataMessageItem.removeAll()
        for i in 0...data.count-1 {
            var uid:Int = Int(String(data[i][0]))!
            var username:String = String(data[i][1])
            var email:String = String(data[i][3])
            var phone:String = String(data[i][4])
            var gender:String = String(data[i][5])
            var intro:String = String(data[i][6])
            
            
            //不管服务器数据 status默认0
            var Item:CommentItem = CommentItem(status:0,uid: uid, username: username, email: email, phone: phone, gender: gender, intro: intro)
            self.dataMessageItem.append(Item)
        }
    }
    
    func ReturnCommentCount()->Int
    {
        return dataMessageItem.count
    }
    
    func ReturnCommentCellData(Index:Int) -> CommentItem {
        if(self.dataMessageItem.count>=Index)
        {
            return self.dataMessageItem[Index]
        }
        else
        {
            return CommentItem()
        }
    }
}