import Foundation

/*
  数据提供协议
*/
protocol SecondTableDataSource
{
    
    /*返回对话记录中的全部行数*/
    func rowsForSeoncdTable( tableView:SecondTableView) -> Int
    /*返回某一行的内容*/
    func SecondTableViewDetail(tableView:SecondTableView, dataForRow:Int)-> SecondTableMessageItem

}