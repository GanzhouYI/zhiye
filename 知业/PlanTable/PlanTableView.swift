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
    var IsLoading:Bool = false
    
    //新增计划
    var newPlanView:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame:CGRect)
    {
        self.bubbleSection = Array<PlanTableMessageItem>()
        
        super.init(frame:frame,  style:UITableViewStyle.Plain)

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
        
        newPlanView = UIButton(frame: CGRectMake(0, self.frame.height, self.frame.width, 120))
        newPlanView.addTarget(self, action: "NewPlanFunc", forControlEvents: UIControlEvents.TouchUpInside)
        self.tableFooterView = self.newPlanView
        
        print("beginReturnLastTime")
       MySQL.shareMySQL().ReturnLastTime("2017-02-10 17:38:36")
    }
 
    //新增计划
    private func ShowPlanFunc() {
        newPlanView!.backgroundColor = UIColor.orangeColor()
    }
    
    private func NewPlanFunc()
    {
        //self.didSelectDelegate?.Plan_Table_DidSelect(10,bubbleSection: bubbleSection)
    }
    
    
    // 下拉刷新数据
    func refreshData() {
        //刷新远程数据
        if(IsLoading == false)
        {
            IsLoading == true
            refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
            updateNewDynamic()
        }
        else
        {
            refreshControl.attributedTitle = NSAttributedString(string: "正在下载")
            self.refreshControl.endRefreshing()
        }
    }
    
    func searchLocalPlanData(){
        self.bubbleSection?.removeAll()
        self.bubbleSection=MySQL.shareMySQL().searchLocalPlan()
    }
    
    func updateNewDynamic(){
        //测试数据  仅仅用于没有表存在本地的情况下，如果本地创建了表是不行的
        //let str:[String] = MySQL.shareMySQL().lastDatePlan()
        let str:[String] = [""]
        print("Step:1")
        PlanNet.sharedPlan()?.DownPlan(str,block:{(dataInfo,data) -> Void in
            print("Step:4")
            if dataInfo == "已经是最新的"
            {
                self.refreshControl.endRefreshing()
                print("updatePlan() 已经是最新的")
                return
            }
            else if dataInfo == "有更新数据"
            {
                //导入本地数据
                self.searchLocalPlanData()
            }
            else if dataInfo == "网络错误"
            {
                print("PlanTable网络错误")
                MBProgressHUD.showDelayHUDToView(self, message: "网络连接错误")
            }
            
            self.IsLoading = false
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
        
        //需要从服务器更新下载，才可点击显示PlanTableDataView
        if(data.ttidUpdated == 0)
        {
            IsLoading = true
            let image_frame = CGRectMake(0, 0, self.frame.width, 120)
            var cell =  PlanTableViewCell(frame:image_frame,data:data, reuseIdentifier:cellId)
            
            PlanNet.sharedPlan()?.DownPlanDataCell(&IsLoading, PlanCell: &cell)

        }//已经更新完成，可以点击显示PlanTableDataView
        else if(data.ttidUpdated == 1)
        {
            
        }//需要上传服务器
        else if(data.ttidUpdated == 2)
        {
            IsLoading = true
        }
        let image_frame = CGRectMake(0, 0, self.frame.width, 120)
        let cell =  PlanTableViewCell(frame:image_frame,data:data, reuseIdentifier:cellId)
        //当下拉到底部，执行loadMore()
        if (indexPath.row < 9)
        {
            ShowPlanFunc()
        }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        if(indexPath.row < self.bubbleSection?.count)
        {
        self.didSelectDelegate?.Plan_Table_DidSelect(indexPath.row,bubbleSection: self.bubbleSection![indexPath.row])
        }
    }
}
