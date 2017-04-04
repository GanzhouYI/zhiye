import UIKit
/*
            一列                  两列
行高    1X  1.5X   2X   3X   4X
闹铃     左边右边，时间
跳转     左边跳             右边跳
备注      改行的备注
 */
class PlanTableCellDataMessageItem
{
    /*
            一列                                     两列
            时间、周期   指定            时间、周期   指定    列宽
            一倍高、两倍                   一倍高、两倍
     
              0b          
10          0(0最新版本不用上传，1是修改了需要上传)
9            0(right--时间周期、指定)
8            0(right--是否有闹铃)
7            0(三倍四倍列高)
6            0(一倍两倍列高)
5            0(三倍四倍列宽)
4            0(一倍两倍列宽)
3            0(left--时间周期、指定)
2            0(left--是否有闹铃)
1            0(一列、两列)
               
     */
    var row_type:Int!
    
    var left_data:String = ""
    var left_alarm:String = ""
    var left_connect:String = "-1"
    
    var right_data:String = ""
    var right_alarm:String = ""
    var right_connect:String = "-1"
    
    //构造空文本消息体
    init()
    {
        row_type = 0b001111001
        
        left_data = ""
        left_alarm = ""
        left_connect = "-1"
        
        right_data = ""
        right_alarm = ""
        right_connect = "-1"
    }
    
    init(row_type:Int,
         left_data:String,left_alarm:String,left_connect:String,
         right_data:String,right_alarm:String,right_connect:String)
    {
        self.row_type = row_type
        
        self.left_data = left_data
        self.left_alarm = left_alarm.stringByReplacingOccurrencesOfString(" +0000", withString: "")
        self.left_connect = left_connect
        
        self.right_data = right_data
        self.right_alarm = right_alarm.stringByReplacingOccurrencesOfString(" +0000", withString: "")
        self.right_connect = right_connect
    }
   
    func SetData(var IsLeft:Bool,var data:String)  {
        if(IsLeft == true)
        {
            self.left_data = data
        }
        else
        {
            self.right_data = data
        }
    }
    
    //更新row_type第10位 true设1  false 设0
    func SetRow_type(IsUpdate:Bool)  {
        if(IsUpdate == true)
        {
            self.row_type = self.row_type & 0b1111111111
        }
        else
        {
            self.row_type = self.row_type & 0b0111111111
        }
    }
    
    func SetAlarm(IsLeft:Bool,IsOpen:Bool,IsSpecialTime:Bool,Data:String){
        if(IsOpen == false)
        {
            if(IsLeft == true)
            {
                self.row_type = self.row_type & 0b1111111001
                self.left_alarm = ""
            }
            else
            {
                self.row_type = self.row_type & 0b1001111111
                self.right_alarm = ""
            }
        }
        else
        {
            if(IsLeft == true)
            {
                // 设置有闹钟
                self.row_type = self.row_type | 0b0000000010
                if(IsSpecialTime == true)
                {
                    self.row_type = self.row_type | 0b000000110
                    self.left_alarm = Data
                }
                else
                {
                    self.row_type = self.row_type & 0b1111111011
                    self.left_alarm = Data
                }
            }
            else
            {
                //设置有闹钟
                self.row_type = self.row_type | 0b0010000000
                if(IsSpecialTime == true)
                {
                    self.row_type = self.row_type | 0b110000000
                    self.right_alarm = Data
                }
                else
                {
                    self.row_type = self.row_type & 0b1011111111
                    self.right_alarm = Data
                }
            }
        }
    }
    
    //是否修改过需要上传  true 是需要上传
    func NeedUpload() -> Bool {
        if(self.row_type & 0b1000000000 > 0)
        {
            return true
        }
        return false
    }
    
    func HasDoubleCol() -> Bool {
        if(self.row_type & 0b000000001 > 0) {return true}
        else {return false}
    }
    
    func HasLeftAlarm()->Bool
    {
        if(self.row_type & 0b000000010 > 0) {return true}
        else {return false}
    }
    
    func ReturnLeftAlarm(AlarmIndex:Int)->String
    {
        if((self.left_alarm == "")) {return ""}
        var myArray = left_alarm.componentsSeparatedByString(",")
        if(myArray.count>AlarmIndex){return myArray[AlarmIndex]}
        return ""
    }
    
    func ReturnRightAlarm(AlarmIndex:Int)->String
    {
        if((self.right_alarm == "")) {return ""}
        var myArray = right_alarm.componentsSeparatedByString(",")
        if(myArray.count>AlarmIndex){return myArray[AlarmIndex]}
        return ""
    }
    
