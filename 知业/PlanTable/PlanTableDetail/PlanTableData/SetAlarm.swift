import Foundation
import UIKit
class SetAlarmView: UIView,AlarmPickerProtocol {
    var IsLeft:Bool = true
    var PlanTableCell:PlanTableDataViewCell!
    var blackBackGround = UIButton()
    var setupkuang = UIButton()
    var AlarmPickerTime:AlarmPickerView!
    var bt_submit:UIButton!
    var bt_closeAlarm:UIButton!
    var selectDayData:[Int]!
    
    var IsOpen:Bool = true
    var ArrayTime:[String]!
    var ArrayTimeFrequent:[String]!
    
    var la_bg:UILabel!
    var la_frequent:UILabel!
    var bt_once:UIButton!
    var bt_monday:UIButton!
    var bt_tuesday:UIButton!
    var bt_wednesday:UIButton!
    var bt_thursday:UIButton!
    var bt_friday:UIButton!
    var bt_saturday:UIButton!
    var bt_sunday:UIButton!
    
    convenience init(frame: CGRect,PlanTableCell:PlanTableDataViewCell,IsLeft:Bool) {
        self.init(frame: frame)
        self.PlanTableCell = PlanTableCell
        self.IsLeft = IsLeft
        
        UIView.animateWithDuration(1, // 动画时长
            delay:0 ,// 动画延迟z
            usingSpringWithDamping:1.0 ,// 类似弹簧振动效果 0~1
            initialSpringVelocity:1.0 ,// 初始速度
            options:UIViewAnimationOptions.CurveEaseIn, // 动画过渡效果
            animations: {()-> Void in
                self.setupkuang.frame = CGRectMake(50, 70, self.frame.width-100, self.frame.height-160)
                self.AlarmPickerTime = AlarmPickerView(frame: CGRectMake(50, 100, self.frame.width-100, 150),IsSpecialTime:false)
                self.AlarmPickerTime.delegate = self
                self.InitAlarm()
                self.addSubview(self.AlarmPickerTime)
            }, completion:{(Bool)-> Void in
                self.blackBackGround.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)})
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectDayData = [0,0,0,0,0,0,0]
        blackBackGround.backgroundColor = UIColor.whiteColor()
        blackBackGround.alpha = 0.5
        blackBackGround.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.addSubview(blackBackGround)
        
        setupkuang.frame = CGRectMake(60, self.frame.height, self.frame.width-120, 600)
        setupkuang.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        self.addSubview(setupkuang)
        
        la_bg = UILabel(frame: CGRectMake(50, 280, self.frame.width-100, 40))
        la_bg.backgroundColor = UIColor.whiteColor()
        self.addSubview(la_bg)
        
        la_frequent = UILabel(frame: CGRectMake(55, 280, 40, 40))
        la_frequent.text = "重复"
        self.addSubview(la_frequent)
        
