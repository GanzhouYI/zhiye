import UIKit
import Alamofire
class SearchTableDataViewCell:UITableViewCell,UITextViewDelegate
{
    let biaoqian = "fanbiaoqian1"
    //var planTableTTidRow:Int!
    var NOCell:Int!
    var NOLabel:UILabel!
    var addFriend:UIButton!
    
    var usernameLabel:UILabel!
    var emailLabel:UILabel!
    var phoneLabel:UILabel!
    var genderLabel:UILabel!
    var introTextView:UITextView!
    
    var msgItem:SearchItem!//总体信息对象
    
    init(frame:CGRect,NOCell:Int,data:SearchItem, reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.alpha = 0
        self.frame = frame
        self.backgroundColor = NOCell%2==0 ? UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 0.5) : UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 0.5)
        
        self.NOCell = NOCell
        self.msgItem = SearchItem()
        self.msgItem = data

        NOLabel = UILabel(frame: CGRectMake(5,2,30,40))
        NOLabel.text = String(NOCell)
        NOLabel.textColor = UIColor.grayColor()
        
        addFriend = UIButton(frame: CGRectMake(self.frame.width-100,10,80,30))
        addFriend.alpha = 0.5
        addFriend.layer.borderColor = UIColor.whiteColor().CGColor
        addFriend.layer.borderWidth = 2
        addFriend.layer.cornerRadius = 10
        addFriend.addTarget(self, action: "AddFriend", forControlEvents: UIControlEvents.TouchUpInside)
        if(msgItem.status == 0)
        {
            addFriend.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
            addFriend.setTitle("关注", forState: UIControlState.Normal)
        }
        else if(msgItem.status == 1)
        {
            addFriend.backgroundColor = UIColor.grayColor()
            addFriend.setTitle("取消关注", forState: UIControlState.Normal)
        }
        usernameLabel=UILabel(frame: CGRectMake(30,35,self.frame.width/2,40))
        usernameLabel.text = "用户名:" + msgItem.username
        
        genderLabel=UILabel(frame: CGRectMake(self.frame.width/2+40,35,60,40))
        genderLabel.text = "性别:" + msgItem.gender
        
        emailLabel=UILabel(frame: CGRectMake(30,75,self.frame.width/2,40))
        emailLabel.text = "邮箱:" + msgItem.email
        
        phoneLabel=UILabel(frame: CGRectMake(30,115,self.frame.width/2,40))
        phoneLabel.text = "手机号:" + msgItem.phone
        
        
        introTextView=UITextView(frame: CGRectMake(30,160,self.frame.width-60,40))
        introTextView.text = msgItem.intro
        introTextView.backgroundColor = UIColor.brownColor()
        introTextView.font = UIFont.systemFontOfSize(15)
        introTextView.textColor = UIColor.grayColor()
        introTextView.backgroundColor = UIColor.clearColor()
        introTextView.textAlignment = NSTextAlignment.Center
        introTextView.editable=false
        introTextView.selectable = false //防止复制

        self.addSubview(NOLabel)
        self.addSubview(addFriend)
        self.addSubview(usernameLabel)
        self.addSubview(emailLabel)
        self.addSubview(phoneLabel)
        self.addSubview(genderLabel)
        self.addSubview(introTextView)
    }
    
    func AddFriend() {
        if(msgItem.status == 0)
        {
            msgItem.status = 1
            addFriend.backgroundColor = UIColor.grayColor()
            addFriend.setTitle("取消关注", forState: UIControlState.Normal)
            MySQL.shareMySQL().addFriend(String(LoginModel.sharedLoginModel()!.MyUid!), fuid: String(msgItem.uid))
        }
        else if(msgItem.status == 1)
        {
            msgItem.status = 0
            addFriend.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
            addFriend.setTitle("关注", forState: UIControlState.Normal)
            MySQL.shareMySQL().deleteFriend(String(LoginModel.sharedLoginModel()!.MyUid!), fuid: String(msgItem.uid))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
