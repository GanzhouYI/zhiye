import UIKit
import Alamofire
class PlanTableViewCell:UITableViewCell
{
    let biaoqian = "fanbiaoqian1"
    var TableImageUrl:String!
    //var TableImage:UIButton?
    var Tablebiaoqian:UIButton?
    var TableTitle:UILabel?
    var TableDetail:UITextView?
    var Table_yanjin_Image:UIButton?
    var Table_yanjin_Num:UILabel?
    var Table_pinglun_Image:UIButton?
    var Table_pinglun_Num:UILabel?
    
    var msgItem:PlanTableMessageItem!//总体信息对象
    //- (void) setupInternalData
    init(frame:CGRect,data:PlanTableMessageItem, reuseIdentifier cellId:String)
    {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor.whiteColor()
        self.frame = frame
        
        //GetFirstTableImage()
        rebuildUserInterface()
        updateInfoDynamic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GetFirstTableImage(){
        
        /*let fileManager = NSFileManager.defaultManager()
        let dynamicDir = "/zhiye/user/"+LoginModel.sharedLoginModel()!.returnMyName()+"/dynamic/"
        let dynamicDirectory:String = NSHomeDirectory() + "/Documents"+dynamicDir
        FirstTableImageUrl=dynamicDirectory+self.msgItem.dynamic_id!+".jpg"
        if(!fileManager.fileExistsAtPath(FirstTableImageUrl))//如果zhiye/user不存在
        {
            FirstTableImageUrl=""
            downDynamicImage(self.msgItem.FirstTableImage!,dir:dynamicDir, fileName: self.msgItem.dynamic_id!,fileType: ".jpg")
        }
*/
    }
    
    func downDynamicImage(url:String,dir:String,fileName:String,fileType:String){
        /*
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
                self.TableImageUrl=dynamicDirectory+self.msgItem.dynamic_id!+".jpg"
                self.TableImage?.setBackgroundImage(UIImage(named: self.TableImageUrl), forState: UIControlState.Normal)
                return returnUrl
            }*/
    }
    
    func updateInfoDynamic(){
       /* let urlString:String = "http://www.loveinbc.com/zhiye/searchDynamic_update.php"
            let parameters = ["dynamic_id": String(self.msgItem.dynamic_id!)]
            print("输出更新本地动态请求的dynamic_id")
            print(parameters)
            Alamofire.request(.POST, urlString, parameters: parameters)
                .responseJSON{ response in
                    print("数据")
                    switch response.result
                    {
                    case .Success:
                        print("网络连接正常")
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
                            self.FirstTableTitle?.text = JSON[7] as! String
                            self.FirstTableDetail?.text =  JSON[3] as! String
                            self.FirstTable_yanjin_Num!.text =  self.msgItem.NumType(JSON[4] as! String)
                            self.FirstTable_pinglun_Num!.text =  self.msgItem.NumType(JSON[5] as! String)
                        }
                        break
                    case .Failure:
                        print("网络连接错误")
                        break
                    }
            }
        */
    }
    
    func rebuildUserInterface()
    {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        //self.TableImage = UIButton(frame:CGRectMake(5,40,110,90))
        //self.TableImage?.setBackgroundImage(UIImage(named: TableImageUrl), forState: UIControlState.Normal)
        //self.addSubview(self.FirstTableImage!)
        
        self.Tablebiaoqian = UIButton(frame: CGRectMake(0,5,self.frame.width-5,28))
        self.Tablebiaoqian?.setBackgroundImage(UIImage(named: biaoqian), forState: UIControlState.Normal)
        self.addSubview(self.Tablebiaoqian!)
        
        self.TableTitle = UILabel(frame: CGRectMake(125,32,self.frame.width-125,25))
        self.TableTitle!.adjustsFontSizeToFitWidth = false//如果标题文字超过了宽度自动调整字体大小适应，false不开启
        self.TableTitle?.font = UIFont.systemFontOfSize(20)
        print(self.msgItem.name)
        self.TableTitle?.text = self.msgItem.name
        self.TableTitle?.textAlignment = NSTextAlignment.Left
        self.addSubview(self.TableTitle!)
        
        self.TableDetail = UITextView(frame: CGRectMake(140,57,self.frame.width-140,45))
        self.TableDetail?.text = self.msgItem.tip
        self.TableDetail?.font = UIFont.systemFontOfSize(15)
        self.TableDetail?.textColor = UIColor.grayColor()
        self.TableDetail!.editable=false
        self.TableDetail!.userInteractionEnabled=false
        self.addSubview(self.TableDetail!)

        self.Table_yanjin_Image = UIButton(frame: CGRectMake(245,106, 25,13))
        self.Table_yanjin_Image?.setBackgroundImage(UIImage(named: "主页眼镜1"), forState: UIControlState.Normal)
        self.addSubview(Table_yanjin_Image!)
        
        self.Table_yanjin_Num = UILabel(frame: CGRectMake(285 ,106, 50, 13))
        self.Table_yanjin_Num!.text = String(self.msgItem.Table_yanjin_Num)
        self.Table_yanjin_Num?.textAlignment = NSTextAlignment.Center
        self.Table_yanjin_Num!.font = UIFont.systemFontOfSize(15)
        self.Table_yanjin_Num?.textColor = UIColor.grayColor()
        self.addSubview(Table_yanjin_Num!)
        
        self.Table_pinglun_Image = UIButton(frame: CGRectMake(335,106,25,13))
        self.Table_pinglun_Image?.setBackgroundImage(UIImage(named: "主页评论数量"), forState: UIControlState.Normal)
        self.addSubview(Table_pinglun_Image!)
        
        self.Table_pinglun_Num = UILabel(frame: CGRectMake(360,106,self.frame.width-360,13))
        self.Table_pinglun_Num?.textAlignment = NSTextAlignment.Center
        self.Table_pinglun_Num!.text = String(self.msgItem.Table_pinglun_Num)
        self.Table_pinglun_Num?.textColor = UIColor.grayColor()
        self.Table_pinglun_Num!.font = UIFont.systemFontOfSize(15)
        self.addSubview(Table_pinglun_Num!)
        
    }
}
