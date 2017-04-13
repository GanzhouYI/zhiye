import Foundation

protocol Friend_Table_Data_Delegate :NSObjectProtocol{
    func Friend_Table_Data_DidSelect(index : Int)
}

protocol Friend_Table_Status_Delegate :NSObjectProtocol{
    func Friend_Table_StatusChanged(index : Int)
}

