import Foundation
import UIKit
class setupView: UIView {
    
    var blackBackGround = UIButton()
    var setupkuang = UIButton()
    var cleanOtherUser = UIButton()
    var cleanCache = UIButton()
    
    var chatUs = UIButton()
    var chatTextView=UITextView()
    var contactUsMessage:String = ""
    var returnTip = UITextView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blackBackGround.backgroundColor = UIColor.blackColor()
        blackBackGround.alpha = 0.5
        blackBackGround.frame = CGRectMake(0, 20, self.frame.width, self.frame.height)
        self.addSubview(blackBackGround)
        
        setupkuang.frame = CGRectMake(100, self.frame.height, self.frame.width-200, 400)
        setupkuang.setBackgroundImage(UIImage(named: "设置中间背景.jpg"), forState: UIControlState.Normal)
        setupkuang.setBackgroundImage(UIImage(named: "设置中间背景.jpg"), forState: UIControlState.Highlighted)
        self.addSubview(setupkuang)
        
        cleanOtherUser.frame=CGRectMake(110, -50, self.frame.width-220, 30)
        cleanOtherUser.setTitle("清除其他用户", forState: UIControlState.Normal)
        cleanOtherUser.tintColor=UIColor.whiteColor()
        cleanOtherUser.addTarget(self, action: "CleanOtherUser", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(cleanOtherUser)
        
        cleanCache.frame=CGRectMake(110, 0, self.frame.width-220, 30)
        cleanCache.setTitle("清除缓存", forState: UIControlState.Normal)
        cleanCache.tintColor=UIColor.whiteColor()
        self.addSubview(cleanCache)
        
        chatTextView.frame=CGRectMake(110, self.frame.height+200-30-10-100, self.frame.width-220, 100)
        chatTextView.backgroundColor=UIColor.whiteColor()
        self.addSubview(chatTextView)
        
        chatUs.frame=CGRectMake(110, self.frame.height+200-30, self.frame.width-220, 30)
        chatUs.setTitle("联系我们", forState: UIControlState.Normal)
        chatUs.addTarget(self, action: "chat", forControlEvents: UIControlEvents.TouchUpInside)
        chatUs.tintColor=UIColor.whiteColor()
        self.addSubview(chatUs)

        returnTip.frame = CGRectMake(110, self.frame.height+200+60, self.frame.width-220, 60)
        returnTip.editable=false
        returnTip.textAlignment = NSTextAlignment.Center
        returnTip.font = UIFont.boldSystemFontOfSize(19)
        returnTip.backgroundColor = UIColor.clearColor()
        returnTip.selectable = false //防止复制
        self.addSubview(returnTip)
        
        UIView.animateWithDuration(1, // 动画时长
            delay:0 ,// 动画延迟z
            usingSpringWithDamping:1.0 ,// 类似弹簧振动效果 0~1
            initialSpringVelocity:1.0 ,// 初始速度
            options:UIViewAnimationOptions.CurveEaseIn, // 动画过渡效果
            animations: {()-> Void in
                self.setupkuang.frame = CGRectMake(100, 150, self.frame.width-200, self.frame.height-300)
                self.cleanOtherUser.frame=CGRectMake(110, 180, self.frame.width-220, 30)
                self.cleanCache.frame=CGRectMake(110, 230, self.frame.width-220, 30)
                self.chatTextView.frame=CGRectMake(110, 280, self.frame.width-220, 100)
                self.chatUs.frame=CGRectMake(110, 400, self.frame.width-220, 30)
                self.returnTip.frame=CGRectMake(110, 460, self.frame.width-220, 60)
            }, completion:{(Bool)-> Void in
                self.blackBackGround.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)})
        
    }
    
    func chat()
    {
        self.endEditing(true)
        if(self.returnTip.text == "网络错误，请检测网络" || (chatTextView.text != "" && contactUsMessage != chatTextView.text))
        {
            contactUsMessage = chatTextView.text
            contactUsNet.sharedcontactUsNet()?.contactUs(chatTextView.text, block: { (dataInfo) in
                if(dataInfo == "谢谢您的反馈")
                {
                    self.returnTip.text = "谢谢您的反馈,我们会做的更好"
                }
                else if(dataInfo == "出现故障,请联系QQ1025435307")
                {
                    self.returnTip.text = "出现故障,请联系QQ1025435307"
                }
                else
                {
                    self.returnTip.text = "网络错误，请检测网络"
                }
            })
        }
        else
        {
            //两次反馈的信息一样，不做处理
        }
    }
    
    func CleanOtherUser()
    {
        let username:String=NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        Clean.sharedLoginModel()?.cleanOtherUser(username)
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
                self.cleanOtherUser.frame=CGRectMake(self.frame.width/3+10, self.frame.height, self.frame.width/3-20, 30)
                self.chatTextView.frame=CGRectMake(self.frame.width/3+10, self.frame.height+50, self.frame.width/3-20, 30)
                self.cleanCache.frame=CGRectMake(self.frame.width/3+10, self.frame.height+50, self.frame.width/3-20, 30)
                self.chatUs.frame=CGRectMake(self.frame.width/3+10, -30, self.frame.width/3-20, 30)
                self.returnTip.frame=CGRectMake(self.frame.width/3+10, -30, self.frame.width/3-20, 60)
            }, completion: {(finnish)-> Void in
                self.blackBackGround.removeFromSuperview()
                self.setupkuang.removeFromSuperview()
                self.cleanOtherUser.removeFromSuperview()
                self.cleanCache.removeFromSuperview()
                self.chatUs.removeFromSuperview()
                self.removeFromSuperview()
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}

