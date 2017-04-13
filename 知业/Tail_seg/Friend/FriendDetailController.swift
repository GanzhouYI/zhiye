import UIKit
import Alamofire
class FriendDetailController: UIViewController,UITextFieldDelegate,UITextViewDelegate,Friend_Table_Data_Delegate {
    
    var bubbleSection = Array<FriendItem>()
    
    var tipLabel:UILabel!
    var backButton:UIButton!
    var myFriend:UIButton!
    var friendMe:UIButton!
    var backgroundButton:UIButton!
    
    var FriendTableView:FriendTableDataView!
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        backgroundButton = UIButton(frame:self.view.frame)
        backgroundButton.addTarget(self, action: "returnbackKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        backgroundButton.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        
        backButton = UIButton(frame: CGRectMake(0,15,50,40))
        backButton.addTarget(self, action: "Func_Back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("返回", forState: UIControlState.Normal)
        
        myFriend = UIButton(frame: CGRectMake(self.view.frame.width/2-100,15,100,40))
        myFriend.backgroundColor = UIColor.grayColor()
        myFriend.layer.borderColor = UIColor.whiteColor().CGColor
        myFriend.layer.borderWidth = 2
        myFriend.layer.cornerRadius = 10
        myFriend.addTarget(self, action: "Func_MyFriend", forControlEvents: UIControlEvents.TouchUpInside)
        myFriend.setTitle("我关注的", forState: UIControlState.Normal)
        
        
        friendMe = UIButton(frame: CGRectMake(self.view.frame.width/2,15,100,40))
        friendMe.layer.borderColor = UIColor.whiteColor().CGColor
        friendMe.layer.borderWidth = 2
        friendMe.layer.cornerRadius = 10
        friendMe.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        friendMe.addTarget(self, action: "Func_FriendMe", forControlEvents: UIControlEvents.TouchUpInside)
        friendMe.setTitle("关注我的", forState: UIControlState.Normal)
        //为FriendTableDataView初始化数据
        //默认进去是第0个ttid和 ttidRow
        
        tipLabel = UILabel(frame: CGRectMake(self.view.frame.width/2-90,70,180,40))
        tipLabel.font = UIFont.boldSystemFontOfSize(20)
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.textColor = UIColor.yellowColor()
        
        self.FriendTableView = FriendTableDataView(frame:CGRectMake(0
            , 70, self.view.frame.width, self.view.frame.height-70))
        //创建一个重用的单元格
        self.FriendTableView!.registerClass(FriendTableDataViewCell.self, forCellReuseIdentifier: "MsgCell")
        self.FriendTableView.didSelectDelegate = self
        Func_MyFriend()
        
        self.view.addSubview(backgroundButton)
        self.view.addSubview(backButton)
        self.view.addSubview(FriendTableView)
        self.view.addSubview(friendMe)
        self.view.addSubview(myFriend)
        self.view.addSubview(tipLabel)


    }
    
    func Func_MyFriend() {
        myFriend.backgroundColor = UIColor.grayColor()
        friendMe.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        FriendNet.sharedFriend()!.SearchMyFriend({(dataInfo,data) -> Void in
            if dataInfo == "无好友"
            {
                self.tipLabel.text = "您还未关注好友"
            }
            else if dataInfo == "好友存在"
            {
                self.tipLabel.text = ""
                self.FriendTableView.ReloadFriend(true)
            }
            else if dataInfo == "网络错误"
            {
                self.tipLabel.text = "网络错误"
            }
        })

    }
    
    func Func_FriendMe() {
        myFriend.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        friendMe.backgroundColor = UIColor.grayColor()
        FriendNet.sharedFriend()!.SearchFriendMe({(dataInfo,data) -> Void in
            if dataInfo == "无好友"
            {
                self.tipLabel.text = "还未有人关注您"
            }
            else if dataInfo == "好友存在"
            {
                self.tipLabel.text = ""
                self.FriendTableView.ReloadFriend(false)
            }
            else if dataInfo == "网络错误"
            {
                self.tipLabel.text = "网络错误"
            }
        })

    }

    //隐藏状态栏
    override func prefersStatusBarHidden()->Bool{
        return true
    }
    
    func Func_Back() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func returnbackKeyboard()
    {
        //这个方法好，隐藏所有键盘无论在哪个控件上
        self.view.endEditing(true)
    }
    
    /*Friend_Table_Data_Delegate*/
    func Friend_Table_Data_DidSelect(index: Int) {
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
