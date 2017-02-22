//
//  C_ViewController.swift
//  SwiftInAction-008-016
//
//  Created by __________V|R__________ on 16/3/8.
//  Copyright © 2016年 ucai. All rights reserved.
//

import UIKit

extension shexiangController
{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let showOne=ShowOne()
        showOne.indexPath = indexPath.row
        self.navigationController?.pushViewController(showOne, animated: true)
    }

    func ChisePic(btn:UIButton)
    {
        
        if ((btn.frame.width) == 20)//选中了
        {
            btn.frame = CGRectMake(btnX[Int(btn.titleLabel!.text!)!]-(CellWIdth-5-20), btnY[Int(btn.titleLabel!.text!)!]-5, CellWIdth, CellWIdth)
            print(btn.titleLabel!.text)
            //btn.backgroundColor = UIColor.whiteColor()
            btn.alpha = 1
            btn.setBackgroundImage(gouxuan_icon_selected, forState: UIControlState.Normal)
            //保存
            SourceChice.append(btn.titleLabel!.text!)
            sendData.append(assets[Int(btn.titleLabel!.text!)!])
        }
        else//取消
        {
            btn.frame = CGRectMake(btnX[Int(btn.titleLabel!.text!)!], btnY[Int(btn.titleLabel!.text!)!], 20, 20)
            btn.setBackgroundImage(gouxuan_icon, forState: UIControlState.Normal)
            btn.alpha = 1
            
            for i in 0...SourceChice.count
            {
                var num:Int = 0
                if SourceChice[i] == btn.titleLabel!.text
                {
                    sendData.removeAtIndex(num)
                    SourceChice.removeAtIndex(i)
                    break
                }
                num++
            }
        }
    }
    //退出时把所有的全局变量清空
    func back()
    {
        SourceChice.removeAll()
        assets.removeAll()
        sendData.removeAll()
        let nav = UINavigationController(rootViewController: MainViewController())
        self.presentViewController(nav, animated: true, completion: nil)
    }

    func sendALL()
    {
        let send = SendViewController()
        self.navigationController?.pushViewController(send, animated: true)
    }
}