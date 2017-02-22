import UIKit

class SecondTableMessageItem
{
    var Pic:UIImage?
    var biaoqian1:UIImage?
    var Detail:String?
    var biaoqian2:UIImage?
    var Num:Int?
    
       //构造空文本消息体
    init()
    {
        
    }
    
    init(num:Int, Pic:String,biaoqian1:String,Detail:String,biaoqian2:String)
    {
        
        self.Pic = UIImage(named: Pic)!
        
        self.biaoqian1 = UIImage(named: biaoqian1)!
        
        self.Detail = Detail
        
        self.biaoqian2 = UIImage(named: biaoqian2)!
    
        self.Num = num
        
    
    }
    
    
}