//
//  CustomLayout.swift
//  SwiftInAction-008-016
//
//  Created by zhihua on 14-7-13.
//  Copyright (c) 2014年 ucai. All rights reserved.
//

import UIKit

/**
 * 这个类只简单定义了一个section的布局
 */
class lvjing_Layout : UICollectionViewLayout {
    
    var ContentSize:CGSize!
    
    init(size:CGSize) {
        super.init()
        print(size)
        ContentSize = size
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 内容区域总大小，不是可见区域
    override func collectionViewContentSize() -> CGSize {
        return ContentSize
    }
    
    // 所有单元格位置属性collectionViewHeight
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let cellCount = self.collectionView!.numberOfItemsInSection(0)
        for i in 0..<cellCount {
            let indexPath =  NSIndexPath(forItem:i, inSection:0)
            
            let attributes =  self.layoutAttributesForItemAtIndexPath(indexPath)
            
            attributesArray.append(attributes)
            
        }
        return attributesArray
    }
    
    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        //当前单元格布局属性
        let attribute =  UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
        
        //内部间隙，左右5   （top,left,bottom,right）
        let insets = UIEdgeInsetsMake(5, 5, 5, 10)
        
        //单元格边长
        let smallCellSide:CGFloat = (collectionView!.bounds.size.width - insets.right*5)/4
        
        
        //当前行的Y坐标
        let lineOriginY = insets.top
        //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
        let SmallX =  smallCellSide*CGFloat(indexPath.item) + insets.right*CGFloat(indexPath.item+1)
        
        
        
        attribute.frame = CGRectMake(SmallX, lineOriginY, smallCellSide, smallCellSide)
        
        
        
        return attribute
    }
    
    
    
    
    
}