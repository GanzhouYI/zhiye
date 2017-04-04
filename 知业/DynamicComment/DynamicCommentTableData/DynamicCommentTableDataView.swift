import UIKit
class CommentTableDataView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    //数据源，用于与 ViewController 交换数据
    weak var didSelectDelegate : Comment_Table_Data_Delegate?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    init(frame:CGRect)
    {
        super.init(frame:frame,  style:UITableViewStyle.Plain)
        self.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        //self.tableHeaderView = First_Scroll
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        //在tableview 和tableviewcell中
        //两种方法皆可隐藏  所有键盘
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,action: "HandleTap:"))
    }
    
    func HandleTap(sender:UITapGestureRecognizer)
    {
        self.reloadData()
        if sender.state == .Ended
        {
            //这个方法好，隐藏所有键盘无论在哪个控件上
            self.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    override func reloadData()
    {
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = true//滚动的提示条
        
        super.reloadData()
    }
    //第一个方法返回分区数，在本例中，就是1
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {
        return 1
    }
    
    //返回指定分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CommentManager.shareCommentManager().dataMessageItem.count
    }
        
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        return 200
    }
    
    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "MsgCell"
        let heighForRow = CGRectMake(0, 0, self.frame.width, 200)

        var cell =  CommentTableDataViewCell(frame:heighForRow,NOCell:indexPath.row,data:CommentManager.shareCommentManager().ReturnCommentCellData(indexPath.row), reuseIdentifier:cellId)
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        self.didSelectDelegate?.Comment_Table_Data_DidSelect(indexPath.row)
    }
}
