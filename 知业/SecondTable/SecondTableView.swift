import UIKit

class SecondTableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    //用于保存所有消息
    var bubbleSection:Array<SecondTableMessageItem>!
    //数据源，用于与 ViewController 交换数据
    var SecondDataProtocol:SecondTableDataSource!
    required init?(coder aDecoder: ((NSCoder))) {
        super.init(coder: aDecoder)
    }
    init(frame:CGRect)
    {
        self.bubbleSection = Array<SecondTableMessageItem>()
        
        super.init(frame:frame,  style:UITableViewStyle.Plain)

        
        self.backgroundColor = UIColor.clearColor()
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None//分隔符风格
        self.delegate = self
        self.dataSource = self
        
        
    }
 
    
    override func reloadData()
    {
        
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = true//滚动的提示条
        
        var count =  0
        if ((self.SecondDataProtocol != nil))
        {
            count = self.SecondDataProtocol.rowsForSeoncdTable(self)
            
            if(count > 0)
            {   
                
                for (var i = 0; i < count; i += 1)
                {
                    
                    let object =  self.SecondDataProtocol.SecondTableViewDetail(self, dataForRow:i)
                    bubbleSection.append(object)
                    
                }
                
            }
        }
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
        if (section >= self.bubbleSection.count)
        {
            return 1
        }
        
        return self.bubbleSection.count+1
    }
        
    //用于确定单元格的高度，如果此方法实现得不对，单元格与单元格之间会错位
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat
    {
        
        // Header
        if (indexPath.row == 0)
        {
            print("self.frame.height*3/8")
            print(self.frame.height*3/8)
            return 0
        }
        
        
        return self.frame.height*3/8
    }
    
    //返回自定义的 TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
          
        let cellId = "MsgCell"
        if(indexPath.row > 0)
        {
            let data =  self.bubbleSection[indexPath.row-1]
            let image_frame = CGRectMake(0, 0, self.frame.width, self.frame.height*3/8)
            let cell =  SecondTableViewCell(frame:image_frame,data:data, reuseIdentifier:cellId)
        
            return cell
        }
        else
        {
            
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
    }
}
