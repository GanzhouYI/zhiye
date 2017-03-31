import Foundation
import Alamofire

class contactUsNet:NSObject {
    static var Model:contactUsNet?
    static var predicate:dispatch_once_t = 0
    class func sharedcontactUsNet()->contactUsNet?{
        dispatch_once(&predicate) { () -> Void in
            Model = contactUsNet()
        }
        return Model
    }
    
    
    typealias NetworkBlock = (dataInfo:String)->Void
    
    func contactUs(message:String,block:NetworkBlock?)
    {
        let urlString:String = "http://www.loveinbc.com/zhiye/contactUs.php"
        let parameters = ["uid":String(LoginModel.sharedLoginModel()!.MyUid!),"message": message]
        //let parameters = ["dynamic_date":""]
        print("输出更新动态请求的lastDate")
        print(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON{ response in
                print("数据")
                switch response.result
                {
                case .Success:
                    print("contactUs 网络连接正常")
                    print(response.result.value!)
                    let str = (response.result.value!)as?String
                    
                    if(str == "谢谢您的反馈")
                    {
                        block!(dataInfo:"谢谢您的反馈")
                    }
                    else
                    {
                        block!(dataInfo:"出现故障,请联系QQ1025435307")
                    }
                    break
                case .Failure:
                    print("网络连接错误")
                    block!(dataInfo:"网络错误")
                    break
                }
        }
    }
    
}

