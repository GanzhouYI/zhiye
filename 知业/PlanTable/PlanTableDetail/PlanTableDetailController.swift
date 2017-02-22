import UIKit
import Alamofire
class PlanTableDetailController: UIViewController,UITextFieldDelegate,UITextViewDelegate,Plan_Table_Data_Delegate,Plan_Table_SetAlarm_Delegate {
    
    var backButton:UIButton!
    var navTitle:UILabel!
    var DetailTextViewPlaceholder:UITextField!
    var bubbleSection = PlanTableMessageItem()
    var FirstTableImageUrl:String!
    
    var HeadView:UIView!
    var backgroundButton:UIButton!
    var planName:UITextField!
    var planDescribe:UITextView!
    
    var PlanTableDataViewController:PlanTableDataView!
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        GetFirstTableImage()
        
        backgroundButton = UIButton(frame:self.view.frame)
        backgroundButton.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        
        navTitle=UILabel(frame: CGRectMake(60,20,self.view.frame.width-80-40,50))
        navTitle.font = UIFont(name: "Arial", size: 25)
        navTitle.textAlignment=NSTextAlignment.Center
        
        backButton = UIButton(frame: CGRectMake(5,20,60,40))
        backButton.setTitle("返回", forState: UIControlState.Normal)
        //backButton.backgroundColor=UIColor.grayColor()
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        
        HeadView = UIView(frame: CGRectMake(0,70,self.view.frame.width,140))
        HeadView.layer.masksToBounds = true
        HeadView.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        //HeadView.layer.cornerRadius = 10
        
        planName = UITextField(frame: CGRectMake(20,0,self.view.frame.width-40,40))
        //planName.backgroundColor = UIColor(red: 92/255, green: 172/255, blue: 236/255, alpha: 1)
        planName.placeholder="表标题"//默认显示信息
        planName.font = UIFont(name: "Arial", size: 24)
        planName.textAlignment = NSTextAlignment.Center
        planName.returnKeyType=UIReturnKeyType.Next//键盘点击确定发生什么
        //planName.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        planName.delegate=self

        DetailTextViewPlaceholder = UITextField(frame: CGRectMake(0, 40, self.view.frame.width-40, 40))
        DetailTextViewPlaceholder.placeholder="详细描述"//默认显示信息
        DetailTextViewPlaceholder.textAlignment = NSTextAlignment.Center
        
        planDescribe=UITextView(frame: CGRectMake(20, 40, self.view.frame.width-40, 90))
        planDescribe.delegate = self
        planDescribe.alpha = 0.5
        planDescribe.layer.borderColor = UIColor.whiteColor().CGColor
        planDescribe.layer.borderWidth = 2
        planDescribe.layer.cornerRadius = 10
        planDescribe.backgroundColor = UIColor.clearColor()
        planDescribe.font = UIFont(name: "Arial", size: 20)
       //planDescribe.backgroundColor=UIColor.greenColor()
        
        PlanTableDataMessage.sharePlanTableData().dataMessageItem.removeAll()
        
        for tidID in 0..<10
        {
            var tid:String
            var ttid:String
            var title:String
            var tip:String
            
            var CellDataItem:PlanTableCellDataMessageItem
            var CellData:Array<PlanTableCellDataMessageItem>
            CellData = Array<PlanTableCellDataMessageItem>()
            
            tid = String(tidID)
            ttid = String(tidID)
            title = String(tidID)
            tip = String(tidID)
            
            for i in 1..<111
            {
                CellDataItem = PlanTableCellDataMessageItem(
                                                            row_type:0b111111011,
                                                            left_data:String(i),left_alarm:String("20,00,一二三四五六日"),left_connect:String(i),
                                                            right_data:String(i),right_alarm:String("2017,1,1,21,00"),right_connect:String(i))
                
                CellData.append(CellDataItem)
            }
            var temp = PlanTableDataMessageItem(
                tid: tid,ttid: ttid,title: title,tip: tip,CellData: CellData)
            
            PlanTableDataMessage.sharePlanTableData().dataMessageItem.append(temp)
            CellData.removeAll()
        }
        
