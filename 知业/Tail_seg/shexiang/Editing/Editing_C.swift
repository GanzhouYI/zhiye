//
//  ExtensionEditing.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/14.
//  Copyright © 2016年 ucai. All rights reserved.
//

import UIKit

extension Editing{
    func conterScrollViewContens()
    {
        let boundSize = self.scrollBG.bounds.size
        var contentFrame = self.imageView.frame
        //水平居中位置
        if contentFrame.size.width < boundSize.width
        {
            contentFrame.origin.x = (boundSize.width-contentFrame.size.width)/2.0
        }
        else
        {
            contentFrame.origin.x = 0.0
        }
        //垂直居中位置
        if contentFrame.size.height < boundSize.height
        {
            contentFrame.origin.y = (boundSize.height-contentFrame.size.height)/2.0
        }
        else
        {
            contentFrame.origin.y = 0.0
        }
        self.imageView.frame = contentFrame
    }

    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        contentViewBlack = UIImageView(frame: CGRectMake(0, 0, self.contentView.frame.width, self.contentView.frame.height))
        contentViewBlack.backgroundColor = UIColor.blackColor()
        self.contentView.addSubview(contentViewBlack)
        switch item.tag
        {
            case 0:
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Editing.tiezhiComplete(_:)), name: "tiezhiCompleteNotification", object: nil)

                let tiezhi_collection = tiezhi_collectionView(frame:CGRectMake(20,20,self.view.frame.width-40,self.contentView.frame.height-20),tiezhi_contentSize: tiezhi_contentSize())
                tiezhi_collection.delegate = self
                
                self.contentView.addSubview(tiezhi_collection)
                //self.contentView.backgroundColor = UIColor.redColor()
            break
            
            case 1:
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Editing.biaoqianComplete(_:)), name: "biaoqianCompleteNotification", object: nil)
                
                
                let biaoqian_collection = biaoqian_collectionView(frame:CGRectMake(20,20,self.view.frame.width-40,self.contentView.frame.height-20),biaoqian_contentSize: biaoqian_contentSize())
                biaoqian_collection.delegate = self
                
                self.contentView.addSubview(biaoqian_collection)
                //self.contentView.backgroundColor = UIColor.redColor()
            break
            
            case 2:
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Editing.lvjingComplete(_:)), name: "lvjingCompleteNotification", object: nil)
                print("Edit_C")
                let lvjing_collection = lvjing_collectionView(frame:CGRectMake(20,20,self.view.frame.width-40,self.contentView.frame.height-20),lvjing_contentSize: lvjing_contentSize())
                lvjing_collection.delegate = self
                
                self.contentView.addSubview(lvjing_collection)
            break
            
            case 3:
                
            break
        default:
            break
        }
        
    }
    

    func UIImage_lvjing(var EditImage:UIImage,typeName:String)->UIImage
    {
        
        switch typeName
        {
        case "CISepiaTone"://怀旧
            filter = CIFilter(name: "CISepiaTone")//设置过滤器的名字,也就是给图片上不同的样式，并给浮点值意味着深浅
            filter!.setValue(beginImage, forKey: kCIInputImageKey)
            filter!.setValue(0.8, forKey: kCIInputIntensityKey)
            // 4
            //let newImage = UIImage(CIImage: filter!.outputImage!)
            //上面的性能不好，每次都会创建一个新的CIContext对象
            
            //context = CIContext(options:nil)上面已经创建了一个context对象，所以不要重复创建这样效率大大提高
            let cgimg = context.createCGImage(filter!.outputImage!,fromRect:(filter!.outputImage?.extent)!)
            EditImage = UIImage(CGImage:cgimg)
            break
            
        case "CIPhotoEffectChrome":
            filter = CIFilter(name: "CIPhotoEffectChrome")
            filter!.setValue(beginImage, forKey: kCIInputImageKey)
            let cgimg = context.createCGImage(filter!.outputImage!,fromRect:(filter!.outputImage?.extent)!)
            EditImage = UIImage(CGImage:cgimg)
            break

        case "CICrystallize":
            filter = CIFilter(name: "CICrystallize")
            filter!.setValue(beginImage, forKey: kCIInputImageKey)
            let cgimg = context.createCGImage(filter!.outputImage!,fromRect:(filter!.outputImage?.extent)!)
            EditImage = UIImage(CGImage:cgimg)
            break
            
        case "CIPhotoEffectNoir":
            filter = CIFilter(name: "CIPhotoEffectNoir")
            filter!.setValue(beginImage, forKey: kCIInputImageKey)
            let cgimg = context.createCGImage(filter!.outputImage!,fromRect:(filter!.outputImage?.extent)!)
            EditImage = UIImage(CGImage:cgimg)
            break
            
        case "CIFalseColor":
            filter = CIFilter(name: "CIFalseColor")
            filter!.setValue(beginImage, forKey: kCIInputImageKey)
            let cgimg = context.createCGImage(filter!.outputImage!,fromRect:(filter!.outputImage?.extent)!)
            EditImage = UIImage(CGImage:cgimg)
            break
            
        default :
            print(typeName)
            print("返回原图")
            break
        }
        return EditImage

    }

    
    //通知中心改变Edit_Image
    func tiezhiComplete(notification:NSNotification){
        let data = notification.userInfo! as NSDictionary
        let typeName = data["type"]! as! String
        self.imageView.image = self.imageView.image?.UIImage_tiezhi(self.imageView.image!, typeName: typeName)
        
    }
    //通知中心改变Edit_Image
    func biaoqianComplete(notification:NSNotification){
        
        let data = notification.userInfo! as NSDictionary
        let typeName = data["type"]! as! String
        self.imageView.image = self.imageView.image?.UIImage_biaoqian(self.imageView.image!, typeName: typeName)
        
    }
    //通知中心改变Edit_Image
    func lvjingComplete(notification:NSNotification){
        
        let data = notification.userInfo! as NSDictionary
        let typeName = data["type"]! as! String
        self.imageView.image = UIImage_lvjing(self.EditImage, typeName: typeName)
    }
    
    //     实现 tiezhi_collectionView_Delegate
    func tiezhi_Images() -> [String]
    {
        return Edit_Data.Edit_Image_tiezhi
    }
    
    func tiezhi_numberOfItemsInSection() -> Int
    {
        return Edit_Data.Edit_Image_tiezhi.count
    }
    
    func tiezhi_contentSize() -> CGSize {
        return Edit_Data.tiezhi_collectionViewSize
    }
    
    //     实现 biaoqian_collectionView_Delegate
    func biaoqian_Images() -> [String]
    {
        return Edit_Data.Edit_Image_biaoqian
    }
    
    func biaoqian_numberOfItemsInSection() -> Int
    {
        return Edit_Data.Edit_Image_biaoqian.count
    }
    
    func biaoqian_contentSize() -> CGSize {
        return Edit_Data.biaoqian_collectionViewSize
    }
    
    //     实现 lvjing_collectionView_Delegate
    func lvjing_Images() -> [String]
    {
        return Edit_Data.Edit_Image_lvjing
    }
    
    func lvjing_numberOfItemsInSection() -> Int
    {
        return Edit_Data.Edit_Image_lvjing.count
    }
    
    func lvjing_contentSize() -> CGSize {
        return Edit_Data.lvjing_collectionViewSize
    }
    
    
}
