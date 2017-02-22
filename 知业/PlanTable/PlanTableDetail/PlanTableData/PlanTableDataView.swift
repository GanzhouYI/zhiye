import UIKit

class PlanTableDataView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    var planTableTTid:Int!
    var planTableTTidRow:Int!
    //数据源，用于与 ViewController 交换数据
    weak var didSelectDelegate : Plan_Table_Data_Delegate?
    //设置闹铃  用于Cell传递界面显示、设置闹铃
    //PlanTableDetailController 完成协议
    weak var setAlarmDelegate:Plan_Table_SetAlarm_Delegate?
    //新增计划
    var newPlanView:UIButton!
    
    // 假函数， 由PlanTableDetailController实现
    func ShowSetAlarm(AlarmData:AnyObject)
    {
        print("假函数")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    init(frame:CGRect,planTableTTid:Int,planTableTTidRow:Int)
    {
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
        
        newPlanView = UIButton(frame: CGRectMake(0, self.frame.height, self.frame.width, 120))
        newPlanView.addTarget(self, action: "NewPlanFunc", forControlEvents: UIControlEvents.TouchUpInside)
        self.tableFooterView = self.newPlanView
        
        //在tableview 和tableviewcell中
        //两种方法皆可隐藏  所有键盘
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,action: "HandleTap:"))
    }
    
    func HandleTap(sender:UITapGestureRecognizer)
    {
        var indexpath = NSIndexPath(forRow: 6, inSection: 0)
        
        self.scrollToRowAtIndexPath(indexpath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        self.reloadData()
        if sender.state == .Ended
        {
            //这个方法好，隐藏所有键盘无论在哪个控件上
            self.endEditing(true)
        }
        sender.cancelsTouchesInView = false
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
        updateNewDynamic()
        
    }
    
    func searchDynamicToFirstTable(){
        //self.bubbleSection
       // self.bubbleSection=MySQL.shareMySQL().searchDynamic()
    }
    
    func updateNewDynamic(){
        var ind:Int=1
        let str:String = MySQL.shareMySQL().lastDateDynamic()
        downDynamic.sharedDownDynamic()?.conNet(str,block:{(dataInfo,data) -> Void in
            if dataInfo == "已经是最新的"
            {
                print("updateDynamicFirst() 已经是最新的")
                return
            }
            else if dataInfo == "有更新数据"
            {
                print("有更新数据，开始往table和本地数据库导入")
                for i in 0..<data.count
                {
                    var tempdata = data[i]
                    //let temp = PlanTableDataMessageItem(dynamic_id:data[i][0],FirstTableImage: data[i][2],FirstTableTitle: data[i][7],FirstTableDetail: data[i][3],FirstTable_yanjin_Num: Int(data[i][4])!,FirstTable_pinglun_Num: Int(data[i][5])!)
                    //self.bubbleSection!.append(temp)
                    //MySQL.shareMySQL().insertDynamic(data[i])
                    //downDynamic.sharedDownDynamic()?.downDynamicImage(data[i][2],dynamic_id: data[i][0])
                }
            }
            else if dataInfo == "网络错误"
            {
                print("FirstTable网络错误")
                MBProgressHUD.showDelayHUDToView(self, message: "网络连接错误")
            }
            //获取数据完毕
            super.reloadData()
            self.reloadData()
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
        return PlanTableDataMessage.sharePlanTableData().ReturnTableDataCount(String(planTableTTid))
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
        let image_frame = CGRectMake(0, 0, self.frame.width, 80)
        var cell =  PlanTableDataViewCell(frame:image_frame,planTableTTid: planTableTTid,planTableTTidRow:planTableTTidRow,NOCell:indexPath.row,data:PlanTableDataMessage.sharePlanTableData().ReturnCellDataItem(String(planTableTTid), NOCell:indexPath.row), reuseIdentifier:cellId)
        cell.setAlarmDelegate = self.setAlarmDelegate
        //当下拉到底部，执行loadMore()
        print("Cell For Row"+String(indexPath.row))
        if (indexPath.row < 9)
        {
            ShowPlanFunc()
        }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        self.didSelectDelegate?.Plan_Table_Data_DidSelect(indexPath.row)
    }
}
