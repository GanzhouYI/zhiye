//
//  First_ScrollView.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/1/22.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//


import Foundation
import UIKit

/// if is 0,autoplay is not


private let pageControlMargin:CGFloat = 20
private let defaultCurrentPageIndicatorTintColor = UIColor.redColor()
private let defaultPageIndicatorTintColor = UIColor.whiteColor()

public protocol First_ScrollView_Protocol :NSObjectProtocol{
    
    func First_didSelectCurrentPage(index : Int)
    func First_numberOfPages() -> Int
    func First_currentPageViewIndex(index:Int) -> String
    func First_currentPageLabel_Title(index: Int) -> String
}

class First_ScrollView: UIView,UIScrollViewDelegate {
    
    //**  property  */
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var timer: NSTimer?
    var Title = UILabel(frame: CGRectMake(20,170,200,20))
    var currentImageView = UIImageView()
    var lastImageView = UIImageView()
    var nextImageView = UIImageView()
    var totalPages:Int!
    var defaultTimeInterval : NSTimeInterval = -1
    weak var delegate : First_ScrollView_Protocol? {
        
        didSet{
            
            if let pages = delegate?.First_numberOfPages(){
                totalPages = pages
            }
            
            scrollView.scrollEnabled = !(totalPages == 1)//只有一张图片就不滚动
            setScrollViewOfImage()
            
            Title.text = delegate?.First_currentPageLabel_Title(currentPageIndex)
            
            self.pageControl = UIPageControl(frame: CGRectMake(self.frame.size.width - pageControlMargin * CGFloat(totalPages), self.frame.size.height - 30*高比例, pageControlMargin * CGFloat(totalPages), pageControlMargin))
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = totalPages
            pageControl.currentPageIndicatorTintColor = defaultCurrentPageIndicatorTintColor
            pageControl.pageIndicatorTintColor = defaultPageIndicatorTintColor
            pageControl.backgroundColor = UIColor.clearColor()
            self.addSubview(pageControl)
            
            Title.frame = CGRectMake(20,170,self.frame.width-20-10-self.pageControl.frame.width,20)
            Title.textColor=UIColor.whiteColor()
            Title.font = UIFont(name:"Arial", size:20)
            Title.textAlignment=NSTextAlignment.Left
            self.addSubview(Title)
        }
    }
    
    var currentPageIndex : Int! {
        
        didSet{
            self.pageControl.currentPage = currentPageIndex
        }
    }
    
    /**
     *  init
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
     
        // default is 0
        currentPageIndex = 0
        setUpCycleScrollView()
    }
    
    init(frame:CGRect,defaultTimeInterval:NSTimeInterval)
    {   super.init(frame: frame)
        self.defaultTimeInterval = defaultTimeInterval
        currentPageIndex = 0
        setUpCycleScrollView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCycleScrollView(){
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        
        scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        self.setImageViewWithIndex(index: 1, imageView: currentImageView)
        self.setImageViewWithIndex(index: 0, imageView: lastImageView)
        self.setImageViewWithIndex(index: 2, imageView: nextImageView)
        
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        
        if defaultTimeInterval != -1 {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(defaultTimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    func timerAction(){
        
        scrollView.setContentOffset(CGPointMake(self.frame.size.width*2, 0), animated: true)
    }
    
    private func setImageViewWithIndex(index index: Int,imageView: UIImageView!){
        
        assert(imageView != nil, "对象不能为空")
        
        imageView.frame = CGRectMake(self.frame.size.width * CGFloat(index), 0, self.frame.size.width, self.frame.size.height)
        imageView.userInteractionEnabled = true//?????疑问
        imageView.contentMode = .ScaleAspectFill
        
        scrollView.addSubview(imageView)
        
        if imageView == self.currentImageView {
            
            var imageTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction:"))
            currentImageView.addGestureRecognizer(imageTap)
        }
        
    }
    
    func imageTapAction(tap: UITapGestureRecognizer){
        
        delegate?.First_didSelectCurrentPage(currentPageIndex)//点击图片事件
        
    }
    private func setScrollViewOfImage(){
        
        if let currentStr = delegate?.First_currentPageViewIndex(currentPageIndex) {
            
            currentImageView.image = UIImage(named: currentStr)
        }
        if let lastStr = delegate?.First_currentPageViewIndex(getLastImageIndex(currentPageIndex)) {
            
            lastImageView.image = UIImage(named: lastStr)
        }
        if let nextStr = delegate?.First_currentPageViewIndex(getNextImageIndex(currentPageIndex)) {
            
            nextImageView.image = UIImage(named: nextStr)
        }
        
    }
    private func getLastImageIndex(currentImageIndex: Int) -> Int{
        let tempIndex = currentImageIndex - 1
        if tempIndex == -1 {
            return totalPages - 1
        }else{
            return tempIndex
        }
    }
    
    private func getNextImageIndex(currentImageIndex: Int) -> Int
    {
        let tempIndex = currentImageIndex + 1
        return tempIndex < totalPages ? tempIndex : 0
    }
    
    /**
     *  scrollViewDelegate
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //如果手滑动开始则重新计数滚动
        if defaultTimeInterval != -1 {
            timer?.invalidate()
            timer = nil
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //如果手滑动结束则调用下面方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.currentPageIndex = self.getLastImageIndex(self.currentPageIndex)
        }else if offset == self.frame.size.width * 2 {
            self.currentPageIndex = self.getNextImageIndex(self.currentPageIndex)
        }
        
        Title.text = delegate?.First_currentPageLabel_Title(currentPageIndex)
        
        self.setScrollViewOfImage()
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        if timer == nil && defaultTimeInterval != 0 {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(defaultTimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        //自动切换下一个image调用这个方法
        
        //调用上面方法
        
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
}