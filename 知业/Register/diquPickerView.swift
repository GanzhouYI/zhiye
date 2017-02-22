import UIKit

protocol diquPickerProtocol
{
    func Diqudata(data: [String])->Void
}

class diquPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var Picker:UIPickerView!
    var 透明:UIImageView!
    
    var addressData:NSDictionary!
    var address:NSArray!
    var delegate:diquPickerProtocol!
    var province=[String]()
    var city=[String]()
    var xian=[String]()
    var selectArray=[Int]()//记录选中第几个省市县
    
    func  addressInit()
    {
        
        let path = NSBundle.mainBundle().pathForResource("address", ofType: "plist")
        addressData = NSDictionary.init(contentsOfFile: path!)
        address = NSArray(array: (addressData["address"])! as! [AnyObject])
        
        //初始化地区为 省5市1 县未选
        for a in 0...address.count-1{
            province.append(address[a]["name"] as! String)
        }
        for b in 0..<address[5]["sub"]!!.count{
            city.append(address[5]["sub"]!![b]["name"] as! String)
        }
        
        for c in 0...address[5]["sub"]!![1]["sub"]!!.count-1{
            xian.append(address[5]["sub"]!![1]["sub"]!![c] as! String)
        }
        
        selectArray.append(5)//省
        selectArray.append(1)//市
        selectArray.append(3)//县
        
        Picker.selectRow(selectArray[0], inComponent: 0, animated: true)
        Picker.selectRow(selectArray[1], inComponent: 1, animated: true)
        Picker.selectRow(selectArray[2], inComponent: 2, animated: true)
        
    }
    
    func  addressCityALL()->[String]
    {
        var addressData:NSDictionary!
        var address:NSArray!
        
        var city=[String]()
        var xian:NSArray!
        var count:Int!
        let path = NSBundle.mainBundle().pathForResource("address", ofType: "plist")
        addressData = NSDictionary.init(contentsOfFile: path!)
        address = NSArray(array: (addressData["address"])! as! [AnyObject])
        count = address.count
        
        /* print(address[0]["name"])//省
        print(address[0]["sub"]!![0]["name"])//市
        print(address[0]["sub"]!![0]["sub"]!![0])//县
        */
        return city
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Picker = UIPickerView()
        Picker.dataSource = self
        Picker.delegate = self
        
        透明 = UIImageView(frame: frame)
        透明.backgroundColor = UIColor.whiteColor()
        透明.alpha = 0.9
        self.addSubview(透明)
        
        addressInit()
        self.addSubview(Picker)
        
        var button = UIButton(frame: CGRectMake(0,20,self.frame.width,50))
        button.center = self.center
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("确定", forState: UIControlState.Normal)
        button.addTarget(self, action: "getPickerViewValue", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component==0)
        {
            return self.province.count
        }
        else if (component==1)
        {
            return self.city.count
        }
        else
        {
            return self.xian.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component==0
        {
            return self.province[row]
        }
        else if component == 1
        {
            return self.city[row]
        }
        else
        {
            return self.xian[row]
        }
    }
    
    func getPickerViewValue()
    {
        var diquData:[String] = [String(address[selectArray[0]]["name"]!!),String(address[selectArray[0]]["sub"]!![selectArray[1]]["name"]!!),
            String(address[selectArray[0]]["sub"]!![selectArray[1]]["sub"]!![selectArray[2]])]
        delegate.Diqudata(diquData)
        self.removeFromSuperview()
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component==0
        {
            city.removeAll()
            for b in 0...address[row]["sub"]!!.count-1{
                city.append(address[row]["sub"]!![b]["name"] as! String)
            }
            
            xian.removeAll()
            for c in 0...address[row]["sub"]!![0]["sub"]!!.count-1{
                xian.append(address[row]["sub"]!![0]["sub"]!![c] as! String)
            }
            
            selectArray.removeAll()
            selectArray.append(row)//省
            selectArray.append(0)//市
            selectArray.append(0)//县
            
            //下面的有先后顺序不然 刷新不出来
            pickerView.selectedRowInComponent(1)
            pickerView.reloadComponent(1)
            pickerView.selectedRowInComponent(2)
            pickerView.reloadComponent(2)
            pickerView.selectRow(selectArray[1], inComponent: 1, animated: true)
            pickerView.selectRow(selectArray[2], inComponent: 2, animated: true)
        }
        
        if component==1
        {
            
            selectArray.removeAtIndex(2)
            selectArray.removeAtIndex(1)
            selectArray.append(row)
            selectArray.append(0)
            
            xian.removeAll()
            
            for c in 0...address[selectArray[0]]["sub"]!![selectArray[1]]["sub"]!!.count-1{
                //保留省
                xian.append(address[selectArray[0]]["sub"]!![selectArray[1]]["sub"]!![c] as! String)
            }
            pickerView.selectRow(selectArray[2], inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
        }
        
        if component==2
        {
            selectArray.removeAtIndex(2)
            selectArray.append(row)
        }
    }
    

    
    
}

