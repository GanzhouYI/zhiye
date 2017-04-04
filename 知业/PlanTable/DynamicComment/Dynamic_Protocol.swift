import Foundation

protocol Dynamic_Name_Delegate :NSObjectProtocol{
    func Dynamic_CName_Changed(row:String,Cname:String)
    func Dynamic_CTName_Changed(row:String,CTname:String)
}

protocol Comment_Selected_Delegate :NSObjectProtocol{
    func Comment_TextViewShow(CFloor:String,CTuid:String,CRow:String,CTname:String)
    func HiddenComment()
}