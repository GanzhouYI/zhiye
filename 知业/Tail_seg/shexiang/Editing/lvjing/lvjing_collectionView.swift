//
//  lvjing_collectionView.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/14.
//  Copyright © 2016年 ucai. All rights reserved.
//

import Foundation
import UIKit

public protocol lvjing_collectionView_Delegate :NSObjectProtocol{
    
    func lvjing_Images() -> [String]
    func lvjing_numberOfItemsInSection() -> Int
    func lvjing_contentSize()->CGSize
}


class lvjing_collectionView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    var collectionView :UICollectionView!
    var numberOfItemsInSection:Int!
    var Images:[String]!
    var layout:lvjing_Layout!
    
    weak var delegate:lvjing_collectionView_Delegate?
        {
        didSet{
            if let num = delegate?.lvjing_numberOfItemsInSection(){
                numberOfItemsInSection = num
            }
            if let Data = delegate?.lvjing_Images(){
                Images = Data
            }
            //            if let size = delegate?.lvjing_contentSize(){
            //                layout = lvjing_Layout(size: size)
            //            }
            
        }
    }
    deinit {//记得移除通知监听
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    init(frame: CGRect,lvjing_contentSize:CGSize) {
        super.init(frame: frame)
        
        layout = lvjing_Layout(size: (lvjing_contentSize))
        setUp_lvjing_collectionView()
        
        // default is 0
        
    }
    
    //    init(frame:CGRect,Layout:lvjing_Layout) //重写init
    //    {   super.init(frame: frame)
    //       setUp_lvjing_collectionView()
    //        self.layout = Layout
    //    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp_lvjing_collectionView()
    {
        self.collectionView = UICollectionView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.height),collectionViewLayout:layout!)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 注册CollectionViewCell
        let collectionViewBGImage=UIImageView(image: UIImage(named: "背景3.png"))
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
        
        let Image_Data = UIImageView()
        Image_Data.frame = cell.bounds
        Image_Data.image = UIImage(named: Images[indexPath.row])
        cell.addSubview(Image_Data)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("begin select")
        var data = ["":""]
        switch indexPath.row
        {
        case 0:
            print("原图")
            data = ["type":"none"]
            break
        case 1:
            print("怀旧")
            data = ["type":"CISepiaTone"]//怀旧
            break
        case 2:
            print("高亮")
            data = ["type":"CIPhotoEffectChrome"]
            break
            
        case 3:
            print("黑白")
            data = ["type":"CIPhotoEffectNoir"]
            break
            
        case 4:
            print("泛红")
            data = ["type":"CIFalseColor"]
            break
            
        default:
            data = ["type":"none"]
            print("没有 collection select")
            break
        }
        print("collectionView Select")
        print(data)
        NSNotificationCenter.defaultCenter().postNotificationName("lvjingCompleteNotification", object: nil, userInfo: data)
        
        print("select \(indexPath.row)")
    }
    
}