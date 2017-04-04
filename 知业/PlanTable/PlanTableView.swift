import UIKit

class PlanTableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    //用于保存所有消息
    var bubbleSection:Array<PlanTableMessageItem>?
    //数据源，用于与 ViewController 交换数据
    weak var didSelectDelegate : Plan_Table_Delegate?
    //下拉刷新
    var refreshControl = UIRefreshControl()
    var timer:NSTimer!
    var IsLoading:Int = 0
    
    //新增计划
    var newPlanView:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect)
    {
        self.bubbleSection = Array<PlanTableMessageItem>()
        
        super.init(frame:frame,  style:UITableViewStyle.Plain)

        super.setEditing(editing, animated: true)
        self.setEditing(editing, animated: true)
        self.backgroundColor = UIColor.grayColor()
        //self.tableHeaderView = First_Scroll
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        //添加刷新
        refreshControl.addTarget(self, action: "refreshData",
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.addSubview(refreshControl)
        
        //导入本地数据
        searchLocalPlanData()
        refreshData()
        
        newPlanView = UIButton(frame: CGRectMake(0, self.frame.height, self.frame.width, 60))
        newPlanView.setTitle("新增+", forState: UIControlState.Normal)
        newPlanView.setTitleColor(UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1), forState: UIControlState.Normal)
        newPlanView.addTarget(self, action: "NewPlanFunc", forControlEvents: UIControlEvents.TouchUpInside)
        self.tableFooterView = self.newPlanView
        
        print("beginReturnLastTime")
       MySQL.shareMySQL().ReturnLastTime("2017-02-10 17:38:36")
    }
 
    //显示新增按钮
    private func ShowPlanFunc() {
        newPlanView!.backgroundColor = UIColor.whiteColor()
    }
    
    //点击新增
    func NewPlanFunc()
    {
        MySQL.shareMySQL().insertEmptyPlan()
        
        // PlanTableDataMessage 处理
        //PlanTableDataMessage.sharePlanTableData().insertNewPlanCell(String(planTableTid),planTableTTid: String(planTableTTid))
        searchLocalPlanData()

        self.didSelectDelegate?.Plan_Table_DidSelect(self.bubbleSection!.count-1,bubbleSection: self.bubbleSection![self.bubbleSection!.count-1])
    }
    
    // 下拉刷新数据
    func refreshData() {
        //刷新远程数据
        if(IsLoading == 0)
        {
            IsLoading += 1
            refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
            updateNewDynamic()
        }
        else
        {
            refreshControl.attributedTitle = NSAttributedString(string: "正在下载或上传")
            self.refreshControl.endRefreshing()
        }
    }
    
    public func searchLocalPlanData(){
        self.bubbleSection?.removeAll()
        //重新加载本地数据库
        PlanTableMessageManage.sharePlanMessageManage().RefreshLocalPlan()
        self.bubbleSection=PlanTableMessageManage.sharePlanMessageManage().dataMessageItem
        self.reloadData()
    }
    
    func updateNewDynamic(){
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        //let str:[String] = MySQL.shareMySQL().lastDatePlan()
        let str:[String] = [""]
        print("Step:1")
        PlanNet.sharedPlan()?.DownPlan(str,block:{(dataInfo,data) -> Void in
            print("Step:4")
            if dataInfo == "不更改"
            {
                self.refreshControl.endRefreshing()
                print("updatePlan() 已经是最新的")
                return
            }
            else if dataInfo == "要更改"
            {
                //导入本地数据
                self.searchLocalPlanData()
            }
            else if dataInfo == "网络错误"
            {
                print("PlanTable网络错误")
                MBProgressHUD.showDelayHUDToView(self, message: "网络连接错误")
            }
            
            self.IsLoading = self.IsLoading-1
            //获取数据完毕
            super.reloadData()
            self.reloadData()
            self.refreshControl.endRefreshing()
        })
        print("Step:6")
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
        return self.bubbleSection!.count
    }
        
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        
        return 140
    }

    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "MsgCell"
        let data =  self.bubbleSection![indexPath.row]

        let image_frame = CGRectMake(0, 0, self.frame.width, 120)
        let cell =  PlanTableViewCell(frame:image_frame,data:data, reuseIdentifier:cellId)
        cell.editing = true
        //当下拉到底部，执行loadMore()
        if (indexPath.row < 9)
        {
            ShowPlanFunc()
        }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        print(indexPath.row)
        print(self.bubbleSection?.count)
        if(indexPath.row < self.bubbleSection!.count)
        {
            //只有是最新版本或需要上传但不在上传状态才可以点击
            if(self.bubbleSection![indexPath.row].status == 0 || self.bubbleSection![indexPath.row].status == 2)
            {
                self.didSelectDelegate?.Plan_Table_DidSelect(indexPath.row,bubbleSection: self.bubbleSection![indexPath.row])
            }
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
        
        /*let readed = UITableViewRowAction(style: .Normal, title: "标为已读") {
            action, index in
            print("favorite button tapped")
            self.alertShow("标为已读")
        }
        readed.backgroundColor = UIColor.orangeColor()
        */
        let delete = UITableViewRowAction(style: .Normal, title: "删除") {
            action, index in
            print("share button tapped")
            self.ActionForPlanCell("删除",tid: self.bubbleSection![indexPath.row].tid)
        }
        delete.backgroundColor = UIColor.blueColor()
        
        return [delete]
    }
    
    func ActionForPlanCell(title:String,tid:Int)
    {
        if(title == "删除")
        {
            MySQL.shareMySQL().DeletePlan(tid)
            searchLocalPlanData()
        }
    }
    
    func tableView(tableView: UITableView,
                     titleForDeleteConfirmationButtonForRowAt indexPath: NSIndexPath)-> String? {
            return "确定删除？"
    }
    
    /*func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            // 同时你也需要实现本方法,否则自定义action是不会显示的,啦啦啦
            if(editingStyle == UITableViewCellEditingStyle.Delete)
            {
                MySQL.shareMySQL().DeletePlan(self.bubbleSection![indexPath.row].tid)
                searchLocalPlanData()
            }
    }*/
    
}
