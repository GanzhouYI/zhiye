import UIKit

class PlanTableMessageItem
{
    //var TableImage:String?
    //var FirstTablebiaoqian:UIImage?
    
    var tid:Int?
    var ttidUpdated:Int?
    var name:String?
    var tip:String?
    var Table_yanjin_Num:String!
    var Table_pinglun_Num:String!
    
       //构造空文本消息体
    init()
    {
        tid = 0
        ttidUpdated = 0
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

    init(tid:Int,ttidUpdated:Int,name:String,tip:String,Table_yanjin_Num:Int,Table_pinglun_Num:Int)
    {
       // self.TableImage = TableImage
        self.tid = tid
        self.ttidUpdated = ttidUpdated
        self.name = name
        self.tip = tip
        //self.FirstTablebiaoqian = UIImage(named: FirstTablebiaoqian)!
        self.Table_yanjin_Num = NumType(Table_yanjin_Num)
        self.Table_pinglun_Num = NumType(Table_pinglun_Num)
    }
}