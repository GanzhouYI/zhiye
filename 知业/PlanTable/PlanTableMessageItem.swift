import UIKit
class PlanTableMessageManage
{
    static var PlanTableManage:PlanTableMessageManage?
    static var predicate:dispatch_once_t = 0
    var dataMessageItem:Array<PlanTableMessageItem>!
    class func sharePlanMessageManage() -> PlanTableMessageManage {
        dispatch_once(&predicate) { () -> Void in
            PlanTableManage = PlanTableMessageManage()
            //获取数据库实例
        }
        return PlanTableManage!
    }
    //构造空文本消息体
    init()
    {
        self.dataMessageItem = Array<PlanTableMessageItem>()
        dataMessageItem = MySQL.shareMySQL().searchLocalPlan()
    }
    
    init(dataMessageItem:Array<PlanTableMessageItem>)
    {
        self.dataMessageItem = dataMessageItem
    }
    
    public func RefreshLocalPlan() {
        dataMessageItem.removeAll()
        dataMessageItem = MySQL.shareMySQL().searchLocalPlan()
    }
    
    public func SetPlanStatus(tid:Int,status:Int)
    {
        for(var i:Int=0;i<self.dataMessageItem.count;i++)
        {
            if(self.dataMessageItem[i].tid == tid)
            {
                self.dataMessageItem[i].status = status
            }
        }
    }
}

class PlanTableMessageItem
{
    //var TableImage:String?
    //var FirstTablebiaoqian:UIImage?
    
    //数据库存储   status (0、最新数据   1、需要更新   2、需要上传   3、已删除 )
    //table变量bubbleSection 存储 
    //    status (0、最新数据   1、需要更新   2、需要上传   3、已删除  4、正在上传   5、正在下载  6、需要下载)
    var tid:Int!
    var name:String?
    var tip:String?
    var Table_yanjin_Num:String!
    var Table_pinglun_Num:String!
    var statusDelegate:Plan_Table_Status_Delegate?
    var status:Int!
        {
        didSet {
            if((statusDelegate) != nil)
            {
                statusDelegate?.Plan_Table_StatusChanged(status)
            }
        }
    }
       //构造空文本消息体
    init()
    {
        tid = 0
        status = 0
        name = ""
        tip = ""
        Table_yanjin_Num = ""
        Table_pinglun_Num = ""
    }
        
    //对数据例如评论数据进行格式转换
    func NumType(strNum:String) -> String
    {
        var str:String=""
        var num:Int = Int(strNum)!
        if(num<=999)
        {
            str = String(num)
        }
        else if (num>999&&num<=9999)
        {
            str = String(format:"%.1f",Double(num)/1000) + "k"
        }
        else if(num>99999&&num<=999999)
        {
            str = String(format:"%.1f",Double(num)/10000) + "万"
        }
        else if(num>999999)
        {
            str = "99万+"
        }
        return str
    }

    
    
    //对数据例如评论数据进行格式转换
    func NumType(num:Int) -> String
    {
        var str:String=""
        if(num<=999)
        {
            str = String(num)
        }
        else if (num>999&&num<=9999)
        {
            str = String(format:"%.1f",Double(num)/1000) + "k"
        }
        else if(num>99999&&num<=999999)
        {
            str = String(format:"%.1f",Double(num)/10000) + "万"
        }
        else if(num>999999)
        {
            str = "99万+"
        }
        return str
    }

    init(tid:Int,status:Int,name:String,tip:String,Table_yanjin_Num:Int,Table_pinglun_Num:Int)
    {
       // self.TableImage = TableImage
        self.tid = tid
        self.status = status
        self.name = name
        self.tip = tip
        //self.FirstTablebiaoqian = UIImage(named: FirstTablebiaoqian)!
        self.Table_yanjin_Num = NumType(Table_yanjin_Num)
        self.Table_pinglun_Num = NumType(Table_pinglun_Num)
    }
    
}