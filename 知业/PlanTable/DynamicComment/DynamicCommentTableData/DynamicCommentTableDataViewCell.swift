import UIKit
import Alamofire
class CommentTableDataViewCell:UITableViewCell,UITextViewDelegate,Dynamic_Name_Delegate
{
    let biaoqian = "fanbiaoqian1"
    //楼层
    var NOCell:Int!
    var NOLabel:UILabel!
    //正在评论楼层里的第几行
    var CRow:Int = 0
    var CTuid:String = ""
    
    var cnameButton:[UIButton]=[]
    var commentTextView:[UITextView]=[]
    var comment_timeLabel:[UILabel]=[]
    var commentButton:[UIButton]=[]
    
    var msgItem:Array<DynamicCommentItem>!//总体信息对象
    weak var showCommentDelegate:Comment_Selected_Delegate?
    init(frame:CGRect,NOCell:Int,data:Array<DynamicCommentItem>, reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.alpha = 0
        self.frame = frame
        self.backgroundColor = NOCell%2==0 ? UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 0.5) : UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 0.5)
        
        self.NOCell = NOCell
        NOLabel = UILabel(frame: CGRectMake(5,5,40,20))
        NOLabel.text = String(NOCell) + "楼"
        NOLabel.font = UIFont.systemFontOfSize(15)
        NOLabel.textColor = UIColor.grayColor()
        self.addSubview(NOLabel)
        
        self.msgItem = Array<DynamicCommentItem>()
        self.msgItem = data
        for i in 0..<data.count
        {
            self.msgItem[i].nameDelegate = self
        }

        //NOLabel = UILabel(frame: CGRectMake(5,2,30,40))
        //NOLabel.text = String(NOCell)
       // NOLabel.textColor = UIColor.grayColor()
        
        var cnameButtonItem = UIButton(frame: CGRectMake(25,5,100,30))
        cnameButtonItem.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cnameButtonItem.setTitle(self.msgItem[0].cname, forState: UIControlState.Normal)
        cnameButtonItem.titleLabel?.textAlignment = NSTextAlignment.Left
        cnameButtonItem.addTarget(self, action: "FindCname", forControlEvents: UIControlEvents.TouchUpInside)
        cnameButton.append(cnameButtonItem)
        
        var commentTextViewItem = UITextView(frame: CGRectMake(60,35,self.frame.width-120,80))
        commentTextViewItem.text = self.msgItem[0].comment
        commentTextViewItem.font = UIFont.systemFontOfSize(15)
        commentTextViewItem.backgroundColor = UIColor.clearColor()
        commentTextViewItem.textColor = UIColor.blackColor()
        commentTextViewItem.textAlignment = NSTextAlignment.Left
        commentTextViewItem.editable=false
        commentTextViewItem.selectable = false //防止复制
        commentTextView.append(commentTextViewItem)
        
        //   comment_timeLabel = Array<UILabel>()
        var comment_timeLabelItem = UILabel(frame: CGRectMake(self.frame.width/2 - 75,115,200,15))
        comment_timeLabelItem.text = self.msgItem[0].comment_time
        comment_timeLabelItem.textColor = UIColor.grayColor()
        comment_timeLabel.append(comment_timeLabelItem)
        
        
        var commentButtonItem = UIButton(frame: CGRectMake(self.frame.width/2 + 110,115,60,15))
        commentButtonItem.setTitle("评论", forState: UIControlState.Normal)
        commentButtonItem.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        commentButtonItem.addTarget(self, action: "Comment:", forControlEvents: UIControlEvents.TouchUpInside)
        commentButton.append(commentButtonItem)
        
        //self.addSubview(NOLabel)
        self.addSubview(cnameButtonItem)
        self.addSubview(commentTextViewItem)
        self.addSubview(comment_timeLabelItem)
        self.addSubview(commentButtonItem)

        
        if(msgItem.count > 1)
        {
            for i in 1..<msgItem.count
            {
                var cnameButtonItem = UIButton(frame: CGRectMake(45,CGFloat((140)*i),100,30))
                cnameButtonItem.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                cnameButtonItem.setTitle(self.msgItem[i].cname, forState: UIControlState.Normal)
                cnameButtonItem.addTarget(self, action: "FindCname", forControlEvents: UIControlEvents.TouchUpInside)
                cnameButton.append(cnameButtonItem)
                
                var commentTextViewItem = UITextView(frame: CGRectMake(105,CGFloat(35+(140)*i),self.frame.width-165,80))
                commentTextViewItem.text = "(回复给:"+self.msgItem[i].ctname+")"+self.msgItem[i].comment
                commentTextViewItem.backgroundColor = UIColor.clearColor()
                commentTextViewItem.font = UIFont.systemFontOfSize(15)
                commentTextViewItem.textAlignment = NSTextAlignment.Left
                commentTextViewItem.editable=false
                commentTextViewItem.selectable = false //防止复制
                commentTextView.append(commentTextViewItem)
                
                //   comment_timeLabel = Array<UILabel>()
                var comment_timeLabelItem = UILabel(frame: CGRectMake(self.frame.width/2 - 75,CGFloat(115+(140)*i),200,15))
                comment_timeLabelItem.text = self.msgItem[i].comment_time
                comment_timeLabelItem.textColor = UIColor.grayColor()
                comment_timeLabel.append(comment_timeLabelItem)
                
                
                var commentButtonItem = UIButton(frame: CGRectMake(self.frame.width/2 + 110,CGFloat(115+(140)*i),60,15))
                commentButtonItem.setTitle("评论", forState: UIControlState.Normal)
                commentButtonItem.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                commentButtonItem.addTarget(self, action: "Comment:", forControlEvents: UIControlEvents.TouchUpInside)
                commentButton.append(commentButtonItem)
                
                //self.addSubview(NOLabel)
                //self.addSubview(ctnameLabel)
                self.addSubview(cnameButtonItem)
                self.addSubview(commentTextViewItem)
                self.addSubview(comment_timeLabelItem)
                self.addSubview(commentButtonItem)
            }
        }
    }
    
    //返回同floor下最大的Row
    func ReturnMaxRow() -> Int {
        var MaxRow:Int = 0
        for i in 0..<self.msgItem!.count
        {
            if(Int(self.msgItem[i].crow) >= MaxRow)
            {
                MaxRow = Int(self.msgItem[i].crow)!
            }
        }
        return MaxRow + 1
    }
    
    func Comment(button:UIButton) {
        
        //找到同层下最大的row
        
        for i in 0..<commentButton.count
        {
            if(button == commentButton[i])
            {
                self.showCommentDelegate?.Comment_TextViewShow(String(NOCell), CTuid: self.msgItem[i].ctuid,CRow: String(ReturnMaxRow()),CTname:self.msgItem[i].ctname)
            }
        }
        /*DynamicCommentNet.sharedDynamicComment()?.UpLoadDynamicComment(msgItem[0].dynamic_id,cuid:String(LoginModel.sharedLoginModel()!.returnMyUid()),cfloor:String(NOCell),ctuid:CTuid,comment:"",block: { (dataInfo) in
            if(dataInfo == "评论成功")
            {
            }
            else if(dataInfo == "评论失败")
            {
                
            }
            else
            {
            }
        })*/

    }
    
    func FindCname() {
    }
    
    func Dynamic_CName_Changed(crow:String,Cname:String)
    {
        cnameButton[Int(crow)!].setTitle(Cname, forState: UIControlState.Normal)
    }
    func Dynamic_CTName_Changed(crow:String,CTname:String)
    {
        var textChanged = "(回复给:"+CTname+")"+self.msgItem[Int(crow)!].comment
        commentTextView[Int(crow)!].text = textChanged
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
