import UIKit
import Alamofire
class FirstTableDetailController: UIViewController {
    
    var navBcakGround:UIImageView!
    var backButton:UIButton!
    var navTitle:UITextView!
    var DetailTextView:UITextView!
    var Detail_ScrollView:FirstTableDetail_ScorllView!
    var bubbleSection:FirstTableMessageItem!
    var FirstTableImageUrl:String!
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor=UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 1)
        GetFirstTableImage()
        
        navTitle=UITextView(frame: CGRectMake(60,20,self.view.frame.width-80-20,60))
        navTitle.backgroundColor=UIColor.clearColor()
        navTitle.font=UIFont.systemFontOfSize(22)
        navTitle.editable = false
        navTitle.text=bubbleSection.FirstTableTitle
        navTitle.textAlignment=NSTextAlignment.Center
        
        backButton = UIButton(frame: CGRectMake(5,20,60,40))
        backButton.setTitle("返回", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        
        navBcakGround=UIImageView()
        navBcakGround.frame=CGRectMake(0, 20, self.view.frame.width, 40)
        navBcakGround.backgroundColor=UIColor(red: 135/255, green: 206/255, blue: 255/255, alpha: 1)
        navBcakGround.image=UIImage(named: "")
        navBcakGround.contentMode=UIViewContentMode.ScaleToFill
        
        Detail_ScrollView=FirstTableDetail_ScorllView(frame:CGRectMake(0, 80, self.view.frame.width, 300),FirstTableImageUrl:self.FirstTableImageUrl)
        
        DetailTextView=UITextView(frame: CGRectMake(0, 380, self.view.frame.width, self.view.frame.height-370-70))
        DetailTextView.font=UIFont.systemFontOfSize(25)
        DetailTextView.editable = false
        DetailTextView.selectable = false //防止复制
        DetailTextView.text=bubbleSection.FirstTableDetail
        DetailTextView.backgroundColor=UIColor.clearColor()
        
        self.view.addSubview(navBcakGround)
        self.view.addSubview(backButton)
        self.view.addSubview(navTitle)
        self.view.addSubview(Detail_ScrollView)
        self.view.addSubview(DetailTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func GetFirstTableImage(){
        
        let fileManager = NSFileManager.defaultManager()
        let dynamicDir = "/zhiye/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic/"
        let dynamicDirectory:String = NSHomeDirectory() + "/Documents"+dynamicDir
        FirstTableImageUrl=dynamicDirectory+self.bubbleSection.dynamic_id!+".jpg"
//        if(!fileManager.fileExistsAtPath(FirstTableImageUrl))//如果zhiye/user不存在
//        {
//            FirstTableImageUrl=""
//            downDynamicImage(self.msgItem.FirstTableImage!,dir:dynamicDir, fileName: self.msgItem.dynamic_id!,fileType: ".jpg")
//        }
        
    }
    
    
    func back()
    {
        print("backback")
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
