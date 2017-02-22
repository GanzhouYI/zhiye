//
//  ViewController.swift
//  SwiftInAction-008-016
//
//  Created by zhihua on 14-7-13.
//  Copyright (c) 2014年 ucai. All rights reserved.
//

import UIKit
import AssetsLibrary

//let screenBounds:CGRect = UIScreen.mainScreen().bounds//屏幕大小

//资源库管理类
var assetsLibrary =  ALAssetsLibrary()
//保存照片集合
var assets = [ALAsset]()

public func GetImageFromAssets(indexPath:Int)->NSData
{
    let myAsset = assets[indexPath]
        //获取文件名
    let representation =  myAsset.defaultRepresentation()
    //获取原图
    let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
    let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
        length: Int(representation.size()), error: nil)
    let data =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
    return data
}
//================================================

public func GetcollectionViewHeight(NumOfassets:Int)->CGFloat
{
    //============================================
    //根据相机相片数量或选中的相片数量设置collectionView的高度
    let width = Int((screenBounds.width - 5*5)/4+5)
    let num = NumOfassets / 4
    var collectionViewHeight:CGFloat!
    if NumOfassets>4
    {
        if NumOfassets%4 == 0
        {
            collectionViewHeight = CGFloat(5+num*width)
        }
        else
        {
            collectionViewHeight = CGFloat(5+(num+1)*width)
        }
    }
    else
    {
        collectionViewHeight = CGFloat(10+width)
    }
    
    return collectionViewHeight

}


var SourceChice = [String]()


class shexiangController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate
{
    var CellY:CGFloat = 0
    var CellX:CGFloat = 0
    var CellWIdth:CGFloat = 0
    var btnX = [CGFloat]()
    var btnY = [CGFloat]()
    
    var collectionView:UICollectionView!
    var gouxuan_icon_selected = UIImage(named: "gouxuan_icon_selected.png")
    var gouxuan_icon = UIImage(named: "gouxuan_icon.png")
    var paishe_icon = UIImage(named: "拍摄.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.

        GetImageFromiPhone()
        
        let back_BarItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = back_BarItem
        
        let send_BarItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendALL")
        self.navigationItem.rightBarButtonItem = send_BarItem
        
        self.title = "图库"
        
        let layout = ChosePicLayout()
        //let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRectMake(0,10,view.bounds.size.width,self.view.frame.height-70-(self.navigationController?.navigationBar.frame.height)!), collectionViewLayout:layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 注册CollectionViewCell
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ViewCell")
        //默认背景是黑色和label一致
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        var send = UIButton(frame: CGRectMake(0,self.view.frame.height-60,self.view.frame.width,60))
        send.setTitle("", forState: UIControlState.Normal)
        send.setBackgroundImage(paishe_icon, forState: UIControlState.Normal)
        //send.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)
        send.backgroundColor = UIColor.grayColor()
        self.view.addSubview(send)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func GetImageFromiPhone(){
        var countOne = 0
        //ALAssetsGroupSavedPhotos表示只读取相机胶卷（ALAssetsGroupAll则读取全部相簿）
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {
            (group: ALAssetsGroup!, stop) in
            print("is goin")
            if group != nil
            {
                let assetBlock : ALAssetsGroupEnumerationResultsBlock = {
                    (result: ALAsset!, index: Int, stop) in
                    if result != nil
                    {
                        assets.append(result)
                        countOne++
                    }
                }
                group.enumerateAssetsUsingBlock(assetBlock)
                print("assets:\(assets.count)")
                print("testtestteztre")
                print(sendData)
                print(assets)
                GetcollectionViewHeight(assets.count)
                //collectionView网格重载数据
                self.collectionView?.reloadData()
            }
            }, failureBlock: { (fail) in
                print(fail)
        })

}
    
    
    // CollectionView行数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count;
    }
    
    // 获取单元格
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "ViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath)
        self.CellWIdth = cell.bounds.size.width
        self.CellX = cell.frame.origin.x
        self.CellY = cell.frame.origin.y
        // 添加图片
        let img = UIImageView()
        img.image = UIImage(data: GetImageFromAssets(indexPath.row))
        
        let btn = UIButton(frame:CGRectMake(cell.bounds.size.width-5-20,5,20,20))
        btn.setBackgroundImage(gouxuan_icon, forState: UIControlState.Normal)
        btn.addTarget(self, action: "ChisePic:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.titleLabel!.text = String(indexPath.item)
        self.btnX.append(btn.frame.origin.x)
        self.btnY.append(btn.frame.origin.y)
        if sendData.contains(assets[indexPath.item])
        {
            SourceChice.append(btn.titleLabel!.text!)
            btn.frame = CGRectMake(btnX[Int(btn.titleLabel!.text!)!]-(CellWIdth-5-20), btnY[Int(btn.titleLabel!.text!)!]-5, CellWIdth, CellWIdth)
            //btn.backgroundColor = UIColor.whiteColor()
            //btn.alpha = 0.3
            btn.setBackgroundImage(gouxuan_icon_selected, forState: UIControlState.Normal)
        }
        
        img.frame = cell.bounds
        // 图片上面显示课程名称，居中显示
        
        cell.addSubview(img)
        cell.addSubview(btn)
        
        return cell
    }
    
        

    
    
        /* 自定义布局不需要调用
    //单元格大小
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let size:Float = indexPath.item % 3 == 0 ? 200 : 100
        return CGSize(width:size, height:size)
    }
    */
    
    
}