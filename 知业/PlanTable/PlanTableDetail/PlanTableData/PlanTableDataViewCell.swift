import UIKit
import Alamofire
class PlanTableDataViewCell:UITableViewCell,UITextViewDelegate
{
    let biaoqian = "fanbiaoqian1"
    let alarmImage = "alarm"
    var planTableTTid:Int!
    var planTableTTidRow:Int!
    var NOCell:Int!
    var NOLabel:UILabel!
    
    var leftAlarmIcon_button:UIButton!
    var leftAlarmData_button:UIButton!
    var leftAlarmDataFrequent_button:UIButton!
    var left_data:UITextView!
    
    var rightAlarmIcon_button:UIButton!
    var rightAlarmData_button:UIButton!
    var rightAlarmDataFrequent_button:UIButton!
    var right_data:UITextView!
    
    //设置闹铃  用于Cell传递界面显示、设置闹铃
    //PlanTableDetailController 完成协议
    weak var setAlarmDelegate:Plan_Table_SetAlarm_Delegate?
    
    var msgItem:PlanTableCellDataMessageItem!//总体信息对象
    
    init(frame:CGRect,planTableTTid:Int,planTableTTidRow:Int,NOCell:Int,data:PlanTableCellDataMessageItem, reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.alpha = 0
        self.frame = frame
        self.backgroundColor = NOCell%2==0 ? UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 0.5) : UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 0.5)
        self.planTableTTid = planTableTTid
        self.planTableTTidRow = planTableTTidRow
        self.NOCell = NOCell
        self.msgItem = PlanTableCellDataMessageItem()
        self.msgItem = data

        NOLabel = UILabel(frame: CGRectMake(5,2,30,40))
        NOLabel.text = String(NOCell)
        NOLabel.textColor = UIColor.grayColor()
        
        leftAlarmIcon_button = UIButton(frame: CGRectMake(30,5,30,30))
        leftAlarmIcon_button.setBackgroundImage(UIImage(named: alarmImage), forState: UIControlState.Normal)
        leftAlarmIcon_button.addTarget(self, action: "FuncSetAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
        
        leftAlarmData_button = UIButton(frame: CGRectMake(65,0,self.frame.width/2-85,30))
        leftAlarmData_button.tag = 1000
        leftAlarmData_button.backgroundColor = UIColor.blackColor()
        leftAlarmData_button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        leftAlarmData_button.titleLabel?.font = UIFont(name: "Arial", size: 13)
        leftAlarmData_button.addTarget(self, action: "FuncSetAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
        
        leftAlarmDataFrequent_button = UIButton(frame: CGRectMake(65,12,self.frame.width/2-85,30))
        leftAlarmDataFrequent_button.tag = 1001
        leftAlarmDataFrequent_button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        leftAlarmDataFrequent_button.titleLabel?.font = UIFont(name: "Arial", size: 13)
        leftAlarmDataFrequent_button.addTarget(self, action: "FuncSetAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
        
        rightAlarmIcon_button = UIButton(frame: CGRectMake(15+self.frame.width/2,5,30,30))
        rightAlarmIcon_button.setBackgroundImage(UIImage(named: alarmImage), forState: UIControlState.Normal)
        rightAlarmIcon_button.addTarget(self, action: "FuncSetAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
        
        rightAlarmData_button = UIButton(frame: CGRectMake(15+self.frame.width/2+35,0,self.frame.width/2-85,30))
        rightAlarmData_button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        rightAlarmData_button.addTarget(self, action: "FuncSetAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
        rightAlarmData_button.titleLabel?.font = UIFont(name: "Arial", size: 13)
        
        rightAlarmDataFrequent_button = UIButton(frame: CGRectMake(15+self.frame.width/2+35,12,self.frame.width/2-85,30))
        rightAlarmDataFrequent_button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        rightAlarmDataFrequent_button.addTarget(self, action: "FuncSetAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
        rightAlarmDataFrequent_button.titleLabel?.font = UIFont(name: "Arial", size: 13)
        
        left_data = UITextView(frame: CGRectMake(30,35,self.frame.width/2-50,40))
        left_data.delegate = self
        left_data.tag = 2000
        
        right_data = UITextView(frame: CGRectMake(15+self.frame.width/2,35,self.frame.width/2-50,40))
        right_data.delegate = self
        right_data.tag = 2001
        
        left_data.text = msgItem.left_data!
        right_data.text = msgItem.right_data!

        if(msgItem.HasLeftAlarm())
        {
            
            if(msgItem.IsSpecialLeftTime())
            {
                var time:String = msgItem.ReturnLeftAlarm(0)+"-"+msgItem.ReturnLeftAlarm(1)+"-"+msgItem.ReturnLeftAlarm(2)+" "+msgItem.ReturnLeftAlarm(3)+":"+msgItem.ReturnLeftAlarm(4)
                leftAlarmData_button.setTitle(time, forState: UIControlState.Normal)
            }
            else
            {
                var time:String = msgItem.ReturnLeftAlarm(0)+":"+msgItem.ReturnLeftAlarm(1)
                leftAlarmData_button.setTitle(time, forState: UIControlState.Normal)
                leftAlarmDataFrequent_button.setTitle(msgItem.ReturnLeftAlarm(2), forState: UIControlState.Normal)
            }
        }
        if(msgItem.HasDoubleCol() && msgItem.HasRightAlarm())
        {
            if(msgItem.IsSpecialRightTime())
            {
                var time:String = msgItem.ReturnRightAlarm(0)+"-"+msgItem.ReturnRightAlarm(1)+"-"+msgItem.ReturnRightAlarm(2)+" "+msgItem.ReturnRightAlarm(3)+":"+msgItem.ReturnRightAlarm(4)
                rightAlarmData_button.setTitle(time, forState: UIControlState.Normal)
            }
            else
            {
                var time:String = msgItem.ReturnRightAlarm(0)+":"+msgItem.ReturnRightAlarm(1)
                rightAlarmData_button.setTitle(time, forState: UIControlState.Normal)
                rightAlarmDataFrequent_button.setTitle(msgItem.ReturnRightAlarm(2), forState: UIControlState.Normal)
            }
        }
        self.addSubview(leftAlarmData_button)
        self.addSubview(leftAlarmDataFrequent_button)
        self.addSubview(leftAlarmIcon_button)
        self.addSubview(left_data)
        
        self.addSubview(right_data)
        self.addSubview(rightAlarmIcon_button)
        self.addSubview(rightAlarmData_button)
        self.addSubview(rightAlarmDataFrequent_button)
        
        self.addSubview(NOLabel)
    }

    func textViewDidEndEditing(textView: UITextView)
    {
        if(textView.tag == 2000)
        {
            self.msgItem.SetData(true,data: textView.text!)
        }
        else if(textView.tag == 2001)
        {
            self.msgItem.SetData(false,data: textView.text!)
        }
    }
    
    func HandleTap(sender:UITapGestureRecognizer)
    {
        if sender.state == .Ended
        {
            //这个方法好，隐藏所有键盘无论在哪个控件上
            self.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func FuncSetAlarm(AlarmButton:UIButton)
    {
        if(AlarmButton.tag == 1000 || AlarmButton.tag == 1001)
        {
            self.setAlarmDelegate?.ShowSetAlarm!(self,IsLeft:true,planTableTTid:planTableTTid,NOCell:NOCell)
        }
        else
        {
            self.setAlarmDelegate?.ShowSetAlarm!(self,IsLeft:false,planTableTTid:planTableTTid,NOCell:NOCell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //来源于UITextViewDelegate协议
    func textViewShouldReturn(textView:UITextView) ->Bool
    {
        //if (textField == planName) {
            //planName.resignFirstResponder()
        //    return true;
       // }
        return true
    }
    
    func rebuildUserInterface()
    {
        self.selectionStyle = UITableViewCellSelectionStyle.None

    }
}
