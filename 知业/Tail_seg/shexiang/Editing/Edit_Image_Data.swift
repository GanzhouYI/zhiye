//
//  Edit_Image.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/15.
//  Copyright © 2016年 ucai. All rights reserved.
//

import Foundation
import UIKit

class Edit_Image_Data {
    
    var Edit_Image_tiezhi=["yindao.png","yindao1.jpg","yindao2.png","yindao3.jpg","yindao4.png","卡背.jpg"]
    
    var tiezhi_collectionViewSize:CGSize{
        let width = (Double(screenBounds.width)-40-10*5)/4///每个Image贴图占的大小
        let widthSum:CGFloat!
        widthSum = CGFloat(Double(Edit_Image_tiezhi.count)*(width+10))+10
        return CGSize(width: widthSum,height: CGFloat(0))
    }

    
    var Edit_Image_biaoqian=["yindao1.jpg","yindao2.png","yindao3.jpg","yindao4.png","卡背.jpg"]
    
    var biaoqian_collectionViewSize:CGSize{
        let width = (Double(screenBounds.width)-40-10*5)/4///每个Image标签占的大小
        let widthSum:CGFloat!
        widthSum = CGFloat(Double(Edit_Image_biaoqian.count)*(width+10))+10
            return CGSize(width: widthSum,height: CGFloat(0))
    }
    
    var Edit_Image_lvjing=["原图.png","怀旧.png","高亮.png","黑白.png","泛红.png"]
    var lvjing_collectionViewSize:CGSize{
        let width = (Double(screenBounds.width)-40-10*5)/4///每个Image标签占的大小
        let widthSum:CGFloat!
        widthSum = CGFloat(Double(Edit_Image_lvjing.count)*(width+10))+10
        return CGSize(width: widthSum,height: CGFloat(0))
    }
 
    
}