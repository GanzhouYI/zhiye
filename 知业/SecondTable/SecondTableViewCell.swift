import UIKit

class SecondTableViewCell:UITableViewCell
{
    var Pic:UIButton!
    var biaoqian1:UIButton!
    var Detail:UIButton!
    var biaoqian2:UIButton!
    var msgItem:SecondTableMessageItem!//总体信息对象
    //- (void) setupInternalData
    init(frame:CGRect,data:SecondTableMessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.frame = frame
        rebuildUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebuildUserInterface()
    {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.Pic = UIButton()
        self.Pic.setBackgroundImage(self.msgItem.Pic, forState: UIControlState.Normal)
        
        self.biaoqian1 = UIButton()
        self.biaoqian1.setBackgroundImage(self.msgItem.biaoqian1, forState: UIControlState.Normal)
        
        self.Detail = UIButton()
        self.Detail.setTitle(self.msgItem.Detail, forState: UIControlState.Normal)
        
        self.biaoqian2 = UIButton()
        self.biaoqian2.setBackgroundImage(self.msgItem.biaoqian2, forState: UIControlState.Normal)
        
        if self.msgItem.Num! % 2 != 0//奇数
        {

            self.Pic.frame = CGRectMake(0, 0, self.frame.width/2, self.frame.height)
            self.Pic.backgroundColor = UIColor.blackColor()
            
            self.biaoqian1.frame = CGRectMake(self.frame.width/2, self.frame.height*1/8, self.frame.width/2*2/3, self.frame.height*1/8)
            
            self.Detail.frame = CGRectMake(self.frame.width/2+5, self.frame.height*2/8+self.frame.height/9, self.frame.width/2-10, self.frame.height*8/25)
            self.Detail.backgroundColor = UIColor.whiteColor()
            
            self.biaoqian2.frame = CGRectMake(self.frame.width/2+5, self.frame.height*2/8+self.frame.height*2/9+self.frame.height*8/25, self.frame.width/4, self.frame.height*1/8)
            self.biaoqian2.backgroundColor = UIColor.purpleColor()
        }
        else
        {
            self.Pic.frame = CGRectMake(self.frame.width/2, 0, self.frame.width/2, self.frame.height)
            self.Pic.backgroundColor = UIColor.blackColor()
            
            self.biaoqian1.frame = CGRectMake(self.frame.width/2-self.frame.width/2*2/3, self.frame.height*1/8, self.frame.width/2*2/3, self.frame.height*1/8)
            
            self.Detail.frame = CGRectMake(5, self.frame.height*2/8+self.frame.height/9, self.frame.width/2-10, self.frame.height*8/25)
            self.Detail.backgroundColor = UIColor.whiteColor()
            
            self.biaoqian2.frame = CGRectMake(self.frame.width/2-5-self.frame.width/4, self.frame.height*2/8+self.frame.height*2/9+self.frame.height*8/25, self.frame.width/4, self.frame.height*1/8)
            self.biaoqian2.backgroundColor = UIColor.purpleColor()

        }
        self.addSubview(self.Pic)
        self.addSubview(self.biaoqian1)
        self.addSubview(self.Detail)
        self.addSubview(self.biaoqian2)
        
    }
}
