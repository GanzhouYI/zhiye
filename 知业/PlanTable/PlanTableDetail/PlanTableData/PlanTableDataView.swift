import UIKit
class PlanTableDataView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    var writingIndex:Int = 0
    var planTableTid:Int = 0
    var planTableTTid:Int = 0
    
    //在 PlanTableDataMessage中PlanTableCellData的下标
    var planTableTTidRow:Int = 0
    //表有几行
    var numberOfPlanRow:Int = 0
    
    //数据源，用于与 ViewController 交换数据
    weak var didSelectDelegate : Plan_Table_Data_Delegate?
    //设置闹铃  用于Cell传递界面显示、设置闹铃
    //PlanTableDetailController 完成协议
    weak var setAlarmDelegate:Plan_Table_SetAlarm_Delegate?
    //新增计划
    var DidCellAdd:Bool = false
    var newPlanView:UIButton!
    
    // 假函数， 由PlanTableDetailController实现
    func ShowSetAlarm(AlarmData:AnyObject)
    {
        print("假函数")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    init(frame:CGRect,planTableTid:Int,planTableTTid:Int,planTableTTidRow:Int)
    {
        self.planTableTid = planTableTid
        self.planTableTTid = planTableTTid
        self.planTableTTidRow = planTableTTidRow
        super.init(frame:frame,  style:UITableViewStyle.Plain)
        self.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        //self.tableHeaderView = First_Scroll
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        //MySQL.shareMySQL().removeAllDynamic()
        //导入本地数据
        //searchDynamicToFirstTable()
       // refreshData()
        
        newPlanView = UIButton(frame: CGRectMake(0, self.frame.height, self.frame.width, 60))
        //newPlanView.titleLabel?.font = UIFont.systemFontOfSize(10)
        newPlanView.setTitle("新增+", forState: UIControlState.Normal)
        newPlanView.setTitleColor(UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1), forState: UIControlState.Normal)
        newPlanView.addTarget(self, action: "NewPlanFunc", forControlEvents: UIControlEvents.TouchUpInside)
        newPlanView!.backgroundColor = UIColor.whiteColor()
        self.tableFooterView = self.newPlanView
        
        //在tableview 和tableviewcell中
        //两种方法皆可隐藏  所有键盘
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,action: "HandleTap:"))
    }
    
    func HandleTap(sender:UITapGestureRecognizer)
    {
        //var indexpath = NSIndexPath(forRow: 6, inSection: 0)
        
        //self.scrollToRowAtIndexPath(indexpath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        self.reloadData()
        if sender.state == .Ended
        {
            //这个方法好，隐藏所有键盘无论在哪个控件上
            self.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }

    //新增计划
    func NewPlanFunc() {
        DidCellAdd = true
        
        //本地数据库处理
        //uid int,tid int,ttid int,ttid_row
        var Item:[String] = [String(LoginModel.sharedLoginModel()!.returnMyUid()),String(planTableTid),String(planTableTTid),String(numberOfPlanRow)]
        MySQL.shareMySQL().insertPlanEmptyCell(Item)
        
        // PlanTableDataMessage 处理
        PlanTableDataMessage.sharePlanTableData().insertNewPlanCell(String(planTableTid),planTableTTid: String(planTableTTid))
        self.reloadData()
    }
    
    
    func searchDynamicToFirstTable(){
        //self.bubbleSection
       // self.bubbleSection=MySQL.shareMySQL().searchDynamic()
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
        numberOfPlanRow = PlanTableDataMessage.sharePlanTableData().ReturnTableDataCount(String(planTableTid),planTableTTid: String(planTableTTid))
        //小于100 才可以添加新的一行
        if(numberOfPlanRow<100)
        {
            self.newPlanView.enabled = true
        }
        else
        {
            self.newPlanView.enabled = false
        }
        return numberOfPlanRow
    }
        
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        return 90
    }
    
    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "MsgCell"
        let heighForRow = CGRectMake(0, 0, self.frame.width, 90)

        var cell =  PlanTableDataViewCell(frame:heighForRow,planTableTid:planTableTid,planTableTTid: planTableTTid,NOCell:indexPath.row,data:PlanTableDataMessage.sharePlanTableData().ReturnCellDataItem(String(planTableTid),planTableTTid: String(planTableTTid), NOCell:indexPath.row), reuseIdentifier:cellId)
        cell.setAlarmDelegate = self.setAlarmDelegate

        //当下拉到底部，执行loadMore()
        print("Cell For Row"+String(indexPath.row))
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        self.didSelectDelegate?.Plan_Table_Data_DidSelect(indexPath.row)
    }
}
