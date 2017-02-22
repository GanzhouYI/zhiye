//
//  biaoqian_collectionView.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/14.
//  Copyright © 2016年 ucai. All rights reserved.
//

import Foundation
import UIKit

public protocol biaoqian_collectionView_Delegate :NSObjectProtocol{
    
    func biaoqian_Images() -> [String]
    func biaoqian_numberOfItemsInSection() -> Int
    func biaoqian_contentSize()->CGSize
    
}


class biaoqian_collectionView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    var collectionView :UICollectionView!
    var numberOfItemsInSection:Int!
    var Images:[String]!
    var layout:biaoqian_Layout!
    
    weak var delegate:biaoqian_collectionView_Delegate?
        {
        didSet{
            if let num = delegate?.biaoqian_numberOfItemsInSection(){
                numberOfItemsInSection = num
            }
            if let Data = delegate?.biaoqian_Images(){
                Images = Data
            }
            //            if let size = delegate?.biaoqian_contentSize(){
            //                layout = biaoqian_Layout(size: size)
            //            }
            
        }
    }
    
    init(frame: CGRect,biaoqian_contentSize:CGSize) {
        super.init(frame: frame)
        
        layout = biaoqian_Layout(size: (biaoqian_contentSize))
        setUp_biaoqian_collectionView()
        
        // default is 0
        
    }
    
    //    init(frame:CGRect,Layout:biaoqian_Layout) //重写init
    //    {   super.init(frame: frame)
    //       setUp_biaoqian_collectionView()
    //        self.layout = Layout
    //    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp_biaoqian_collectionView()
    {
        self.collectionView = UICollectionView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.height),collectionViewLayout:layout!)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 注册CollectionViewCell
        var collectionViewBGImage=UIImageView(image: UIImage(named: "背景3.png"))
        self.collectionView.backgroundView = collectionViewBGImage
        self.collectionView.backgroundColor = UIColor.whiteColor()
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
        NSNotificationCenter.defaultCenter().postNotificationName("biaoqianCompleteNotification", object: nil, userInfo: data)
        print("select \(indexPath.row)")
    }
    
}