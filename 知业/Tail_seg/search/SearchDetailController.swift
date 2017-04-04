import UIKit
import Alamofire
class SearchDetailController: UIViewController,UITextFieldDelegate,UITextViewDelegate,Search_Table_Data_Delegate {
    
    var bubbleSection = Array<SearchItem>()
    
    var tipLabel:UILabel!
    var backButton:UIButton!
    var submit:UIButton!
    var backgroundButton:UIButton!
    var planName:UITextField!
    
    var SearchTableView:SearchTableDataView!
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        backgroundButton = UIButton(frame:self.view.frame)
        backgroundButton.addTarget(self, action: "returnbackKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        backgroundButton.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        
        tipLabel = UILabel(frame: CGRectMake(self.view.frame.width/2-60,70,120,40))
        tipLabel.font = UIFont.boldSystemFontOfSize(20)
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.textColor = UIColor.yellowColor()
        
        planName = UITextField(frame: CGRectMake(55,15,self.view.frame.width-135,40))
        planName.backgroundColor = UIColor.whiteColor()
        planName.placeholder="输入查询的名字/邮箱/手机号"//默认显示信息
        planName.font = UIFont(name: "Arial", size: 15)
        planName.layer.borderColor = UIColor.whiteColor().CGColor
        planName.layer.borderWidth = 1
        planName.clearButtonMode=UITextFieldViewMode.WhileEditing
        planName.layer.cornerRadius = 5
        planName.textAlignment = NSTextAlignment.Center
        planName.returnKeyType=UIReturnKeyType.Search//键盘点击确定发生什么
        planName.delegate=self
        
        backButton = UIButton(frame: CGRectMake(0,15,50,40))
        backButton.addTarget(self, action: "Func_Back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("返回", forState: UIControlState.Normal)
        
        submit = UIButton(frame: CGRectMake(self.view.frame.width-60,15,50,40))
        submit.layer.borderColor = UIColor.whiteColor().CGColor
        submit.layer.borderWidth = 2
        submit.layer.cornerRadius = 10
        submit.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        submit.addTarget(self, action: "Func_Submit", forControlEvents: UIControlEvents.TouchUpInside)
        submit.setTitle("取消", forState: UIControlState.Normal)
        
        //为SearchTableDataView初始化数据
        //默认进去是第0个ttid和 ttidRow
        self.SearchTableView = SearchTableDataView(frame:CGRectMake(0
            , 70, self.view.frame.width, self.view.frame.height-70))
        
        //创建一个重用的单元格
        self.SearchTableView!.registerClass(SearchTableDataViewCell.self, forCellReuseIdentifier: "MsgCell")
        self.SearchTableView.didSelectDelegate = self
        self.SearchTableView.reloadData()
        
        self.view.addSubview(backgroundButton)
        self.view.addSubview(backButton)
        self.view.addSubview(SearchTableView)
        self.view.addSubview(tipLabel)
        self.view.addSubview(planName)
        self.view.addSubview(submit)

    }

    //隐藏状态栏
    override func prefersStatusBarHidden()->Bool{
        return true
    }
    
    func Func_Back() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func Func_Submit() {
        returnbackKeyboard()
        if(planName.text == "")
        {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else
        {
            SearchNet.sharedSearch()!.DownSearchPerson(planName.text!,block:{(dataInfo,data) -> Void in
                if dataInfo == "用户不存在"
                {
                    self.tipLabel.text = "用户不存在"
                }
                else if dataInfo == "用户存在"
                {
                    self.tipLabel.text = ""
                    self.SearchTableView.reloadData()
                }
                else if dataInfo == "网络错误"
                {
                    self.tipLabel.text = "网络错误"

                }
            })

        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField == planName)
        {
            self.tipLabel.text = ""
            self.submit.setTitle("完成", forState: UIControlState.Normal)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //键盘上的 Search 按键
        Func_Submit()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == planName)
        {
            if(planName.text == "")
            {
                self.submit.setTitle("取消", forState: UIControlState.Normal)
            }
            else
            {
                self.submit.setTitle("完成", forState: UIControlState.Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func returnbackKeyboard()
    {
        //这个方法好，隐藏所有键盘无论在哪个控件上
        self.view.endEditing(true)
    }
    
    /*Search_Table_Data_Delegate*/
    func Search_Table_Data_DidSelect(index: Int) {
        //print("输出",index)
        //let FirstTableDetailCotroller = PlanTableData()
        //FirstTableDetailCotroller.bubbleSection = bubbleSection
        //self.navigationController?.pushViewController(FirstTableDetailCotroller, animated: true)
    }

    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
