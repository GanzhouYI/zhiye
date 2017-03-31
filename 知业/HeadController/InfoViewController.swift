import UIKit
import Alamofire
class InfoViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,diquPickerProtocol {
    
    var keyBoardHeight:CGFloat=300
    var HeightDiffer:CGFloat!
    var BG_ScrollView = UIScrollView()
    var BG_delegate = UIScrollViewDelegate?()
    var backgroundButton:UIButton!
    var tipAlert:UIAlertController!
    var bt_tou:UIButton!
    var la_name:UILabel!
    var tfName:UITextField!
    var la_name_tip:UILabel!
    var la_pwd:UILabel!
    var tfPs:UITextField!
    var la_surePwd:UILabel!
    var tfSurePS:UITextField!
    var la_pwd_tip:UILabel!
    var bt_diqu:UIButton!
    var diquData = ["","",""]
    var la_gender:UILabel!
    var segGender:UISegmentedControl!
    var Picker:diquPickerView!
    var gender = ["男","女"]
    
    var zhuceData=["username":"",
                   "pwd":"",
                   "email":"",
                   "phone":"",
                   "gender":"",
                   "intro":"",
                   "diqu":"",
                   "logo":""]
    
    var la_email:UILabel!
    var tf_email:UITextField!
    var la_phone:UILabel!
    var tf_phone:UITextField!
    var la_intro:UILabel!
    var tf_intro:UITextView!
    var logo:String!
    
    var userInfo:[String:String] = ["":""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        //userInfo = MySQL.shareMySQL().searchUserInfo()
        
        BG_ScrollView.frame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height-20)
        BG_ScrollView.contentSize = CGSizeMake(0,800)
        BG_ScrollView.pagingEnabled = true
        BG_ScrollView.bounces = false//弹簧效果
        BG_ScrollView.showsHorizontalScrollIndicator = false//水平导航条
        BG_ScrollView.delegate = self
        BG_ScrollView.backgroundColor = UIColor(red: 112/255, green: 128/255, blue: 144/255, alpha: 1)
        self.view.addSubview(BG_ScrollView)
        
        backgroundButton = UIButton(frame:self.view.frame)
        backgroundButton.addTarget(self,action:#selector(RegisterViewController.returnbackKeyboard),forControlEvents:UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(backgroundButton)
        
        let head = UIImageView(frame: CGRectMake(0,20,self.view.frame.width,40))
        head.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 112/255, alpha: 1)
        self.view.addSubview(head)
        
        let back=UIButton(frame: CGRectMake(20,25,50,30))
        back.setTitle("取消", forState: UIControlState.Normal)
        back.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        back.addTarget(self, action: #selector(RegisterViewController.backToLogin)
            , forControlEvents: UIControlEvents.TouchUpInside)
        self.view.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(back)
        
        let submit=UIButton(frame: CGRectMake(self.view.frame.width-20-50,25,50,30))
        submit.setTitle("完成", forState: UIControlState.Normal)
        submit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submit.addTarget(self, action: #selector(RegisterViewController.submit)
            , forControlEvents: UIControlEvents.TouchUpInside)
        self.view.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(submit)
        
        bt_tou = UIButton(frame: CGRectMake(self.view.frame.width/2-60, 40, 120,120))
        bt_tou.backgroundColor = UIColor.grayColor()
        bt_tou.layer.cornerRadius = 60
        bt_tou.layer.masksToBounds = true
        bt_tou.setBackgroundImage(UIImage(named: "衣洛特iOS图标/头像"), forState: UIControlState.Normal)
        bt_tou.contentMode=UIViewContentMode.Center
        bt_tou.addTarget(self, action: #selector(RegisterViewController.choseTouImage), forControlEvents: UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(bt_tou)
        
        la_name = UILabel(frame: CGRectMake(20,170,80,40))
        la_name.textAlignment = NSTextAlignment.Center
        la_name.font = UIFont(name: "Zapfino", size: 20)
        la_name.text = "昵  称："
        la_name.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_name)
        
        tfName = UITextField(frame: CGRectMake(100,170,self.view.frame.width-120,40))
        tfName.placeholder="输入用户名长度小于12个字符"//默认显示信息
        tfName.returnKeyType=UIReturnKeyType.Next//键盘点击确定发生什么
        tfName.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tfName.backgroundColor = UIColor.whiteColor()
        tfName.delegate=self
        BG_ScrollView.addSubview(tfName)
        