    func IsSpecialLeftTime()->Bool
    {
        if(self.row_type & 0b000000100 > 0) {return true}
        else {return false}
    }
    
    func HasRightAlarm()->Bool
    {
        if(self.row_type & 0b10000000 > 0) {return true}
        else {return false}
    }
    
    func IsSpecialRightTime()->Bool
    {
        if(self.row_type & 0b100000000 > 0) {return true}
        else {return false}
    }
}

class PlanTableDataMessageItem
{
    var tid:String?
    var ttid:String?
    var name:String?
    var tip:String?
    var PlanTableCellData:Array<PlanTableCellDataMessageItem>
    //构造空文本消息体
    init()
    {
        tid = ""
        ttid = ""
        name = ""
        tip = ""
        
        PlanTableCellData = Array<PlanTableCellDataMessageItem>()
    }
    
    init(tid:String,ttid:String,name:String,tip:String,CellData:Array<PlanTableCellDataMessageItem>)
    {
        self.tid = tid
        self.ttid = ttid
        self.name = name
        self.tip = tip
        PlanTableCellData = Array<PlanTableCellDataMessageItem>()
        PlanTableCellData = CellData
    }
}

class PlanTableDataMessage
{
    static var PlanTableData:PlanTableDataMessage?
    static var predicate:dispatch_once_t = 0
    var dataMessageItem:PlanTableDataMessageItem
    class func sharePlanTableData() -> PlanTableDataMessage {
        dispatch_once(&predicate) { () -> Void in
            PlanTableData = PlanTableDataMessage()
            //获取数据库实例
        }
        return PlanTableData!
    }
       //构造空文本消息体
    init()
    {
        self.dataMessageItem = PlanTableDataMessageItem()
    }
    
    init(dataMessageItem:PlanTableDataMessageItem)
    {
        self.dataMessageItem = dataMessageItem
    }
    
    func InitData(tid:Int,ttid:Int,uid:Int=(LoginModel.sharedLoginModel()?.MyUid)!)
    {
        self.dataMessageItem = PlanTableDataMessageItem()
        var planInfo:[String]=[]
        var name:String=""
        var tip:String=""
        var CellData:Array<PlanTableCellDataMessageItem> = Array<PlanTableCellDataMessageItem>()
        
        planInfo = MySQL.shareMySQL().ReturnPlanInfo(tid,uid:uid)
        name = planInfo[0]
        tip = planInfo[1]
        CellData = MySQL.shareMySQL().ReturnPlanCellData(tid, ttid: ttid, uid: uid)
        
        var Plan:PlanTableDataMessageItem = PlanTableDataMessageItem(tid: String(tid), ttid: String(ttid), name: name, tip: tip, CellData: CellData)
        self.dataMessageItem=Plan
    }
    
    func ReturnTableDataCount(planTableTid:String,planTableTTid:String)->Int
    {
        if(dataMessageItem.tid == planTableTid && dataMessageItem.ttid == planTableTTid)
        {
            return dataMessageItem.PlanTableCellData.count
        }
        return 0
    }
    
    func ReturnCellDataItem(planTableTid:String,planTableTTid:String,NOCell:Int)->PlanTableCellDataMessageItem
    {
            if(dataMessageItem.tid == planTableTid && dataMessageItem.ttid == planTableTTid)
            {
                return dataMessageItem.PlanTableCellData[NOCell]
            }
        return PlanTableCellDataMessageItem()
    }
    
    func ReturnCellRow(planTableTid:String,planTableTTid:String,NOCell:Int)->PlanTableCellDataMessageItem
    {
        if(dataMessageItem.tid == planTableTid && dataMessageItem.ttid == planTableTTid)
        {
            return dataMessageItem.PlanTableCellData[NOCell]
        }
        return PlanTableCellDataMessageItem()
    }
    
    // 对于Cell中的数据进行添加，修改操作    此函数可完成
    func SetCellData(planTableTid:String,planTableTTid:String,NOCell:Int,msgItem:PlanTableCellDataMessageItem)
    {
        if(dataMessageItem.tid == planTableTid && dataMessageItem.ttid == planTableTTid)
        {
            dataMessageItem.PlanTableCellData[NOCell] = msgItem
            return
        }
    }
    
    
    //
    func insertNewPlanCell(planTableTid:String,planTableTTid:String)
    {
        if(dataMessageItem.tid == planTableTid && dataMessageItem.ttid == planTableTTid)
        {
            var Item = PlanTableCellDataMessageItem()
            dataMessageItem.PlanTableCellData.append(Item)
        }
    }
    
}