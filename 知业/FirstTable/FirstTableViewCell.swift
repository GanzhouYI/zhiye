import UIKit
import Alamofire
class FirstTableViewCell:UITableViewCell
{
    let biaoqian = "fanbiaoqian1"
    var FirstTableImageUrl:String!
    var FirstTableImage:UIButton?
    var FirstTablebiaoqian:UIButton?
    var FirstTableTitle:UILabel?
    var FirstTableDetail:UITextView?
    var FirstTable_yanjin_Image:UIButton?
    var FirstTable_yanjin_Num:UILabel?
    var FirstTable_pinglun_Image:UIButton?
    var FirstTable_pinglun_Num:UILabel?
    
    var msgItem:FirstTableMessageItem!//总体信息对象
    //- (void) setupInternalData
    init(frame:CGRect,data:FirstTableMessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor.whiteColor()
        self.frame = frame
        
        GetFirstTableImage()
        rebuildUserInterface()
        updateInfoDynamic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GetFirstTableImage(){
        
        let fileManager = NSFileManager.defaultManager()
        let dynamicDir = "/zhiye/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic/"
        let dynamicDirectory:String = NSHomeDirectory() + "/Documents"+dynamicDir
        FirstTableImageUrl=dynamicDirectory+self.msgItem.dynamic_id!+".jpg"
        if(!fileManager.fileExistsAtPath(FirstTableImageUrl))//如果zhiye/user不存在
        {
            FirstTableImageUrl=""
            downDynamicImage(self.msgItem.FirstTableImage!,dir:dynamicDir, fileName: self.msgItem.dynamic_id!,fileType: ".jpg")
        }

    }
    
    func downDynamicImage(url:String,dir:String,fileName:String,fileType:String){
        
            Alamofire.download(.GET, url) {
                wuyongdeURL,response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask)[0]
                let folder = directoryURL.URLByAppendingPathComponent(dir, isDirectory: true)
                //判断文件夹是否存在，不存在则创建
                let exist = fileManager.fileExistsAtPath(folder.path!)
                if !exist {
                    try! fileManager.createDirectoryAtURL(folder, withIntermediateDirectories: true,
                                                          attributes: nil)
                }
                let returnUrl = folder.URLByAppendingPathComponent(fileName+fileType)
                //下载完更新图片
                let dynamicDir = "/zhiye/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic/"
                let dynamicDirectory:String = NSHomeDirectory() + "/Documents"+dynamicDir
                self.FirstTableImageUrl=dynamicDirectory+self.msgItem.dynamic_id!+".jpg"
                self.FirstTableImage?.setBackgroundImage(UIImage(named: self.FirstTableImageUrl), forState: UIControlState.Normal)
                return returnUrl
            }
    }
    
    func updateInfoDynamic(){
        let urlString:String = "http://www.loveinbc.com/zhiye/searchDynamic_update.php"
            let parameters = ["dynamic_id": String(self.msgItem.dynamic_id!)]
            print("输出更新本地动态请求的dynamic_id")
            print(parameters)
            Alamofire.request(.POST, urlString, parameters: parameters)
                .responseJSON{ response in
                    print("数据")
                    switch response.result
                    {
                    case .Success:
                        print("searchDynamic_update  网络连接正常")
                        print(response.result.value!)
                        let str = (response.result.value!)as?String
                        
                        if(str == "动态不存在")
                        {
                            print("动态不存在")
                        }
                        else if let JSON = response.result.value as? NSArray
                        {
                            print("输出远端下更新的数据")
                            print(JSON)
                            print("输出远端上更新的数据")
                            self.FirstTableTitle?.text = JSON[7] as? String
                            self.FirstTableDetail?.text =  JSON[3] as? String
                            self.FirstTable_yanjin_Num!.text =  self.msgItem.NumType(JSON[4] as! String)
                            self.FirstTable_pinglun_Num!.text =  self.msgItem.NumType(JSON[5] as! String)
                        }
                        break
                    case .Failure:
                        print("网络连接错误")
                        break
                    }
            }
        
    }
    
    func rebuildUserInterface()
    {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.FirstTableImage = UIButton(frame:CGRectMake(5,40,110,90))
        self.FirstTableImage?.setBackgroundImage(UIImage(named: FirstTableImageUrl), forState: UIControlState.Normal)
        self.addSubview(self.FirstTableImage!)
        
        self.FirstTablebiaoqian = UIButton(frame: CGRectMake(0,5,self.frame.width-5,28))
        self.FirstTablebiaoqian?.setBackgroundImage(UIImage(named: biaoqian), forState: UIControlState.Normal)
        self.addSubview(self.FirstTablebiaoqian!)
        
        self.FirstTableTitle = UILabel(frame: CGRectMake(125,32,self.frame.width-125,25))
        self.FirstTableTitle!.adjustsFontSizeToFitWidth = false//如果标题文字超过了宽度自动调整字体大小适应，false不开启
        self.FirstTableTitle?.font = UIFont.systemFontOfSize(20)
        self.FirstTableTitle?.text = self.msgItem.FirstTableTitle
        self.FirstTableTitle?.textAlignment = NSTextAlignment.Left
        self.addSubview(self.FirstTableTitle!)
        
        self.FirstTableDetail = UITextView(frame: CGRectMake(140,57,self.frame.width-140,45))
        self.FirstTableDetail?.text = self.msgItem.FirstTableDetail
        self.FirstTableDetail?.font = UIFont.systemFontOfSize(15)
        self.FirstTableDetail?.textColor = UIColor.grayColor()
        self.FirstTableDetail!.editable=false
        self.FirstTableDetail!.userInteractionEnabled=false
        self.addSubview(self.FirstTableDetail!)

        self.FirstTable_yanjin_Image = UIButton(frame: CGRectMake(245,106, 25,13))
        self.FirstTable_yanjin_Image?.setBackgroundImage(UIImage(named: "衣洛特iOS图标/主页FirstTable/主页眼镜1"), forState: UIControlState.Normal)
        self.addSubview(FirstTable_yanjin_Image!)
        
        self.FirstTable_yanjin_Num = UILabel(frame: CGRectMake(285 ,106, 50, 13))
        self.FirstTable_yanjin_Num!.text = String(self.msgItem.FirstTable_yanjin_Num)
        self.FirstTable_yanjin_Num?.textAlignment = NSTextAlignment.Center
        self.FirstTable_yanjin_Num!.font = UIFont.systemFontOfSize(15)
        self.FirstTable_yanjin_Num?.textColor = UIColor.grayColor()
        self.addSubview(FirstTable_yanjin_Num!)
        
        self.FirstTable_pinglun_Image = UIButton(frame: CGRectMake(335,106,25,13))
        self.FirstTable_pinglun_Image?.setBackgroundImage(UIImage(named: "衣洛特iOS图标/主页FirstTable/主页评论数量"), forState: UIControlState.Normal)
        self.addSubview(FirstTable_pinglun_Image!)
        
        self.FirstTable_pinglun_Num = UILabel(frame: CGRectMake(360,106,self.frame.width-360,13))
        self.FirstTable_pinglun_Num?.textAlignment = NSTextAlignment.Center
        self.FirstTable_pinglun_Num!.text = String(self.msgItem.FirstTable_pinglun_Num)
        self.FirstTable_pinglun_Num?.textColor = UIColor.grayColor()
        self.FirstTable_pinglun_Num!.font = UIFont.systemFontOfSize(15)
        self.addSubview(FirstTable_pinglun_Num!)
        
    }
}
