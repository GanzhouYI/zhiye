import UIKit
import Alamofire
class SearchTableViewCell:UITableViewCell,Plan_Table_Status_Delegate
{
    let biaoqian = "fanbiaoqian1"
    var TableImageUrl:String!
    //var TableImage:UIButton?
    var UpdateButton:UIButton?
    var UpLoadButton:UIButton?
    var TipLabel:UILabel?
    
    var Tablebiaoqian:UIButton?
    var TableTitle:UILabel?
    var TableDetail:UITextView?
    var Table_yanjin_Image:UIButton?
    var Table_yanjin_Num:UILabel?
    var Table_pinglun_Image:UIButton?
    var Table_pinglun_Num:UILabel?
    
    var msgItem:PlanTableMessageItem!//总体信息对象
    //- (void) setupInternalData
    init(frame:CGRect,data:PlanTableMessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 1)
        self.frame = frame
        
        self.msgItem.statusDelegate = self
        rebuildUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func rebuildUserInterface()
    {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        //self.TableImage = UIButton(frame:CGRectMake(5,40,110,90))
        //self.TableImage?.setBackgroundImage(UIImage(named: TableImageUrl), forState: UIControlState.Normal)
        //self.addSubview(self.FirstTableImage!)
        
        self.Tablebiaoqian = UIButton(frame: CGRectMake(0,0,self.frame.width-5,28))
        self.Tablebiaoqian?.setBackgroundImage(UIImage(named: biaoqian), forState: UIControlState.Normal)
        self.addSubview(self.Tablebiaoqian!)
        
        self.TableTitle = UILabel(frame: CGRectMake(20,32,self.frame.width-40,25))
        self.TableTitle!.adjustsFontSizeToFitWidth = false//如果标题文字超过了宽度自动调整字体大小适应，false不开启
        self.TableTitle?.font = UIFont.systemFontOfSize(20)
        print(self.msgItem.name)
        self.TableTitle?.text = self.msgItem.name
        self.TableTitle?.textAlignment = NSTextAlignment.Center
        self.addSubview(self.TableTitle!)
        
        self.TableDetail = UITextView(frame: CGRectMake(20,57,self.frame.width-40,45))
        self.TableDetail?.text = self.msgItem.tip
        self.TableDetail?.font = UIFont.systemFontOfSize(15)
        self.TableDetail?.textColor = UIColor.grayColor()
        self.TableDetail?.backgroundColor = UIColor.clearColor()
        self.TableDetail?.textAlignment = NSTextAlignment.Center
        self.TableDetail!.editable=false
        self.TableDetail!.selectable = false //防止复制
        //self.TableDetail!.userInteractionEnabled=false
        self.addSubview(self.TableDetail!)

        
        self.TipLabel = UILabel(frame: CGRectMake(20,106,200,25))
        self.TipLabel?.textColor = UIColor.whiteColor()
        self.TipLabel?.textAlignment=NSTextAlignment.Center
        self.addSubview(TipLabel!)
        
        self.UpdateButton = UIButton(frame: CGRectMake(20,106,200,25))
        self.UpdateButton?.setTitle("需要更新", forState: UIControlState.Normal)
        self.UpdateButton?.addTarget(self, action: "UpdateFunc", forControlEvents: UIControlEvents.TouchUpInside)
        self.UpdateButton?.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        self.addSubview(UpdateButton!)
        self.UpdateButton?.hidden = true
        
        self.UpLoadButton = UIButton(frame: CGRectMake(20,106,200,25))
        self.UpLoadButton?.setTitle("需要上传", forState: UIControlState.Normal)
        self.UpLoadButton?.addTarget(self, action: "UpLoadFunc", forControlEvents: UIControlEvents.TouchUpInside)
        self.UpLoadButton?.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        self.addSubview(UpLoadButton!)
        self.UpLoadButton?.hidden = true
        
        //    status (0、最新数据   1、需要更新   2、需要上传   3、已删除  4、正在上传   5、正在下载  6、需要下载)
        print(String(self.msgItem.status)+"msgItem")
        if(self.msgItem.status! == 0)
        {
            self.TipLabel?.text = "最新版本"
            self.TipLabel!.backgroundColor = UIColor(red: 176/255, green: 226/255, blue: 255/255, alpha: 1)
        }
        else if(self.msgItem.status! == 1)
        {
            self.UpdateButton?.hidden = false
        }
        else if(self.msgItem.status! == 2)
        {
            self.UpLoadButton?.hidden = false
        }
        else if(self.msgItem.status! == 4)
        {
            self.TipLabel?.text = "正在上传"
            self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else if(self.msgItem.status! == 5)
        {
            self.TipLabel?.text = "正在下载"
            self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else if(self.msgItem.status! == 6)
        {
            self.UpdateButton?.setTitle("需要下载", forState: UIControlState.Normal)
            self.UpdateButton?.hidden = false
        }
        
        self.Table_yanjin_Image = UIButton(frame: CGRectMake(245,111, 25,13))
        self.Table_yanjin_Image?.setBackgroundImage(UIImage(named: "主页眼镜1"), forState: UIControlState.Normal)
        self.addSubview(Table_yanjin_Image!)
        
        self.Table_yanjin_Num = UILabel(frame: CGRectMake(285 ,111, 50, 13))
        self.Table_yanjin_Num!.text = String(self.msgItem.Table_yanjin_Num)
        self.Table_yanjin_Num?.textAlignment = NSTextAlignment.Center
        self.Table_yanjin_Num!.font = UIFont.systemFontOfSize(15)
        self.Table_yanjin_Num?.textColor = UIColor.grayColor()
        self.addSubview(Table_yanjin_Num!)
        
        self.Table_pinglun_Image = UIButton(frame: CGRectMake(335,111,25,13))
        self.Table_pinglun_Image?.setBackgroundImage(UIImage(named: "主页评论数量"), forState: UIControlState.Normal)
        self.addSubview(Table_pinglun_Image!)
        
        self.Table_pinglun_Num = UILabel(frame: CGRectMake(360,111,self.frame.width-360,13))
        self.Table_pinglun_Num?.textAlignment = NSTextAlignment.Center
        self.Table_pinglun_Num!.text = String(self.msgItem.Table_pinglun_Num)
        self.Table_pinglun_Num?.textColor = UIColor.grayColor()
        self.Table_pinglun_Num!.font = UIFont.systemFontOfSize(15)
        self.addSubview(Table_pinglun_Num!)
        
    }
    
    //下载
    func UpdateFunc(){
        self.UpdateButton?.hidden = true
        self.TipLabel?.text = "正在下载"
        self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        PlanNet.sharedPlan()?.DownPlanDataCell(msgItem.tid!,msgItem: msgItem)
    }
    
    //上传
    func UpLoadFunc(){
        self.UpLoadButton?.hidden = true
        self.TipLabel?.text = "正在上传"
        self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        
        PlanNet.sharedPlan()?.UpLoadPlan(["":""], block: { (dataInfo) in
            
        })
    }
    

    func Plan_Table_StatusChanged(index : Int)
    {
        //    status (0、最新数据   1、需要更新   2、需要上传   3、已删除  4、正在上传   5、正在下载  6、需要下载)
        print(String(self.msgItem.status)+"msgItem")
        if(index == 0)
        {
            self.TipLabel?.text = "更新完成"
            self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else if(index == 1)
        {
            self.UpdateButton?.hidden = false
        }
        else if(index == 2)
        {
            self.UpLoadButton?.hidden = false
        }
        else if(index == 4)
        {
            self.TipLabel?.text = "正在上传"
            self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else if(index == 5)
        {
            self.TipLabel?.text = "正在下载"
            self.TipLabel!.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else if(index == 6)
        {
            self.UpdateButton?.setTitle("需要下载", forState: UIControlState.Normal)
            self.UpdateButton?.hidden = false
        }
    }
}
