import UIKit
import Foundation

extension UIImage{
    

    
    //水印位置枚举
    enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    func UIImage_tiezhi(EditImage:UIImage,typeName:String)->UIImage
    {
        switch typeName
        {
            case "黑白":
                print("黑白")
            break
            case "高斯":
            break
            default:
                print("没有")
            break
        }
        return EditImage
    }
    
    
    func UIImage_biaoqian(EditImage:UIImage,typeName:String)->UIImage
    {
        switch typeName
        {
        case "黑白":
            print("黑白")
            break
        case "高斯":
            break
        default:
            print("没有")
            break
        }
        return EditImage
    }
    
       
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let drawRect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        //let context = UIGraphicsGetCurrentContext()
        //CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        drawInRect(drawRect, blendMode: blendMode, alpha: 0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    //添加图片水印方法
    func waterMarkedImage(waterMarkImage:UIImage, corner:WaterMarkCorner = .BottomRight,
        margin:CGPoint = CGPoint(x: 20, y: 20), alpha:CGFloat = 1) -> UIImage{
            
            var markFrame = CGRectMake(0, 0, waterMarkImage.size.width, waterMarkImage.size.height)
            let imageSize = self.size//底部的image
            
            switch corner{//corner贴图在原图的位置
            case .TopLeft:
                markFrame.origin = margin
            case .TopRight:
                markFrame.origin = CGPoint(x: imageSize.width - waterMarkImage.size.width - margin.x,
                    y: margin.y)
            case .BottomLeft:
                markFrame.origin = CGPoint(x: margin.x,
                    y: imageSize.height - waterMarkImage.size.height - margin.y)
            case .BottomRight:
                markFrame.origin = CGPoint(x: imageSize.width - waterMarkImage.size.width - margin.x,
                    y: imageSize.height - waterMarkImage.size.height - margin.y)
            }
            
            // 开始给图片添加图片
            UIGraphicsBeginImageContext(imageSize)
            //确定原图的frame
            self.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
            //贴图在原图的frame
            waterMarkImage.drawInRect(markFrame, blendMode: .Normal, alpha: alpha)
            //得到当前绘画后的图片
            let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
            //绘画结束
            UIGraphicsEndImageContext()
            
            return waterMarkedImage
    }
}