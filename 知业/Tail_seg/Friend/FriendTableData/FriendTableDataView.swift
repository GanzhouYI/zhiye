import UIKit
class FriendTableDataView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    var IsMyFriend:Bool = true
    //数据源，用于与 ViewController 交换数据
    weak var didSelectDelegate : Friend_Table_Data_Delegate?
    
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
        
    }
    
    func ReloadFriend(IsMyFriend:Bool) {
        if(IsMyFriend == true)
        {
            self.IsMyFriend = true
            self.reloadData()
        }
        else
        {
            self.IsMyFriend = false
            self.reloadData()
        }
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
        if(IsMyFriend == true)
        {
        return FriendManager.shareFriendManager().myFriend.count
        }
        else
        {
            return FriendManager.shareFriendManager().friendMe.count
        }
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

        if(IsMyFriend == true)
        {
            var cell =  FriendTableDataViewCell(IsMyFriend: IsMyFriend,frame:heighForRow,NOCell:indexPath.row,data:FriendManager.shareFriendManager().ReturnFriendCellData(IsMyFriend,Index: indexPath.row), reuseIdentifier:cellId)
            return cell
        }
        else
        {
            var cell =  FriendTableDataViewCell(IsMyFriend: IsMyFriend,frame:heighForRow,NOCell:indexPath.row,data:FriendManager.shareFriendManager().ReturnFriendCellData(IsMyFriend,Index: indexPath.row), reuseIdentifier:cellId)
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        if(IsMyFriend == true)
        {
            self.didSelectDelegate?.Friend_Table_Data_DidSelect(indexPath.row)
        }
        else
        {
            
        }
    }
}
