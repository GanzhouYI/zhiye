import UIKit

class FirstTableView:UITableView,UITableViewDelegate, UITableViewDataSource,
First_ScrollView_Protocol{
    //用于保存所有消息
    var bubbleSection:Array<FirstTableMessageItem>!
    //数据源，用于与 ViewController 交换数据
    var imageArray :[String!] = ["beautiful1.png","beautiful2.png","beautiful3.png","beautiful4.png"]
    var First_Scroll_Title :[String!] = ["beautiful1.png","beautiful2.png","beautiful3.png","beautiful4.png"]
    weak var didSelectDelegate : First_Table_Delegate?
    //下拉刷新
    var refreshControl = UIRefreshControl()
    var timer:NSTimer!
    //上拉刷新
    var loadMoreView:UIView?
    var loadMoreEnable = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame:CGRect)
    {
        self.bubbleSection = Array<FirstTableMessageItem>()
        
        super.init(frame:frame,  style:UITableViewStyle.Plain)

        var First_Scroll = First_ScrollView()
        First_Scroll = First_ScrollView(frame: CGRectMake(0, 0, self.frame.width, 200*高比例),defaultTimeInterval: 3)
        First_Scroll.backgroundColor = UIColor.clearColor()
        First_Scroll.delegate = self
        self.backgroundColor = UIColor.grayColor()
        self.tableHeaderView = First_Scroll
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        //添加刷新
        refreshControl.addTarget(self, action: "refreshData",
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.addSubview(refreshControl)
        
        
        MySQL.shareMySQL().removeAllDynamic()
        //导入本地数据
        searchDynamicToFirstTable()
        refreshData()
        
        loadMoreView = UIView(frame: CGRectMake(0, self.frame.height, self.frame.width, 120))
        self.tableFooterView = self.loadMoreView
    }
 
    //上拉刷新  设置转的图案
    private func setUpFreshing() {
        //上拉刷新
        loadMoreView!.backgroundColor = UIColor.orangeColor()
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityViewIndicator.color = UIColor.darkGrayColor()
        activityViewIndicator.frame = CGRectMake(self.loadMoreView!.frame.size.width/2-activityViewIndicator.frame.width/2, self.loadMoreView!.frame.size.height/2-activityViewIndicator.frame.height/2, activityViewIndicator.frame.width, activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.loadMoreView!.addSubview(activityViewIndicator)
    }
    
    //上拉刷新  设置不转
    private func setUpFreshEnd() {
        //上拉刷新
        loadMoreView!.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 1)
        var tip = UITextField(frame: CGRectMake(50,20,loadMoreView!.frame.width-100,loadMoreView!.frame.height-40))
        tip.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 1)
        tip.text = "已是最新动态"
        
        self.loadMoreView!.addSubview(tip)
    }
    
    
    // 下拉刷新数据
    func refreshData() {
        //刷新远程数据
        updateNewDynamic()
        
    }
    
    func searchDynamicToFirstTable(){
        //self.bubbleSection
        self.bubbleSection=MySQL.shareMySQL().searchDynamic()
    }
    
    func updateNewDynamic(){
        var ind:Int=1
        let str:String = MySQL.shareMySQL().lastDateDynamic()
        downDynamic.sharedDownDynamic()?.conNet(str,block:{(dataInfo,data) -> Void in
            if dataInfo == "已经是最新的"
            {
                self.refreshControl.endRefreshing()
                self.loadMoreEnable = false
                self.setUpFreshEnd()
                print("updateDynamicFirst() 已经是最新的")
                return
            }
            else if dataInfo == "有更新数据"
            {
                print("有更新数据，开始往table和本地数据库导入")
                for i in 0..<data.count
                {
                    var tempdata = data[i]
                    let temp = FirstTableMessageItem(dynamic_id:data[i][0],FirstTableImage: data[i][2],FirstTableTitle: data[i][7],FirstTableDetail: data[i][3],FirstTable_yanjin_Num: Int(data[i][4])!,FirstTable_pinglun_Num: Int(data[i][5])!)
                    self.bubbleSection.append(temp)
                    MySQL.shareMySQL().insertDynamic(data[i])
                    downDynamic.sharedDownDynamic()?.downDynamicImage(data[i][2],dynamic_id: data[i][0])
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
            self.refreshControl.endRefreshing()
            self.loadMoreEnable = true
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
    
    /** First_ScrollViewDelegate*/
    func First_numberOfPages() -> Int {
        
        return imageArray.count;
    }
    func First_currentPageViewIndex(index: Int) -> String {
        
        return imageArray[index]
    }
    func First_didSelectCurrentPage(index: Int) {
        
        
    }
    func First_currentPageLabel_Title(index: Int) -> String {
        return First_Scroll_Title[index]
    }

    
    //返回指定分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bubbleSection.count
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
            let data =  self.bubbleSection[indexPath.row]
            let image_frame = CGRectMake(0, 0, self.frame.width, 120)
            let cell =  FirstTableViewCell(frame:image_frame,data:data, reuseIdentifier:cellId)
        
        //当下拉到底部，执行loadMore()
        if (loadMoreEnable && indexPath.row == self.bubbleSection.count-1 && self.bubbleSection.count > 0)
        {
            setUpFreshing()
            //刷新远程数据
            updateNewDynamic()
        }
        if(loadMoreEnable == false && indexPath.row == self.bubbleSection.count-1 && self.bubbleSection.count > 0)
        {
            setUpFreshEnd()
        }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("shuashuashuashua")
        self.didSelectDelegate?.First_Table_DidSelect(indexPath.row,bubbleSection: self.bubbleSection[indexPath.row])
    }
}
