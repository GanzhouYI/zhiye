import UIKit

class Message: UIViewController {
    
    let image_我的消息 = UIImage(named: "衣洛特iOS图标/我的消息界面/我的消息")
    let image_系统通知 = UIImage(named: "衣洛特iOS图标/我的消息界面/系统通知")
    let image_评论 = UIImage(named: "衣洛特iOS图标/我的消息界面/评论")
    let image_赞 = UIImage(named: "衣洛特iOS图标/我的消息界面/赞")
    let image_新加粉丝 = UIImage(named: "衣洛特iOS图标/我的消息界面/新加粉丝")
    let image_私信 = UIImage(named: "衣洛特iOS图标/我的消息界面/私信")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        var title = UIImageView(frame: CGRectMake(self.view.frame.width/2-90*宽比例,20+60*高比例,180*宽比例,60*高比例))
        title.image = image_我的消息
        self.view.addSubview(title)
        
        var bt_系统通知 = UIButton(frame: CGRectMake(40*宽比例,20+160*高比例,140*宽比例,60*高比例))
        //bt_系统通知.backgroundColor = UIColor.blackColor()
        bt_系统通知.setBackgroundImage(image_系统通知, forState: UIControlState.Normal)
        self.view.addSubview(bt_系统通知)
        
        
        var bt_评论 = UIButton(frame: CGRectMake(40*宽比例,20+260*高比例,110*宽比例,60*高比例))
        //bt_评论.backgroundColor = UIColor.blackColor()
        bt_评论.setBackgroundImage(image_评论, forState: UIControlState.Normal)
        self.view.addSubview(bt_评论)
        
        var bt_赞 = UIButton(frame: CGRectMake(40*宽比例,20+360*高比例,100*宽比例,60*高比例))
        //bt_赞.backgroundColor = UIColor.blackColor()
        bt_赞.setBackgroundImage(image_赞, forState: UIControlState.Normal)
        self.view.addSubview(bt_赞)
        
        var bt_新加粉丝 = UIButton(frame: CGRectMake(40*宽比例,20+460*高比例,170*宽比例,60*高比例))
       // bt_新加粉丝.backgroundColor = UIColor.blackColor()
        bt_新加粉丝.setBackgroundImage(image_新加粉丝, forState: UIControlState.Normal)
        self.view.addSubview(bt_新加粉丝)
        
        var bt_私信 = UIButton(frame: CGRectMake(40*宽比例,20+560*高比例,120*宽比例,60*高比例))
        //bt_私信.backgroundColor = UIColor.blackColor()
        bt_私信.setBackgroundImage(image_私信, forState: UIControlState.Normal)
        self.view.addSubview(bt_私信)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
