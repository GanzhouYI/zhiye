import UIKit

//统计有几个crow就可以返回table有几个row
class DynamicCommentItem
{
    var dynamic_id:String!
    var nameDelegate:Dynamic_Name_Delegate?

    //评论人
    var cuid:String!
    var cname:String = ""
        {
        didSet {
            if((nameDelegate) != nil)
            {
                nameDelegate?.Dynamic_CName_Changed(crow,Cname: cname)
            }
        }
    }
    
    var cfloor:String!
    var crow:String!
    
    //评论人回复给谁
    var ctuid:String!
    var ctname:String = ""
        {
        didSet {
            if((nameDelegate) != nil)
            {
                nameDelegate?.Dynamic_CTName_Changed(crow,CTname: ctname)
            }
        }
    }
    
    var comment:String!
    var comment_time:String!
    var hasRead:String!
    
    //构造空文本消息体
    init()
    {
        dynamic_id = "-1"
        
        cuid = "-1"
        cname = ""
        
        cfloor = "-1"
        crow = "-1"
        
        ctuid = ""
        ctname = ""
        
        comment = ""
        comment_time = ""
        hasRead = ""
}
    
    init(dynamic_id:String, cuid: String, cfloor: String, crow: String, ctuid: String, comment: String,comment_time: String,hasRead: String)
    {
        self.dynamic_id = dynamic_id
        
        self.cuid = cuid
        self.cname = ""
        
        self.cfloor = cfloor
        self.crow = crow
        
        self.ctuid = ctuid
        self.ctname = ""
        
        self.comment = comment
        self.comment_time = comment_time
        self.hasRead = hasRead
    }
}

class DynamicCommentManager
{
    static var CommentTableData:DynamicCommentManager?
    static var predicate:dispatch_once_t = 0
    
    var dynamic_id:String!
    var dataMessageItem:Array<Array<DynamicCommentItem>>
    
    class func shareDynamicCommentManager() -> DynamicCommentManager {
        dispatch_once(&predicate) { () -> Void in
            CommentTableData = DynamicCommentManager()
            //获取数据库实例
        }
        return CommentTableData!
    }
       //构造空文本消息体
    init()
    {
        dynamic_id = "-1"
        self.dataMessageItem = Array<Array<DynamicCommentItem>>()
    }
    
    init(dynamic_id:String,dataMessageItem:Array<Array<DynamicCommentItem>>)
    {
        self.dynamic_id = dynamic_id
        self.dataMessageItem = dataMessageItem
    }
    
    func InitData(dynamic_id:String)
    {
        self.dynamic_id = dynamic_id
        self.dataMessageItem = Array<Array<DynamicCommentItem>>()
    }
    
    //服务器发来的数据一定是按照floor排序发来的！！！
    func RefreshComment(data:[[String]])  {
        var ArrayItem=Array<DynamicCommentItem>()
        var floor:String = ""
        self.dataMessageItem.removeAll()
        if(data.count == 0)
        {
            return
        }
        
        floor = data[0][3]
        
        for i in 0...data.count-1
        {
            var dynamic_id:String = String(data[i][0])
            var cuid:String = String(data[i][1])
            var cfloor:String = String(data[i][2])
            var crow:String = String(data[i][3])
            var ctuid:String = String(data[i][4])
            var comment:String = String(data[i][5])
            var comment_time:String = String(data[i][6])
            var hasRead:String = String(data[i][7])
            
            var Item:DynamicCommentItem = DynamicCommentItem(dynamic_id:dynamic_id, cuid: cuid, cfloor: cfloor, crow: crow, ctuid: ctuid, comment: comment,comment_time: comment_time,hasRead: hasRead)
            if(floor == cfloor)
            {
                ArrayItem.append(Item)
            }
            else
            {
                self.dataMessageItem.append(ArrayItem)
                floor = cfloor
                ArrayItem.removeAll()
                ArrayItem.append(Item)
            }
        }
        self.dataMessageItem.append(ArrayItem)
    }
    
    func SetCName(Cuid:String,Cname:String) {
        for n1 in 0...DynamicCommentManager.shareDynamicCommentManager().dataMessageItem.count-1
        {
            for n2 in 0...DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1].count-1
            {
                if(Cuid == DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1][n2].cuid)
                {
                    DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1][n2].cname = Cname
                }
            }
        }
    }
    
    func SetCTName(CTuid:String,CTname:String) {
        for n1 in 0...DynamicCommentManager.shareDynamicCommentManager().dataMessageItem.count-1
        {
            for n2 in 0...DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1].count-1
            {
                if(CTuid == DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1][n2].ctuid)
                {
                    DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[n1][n2].ctname = CTname
                }
            }
        }
    }
    
    func Clean() {
        self.dataMessageItem.removeAll()
    }
    
    //只需要计算楼层里row＝0的数量即可，这样楼层删除了不影响返回值
    //返回有几楼，也就是DynamicCommentTableDataView有几个row
    func ReturnCommentFloor()->Int
    {
        return self.dataMessageItem.count
    }
    
    func ReturnCommentCellData(Index:Int) -> Array<DynamicCommentItem> {
        return self.dataMessageItem[Index]
    }
}