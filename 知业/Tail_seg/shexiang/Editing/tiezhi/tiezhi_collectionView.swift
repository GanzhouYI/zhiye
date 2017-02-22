//
//  tiezhi_collectionView.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/14.
//  Copyright © 2016年 ucai. All rights reserved.
//

import Foundation
import UIKit

public protocol tiezhi_collectionView_Delegate :NSObjectProtocol{
    
    func tiezhi_Images() -> [String]
    func tiezhi_numberOfItemsInSection() -> Int
    func tiezhi_contentSize()->CGSize
    
}


class tiezhi_collectionView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    var collectionView :UICollectionView!
    var numberOfItemsInSection:Int!
    var Images:[String]!
    var layout:tiezhi_Layout!
    
    weak var delegate:tiezhi_collectionView_Delegate?
        {
        didSet{
            if let num = delegate?.tiezhi_numberOfItemsInSection(){
                numberOfItemsInSection = num
            }
            if let Data = delegate?.tiezhi_Images(){
                Images = Data
            }
//            if let size = delegate?.tiezhi_contentSize(){//需要提前把值赋给layout，因为等下setUp_tiezhi_collectionView中self.collectionView = UICollectionView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.height),collectionViewLayout:layout!)为空
//                layout = tiezhi_Layout(size: size)
//            }
            
        }
    }
    
     init(frame: CGRect,tiezhi_contentSize:CGSize) {
        super.init(frame: frame)

        layout = tiezhi_Layout(size: (tiezhi_contentSize))
        setUp_tiezhi_collectionView()
        
        // default is 0
        
    }
    
//    init(frame:CGRect,Layout:tiezhi_Layout) //重写init
//    {   super.init(frame: frame)
//       setUp_tiezhi_collectionView()
//        self.layout = Layout
//    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp_tiezhi_collectionView()
    {
        self.collectionView = UICollectionView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.height),collectionViewLayout:layout!)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 注册CollectionViewCell
        self.collectionView.backgroundColor = UIColor.whiteColor()
        var collectionViewBGImage=UIImageView(image: UIImage(named: "背景3.png"))
        self.collectionView.backgroundView = collectionViewBGImage
        self.collectionView.showsHorizontalScrollIndicator=false//默认显示滚动条
        self.collectionView.showsVerticalScrollIndicator=false//默认显示滚动条
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ViewCell")
        self.addSubview(self.collectionView)
    }
    
    // CollectionView行数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }
    
    // 获取单元格
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "ViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath)
        
        var Image_Data = UIImageView()
        Image_Data.frame = cell.bounds
        Image_Data.image = UIImage(named: Images[indexPath.row])
        cell.addSubview(Image_Data)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let data = ["type":"yindao.png"]
        NSNotificationCenter.defaultCenter().postNotificationName("tiezhiCompleteNotification", object: nil, userInfo: data)
        
        print("select \(indexPath.row)")
    }

}