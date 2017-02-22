//
//  ShowOne.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/8.
//  Copyright © 2016年 ucai. All rights reserved.
//

import UIKit

class ShowOne: UIViewController,UIScrollViewDelegate {
    
    var 蒙图=UIButton()
    var showONe=UIImageView()
    var scrollBG=UIScrollView()
    var indexPath:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edit = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")
        self.navigationItem.rightBarButtonItem=edit
        self.navigationItem.backBarButtonItem?.target = "back"
        
        蒙图 = UIButton(frame: CGRectMake(0, 20, self.view.frame.width, self.view.frame.height-20))
        //蒙图.alpha = 0.5
        蒙图.backgroundColor = UIColor.blackColor()
        蒙图.addTarget(self, action: "Cancel蒙图", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.showONe = UIImageView(image:UIImage(data: GetImageFromAssets(indexPath)))
        self.showONe.frame.size = CGSize(width: self.view.frame.width,height: {
            ()->CGFloat in
            if self.view.frame.width < self.showONe.frame.width
            {
            return self.showONe.frame.height/(self.showONe.frame.width/self.view.frame.width)
            }
            return self.showONe.frame.height
        }())
        
        self.scrollBG.frame=self.view.frame
        self.scrollBG.contentSize = self.showONe.frame.size
        self.scrollBG.showsHorizontalScrollIndicator=false//默认显示滚动条
        self.scrollBG.showsVerticalScrollIndicator=false//默认显示滚动条
        self.scrollBG.pagingEnabled=false//是否允许滚动，必须设置  默认false
        //计算横纵计算比例
        let ratioX = self.scrollBG.frame.size.width/self.showONe.frame.size.width
        let ratioY = self.scrollBG.frame.size.height/self.showONe.frame.size.height
        let minScale = min(ratioX,ratioY)//取较小值
        self.scrollBG.zoomScale = minScale//初始图片全部显示
        self.scrollBG.minimumZoomScale = minScale //最小缩放比例
        self.scrollBG.maximumZoomScale = 4//最大放大比例
        self.scrollBG.delegate = self
        self.scrollBG.canCancelContentTouches=true
        conterScrollViewContens()
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("scrollviewDoubleTapped:"))
        doubleTapRecognizer.numberOfTapsRequired=2//按几下
        self.scrollBG.addGestureRecognizer(doubleTapRecognizer)
        
        self.view.addSubview(蒙图)
        self.scrollBG.addSubview(showONe)
        self.view.addSubview(scrollBG)
    }
    
    func scrollviewDoubleTapped(recognizer:UITapGestureRecognizer)
    {//获取双击在image View中的位置
        let pointInView = recognizer.locationInView(self.showONe)
        //计算新的缩放比例，并且不能大于原最大缩放比例
        var newZoomScale = self.scrollBG.zoomScale*1.5
        newZoomScale = min(newZoomScale,self.scrollBG.maximumZoomScale)

        //计算要放大的矩形尺寸
        let scrollviewSize = self.scrollBG.bounds.size
        let w = scrollviewSize.width/newZoomScale
        let h = scrollviewSize.height/newZoomScale
        let x = pointInView.x - (w/2.0)
        let y = pointInView.y - (h/2.0)
        let rectToZoom = CGRectMake(x,y, w, h)
        //告诉scroll view进行缩放， 并使用动画效果
        
        self.scrollBG.zoomToRect(rectToZoom, animated: true)
            }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        self.scrollBG.decelerationRate = 0.1//值域是(0.0,1.0),当decelerationRate设置为0.1时,当手指touch up时就会很慢的停下来
    }
    
    
    //MARK:UIscrollViewDelegate协议里的方法
    func viewForZoomingInScrollView(scrollView:UIScrollView)->UIView?{
        
        //self.scrollBG.contentSize = CGSize(width: self.scrollBG.contentSize.width+0,height: self.scrollBG.contentSize.height+66)//高度问题加66
        return self.showONe
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        self.scrollBG.contentSize = CGSize(width: self.scrollBG.contentSize.width+0,height: self.scrollBG.contentSize.height+66)//高度问题加66
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func edit()
    {
        let Edit = Editing()
        // 添加图片
        let myAsset = assets[indexPath]
        //获取文件名
        let representation =  myAsset.defaultRepresentation()
        //获取原图
        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
        let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                                                 length: Int(representation.size()), error: nil)
        let data =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
        
        Edit.EditImage = UIImage(data: data)!
        self.navigationController?.pushViewController(Edit, animated: true)
    }
    
    func conterScrollViewContens()
    {
        let boundSize = self.scrollBG.bounds.size
        var contentFrame = self.showONe.frame
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
        self.showONe.frame = contentFrame
    }
    
    
    func Cancel蒙图()
    {
        
        self.view.removeFromSuperview()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
