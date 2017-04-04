import Foundation

protocol Search_Table_Data_Delegate :NSObjectProtocol{
    func Search_Table_Data_DidSelect(index : Int)
}

protocol Search_Table_Status_Delegate :NSObjectProtocol{
    func Search_Table_StatusChanged(index : Int)
}

