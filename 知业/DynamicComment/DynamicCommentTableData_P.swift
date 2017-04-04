import Foundation

protocol Comment_Table_Data_Delegate :NSObjectProtocol{
    func Comment_Table_Data_DidSelect(index : Int)
}

protocol Comment_Table_Status_Delegate :NSObjectProtocol{
    func Comment_Table_StatusChanged(index : Int)
}

