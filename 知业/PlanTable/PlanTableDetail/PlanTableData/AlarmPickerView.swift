import UIKit

protocol AlarmPickerProtocol
{
    func AlarmData(data: [String])->Void
}

class AlarmPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate{
    //  时钟是2列       日历是3列
    //  true 是time 选择时钟    false 是date  选择日历
    var IsSpecialTime:Bool!
    var la_hour:UILabel!
    var la_min:UILabel!
    var Picker:UIPickerView!
    var 透明:UIImageView!
    var la_selectImage:UILabel!
    
    var delegate:AlarmPickerProtocol!
    var picker_1=[String]()
    var picker_2=[String]()
    var picker_3=[String]()
    var selectArray=[Int]()//记录选中第几个  时分   年月日
    
    func  SetAlarmTime(var hour:Int,var min:Int)
    {
        picker_1.removeAll()
        picker_2.removeAll()
        picker_3.removeAll()
        selectArray.removeAll()
        
        //初始化地区为 省5市1 县未选
        for a in 0...23{
            if(a < 10)
            {
                picker_1.append("0" + String(a))
            }
            else
            {
            picker_1.append(String(a))
            }
        }
        for b in 0..<59{
            if(b < 10)
            {
                picker_2.append("0" + String(b))
            }
            else
            {
            picker_2.append(String(b))
            }
        }
        
        selectArray.append(hour)//   默认选择7时
        selectArray.append(min)//   默认选择0分
        
        Picker.selectRow(selectArray[0], inComponent: 0, animated: true)
        Picker.selectRow(selectArray[1], inComponent: 1, animated: true)
        
        la_hour = UILabel(frame: CGRectMake(self.frame.width*2/5, self.frame.height/2-12.5, 25, 25))
        la_hour.text = "时"
        self.addSubview(la_hour)
        
        la_min = UILabel(frame: CGRectMake(self.frame.width-25, self.frame.height/2-12.5, 25, 25))
        la_min.text = "分"
        self.addSubview(la_min)
    }
    
    convenience init(frame:CGRect,IsSpecialTime:Bool)
    {
        self.init(frame:frame)
        self.IsSpecialTime = IsSpecialTime
        
        if(IsSpecialTime == false)
        {
            SetAlarmTime(0,min: 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Picker = UIPickerView(frame: CGRectMake(0, 0, frame.width, frame.height))
        Picker.dataSource = self
        Picker.delegate = self
        
        la_selectImage = UILabel(frame: CGRectMake(0, self.frame.height/2-12.5, frame.width, 25))
        la_selectImage.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.7)
        self.addSubview(la_selectImage)
        
        透明 = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        透明.backgroundColor = UIColor.whiteColor()
        透明.alpha = 0.9
        
        self.addSubview(透明)
        self.addSubview(Picker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return IsSpecialTime == false ? 2 : 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0)
        {
            return self.picker_1.count
        }
        else if (component == 1)
        {
            return self.picker_2.count
        }
            return self.picker_3.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0)
        {
            return self.picker_1[row]
        }
        else if (component == 1)
        {
            return self.picker_2[row]
        }
            return self.picker_3[row]
    }
    
    func ReturnPickerViewValue()
    {
        var AlarmData:[String]!
        if(IsSpecialTime == false)
        {
            AlarmData = [picker_1[selectArray[0]],picker_2[selectArray[1]]]
        }
        else
        {
            AlarmData = [picker_1[selectArray[0]],picker_2[selectArray[1]],picker_3[selectArray[2]]]
        }
        delegate.AlarmData(AlarmData)
        self.removeFromSuperview()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(IsSpecialTime == false)
        {
            if (component == 0)
            {
                selectArray[0] = row
            }
            else if(component == 1)
            {
                selectArray[1] = row//分
            }
        }
        else if(IsSpecialTime == true)
        {
            if (component == 0)
            {
                selectArray[0] = row
            }
            else if(component == 1)
            {
                selectArray[1] = row
            }
            else if(component == 2)
            {
                selectArray[2] = row
            }
        }
            //下面的有先后顺序不然 刷新不出来
            /*pickerView.selectedRowInComponent(1)
            pickerView.reloadComponent(1)
            pickerView.selectedRowInComponent(2)
            pickerView.reloadComponent(2)
            pickerView.selectRow(selectArray[1], inComponent: 1, animated: true)
            pickerView.selectRow(selectArray[2], inComponent: 2, animated: true)*/
        }
    }