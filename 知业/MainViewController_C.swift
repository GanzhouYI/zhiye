//
//  MainViewController.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/3/20.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation
import UIKit

extension  MainViewController{
    //==========SecondTableView===========下面====================
    
    func setupSecondTable()
    {
        self.Secondtable = SecondTableView(frame:CGRectMake(self.view.frame.width, 20+60*高比例, self.view.frame.width, self.view.frame.height - 130*高比例))
        print("ViewController")
        print(self.view.frame)
        //创建一个重用的单元格
        self.Secondtable!.registerClass(SecondTableViewCell.self, forCellReuseIdentifier: "MsgCell")
        for i in 0...3
        {
            var num:Int = i
            var temp = SecondTableMessageItem( num: num,Pic: Pic[i],biaoqian1: biaoqian1[i],Detail: Detail[i],biaoqian2: biaoqian2[i])
            SecondtableData.append(temp)
        }
        
        self.Secondtable.SecondDataProtocol = self
        self.Secondtable.reloadData()
        
        BG_ScrollView.addSubview(self.Secondtable)
    }
    
    func rowsForSeoncdTable(tableView:SecondTableView) -> Int
    {
        return self.SecondtableData.count
    }
    
    func SecondTableViewDetail(tableView:SecondTableView, dataForRow row:Int) -> SecondTableMessageItem
    {
        return SecondtableData[row]
    }
    //==========SecondTableView===========上面====================
    
    
    func setupFirstTable()
    {
        self.Firsttable = FirstTableView(frame:CGRectMake(0
            , 20+60*高比例, self.view.frame.width, 604*高比例))

        //创建一个重用的单元格
        self.Firsttable!.registerClass(FirstTableViewCell.self, forCellReuseIdentifier: "MsgCell")
        self.Firsttable.didSelectDelegate=self
        self.Firsttable.reloadData()
        
        BG_ScrollView.addSubview(self.Firsttable)
    }
    
        

    //==========FirstTableView===============上面===================
    
    
    func setupPlanTable()
    {
        self.PlanTable = PlanTableView(frame:CGRectMake(2*self.view.frame.width
            , 20+60*高比例, self.view.frame.width, 604*高比例))
        
        //创建一个重用的单元格
        self.PlanTable!.registerClass(PlanTableViewCell.self, forCellReuseIdentifier: "MsgCell")
        self.PlanTable.didSelectDelegate=self
        self.PlanTable.reloadData()
        
        BG_ScrollView.addSubview(self.PlanTable)
    }
    
    
    
