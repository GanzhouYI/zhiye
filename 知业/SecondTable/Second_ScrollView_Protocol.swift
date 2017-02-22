import Foundation
import UIKit

/// if is 0,autoplay is not


private let pageControlMargin:CGFloat = 250
private let defaultCurrentPageIndicatorTintColor = UIColor.redColor()
private let defaultPageIndicatorTintColor = UIColor.whiteColor()

public protocol Second_ScrollView_Delegate :NSObjectProtocol{
    
    func Second_didSelectCurrentPage(index : Int)
    func Second_numberOfPages() -> Int
    func Second_currentPageViewIndex(index:Int) -> String
}

class Second_ScrollView: UIView,UIScrollViewDelegate {
    
    //**  property  */
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var currentImageView = UIImageView()
    var lastImageView = UIImageView()
    var nextImageView = UIImageView()
    var totalPages:Int!
    weak var delegate : Second_ScrollView_Delegate? {
        
        didSet{
            
            if let pages = delegate?.Second_numberOfPages(){
                totalPages = pages
            }
            
            scrollView.scrollEnabled = !(totalPages == 1)//只有一张图片就不滚动
            setScrollViewOfImage()
            
            
            self.pageControl = UIPageControl(frame: CGRectMake(scrollView.frame.origin.x+180*宽比例,scrollView.frame.origin.y+scrollView.frame.size.height-20*高比例,40*宽比例,10*高比例))
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = totalPages
            pageControl.currentPageIndicatorTintColor = defaultCurrentPageIndicatorTintColor
            pageControl.pageIndicatorTintColor = defaultPageIndicatorTintColor
            pageControl.backgroundColor = UIColor.clearColor()
            self.addSubview(pageControl)
            

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
        
        delegate?.Second_didSelectCurrentPage(currentPageIndex)//点击图片事件
        
    }
    private func setScrollViewOfImage(){
        
        if let currentStr = delegate?.Second_currentPageViewIndex(currentPageIndex) {
            
            currentImageView.image = UIImage(named: currentStr)
        }
        if let lastStr = delegate?.Second_currentPageViewIndex(getLastImageIndex(currentPageIndex)) {
            
            lastImageView.image = UIImage(named: lastStr)
        }
        if let nextStr = delegate?.Second_currentPageViewIndex(getNextImageIndex(currentPageIndex)) {
            
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
        
        
        self.setScrollViewOfImage()
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)

        }
}


