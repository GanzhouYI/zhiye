import UIKit
class DynamicCommentTableDataView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    var dynamic_id:String!
    //下拉刷新
    var refreshControl = UIRefreshControl()
    var timer:NSTimer!
    var tipButton = UIButton()
    weak var showCommentDelegate:Comment_Selected_Delegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame:CGRect)
    {
        super.init(frame:frame,  style:UITableViewStyle.Plain)
        self.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        tipButton = UIButton(frame: CGRectMake(0,0,self.frame.width ,100))
        tipButton.backgroundColor = UIColor.whiteColor()
        tipButton.setTitleColor(UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1), forState: UIControlState.Normal)
        tipButton.setTitle("没有人评论，快来抢沙发", forState: UIControlState.Normal)
        tipButton.addTarget(self, action: "Comment", forControlEvents: UIControlEvents.TouchUpInside)
        //添加刷新
        refreshControl.addTarget(self, action: "RefreshDynamicComment",
                                 forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.addSubview(refreshControl)
        
    }
    
    func Comment() {
        print("抢沙发")
    }
    
    
    func RefreshDynamicComment() {
        DynamicCommentManager.shareDynamicCommentManager().Clean()
        DynamicCommentNet.sharedDynamicComment()?.DownDynamicComment(String(dynamic_id),  block: { (dataInfo, data) in
            if(dataInfo == "没有评论")
            {
                //block!(dataInfo:"没有评论",data:[[""]])
            }
            else if(dataInfo == "存在评论")
            {
                DynamicCommentNet.sharedDynamicComment()?.DownCommentName()
                //block!(dataInfo:"存在评论",data: infoData)
                self.reloadData()
            }
            else
            {
                //block!(dataInfo:"网络错误",data:[[""]])
            }
            self.refreshControl.endRefreshing()
        })
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
        if(DynamicCommentManager.shareDynamicCommentManager().dataMessageItem.count == 0)
        {
            self.addSubview(tipButton)
            return 1
        }
        
       tipButton.removeFromSuperview()
        return DynamicCommentManager.shareDynamicCommentManager().ReturnCommentFloor()
    }
        
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        if(DynamicCommentManager.shareDynamicCommentManager().dataMessageItem.count == 0)
        {
            return 100
        }
        else if(DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[indexPath.row].count == 1)
        {
            return 140
        }
        else
        {
            var height:CGFloat = CGFloat(140 + 140 * (DynamicCommentManager.shareDynamicCommentManager().dataMessageItem[indexPath.row].count - 1))
            return height
        }
    }
    
    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "MsgCell"
        let heighForRow = CGRectMake(0, 0, self.frame.width, 200)

        if(DynamicCommentManager.shareDynamicCommentManager().dataMessageItem.count > 0)
        {
        var cell =  CommentTableDataViewCell(frame:heighForRow,NOCell:indexPath.row,data:DynamicCommentManager.shareDynamicCommentManager().ReturnCommentCellData(indexPath.row), reuseIdentifier:cellId)
            cell.showCommentDelegate = self.showCommentDelegate
            return cell
        }
        else
        {
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.endEditing(true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.showCommentDelegate!.HiddenComment()
    }
    
    

}
