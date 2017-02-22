import UIKit
import Alamofire
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    var imageBcakGround = UIImageView()
    
    var tfName:UITextField!
    var tfPs:UITextField!
    var backgroundButton:UIButton!
    
    var btSubmit:UIButton!
    var btlooklook:UIButton!
    var btRegist:UIButton!
    var btForgetPs:UIButton!
    
    var switch_Ps:UISwitch!//开关，控制密码明文暗文
    
    var imageView=UIImageView()//背景
    
    let 先看看 = UIImage(named: "先看看.png")
    let 背景 = UIImage(named: "yiroote.png")
    let 注册 = UIImage(named: "注册.png")
    override func loadView() {
        super.loadView()
        
        MyNotification.sharedMyNotification()!.scheduleNotification(12345)
        
        let viewBounds:CGRect = UIScreen.mainScreen().applicationFrame
        //上面是获取屏幕大小
        backgroundButton = UIButton(frame:viewBounds)
        
        imageBcakGround = UIImageView(frame: CGRectMake(5*宽比例, 0, 500*宽比例, 280*高比例))
        imageBcakGround.image = 背景
        
        tfName=UITextField(frame: CGRectMake(20*宽比例,200*高比例,280*宽比例,30*高比例))
        tfPs=UITextField(frame: CGRectMake(20*宽比例,250*高比例,280*宽比例,30*高比例))
        
        btSubmit=UIButton(frame: CGRectMake(self.view.frame.width/2-100*宽比例,高比例*300,宽比例*200,高比例*30))
        btRegist=UIButton(frame: CGRectMake(20*宽比例,self.view.frame.height-80*高比例,宽比例*80,高比例*60))
        btForgetPs=UIButton(frame: CGRectMake(self.view.frame.width/2-50*宽比例,高比例*350,宽比例*100,高比例*30))
        btlooklook=UIButton(frame: CGRectMake(self.view.frame.width-120*宽比例,self.view.frame.height-90*高比例,宽比例*100,高比例*70))
        
        switch_Ps = UISwitch()
        switch_Ps.frame.origin = CGPoint(x: 320*宽比例, y: 高比例*250)
        
        imageView.frame=self.view.frame
        imageView.image=UIImage(named: "4")
        imageView.contentMode=UIViewContentMode.ScaleToFill
        
        //imageView.autoresizingMask=UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        self.view.addSubview(imageBcakGround)
        self.view.addSubview(imageView)
        self.view.addSubview(backgroundButton)
        self.view.addSubview(tfName)
        self.view.addSubview(tfPs)
        self.view.addSubview(btSubmit)
        self.view.addSubview(btRegist)
        self.view.addSubview(btlooklook)
        self.view.addSubview(btForgetPs)
        self.view.addSubview(switch_Ps)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundButton.addTarget(self,action:Selector("returnbackKeyboard"),forControlEvents:UIControlEvents.TouchUpInside)
        MySQL.shareMySQL().searchAllDynamic()
        self.view.backgroundColor=UIColor.whiteColor()
        
        //提示保存的密码
        let user = NSUserDefaults.standardUserDefaults()//返回NSUserDefaults对象
        tfName.text=user.valueForKey("username")as? String
        tfPs.text=user.valueForKey("pwd") as? String
        
        tfName.placeholder="用户名/手机号/邮箱"//默认显示信息
        tfName.returnKeyType=UIReturnKeyType.Next//键盘点击确定发生什么
        tfName.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tfName.delegate=self
        
        
        tfPs.placeholder="请输入密码"
        tfPs.returnKeyType=UIReturnKeyType.Done//键盘点击确定发生什么
        tfPs.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tfPs.delegate=self
        
        btSubmit.setTitle("登录", forState: UIControlState.Normal)
        btSubmit.backgroundColor=UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5)
        //btSubmit.enabled=false//禁用
        btSubmit.addTarget(self, action: Selector("submit"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        btForgetPs.setTitle("忘记密码", forState: UIControlState.Normal)
        btForgetPs.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        btRegist.setBackgroundImage(注册, forState: UIControlState.Normal)
        btRegist.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btRegist.addTarget(self, action: Selector("regist:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        btlooklook.setBackgroundImage(先看看, forState: UIControlState.Normal)
        btlooklook.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btlooklook.addTarget(self, action: #selector(LoginViewController.looklook), forControlEvents: UIControlEvents.TouchUpInside)
        
        switch_Ps.addTarget(self, action: Selector("switchDidChange"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func returnbackKeyboard()
    {
        tfPs.resignFirstResponder()
        tfName.resignFirstResponder()
    }
    
    func regist(sender:UIButton)
    {
        let reg=RegisterViewController()
        self.presentViewController(reg, animated: true, completion: nil)
    }
    
    func switchDidChange()
    {
        if switch_Ps.on
        {
            tfPs.secureTextEntry=true
            switch_Ps.onTintColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5)
        }
        else
        {
            tfPs.secureTextEntry=false
        }
    }
    
    func submit()
    {
        if self.tfName.text?.characters.count == 0{
            MBProgressHUD.showDelayHUDToView(self.view, message: "没有用户名输入")
        }else if self.tfPs.text?.characters.count == 0{
            MBProgressHUD.showDelayHUDToView(self.view, message: "没有密码输入")
        }
        else
        {
        LoginModel.sharedLoginModel()!.conNet(self.view,username: self.tfName.text!,pwd: self.tfPs.text!,block:{(dataInfo) -> Void in
            if dataInfo == "用户名或密码错误"
            {
                print("login error")
                print(self.view.frame)
                MBProgressHUD.showDelayHUDToView(self.view,message:"用户名或密码错误")
            }
            else if dataInfo == "验证正确"
            {
                let nav = UINavigationController(rootViewController: MainViewController())
                self.presentViewController(nav, animated: true, completion: nil)
//                let Main=MainViewController()
//                self.presentViewController(Main, animated: true, completion: nil)
            }
            else if dataInfo == "网络连接错误"
            {
                print("登陆网络错误")
                MBProgressHUD.showDelayHUDToView(self.view, message: "网络连接错误")
            }
            })
        }
    }
    
    func looklook()
    {
        let nav = UINavigationController(rootViewController: MainViewController())
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    //来源于UITextFieldDelegate协议
    func textFieldShouldReturn(textField:UITextField) ->Bool
    {
        if (textField == tfName) {
            tfName.resignFirstResponder()
            return true;
        }else if (textField == tfPs) {
            tfPs.resignFirstResponder()
            return true;
        }
        return true
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        //        if tfName.text!.isEmpty || tfPs.text!.isEmpty//是空
        //        {
        //            btSubmit.enabled=false
        //        }
        //        else
        //        {
        //            btSubmit.enabled=true
        //        }
        textField.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        //写一个键盘升起的图片
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