    //==========PlanTableView===============上面===================
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //BG_PageControl滑动结束更换seg图片
        let index = Int(scrollView.contentOffset.x/self.view.frame.size.width)
        initSeg()
        if index == 1
        {
            dian.frame = CGRectMake(195*宽比例,20+40*高比例,5*宽比例,5*高比例)
            self.seg_2.setBackgroundImage(推荐, forState: UIControlState.Normal)
        }
        else if index == 2
        {
            dian.frame = CGRectMake(295*宽比例,20+40*高比例,5,5*高比例)
            self.seg_3.setBackgroundImage(广场, forState: UIControlState.Normal)
        }
        else
        {
            dian.frame = CGRectMake(105*宽比例,20+40*高比例,5*宽比例,5*高比例)
            self.seg_1.setBackgroundImage(资讯, forState: UIControlState.Normal)
        }
        
    }
    
    func initSeg()
    {
        self.seg_1.setBackgroundImage(资讯_未, forState: UIControlState.Normal)
        self.seg_2.setBackgroundImage(推荐_未, forState: UIControlState.Normal)
        self.seg_3.setBackgroundImage(广场_未, forState: UIControlState.Normal)
    }
    
    //点击seg图片，BG_PageControl调到seg指定位置
    func segClick(seg:UIButton)
    {
        initSeg()
        switch(seg.titleLabel!.text!)
        {
        case "seg_1":
            dian.frame = CGRectMake(105*宽比例,20+40*高比例,5*宽比例,5*高比例)
            self.seg_1.setBackgroundImage(资讯, forState: UIControlState.Normal)
            BG_ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
            break
        case "seg_2":
            dian.frame = CGRectMake(195*宽比例,20+40*高比例,5,5*高比例)
            self.seg_2.setBackgroundImage(推荐, forState: UIControlState.Normal)
            BG_ScrollView.setContentOffset(CGPointMake(BG_ScrollView.frame.size.width, 0), animated: true)
            break
        case "seg_3":
            dian.frame = CGRectMake(295*宽比例,20+40*高比例,5*宽比例,5*高比例)
            self.seg_3.setBackgroundImage(广场, forState: UIControlState.Normal)
            BG_ScrollView.setContentOffset(CGPointMake(BG_ScrollView.frame.size.width*2, 0), animated: true)
            break
        default:
            break
        }
    }
    
    //底部按钮，跳转到指
    func tail_segClick(seg:UIButton)
    {
        switch(seg.titleLabel!.text!)
        {
        case "摄像":
            let nav = UINavigationController(rootViewController: shexiangController())
            self.presentViewController(nav, animated: true, completion: nil)
            break
        case "搜索":
            
            break
        default:
            break
        }
    }
    
    
    func 设置()
    {
        let begin = setupView(frame:self.view.frame)
        
        self.view.addSubview(begin)
    }
    
    func touClick()
    {
        tou_BcakGround = UIImageView(frame: CGRectMake(0, 0,200,self.view.frame.height))
        tou_BcakGround.backgroundColor=UIColor.whiteColor()
        tou_BcakGround.contentMode=UIViewContentMode.ScaleToFill
        self.view.addSubview(tou_BcakGround)
        
        tou_imageBcakGround = UIImageView(frame: CGRectMake(0, 20,200,120*高比例))
        tou_imageBcakGround.image = 上边背景
        tou_imageBcakGround.contentMode=UIViewContentMode.ScaleToFill
        self.view.addSubview(tou_imageBcakGround)
        
        bt_tou = UIButton(frame: CGRectMake(65*宽比例, 20*高比例, 70*宽比例,70*高比例))
        bt_tou.backgroundColor = UIColor.blackColor()
        bt_tou.layer.cornerRadius = 35*高比例
        bt_tou.layer.masksToBounds = true
        bt_tou.setBackgroundImage(头, forState: UIControlState.Normal)
        bt_tou.contentMode=UIViewContentMode.Center
        self.view.addSubview(bt_tou)
        
        tou_la_name = UILabel(frame: CGRectMake(25*宽比例, 95*高比例, 150*宽比例,20*高比例))
        tou_la_name.text = "Openrun Yiroote"
        tou_la_name.highlighted = true
        tou_la_name.font = UIFont.systemFontOfSize(20*宽比例)
        tou_la_name.textColor = UIColor.whiteColor()
        tou_la_name.textAlignment = NSTextAlignment.Center
        self.view.addSubview(tou_la_name)
        
        tou_bt_message = UIButton(frame: CGRectMake(40*宽比例, 160*高比例, 120*宽比例,40*高比例))
        tou_bt_message.backgroundColor = UIColor.whiteColor()
        tou_bt_message.addTarget(self, action: "fun_我的消息", forControlEvents: UIControlEvents.TouchUpInside)
        tou_bt_message.setBackgroundImage(我的消息, forState: UIControlState.Normal)
        self.view.addSubview(tou_bt_message)
        
        tou_bt_fatie = UIButton(frame: CGRectMake(40*宽比例, 220*高比例, 120*宽比例,40*高比例))
        tou_bt_fatie.backgroundColor = UIColor.whiteColor()
        tou_bt_fatie.addTarget(self, action: "fun_我的发帖", forControlEvents: UIControlEvents.TouchUpInside)
        tou_bt_fatie.setBackgroundImage(我的发帖, forState: UIControlState.Normal)
        tou_bt_fatie.contentMode=UIViewContentMode.Bottom
        self.view.addSubview(tou_bt_fatie)
        
        tou_bt_caogao = UIButton(frame: CGRectMake(40*宽比例, 280*高比例, 120*宽比例,40*高比例))
        tou_bt_caogao.backgroundColor = UIColor.whiteColor()
        tou_bt_caogao.addTarget(self, action: "fun_我的草稿", forControlEvents: UIControlEvents.TouchUpInside)
        tou_bt_caogao.setBackgroundImage(我的草稿, forState: UIControlState.Normal)
        self.view.addSubview(tou_bt_caogao)
        
        tou_bt_shoucang = UIButton(frame: CGRectMake(40*宽比例, 340*高比例, 120*宽比例,40*高比例))
        tou_bt_shoucang.backgroundColor = UIColor.whiteColor()
        tou_bt_shoucang.addTarget(self, action: "fun_我的收藏", forControlEvents: UIControlEvents.TouchUpInside)
        tou_bt_shoucang.setBackgroundImage(我的收藏, forState: UIControlState.Normal)
        self.view.addSubview(tou_bt_shoucang)
        
        tou_bt_cangyu = UIButton(frame: CGRectMake(40*宽比例, 400*高比例, 120*宽比例,40*高比例))
        tou_bt_cangyu.backgroundColor = UIColor.whiteColor()
        tou_bt_cangyu.addTarget(self, action: "fun_我的参与", forControlEvents: UIControlEvents.TouchUpInside)
        tou_bt_cangyu.setBackgroundImage(我的参与, forState: UIControlState.Normal)
        self.view.addSubview(tou_bt_cangyu)
        
        tou_bt_luoluobi = UIButton(frame: CGRectMake(40*宽比例, 460*高比例, 120*宽比例,40*高比例))
        tou_bt_luoluobi.backgroundColor = UIColor.whiteColor()
        tou_bt_luoluobi.setBackgroundImage(我的洛洛币, forState: UIControlState.Normal)
        tou_bt_luoluobi.addTarget(self, action: "fun_我的洛洛币", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tou_bt_luoluobi)
        
        
        tou_bt_back = UIButton(frame: CGRectMake(50, self.view.frame.height-80*高比例, 40*宽比例,40*高比例))
        tou_bt_back.backgroundColor = UIColor.whiteColor()
        tou_bt_back.layer.cornerRadius = 20*高比例
        tou_bt_back.layer.masksToBounds = true
        tou_bt_back.setBackgroundImage(返回图标, forState: UIControlState.Normal)
        tou_bt_back.addTarget(self, action: #selector(MainViewController.tou_back), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tou_bt_back)

        self.蒙图=UIButton(frame:CGRectMake(200,0,self.view.frame.width,self.view.frame.height))
        self.蒙图.backgroundColor=UIColor.blackColor()
        self.蒙图.alpha=0.3
        self.蒙图.addTarget(self, action: Selector("show_tou"), forControlEvents: UIControlEvents.TouchUpInside)
        self.tou.removeFromSuperview()
        self.view.addSubview(蒙图)
        
    }
    
    func show_tou()
    {
        self.tou_bt_back.removeFromSuperview()
        self.tou_bt_luoluobi.removeFromSuperview()
        self.tou_bt_cangyu.removeFromSuperview()
        self.tou_bt_shoucang.removeFromSuperview()
        self.tou_bt_caogao.removeFromSuperview()
        self.tou_bt_fatie.removeFromSuperview()
        self.tou_bt_message.removeFromSuperview()
        self.tou_la_name.removeFromSuperview()
        self.bt_tou.removeFromSuperview()
        self.tou_imageBcakGround.removeFromSuperview()
        self.tou_BcakGround.removeFromSuperview()

        self.view.addSubview(tou)
        self.蒙图.removeFromSuperview()
    }
    
    func fun_我的消息()
    {
        let other = Message()
    }
    
    func fun_我的发帖()
    {
        
    }
    
    func fun_我的草稿()
    {
        
    }
    
    func fun_我的收藏()
    {
        
    }
    
    func fun_我的参与()
    {
        
    }
    
    func fun_我的洛洛币()
    {
        print("我的洛洛币")
    }
    
    func tou_back()
    {
        print("退出")
        let userDefault = NSUserDefaults.standardUserDefaults()//返回NSUserDefaults对象
        userDefault.setObject("", forKey: "uid")
        userDefault.setObject("", forKey: "username")
        userDefault.setObject("", forKey: "pwd")
        userDefault.synchronize()//同步
        let login=LoginViewController()
        self.presentViewController(login, animated: true, completion: nil)
    }
    

    
    /*First_Table_Delegate*/
    func First_Table_DidSelect(index: Int,bubbleSection:FirstTableMessageItem) {
        print("输出",index)
        let FirstTableDetailCotroller = FirstTableDetailController()
        FirstTableDetailCotroller.bubbleSection = bubbleSection
        self.navigationController?.pushViewController(FirstTableDetailCotroller, animated: true)
    }

    /** Second_ScrollViewDelegate*/
    func Second_numberOfPages() -> Int {
        
        return Second_imageArray.count;
    }
    func Second_currentPageViewIndex(index: Int) -> String {
        
        return Second_imageArray[index]
    }
    func Second_didSelectCurrentPage(index: Int) {
    }
    
    /*Plan_Table_Delegate*/
    func Plan_Table_DidSelect(index: Int,bubbleSection:PlanTableMessageItem) {
        print("输出",index)
        if(index<10)
        {
            let PlanTableCotroller = PlanTableDetailController()
            PlanTableCotroller.bubbleSection = bubbleSection
            self.navigationController?.pushViewController(PlanTableCotroller, animated: true)
        }
        else
        {
            
        }
    }
    
    func 关注(btn:UIButton)
    {
        是否关注 = !是否关注
        if 是否关注 == true
        {
            btn.backgroundColor = UIColor.redColor()
        }
        else
        {
            btn.backgroundColor = UIColor.grayColor()
        }
    }
    

}