import UIKit

class FirstTableMessageItem
{
    var dynamic_id:String?
    var FirstTableImage:String?
    //var FirstTablebiaoqian:UIImage?
    var FirstTableTitle:String?
    var FirstTableDetail:String?
    var FirstTable_yanjin_Num:String!
    var FirstTable_pinglun_Num:String!
    
       //构造空文本消息体
    init()
    {
        
    }
    
    //对数据例如评论数据进行格式转换
    func NumType(strNum:String) -> String
    {
        var str:String=""
        let num:Int = Int(strNum)!
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

    init(dynamic_id:String,FirstTableImage:String,FirstTableTitle:String,FirstTableDetail:String,FirstTable_yanjin_Num:Int,FirstTable_pinglun_Num:Int)
    {
        self.dynamic_id = dynamic_id
        
        self.FirstTableImage = FirstTableImage
        
        //self.FirstTablebiaoqian = UIImage(named: FirstTablebiaoqian)!
        
        self.FirstTableTitle = FirstTableTitle
        
        self.FirstTableDetail = FirstTableDetail
        
    
        self.FirstTable_yanjin_Num = NumType(FirstTable_yanjin_Num)
        
        self.FirstTable_pinglun_Num = NumType(FirstTable_pinglun_Num)
    }
}