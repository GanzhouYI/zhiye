import UIKit
class FriendItem
{
    /*
     0陌生人 1好友 2黑名单
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
        status = 1
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

class FriendManager
{
    static var FriendTableData:FriendManager?
    static var predicate:dispatch_once_t = 0
    
    var myFriend:Array<FriendItem>
    var friendMe:Array<FriendItem>
    
    class func shareFriendManager() -> FriendManager {
        dispatch_once(&predicate) { () -> Void in
            FriendTableData = FriendManager()
            //获取数据库实例
        }
        return FriendTableData!
    }
       //构造空文本消息体
    init()
    {
        self.myFriend = Array<FriendItem>()
        self.friendMe = Array<FriendItem>()
    }
    
    init(myFriend:Array<FriendItem>,friendMe:Array<FriendItem>)
    {
        self.myFriend = myFriend
        self.friendMe = friendMe
    }
    
    
    func RefreshFriend(IsMyFriend:Bool,data:[[String]])  {
        if(IsMyFriend == true)
        {
        self.myFriend.removeAll()
        for i in 0...data.count-1 {
            var uid:Int = Int(String(data[i][0]))!
            var username:String = String(data[i][1])
            var email:String = String(data[i][3])
            var phone:String = String(data[i][4])
            var gender:String = String(data[i][5])
            var intro:String = String(data[i][6])
            
            
            //不管服务器数据 status默认0
            var Item:FriendItem = FriendItem(status:1,uid: uid, username: username, email: email, phone: phone, gender: gender, intro: intro)
            self.myFriend.append(Item)
        }
        }
        else
        {
            self.friendMe.removeAll()
            for i in 0...data.count-1 {
                var uid:Int = Int(String(data[i][0]))!
                var username:String = String(data[i][1])
                var email:String = String(data[i][3])
                var phone:String = String(data[i][4])
                var gender:String = String(data[i][5])
                var intro:String = String(data[i][6])
                
                
                //不管服务器数据 status默认0
                var Item:FriendItem = FriendItem(status:0,uid: uid, username: username, email: email, phone: phone, gender: gender, intro: intro)
                self.friendMe.append(Item)
            }
        }
    }
    
    func ReturnFriendCount(IsMyFriend:Bool)->Int
    {
        if(IsMyFriend == true)
        {
            return myFriend.count
        }
        return friendMe.count
    }
    
    func ReturnFriendCellData(IsMyFriend:Bool,Index:Int) -> FriendItem {
        if(IsMyFriend == true)
        {
            if(self.myFriend.count>=Index)
            {
                return self.myFriend[Index]
            }
            else
            {
                return FriendItem()
            }
        }
        else
        {
            if(self.friendMe.count>=Index)
            {
                return self.friendMe[Index]
            }
            else
            {
                return FriendItem()
            }
        }
    }
}