        self.view.addSubview(backgroundButton)
        self.view.addSubview(backButton)
        self.view.addSubview(navTitle)
        HeadView.addSubview(planName)
        HeadView.addSubview(DetailTextViewPlaceholder)
        HeadView.addSubview(planDescribe)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundButton.addTarget(self,action:Selector("returnbackKeyboard"),forControlEvents:UIControlEvents.TouchUpInside)
        LoadData()
        setupPlanTableDataView()
    }
    
    func returnbackKeyboard()
    {
        //这个方法好，隐藏所有键盘无论在哪个控件上
        self.view.endEditing(true)
    }
    
    /*Plan_Table_Data_Delegate*/
    func Plan_Table_Data_DidSelect(index: Int) {
        //print("输出",index)
        //let FirstTableDetailCotroller = PlanTableData()
        //FirstTableDetailCotroller.bubbleSection = bubbleSection
        //self.navigationController?.pushViewController(FirstTableDetailCotroller, animated: true)
    }
    
    /*Plan_Table_SetAlarm_Delegate*/
    func ShowSetAlarm(PlanTableCell:PlanTableDataViewCell,IsLeft:Bool,planTableTTid:Int,NOCell:Int) {
        print("PlanTableController")
        var setAlarmView = SetAlarmView(frame:self.view.frame,PlanTableCell:PlanTableCell,IsLeft:IsLeft)
        self.view.addSubview(setAlarmView)
    }
    
    func setupPlanTableDataView()
    {
        self.PlanTableDataViewController = PlanTableDataView(frame:CGRectMake(0
            , 70, self.view.frame.width, self.view.frame.height-70),planTableTTid:0,planTableTTidRow:0)
        
        //创建一个重用的单元格
        self.PlanTableDataViewController!.registerClass(PlanTableDataViewCell.self, forCellReuseIdentifier: "MsgCell")
        self.PlanTableDataViewController.didSelectDelegate = self
        self.PlanTableDataViewController.setAlarmDelegate = self
        self.PlanTableDataViewController.reloadData()
        self.PlanTableDataViewController.tableHeaderView=HeadView
        self.view.addSubview(PlanTableDataViewController)
    }
    
    private func LoadData()
    {
        if( bubbleSection.name != "")
        {
            navTitle.text = bubbleSection.name
            planName.text = bubbleSection.name
            planDescribe.text=bubbleSection.tip
            if(planDescribe.text == "")
            {
                DetailTextViewPlaceholder.placeholder = "详细信息"
            }
            else
            {
                DetailTextViewPlaceholder.placeholder = ""
            }
        }
    }
    
    func GetFirstTableImage(){
        
        let fileManager = NSFileManager.defaultManager()
        let dynamicDir = "/zhiye/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic/"
        let dynamicDirectory:String = NSHomeDirectory() + "/Documents"+dynamicDir
        //FirstTableImageUrl=dynamicDirectory+self.bubbleSection!.dynamic_id!+".jpg"
//        if(!fileManager.fileExistsAtPath(FirstTableImageUrl))//如果zhiye/user不存在
//        {
//            FirstTableImageUrl=""
//            downDynamicImage(self.msgItem.FirstTableImage!,dir:dynamicDir, fileName: self.msgItem.dynamic_id!,fileType: ".jpg")
//        }
        
    }
    
    
    func back()
    {
        print("backback")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    //来源于UITextViewDelegate协议
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if(textView == planDescribe)
        {
            if(planDescribe.text == "")
            {
                DetailTextViewPlaceholder.placeholder = "详细描述"
            }
            else
            {
                DetailTextViewPlaceholder.placeholder = ""
            }
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if(textView == planDescribe)
        {
            if(planDescribe.text == "")
            {
                DetailTextViewPlaceholder.placeholder = "详细描述"
            }
            else
            {
                DetailTextViewPlaceholder.placeholder = ""
            }
        }
    }

    //来源于UITextFieldDelegate协议
    func textFieldShouldReturn(textField:UITextField) ->Bool
    {
        if (textField == planName) {
            planName.resignFirstResponder()
            return true;
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
                if (planName.text!.isEmpty)//是空
                {
                    navTitle.text = ""
                }
                else
                {
                    navTitle.text = planName.text
                }
        planName.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        //写一个键盘升起的图片
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
