import UIKit
import Alamofire
class FirstTableDetailController: UIViewController {
    
    var navBcakGround:UIImageView!
    var backButton:UIButton!
    var navTitle:UILabel!
    var DetailTextView:UITextView!
    var Detail_ScrollView:FirstTableDetail_ScorllView!
    var bubbleSection:FirstTableMessageItem!
    var FirstTableImageUrl:String!
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor=UIColor.whiteColor()
        GetFirstTableImage()
        
        navTitle=UILabel(frame: CGRectMake(80,20,self.view.frame.width-80-80,40))
        navTitle.text=bubbleSection.FirstTableTitle
        navTitle.textAlignment=NSTextAlignment.Center
        
        backButton = UIButton(frame: CGRectMake(10,20,60,40))
        backButton.setTitle("返回", forState: UIControlState.Normal)
        backButton.backgroundColor=UIColor.grayColor()
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        
        navBcakGround=UIImageView()
        navBcakGround.frame=CGRectMake(0, 20, self.view.frame.width, 40)
        navBcakGround.backgroundColor=UIColor.grayColor()
        navBcakGround.image=UIImage(named: "")
        navBcakGround.contentMode=UIViewContentMode.ScaleToFill
        
        Detail_ScrollView=FirstTableDetail_ScorllView(frame:CGRectMake(0, 60, self.view.frame.width, 300),FirstTableImageUrl:self.FirstTableImageUrl)
        
        DetailTextView=UITextView(frame: CGRectMake(0, 360, self.view.frame.width, 100))
        DetailTextView.font = UIFont(name: "System", size: 100)
        DetailTextView.editable = false
        DetailTextView.selectable = false //防止复制
        DetailTextView.text=bubbleSection.FirstTableDetail
        DetailTextView.backgroundColor=UIColor.greenColor()
        
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
