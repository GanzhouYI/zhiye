//
//  ViewController.swift
//  SwiftInAction-008-016
//
//  Created by zhihua on 14-7-13.
//  Copyright (c) 2014年 ucai. All rights reserved.
//

import UIKit
import AssetsLibrary

var sendData = [ALAsset]()

class SendViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var collectionView:UICollectionView!
    var add_icon = UIImage(named: "gouxuan_icon.png")
        override func viewDidLoad() {
        super.viewDidLoad()
            print("开始")
            
            self.title = "发送"
            self.view.backgroundColor = UIColor.whiteColor()

            let backBtn = UIBarButtonItem(title: "图库", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SendViewController.fun_返回图库))
            self.navigationItem.leftBarButtonItem = backBtn
            
            let cancle = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SendViewController.send))
            self.navigationItem.rightBarButtonItem = cancle
            
            let say = UITextView(frame: CGRectMake(10,66,self.view.frame.width-20,100))
            say.font = UIFont.systemFontOfSize(15)
            say.layer.borderWidth = 2
            self.automaticallyAdjustsScrollViewInsets = false//导航栏高度问题
            say.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(say)
            
            let layout = SendPicLayout()
            //let layout = UICollectionViewFlowLayout()
            self.collectionView = UICollectionView(frame: CGRectMake(0,166+10,view.bounds.size.width,self.view.frame.height-166-60), collectionViewLayout:layout)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            // 注册CollectionViewCell
            self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ViewCell")
            //默认背景是黑色和label一致
            self.collectionView.backgroundColor = UIColor.whiteColor()
            var im = UIImageView(frame: CGRectMake(0,GetcollectionViewHeight(sendData.count+1),self.view.frame.width,50))
            im.backgroundColor = UIColor.grayColor()
            self.collectionView.addSubview(im)
            self.view.addSubview(collectionView)
            
    }
    
    // CollectionView行数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(sendData.count)
        return sendData.count+1;
    }
    
    // 获取单元格
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "ViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath)
        if indexPath.row == sendData.count
        {
            let img = UIImageView()
            img.image = add_icon
            cell.layer.borderWidth = 1
            img.frame = cell.bounds
            cell.addSubview(img)
        }
        else
        {
            // 添加图片
            let myAsset = sendData[indexPath.item]
            let img = UIImageView()
            //获取文件名
            let representation =  myAsset.defaultRepresentation()
            //获取原图
            let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
            let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                length: Int(representation.size()), error: nil)
            let data =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
            img.image = UIImage(data: data)
        
            cell.layer.borderWidth = 0
            img.frame = cell.bounds
            // 图片上面显示课程名称，居中显示
        
            cell.addSubview(img)
        }
        
        return cell
    }

    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == sendData.count
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            let Edit = Editing()
            // 添加图片
            let myAsset = sendData[indexPath.item]
            //获取文件名
            let representation =  myAsset.defaultRepresentation()
            //获取原图
            let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
            let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                length: Int(representation.size()), error: nil)
            let data =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
            
            Edit.EditImage = UIImage(data: data)!
            self.navigationController?.pushViewController(Edit, animated: true)
        }
    }
    
    
    func fun_返回图库()
    {
        print("back")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func send()
    {
        SourceChice.removeAll()
        assets.removeAll()
        sendData.removeAll()
        let Main = MainViewController()
        self.presentViewController(Main, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}