        bt_sunday = UIButton(frame: CGRectMake(110, 287.5, 25, 25))
        bt_sunday.setTitle("日", forState: UIControlState.Normal)
        bt_sunday.backgroundColor = UIColor.grayColor()
        bt_sunday.tag = 7
        bt_sunday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bt_sunday)
        
        bt_monday = UIButton(frame: CGRectMake(145, 287.5, 25, 25))
        bt_monday.setTitle("一", forState: UIControlState.Normal)
        bt_monday.backgroundColor = UIColor.grayColor()
        bt_monday.tag = 1
        bt_monday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bt_monday)
        
        bt_tuesday = UIButton(frame: CGRectMake(180, 287.5,25, 25))
        bt_tuesday.setTitle("二", forState: UIControlState.Normal)
        bt_tuesday.tag = 2
        bt_tuesday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        bt_tuesday.backgroundColor = UIColor.grayColor()
        self.addSubview(bt_tuesday)
        
        bt_wednesday = UIButton(frame: CGRectMake(215, 287.5,25, 25))
        bt_wednesday.setTitle("三", forState: UIControlState.Normal)
        bt_wednesday.tag = 3
        bt_wednesday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        bt_wednesday.backgroundColor = UIColor.grayColor()
        self.addSubview(bt_wednesday)
        
        bt_thursday = UIButton(frame: CGRectMake(250, 287.5,25, 25))
        bt_thursday.setTitle("四", forState: UIControlState.Normal)
        bt_thursday.tag = 4
        bt_thursday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        bt_thursday.backgroundColor = UIColor.grayColor()
        self.addSubview(bt_thursday)
        
        bt_friday = UIButton(frame: CGRectMake(285, 287.5, 25, 25))
        bt_friday.setTitle("五", forState: UIControlState.Normal)
        bt_friday.backgroundColor = UIColor.grayColor()
        bt_friday.tag = 5
        bt_friday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bt_friday)
        
        bt_saturday = UIButton(frame: CGRectMake(320, 287.5, 25, 25))
        bt_saturday.setTitle("六", forState: UIControlState.Normal)
        bt_saturday.backgroundColor = UIColor.grayColor()
        bt_saturday.tag = 6
        bt_saturday.addTarget(self, action: "SelectDay:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(bt_saturday)
        
        bt_submit = UIButton(frame: CGRectMake(50, 350, self.frame.width-100, 40))
        bt_submit.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        bt_submit.addTarget(self, action: "Fun_Submit", forControlEvents: UIControlEvents.TouchUpInside)
        bt_submit.setTitle("确定", forState: UIControlState.Normal)
        self.addSubview(bt_submit)
        
        bt_closeAlarm = UIButton(frame: CGRectMake(50, 410, self.frame.width-100, 40))
        bt_closeAlarm.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        bt_closeAlarm.addTarget(self, action: "Fun_CloseAlarm", forControlEvents: UIControlEvents.TouchUpInside)
        bt_closeAlarm.setTitle("关闭闹钟", forState: UIControlState.Normal)
        self.addSubview(bt_closeAlarm)
    }
    
    func InitAlarm(){
        if(IsLeft == true)
        {
            if(PlanTableCell.msgItem.HasLeftAlarm())
            {
                IsOpen = true
                if(PlanTableCell.msgItem.IsSpecialLeftTime())
                {
                    //指定时间
                }
                else
                {
                    var hour:Int = PlanTableCell.msgItem.ReturnLeftAlarm(0) != "" ? Int(PlanTableCell.msgItem.ReturnLeftAlarm(0))! : 0
                    var min:Int = PlanTableCell.msgItem.ReturnLeftAlarm(1) != "" ? Int(PlanTableCell.msgItem.ReturnLeftAlarm(1))! : 0
                    
                    InitSelectDay(PlanTableCell.msgItem.ReturnLeftAlarm(2))
                    self.AlarmPickerTime.SetAlarmTime(hour, min: min)
                }
            }
            else
            {
                IsOpen = false
                self.AlarmPickerTime.SetAlarmTime(8, min: 0)
            }
        }
        else
        {
            if(PlanTableCell.msgItem.HasRightAlarm())
            {
                IsOpen = true
                if(PlanTableCell.msgItem.IsSpecialRightTime())
                {
                    //指定时间
                }
                else
                {
                    var hour:Int = PlanTableCell.msgItem.ReturnRightAlarm(0) != "" ? Int(PlanTableCell.msgItem.ReturnRightAlarm(0))! : 0
                    var min:Int = PlanTableCell.msgItem.ReturnRightAlarm(1) != "" ? Int(PlanTableCell.msgItem.ReturnRightAlarm(1))! : 0
                    
                    InitSelectDay(PlanTableCell.msgItem.ReturnRightAlarm(2))
                    self.AlarmPickerTime.SetAlarmTime(hour, min:min)
                }
            }
            else
            {
                IsOpen = false
                self.AlarmPickerTime.SetAlarmTime(8, min: 0)
            }
        }
    }
    
    func InitSelectDay(var Day:String) {
        if(Day == "")
        {
            return
        }
        if(Day.containsString("一"))
        {
            selectDayData[0]=1
            bt_monday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[0]=0
            bt_monday.backgroundColor = UIColor.grayColor()
        }
        if(Day.containsString("二"))
        {
            selectDayData[1]=1
            bt_tuesday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[1]=0
            bt_tuesday.backgroundColor = UIColor.grayColor()
        }
        if(Day.containsString("三"))
        {
            selectDayData[2]=1
            bt_wednesday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[2]=0
            bt_wednesday.backgroundColor = UIColor.grayColor()
        }
        if(Day.containsString("四"))
        {
            selectDayData[3]=1
            bt_thursday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[3]=0
            bt_thursday.backgroundColor = UIColor.grayColor()
        }
        if(Day.containsString("五"))
        {
            selectDayData[4]=1
            bt_friday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[4]=0
            bt_friday.backgroundColor = UIColor.grayColor()
        }
        if(Day.containsString("六"))
        {
            selectDayData[5]=1
            bt_saturday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[5]=0
            bt_saturday.backgroundColor = UIColor.grayColor()
        }
        if(Day.containsString("日"))
        {
            selectDayData[6]=1
            bt_sunday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
        else
        {
            selectDayData[6]=0
            bt_sunday.backgroundColor = UIColor.grayColor()
        }
    }
    
    func SelectDay(bt:UIButton)
    {
        switch bt.tag {
        case 1:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_monday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_monday.backgroundColor = UIColor.grayColor()
            }
            break
        case 2:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_tuesday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_tuesday.backgroundColor = UIColor.grayColor()
            }
            break
        case 3:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_wednesday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_wednesday.backgroundColor = UIColor.grayColor()
            }
            break
        case 4:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_thursday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_thursday.backgroundColor = UIColor.grayColor()
            }
            break
        case 5:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_friday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_friday.backgroundColor = UIColor.grayColor()
            }
            break
        case 6:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_saturday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_saturday.backgroundColor = UIColor.grayColor()
            }
            break
        case 7:
            if(selectDayData[bt.tag-1]==0)
            {
                selectDayData[bt.tag-1]=1
                bt_sunday.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
            }
            else
            {
                selectDayData[bt.tag-1]=0
                bt_sunday.backgroundColor = UIColor.grayColor()
            }
            break
        default:
            break
        }
    }
    
    func Fun_CloseAlarm() {
        self.IsOpen = false
        if(IsLeft == true)
        {
            self.PlanTableCell.leftAlarmData_button.setTitle("无", forState: UIControlState.Normal)
            //self.PlanTableCell.leftAlarmData_button.hidden = true
            self.PlanTableCell.leftAlarmDataFrequent_button.setTitle("无", forState: UIControlState.Normal)
            //self.PlanTableCell.leftAlarmDataFrequent_button.hidden = true
            
        }
        else
        {
            self.PlanTableCell.rightAlarmData_button.setTitle("无", forState: UIControlState.Normal)
            //self.PlanTableCell.rightAlarmData_button.hidden = true
            self.PlanTableCell.rightAlarmDataFrequent_button.setTitle("无", forState: UIControlState.Normal)
            //self.PlanTableCell.rightAlarmDataFrequent_button.hidden = true
        }
        
       // PlanTableDataMessage.sharePlanTableData().dataMessageItem[self.PlanTableCell.planTableTTidRow].PlanTableCellData[self.PlanTableCell.NOCell].SetAlarm(IsLeft, IsOpen: IsOpen, IsSpecialTime: self.AlarmPickerTime.IsSpecialTime, Data: "")
        //print("Close test test")
        
        self.PlanTableCell.msgItem.SetAlarm(IsLeft, IsOpen: IsOpen, IsSpecialTime: self.AlarmPickerTime.IsSpecialTime, Data: "")
        
        back()
    }
    
    func Fun_Submit()
    {
        IsOpen = true
        self.AlarmPickerTime.ReturnPickerViewValue()
        back()
    }
    
    func AlarmData(data: [String]) {
        var date:String = ""
        var frequent:String = ""
        if(IsOpen == false)
        {
            if(IsLeft == true)
            {
                self.PlanTableCell.leftAlarmData_button.setTitle("", forState: UIControlState.Normal)
                self.PlanTableCell.leftAlarmDataFrequent_button.setTitle("", forState: UIControlState.Normal)
            }
            else
            {
                self.PlanTableCell.rightAlarmData_button.setTitle("", forState: UIControlState.Normal)
                self.PlanTableCell.rightAlarmDataFrequent_button.setTitle("", forState: UIControlState.Normal)
            }
            self.PlanTableCell.msgItem.SetAlarm(IsLeft, IsOpen: IsOpen, IsSpecialTime: self.AlarmPickerTime.IsSpecialTime, Data: "")
            return
        }
        
        if(self.AlarmPickerTime.IsSpecialTime == false)
        {
            date = data[0] + ":" + data[1]
            for(var i:Int = 0; i < 7; i += 1)
            {
                if(self.selectDayData[i] == 1)
                {
                    if(i == 0){frequent += "一"}
                    if(i == 1){frequent += "二"}
                    if(i == 2){frequent += "三"}
                    if(i == 3){frequent += "四"}
                    if(i == 4){frequent += "五"}
                    if(i == 5){frequent += "六"}
                    if(i == 6){frequent += "日"}
                }
            }
            PlanTableDataMessage.sharePlanTableData().dataMessageItem[self.PlanTableCell.planTableTTidRow].PlanTableCellData[self.PlanTableCell.NOCell].SetAlarm(IsLeft, IsOpen: IsOpen, IsSpecialTime: self.AlarmPickerTime.IsSpecialTime, Data: data[0]+","+data[1]+","+frequent)
            
            self.PlanTableCell.msgItem.SetAlarm(IsLeft, IsOpen: IsOpen, IsSpecialTime: self.AlarmPickerTime.IsSpecialTime, Data: data[0]+","+data[1]+","+frequent)
        
            if(IsLeft == true)
            {
                self.PlanTableCell.leftAlarmData_button.setTitle(date, forState: UIControlState.Normal)
                if(frequent != "")
                {
                    self.PlanTableCell.leftAlarmDataFrequent_button.setTitle(frequent, forState: UIControlState.Normal)
                }
                else
                {
                    self.PlanTableCell.leftAlarmDataFrequent_button.setTitle("", forState: UIControlState.Normal)
                }
            }
            else
            {
                self.PlanTableCell.rightAlarmData_button.setTitle(date, forState: UIControlState.Normal)
                if(frequent != "")
                {
                    self.PlanTableCell.rightAlarmDataFrequent_button.setTitle(frequent, forState: UIControlState.Normal)
                }
                else
                {
                    self.PlanTableCell.rightAlarmDataFrequent_button.setTitle("", forState: UIControlState.Normal)
                }
            }
        }
        else if(self.AlarmPickerTime.IsSpecialTime == true)
        {
            
        }
    }
    
    func back()
    {
        UIView.animateWithDuration(1, // 动画时长
            delay:0 ,// 动画延迟z
            usingSpringWithDamping:1.0 ,// 类似弹簧振动效果 0~1
            initialSpringVelocity:1.0 ,// 初始速度
            options:UIViewAnimationOptions.CurveEaseIn, // 动画过渡效果
            animations: {()-> Void in
                self.setupkuang.frame = CGRectMake(self.frame.width/2-50, -100,100, 100)
            }, completion: {(finnish)-> Void in
                self.blackBackGround.removeFromSuperview()
                self.setupkuang.removeFromSuperview()
                self.removeFromSuperview()
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

