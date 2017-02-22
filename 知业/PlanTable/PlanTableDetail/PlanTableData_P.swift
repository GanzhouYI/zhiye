import Foundation

protocol Plan_Table_Data_Delegate :NSObjectProtocol{
    func Plan_Table_Data_DidSelect(index : Int)
}

@objc protocol Plan_Table_SetAlarm_Delegate:NSObjectProtocol{
    optional func ShowSetAlarm(AlarmData:AnyObject)
    optional func ShowSetAlarm(PlanTableCell:PlanTableDataViewCell,IsLeft:Bool,planTableTTid:Int,NOCell:Int)
}