        la_name_tip = UILabel(frame: CGRectMake(20,210,self.view.frame.width-40,30))
        la_name_tip.textAlignment = NSTextAlignment.Center
        la_name_tip.font = UIFont(name: "Zapfino", size: 14)
        la_name_tip.text = ""
        //la_name_tip.backgroundColor = UIColor.whiteColor()
        BG_ScrollView.addSubview(la_name_tip)
        
        la_pwd = UILabel(frame: CGRectMake(20,240,80,40))
        la_pwd.textAlignment = NSTextAlignment.Center
        la_pwd.font = UIFont(name: "Zapfino", size: 20)
        la_pwd.text = "密  码："
        la_pwd.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_pwd)
        
        tfPs = UITextField(frame: CGRectMake(100,240,self.view.frame.width-120,40))
        tfPs.placeholder="输入字母或数字组成的密码不小于6位"
        tfPs.returnKeyType=UIReturnKeyType.Done//键盘点击确定发生什么
        tfPs.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tfPs.backgroundColor = UIColor.whiteColor()
        tfPs.delegate=self
        BG_ScrollView.addSubview(tfPs)
        
        la_surePwd = UILabel(frame: CGRectMake(20,285,80,40))
        la_surePwd.textAlignment = NSTextAlignment.Center
        la_surePwd.font = UIFont(name: "Zapfino", size: 15)
        la_surePwd.text = "确认密码："
        la_surePwd.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_surePwd)
        
        tfSurePS = UITextField(frame: CGRectMake(100,285,self.view.frame.width-120,40))
        tfSurePS.placeholder="再次输入密码"
        tfSurePS.returnKeyType=UIReturnKeyType.Done//键盘点击确定发生什么
        tfSurePS.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tfSurePS.backgroundColor = UIColor.whiteColor()
        tfSurePS.delegate=self
        BG_ScrollView.addSubview(tfSurePS)
        
        la_pwd_tip = UILabel(frame: CGRectMake(20,325,self.view.frame.width-40,30))
        la_pwd_tip.textAlignment = NSTextAlignment.Center
        la_pwd_tip.font = UIFont(name: "Zapfino", size: 14)
        la_pwd_tip.text = ""
        //la_name_tip.backgroundColor = UIColor.whiteColor()
        BG_ScrollView.addSubview(la_pwd_tip)
        
        la_gender = UILabel(frame: CGRectMake(20,360,80,40))
        la_gender.textAlignment = NSTextAlignment.Center
        la_gender.font = UIFont(name: "Zapfino", size: 20)
        la_gender.text = "性  别："
        la_gender.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_gender)
        
        segGender = UISegmentedControl(items: gender)
        segGender.frame = CGRectMake(100,360,self.view.frame.width-120,40)
        segGender.addTarget(self, action: #selector(RegisterViewController.choseGender(_:)), forControlEvents: UIControlEvents.ValueChanged)
        segGender.selectedSegmentIndex = 0
        segGender.tintColor=UIColor.whiteColor()
        BG_ScrollView.addSubview(segGender)
        
        
        bt_diqu = UIButton(frame: CGRectMake(20,420,self.view.frame.width-40,40))
        bt_diqu.backgroundColor = UIColor(red: 255/255, green: 211/255, blue: 155/255, alpha: 1)
        bt_diqu.setTitle("点击选择地区", forState: UIControlState.Normal)
        bt_diqu.titleLabel?.textAlignment = NSTextAlignment.Center
        bt_diqu.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        bt_diqu.titleLabel?.font = UIFont(name: "Zapfino", size: 20)
        bt_diqu.addTarget(self, action: #selector(RegisterViewController.choseDiqu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(bt_diqu)
        
        la_email = UILabel(frame: CGRectMake(20,480,80,40))
        la_email.textAlignment = NSTextAlignment.Center
        la_email.font = UIFont(name: "Zapfino", size: 20)
        la_email.text = "邮  箱："
        la_email.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_email)
        
        tf_email = UITextField(frame: CGRectMake(100,480,self.view.frame.width-120,40))
        tf_email.placeholder="请输入邮箱"
        tf_email.returnKeyType=UIReturnKeyType.Done//键盘点击确定发生什么
        tf_email.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tf_email.backgroundColor = UIColor.whiteColor()
        tf_email.delegate=self
        BG_ScrollView.addSubview(tf_email)
        
        la_phone = UILabel(frame: CGRectMake(20,520,80,40))
        la_phone.textAlignment = NSTextAlignment.Center
        la_phone.font = UIFont(name: "Zapfino", size: 20)
        la_phone.text = "手  机："
        la_phone.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_phone)
        
        tf_phone = UITextField(frame: CGRectMake(100,520,self.view.frame.width-120,40))
        tf_phone.placeholder="请输入手机号"
        tf_phone.returnKeyType=UIReturnKeyType.Done//键盘点击确定发生什么
        tf_phone.clearButtonMode=UITextFieldViewMode.WhileEditing//当键盘编辑完时出现 X 可以直接删除全部
        tf_phone.backgroundColor = UIColor.whiteColor()
        tf_phone.delegate=self
        BG_ScrollView.addSubview(tf_phone)
        
        la_intro = UILabel(frame: CGRectMake(20,600,self.view.frame.width-40,40))
        la_intro.textAlignment = NSTextAlignment.Center
        la_intro.font = UIFont(name: "Zapfino", size: 17)
        la_intro.text = "个性签名"
        la_intro.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        BG_ScrollView.addSubview(la_intro)
        
        tf_intro = UITextView(frame: CGRectMake(20,640,self.view.frame.width-40,100))
        tf_intro.delegate = self
        tf_intro.font = UIFont(name: "System", size: 40)
        tf_intro.returnKeyType=UIReturnKeyType.Done//键盘点击确定发生什么
        tf_intro.backgroundColor = UIColor.whiteColor()
        BG_ScrollView.addSubview(tf_intro)
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        let keyboardDuring = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]
        
        print("键盘弹起")
        keyBoardHeight=keyboardheight
        
        print(keyboardheight)
        print(keyboardDuring)
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        print("键盘落下")
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        HeightDiffer = self.view.frame.height-20-textField.frame.height-textField.frame.origin.y-keyBoardHeight
        //遮挡了
        if HeightDiffer<0
        {
            BG_ScrollView.frame.origin.y += HeightDiffer
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if HeightDiffer<0
        {
            BG_ScrollView.frame.origin.y -= HeightDiffer
        }
        
        nameConfirm()//验证昵称是否符合
        pwdConfirm()//验证密码是否符合
    }
    
    func nameConfirm()->String
    {
        if((tfName.text) != "")
        {
            if tfName.text?.characters.count<=12
            {
            RegisterModel.sharedRegisterModel()?.registerName(zhuceData
                , block: { (dataInfo) in
                    if(dataInfo == "昵称已存在")
                    {
                        self.la_name_tip.text = "昵称已存在"
                        self.la_name_tip.textColor=UIColor.yellowColor()
                    }
                    else if(dataInfo == "昵称可用")
                    {
                        self.la_name_tip.text = "昵称可用"
                        self.la_name_tip.textColor=UIColor.greenColor()
                        self.returnbackKeyboard()
                    }
                    else if(dataInfo == "网络连接错误")
                    {
                        print("网络连接错误")
                        self.la_name_tip.text = "网络连接错误"
                        self.la_name_tip.textColor=UIColor.greenColor()
                    }
            })
                return "昵称格式正确"
            }
            else
            {
                return "昵称大于12个字符!"
            }
        }
        else
        {
            la_name_tip.text = "用户名长度小于12个字符"
            self.la_name_tip.textColor=UIColor.blackColor()
            return "还未输入昵称！"
        }
        
    }
    
    func pwdConfirm()->String//
    {
        if(tfPs.text == "")
        {
            print("还没开始输入")
            la_pwd_tip.text = ""
            return "还未输入密码"
        }
        else if(self.tfPs.text!.characters.count<6)
        {
            la_pwd_tip.text = "密码长度小于6个字符！"
            la_pwd_tip.textColor = UIColor.yellowColor()
            return "密码长度小于6个字符"
        }
        else if(self.tfPs.text!.characters.count>=15)
        {
            la_pwd_tip.text = "密码长度大于15个字符！"
            la_pwd_tip.textColor = UIColor.yellowColor()
            return "密码长度大于15个字符！"
        }
        else if(tfSurePS.text?.isEmpty == false)
        {
            if(tfPs.text != tfSurePS.text)
            {
                la_pwd_tip.text = "两次输入的密码不一致！"
                la_pwd_tip.textColor = UIColor.yellowColor()
                return "两次输入的密码不一致！"
            }
            else
            {
                la_pwd_tip.text = "记性不错，保存好密码哦！"
                la_pwd_tip.textColor = UIColor.greenColor()
                return "密码格式正确"
            }
        }
        else// tfSurePS为空
        {
            la_pwd_tip.text = "输入确认密码操作！"
            la_pwd_tip.textColor = UIColor.yellowColor()
            return "输入确认密码操作！"
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        HeightDiffer = self.view.frame.height-20-40-textView.frame.height-textView.frame.origin.y-keyBoardHeight
        //遮挡了
        if HeightDiffer<0
        {
            BG_ScrollView.frame.size = CGSize(width: BG_ScrollView.frame.width,height: BG_ScrollView.frame.height+keyBoardHeight)
            BG_ScrollView.frame.origin.y += HeightDiffer
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if HeightDiffer<0
        {
            BG_ScrollView.frame.size = CGSize(width: BG_ScrollView.frame.width,height: BG_ScrollView.frame.height-keyBoardHeight)
            BG_ScrollView.frame.origin.y -= HeightDiffer
        }
    }
    
    func submit()
    {
        zhuceData["username"]=tfName.text
        zhuceData["pwd"]=tfPs.text
        zhuceData["gender"]=gender[segGender.selectedSegmentIndex]
        zhuceData["email"]=tf_email.text
        zhuceData["phone"]=tf_phone.text
        zhuceData["intro"]=tf_intro.text
        zhuceData["diqu"]={
            var diqu:String = ""
            diqu += diquData[0]
            diqu += "-"
            diqu += diquData[1]
            diqu += "-"
            diqu += diquData[2]
            return diqu
            }()
                zhuceData["logo"]=""
        let pwdTip = pwdConfirm()
        let nameTip = nameConfirm()
        if nameTip != "昵称格式正确"
        {
            self.tipAlert = UIAlertController(title: "昵称格式错误", message: nameTip, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: .Default,handler: nil)
            self.tipAlert.addAction(okAction)
            self.presentViewController(self.tipAlert, animated: true, completion: nil)
        }
        else if pwdTip != "密码格式正确"
        {
            self.tipAlert = UIAlertController(title: "密码格式错误", message: pwdTip, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: .Default,handler: {action in
                self.la_pwd_tip.text = pwdTip
                self.la_pwd_tip.textColor = UIColor.yellowColor()
            })
            self.tipAlert.addAction(okAction)
            self.presentViewController(self.tipAlert, animated: true, completion: nil)
        }
        else//向服务器注册
        {
            
        RegisterModel.sharedRegisterModel()?.conNet(zhuceData, block: { (dataInfo) in
            if dataInfo == "昵称已存在"
            {
                print("昵称已存在")
                self.tipAlert = UIAlertController(title: "昵称已存在", message: "昵称被抢了，换个更帅的名称吧！", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default,handler: {action in
                    self.la_name_tip.text = "昵称已存在"
                    self.la_name_tip.textColor=UIColor.yellowColor()
                })
                self.tipAlert.addAction(okAction)
                self.presentViewController(self.tipAlert, animated: true, completion: nil)
            }
            else if dataInfo == "注册失败"
            {
                print("注册失败")
                self.tipAlert = UIAlertController(title: "注册失败", message: "抱歉，zhiye正在维护，或联系客服！", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default,handler: nil)
                self.tipAlert.addAction(okAction)
                self.presentViewController(self.tipAlert, animated: true, completion: nil)

            }
            else if dataInfo == "注册成功"
            {
                print("注册成功")
                self.tipAlert = UIAlertController(title: "注册成功", message: "进入zhiye体验一番吧！", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default,handler: {action in
                self.dismissViewControllerAnimated(true, completion: nil)
                })
                self.tipAlert.addAction(okAction)
                self.presentViewController(self.tipAlert, animated: true, completion: nil)

            }
            else if dataInfo == "网络连接错误"
            {
                print("网络连接错误")
                self.tipAlert = UIAlertController(title: "网络连接错误", message: "检查下网络连接吧！", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default,handler: nil)
                self.tipAlert.addAction(okAction)
                self.presentViewController(self.tipAlert, animated: true, completion: nil)

            }
        })
        }
    }
    
    func choseGender(seg:UISegmentedControl)
    {
        if seg.selectedSegmentIndex==0
        {
            seg.tintColor = UIColor(red: 0/255, green: 229/255, blue: 238/255, alpha: 1)
        }
        else
        {
            seg.tintColor = UIColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
        }
    }
    
    func choseDiqu(bt_diqu:UIButton)
    {
        
        Picker = diquPickerView(frame: self.view.frame)
        Picker.delegate=self
        self.view.addSubview(Picker)
        
    }
    
    
    func Diqudata(data:[String])
    {
        diquData=data
        let title = data[0]+"-"+data[1]+"-"+data[2]
        bt_diqu.setTitle(title, forState: UIControlState.Normal)
    }
    
    
    func returnbackKeyboard()
    {
        tfName.resignFirstResponder()
        tfPs.resignFirstResponder()
        tfSurePS.resignFirstResponder()
        tf_intro.resignFirstResponder()
        tf_phone.resignFirstResponder()
        tf_email.resignFirstResponder()
    }
    
    func choseTouImage()
    {
        
    }
    
    func backToLogin()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
