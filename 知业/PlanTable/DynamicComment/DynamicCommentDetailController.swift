import UIKit
import Alamofire
class DynamicCommentDetailController: UIViewController,UITextViewDelegate,Comment_Selected_Delegate {
    
    var dynamic_id:String = "-1"
    var dynamic_title:String = ""
    //正在评论楼层里的第几行
    var CFloor:String = ""
    var CTuid:String = ""
    var CTname:String = ""
    var CRow:String = ""
    
    var ctnameLabel:UILabel!
    var titleButton:UIButton!
    var tipButton:UIButton!
    var backButton:UIButton!
    var backgroundButton:UIButton!
    
    var keyBoardHeight:CGFloat!
    var commentTextView:UITextView!
    var submitButton:UIButton!
    var CommentTableView:DynamicCommentTableDataView!
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        backgroundButton = UIButton(frame:self.view.frame)
        backgroundButton.addTarget(self, action: "returnbackKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        backgroundButton.backgroundColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 0.5)
        
        backButton = UIButton(frame: CGRectMake(0,15,50,40))
        backButton.addTarget(self, action: "Func_Back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("返回", forState: UIControlState.Normal)
        
        titleButton = UIButton(frame: CGRectMake(50,15,self.view.frame.width-100,40))
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitle(dynamic_title, forState: UIControlState.Normal)
        titleButton.addTarget(self, action: "returnbackKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(backgroundButton)
        self.view.addSubview(backButton)
        self.view.addSubview(titleButton)
    }
    
    func Func_Back() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func Comment_TextViewShow(CFloor:String,CTuid:String,CRow:String,CTname:String)
    {
        self.CFloor = CFloor
        self.CTuid = CTuid
        self.CTname = CTname
        self.CRow = CRow
        self.ctnameLabel.text = "回复给"+CFloor+"楼："+CTname
        self.ctnameLabel.backgroundColor = UIColor.whiteColor()
        self.ctnameLabel.alpha = 0.8
        self.ctnameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.ctnameLabel.layer.borderWidth = 2
        self.ctnameLabel.layer.cornerRadius = 10
        self.commentTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        self.CommentTableView = DynamicCommentTableDataView(frame:CGRectMake(0
            , 70, self.view.frame.width, self.view.frame.height-120))
        self.CommentTableView.showCommentDelegate = self
        self.CommentTableView.dynamic_id = self.dynamic_id
        //创建一个重用的单元格
        self.CommentTableView!.registerClass(CommentTableDataViewCell.self, forCellReuseIdentifier: "MsgCell")
        CommentTableView.RefreshDynamicComment()
        self.view.addSubview(CommentTableView)
        
        ctnameLabel = UILabel(frame: CGRectMake(0,self.view.frame.height-50-30,200,30))
        ctnameLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(ctnameLabel)
        
        self.commentTextView = UITextView(frame: CGRectMake(0,self.view.frame.height-50,self.view.frame.width-50,50))
        commentTextView.delegate = self
        commentTextView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(commentTextView)
        
        self.submitButton = UIButton(frame: CGRectMake(self.view.frame.width-50,self.view.frame.height-50,50,50))
        submitButton.backgroundColor = UIColor.whiteColor()
        submitButton.setTitle("发送", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: "Submit", forControlEvents: UIControlEvents.TouchUpInside)
        submitButton.setTitleColor(UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1), forState: UIControlState.Normal)
        self.view.addSubview(submitButton)

    }
    
    func HiddenComment()
    {
        self.commentTextView.resignFirstResponder()
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        let keyboardDuring = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]
        
        print("键盘弹起")
        keyBoardHeight=keyboardheight
        
    
        self.commentTextView.frame = CGRectMake(0,self.view.frame.height-50-keyBoardHeight,self.view.frame.width-50,50)
        
        self.ctnameLabel.frame.origin = CGPoint(x: CGFloat(0),y: self.view.frame.height-50-30-keyBoardHeight)
        
        self.submitButton.frame = CGRectMake(self.view.frame.width-50,self.view.frame.height-50-keyBoardHeight,50,50)

        print(keyboardheight)
        print(keyboardDuring)
    }
    
    func keyboardWillDisappear(notification:NSNotification)
    {
        self.commentTextView.frame = CGRectMake(0,self.view.frame.height-50,self.view.frame.width-50,50)
        
        self.ctnameLabel.frame.origin = CGPoint(x: CGFloat(0),y: self.view.frame.height-50-30)
        
        self.submitButton.frame=CGRectMake(self.view.frame.width-50,self.view.frame.height-50,50,50)
    }

    
    func textViewDidBeginEditing(textView: UITextView) {
        if(commentTextView == textView)
        {
            
        }
    }
    
    func Submit() {
        if(commentTextView.text != "")
        {
            DynamicCommentNet.sharedDynamicComment()?.UpLoadDynamicComment(dynamic_id,cuid:String(LoginModel.sharedLoginModel()!.returnMyUid()),cfloor:CFloor,ctuid:CTuid,crow:CRow,comment:commentTextView.text,block: { (dataInfo) in
                if(dataInfo == "评论成功")
                {
                    self.ctnameLabel.text = "评论成功"
                    self.CommentTableView.RefreshDynamicComment()
                }
                else if(dataInfo == "评论失败")
                {
                    self.ctnameLabel.text = "网络不好，请重试"
                    self.CRow = String(Int(self.CRow)! + 1)
                }
                else
                {
                    self.ctnameLabel.text = "网络不好，请检测网络"
                }
            })
        }
    }
    
    func returnbackKeyboard()
    {
        self.commentTextView.endEditing(true)
    }
    
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
