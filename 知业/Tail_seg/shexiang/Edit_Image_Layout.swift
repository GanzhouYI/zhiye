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
class Edit_Image_Layout : UICollectionViewLayout {
    
    // 内容区域总大小，不是可见区域
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(collectionView!.bounds.size.width, 1+100)
    }
    
    // 所有单元格位置属性collectionViewHeight
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]! {
        
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
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes! {
        
        //当前单元格布局属性
        let attribute =  UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
        
        //单元格外部空隙，简单起见，这些常量都在方法内部定义了，没有共享为类成员
        let lineSpacing = 5
        
        //内部间隙，左右5   （top,left,bottom,right）
        let insets = UIEdgeInsetsMake(2, 5, 2, 5)
        
        //单元格边长
        let smallCellSide:CGFloat = (collectionView!.bounds.size.width - insets.right*5)/4
        
        
        //当前行数，每行显示3个图片，1大2小
        let line:Int =  indexPath.item / 4
        //当前行的Y坐标
        let lineOriginY =  smallCellSide * CGFloat(line) + CGFloat(lineSpacing * line) + insets.top
        //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
        let SmallX =  smallCellSide*CGFloat(indexPath.item % 4) + insets.right*CGFloat(indexPath.item % 4+1)
        
        // 每行2个图片，2行循环一次，一共6种位置
        
        
        attribute.frame = CGRectMake(SmallX, lineOriginY, smallCellSide, smallCellSide)
        
        
        
        return attribute
    }
    

    
}