
//  衣洛特V|R__________ on 16/1/14.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import UIKit
let  screenBounds:CGRect = UIScreen.mainScreen().bounds
let 宽比例 = screenBounds.width/414
let 高比例 = screenBounds.height/736

class MainViewController:UIViewController,UIScrollViewDelegate,First_Table_Delegate,Second_ScrollView_Delegate, SecondTableDataSource,Plan_Table_Delegate{
    var BG_ScrollView = UIScrollView()
    var BG_delegate = UIScrollViewDelegate?()
    
    let Pic = ["beautiful1.png","beautiful2.png","beautiful3.png","beautiful4.png"]
    let biaoqian1 = ["biaoqian1","biaoqian2","biaoqian3","biaoqian4"]
    let Detail = ["123","234","345","456"]
    let biaoqian2 = ["biaoqian1","biaoqian2","biaoqian3","biaoqian4"]
    var SecondtableData = [SecondTableMessageItem]()
    var Secondtable:SecondTableView!
    
    let FirstTableImage = ["beautiful1.png","beautiful2.png","beautiful3.png","beautiful4.png"]
    let FirstTablebiaoqian = ["fanbiaoqian1","fanbiaoqian2","fanbiaoqian3","fanbiaoqian4"]
    let FirstTableTitle = ["中国人民一二三四五六七八九十","中国人民一二三四五六七八九十中国人民","345","abcABC"]
    let FirstTableDetail = ["中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十","中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十中国人民一二三四五六七八九十","一二三四五六七八九十","中国人民一二三四五六七八九十"]

    let FirstTable_yanjin_Num = [11111111,22222222,3333,4]
    let FirstTable_pinglun_Num = [111111,22222222,3333,44444444]
    var Firsttable:FirstTableView!
    
    var PlanTable:PlanTableView!
    
    let 资讯 = UIImage(named: "资讯")
    let 推荐 = UIImage(named: "推荐")
    let 广场 = UIImage(named: "广场")
    let 资讯_未 = UIImage(named: "资讯未")
    let 推荐_未 = UIImage(named: "推荐未")
    let 广场_未 = UIImage(named: "广场未")
    let 蓝色小点 = UIImage(named: "蓝色小点")
    let 设置图片 = UIImage(named: "设置灰色图标")
    let 头 = UIImage(named: "头像")
    
    let seg1_未 = UIImage(named: "seg未点击第1张图片")
    let seg2_未 = UIImage(named: "seg未点击第2张图片")
    let seg3_未 = UIImage(named: "seg未点击第3张图片")
    let seg1 = UIImage(named: "seg点击第1张图片")
    let seg2 = UIImage(named: "seg点击第2张图片")
    let seg3 = UIImage(named: "seg点击第3张图片")

    let tail_image_seg1 = UIImage(named: "分类搜索")
    let tail_image_seg2 = UIImage(named: "主页")
    let tail_image_seg3 = UIImage(named: "相机")
    let tail_image_seg4 = UIImage(named: "我的消息")
    let tail_image_seg5 = UIImage(named: "周边")
    
    let biaoqian = UIImage(named: "biaoqian2")
    let fanbiaoqian = UIImage(named: "fanbiaoqian2")

    var 是否关注:Bool = false

    var Second_Scroll = Second_ScrollView()
    var Second_imageArray :[String!] = ["beautiful1.png","beautiful2.png","beautiful3.png","beautiful4.png"]
   
    let 上边背景 = UIImage(named:   "个人中心图标")
    let 头像 = UIImage(named: "蓝圆")
    let 我的消息 = UIImage(named: "我的消息")
    let 我的发帖 = UIImage(named: "我的发帖")
    let 我的草稿 = UIImage(named: "我的草稿")
    let 我的收藏 = UIImage(named: "我的收藏")
    let 我的参与 = UIImage(named:"我的参与")
    let 我的洛洛币 = UIImage(named: "我的洛洛币")
    let 返回图标 = UIImage(named:"返回图标")

    
    var headToolbar = UIToolbar()
    var tailToolbar = UIToolbar()
    
    var 蒙图 = UIButton()
    var tou_bt_back = UIButton()
    var tou_bt_luoluobi = UIButton()
    var tou_bt_cangyu = UIButton()
    var tou_bt_shoucang = UIButton()
    var tou_bt_caogao = UIButton()
    var tou_bt_fatie = UIButton()
    var tou_bt_message = UIButton()
    var tou_la_name = UILabel()
    var bt_tou = UIButton()
    var  tou_imageBcakGround = UIImageView()
    var  tou_BcakGround=UIImageView()
    var tou = UIButton(frame: CGRectMake(10*宽比例, 20, 宽比例*60, 高比例*60))
    
    var btn = UIButton()
    var seg_1 = UIButton(frame: CGRectMake(宽比例*90, 20+10*高比例, 宽比例*35, 30*高比例))
    var seg_2 = UIButton(frame: CGRectMake(180*宽比例, 20+10*高比例, 宽比例*35, 30*高比例))
    var seg_3 = UIButton(frame: CGRectMake(280*宽比例, 20+10*高比例, 宽比例*35, 30*高比例))
    var dian = UIImageView(frame: CGRectMake(105*宽比例,20+40*高比例,5*宽比例,5*高比例))
    var shezhi = UIButton(frame: CGRectMake(360*宽比例, 20+10*高比例, 35*宽比例, 35*高比例))
    
    var tail_seg1 = UIButton()
    var tail_seg2 = UIButton()
    var tail_seg3 = UIButton()
    var tail_seg4 = UIButton()
    var tail_seg5 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent=false
        self.navigationController?.navigationBarHidden=true
        MyNotification.sharedMyNotification()!.scheduleNotification(12345)
        
        setupFirstTable()
        setupSecondTable()
        setupPlanTable()
        
        BG_ScrollView.frame = self.view.bounds
        BG_ScrollView.contentSize = CGSizeMake(3*self.view.frame.width,0)
        BG_ScrollView.pagingEnabled = true
        BG_ScrollView.bounces = false//弹簧效果
        BG_ScrollView.showsHorizontalScrollIndicator = false//水平导航条
        BG_ScrollView.delegate = self
        self.view.addSubview(BG_ScrollView)
        
        
        Second_Scroll = Second_ScrollView(frame: CGRectMake(2*self.view.frame.width+10*宽比例, 20+170*高比例, self.view.frame.width-20*宽比例, 150*高比例))
        Second_Scroll.backgroundColor = UIColor.clearColor()
        Second_Scroll.delegate = self
       // BG_ScrollView.addSubview(Second_Scroll)
        
        headToolbar = UIToolbar(frame: CGRectMake(0,20,self.view.frame.width,60*高比例))
        self.view.addSubview(headToolbar)
        
        tou.backgroundColor = UIColor.whiteColor()
        tou.layer.cornerRadius = 30*高比例
        tou.layer.masksToBounds = true
        tou.setBackgroundImage(头, forState: UIControlState.Normal)
        tou.addTarget(self, action: "touClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tou)
        
        let segImage_1 = 资讯
        seg_1.setBackgroundImage(segImage_1, forState: UIControlState.Normal)
        seg_1.setTitle("seg_1", forState: UIControlState.Normal)
        seg_1.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        seg_1.addTarget(self, action: "segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(seg_1)
        
        dian.image = 蓝色小点
        self.view.addSubview(dian)
        
        let segImage_2 = 推荐_未
        seg_2.setBackgroundImage(segImage_2, forState: UIControlState.Normal)
        seg_2.setTitle("seg_2", forState: UIControlState.Normal)
        seg_2.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        seg_2.addTarget(self, action: "segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(seg_2)
        
        let segImage_3 = 广场_未
        seg_3.setBackgroundImage(segImage_3, forState: UIControlState.Normal)
        seg_3.setTitle("seg_3", forState: UIControlState.Normal)
        seg_3.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        seg_3.addTarget(self, action: "segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(seg_3)
        
        shezhi.setBackgroundImage(设置图片, forState: UIControlState.Normal)
        shezhi.setTitle("shezhi", forState: UIControlState.Normal)
        shezhi.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        shezhi.addTarget(self, action: "设置", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(shezhi)
        
        
        tailToolbar = UIToolbar(frame: CGRectMake(0,self.view.frame.height-20-30*高比例,self.view.frame.width,50*高比例))
        self.view.addSubview(tailToolbar)
        
        tail_seg1 = UIButton(frame: CGRectMake(30*宽比例,self.view.frame.height-20-20*高比例,30*宽比例,30*高比例))
        tail_seg1.setBackgroundImage(tail_image_seg1, forState: UIControlState.Normal)
        tail_seg1.setTitle("search", forState: UIControlState.Normal)
        tail_seg1.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        tail_seg1.addTarget(self, action: "tail_segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tail_seg1)

        
        tail_seg2 = UIButton(frame: CGRectMake(110*宽比例,self.view.frame.height-20-20*高比例,30*宽比例,30*高比例))
        tail_seg2.setBackgroundImage(tail_image_seg2, forState: UIControlState.Normal)
        tail_seg2.setTitle("tail_seg2", forState: UIControlState.Normal)
        tail_seg2.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        tail_seg2.addTarget(self, action: "tail_segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tail_seg2)
        
        tail_seg3 = UIButton(frame: CGRectMake(180*宽比例,self.view.frame.height-20-40*高比例,50*宽比例,50*高比例))
        tail_seg3.setBackgroundImage(tail_image_seg3, forState: UIControlState.Normal)
        tail_seg3.setTitle("摄像", forState: UIControlState.Normal)
        tail_seg3.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        tail_seg3.addTarget(self, action: "tail_segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tail_seg3)
        
        tail_seg4 = UIButton(frame: CGRectMake(270*宽比例,self.view.frame.height-20-20*高比例,30*宽比例,30*高比例))
        tail_seg4.setBackgroundImage(tail_image_seg4, forState: UIControlState.Normal)
        tail_seg4.setTitle("tail_seg4", forState: UIControlState.Normal)
        tail_seg4.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        tail_seg4.addTarget(self, action: "tail_segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tail_seg4)
        
        tail_seg5 = UIButton(frame: CGRectMake(350*宽比例,self.view.frame.height-20-20*高比例,30*宽比例,30*高比例))
        tail_seg5.setBackgroundImage(tail_image_seg5, forState: UIControlState.Normal)
        tail_seg5.setTitle("tail_seg5", forState: UIControlState.Normal)
        tail_seg5.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        tail_seg5.addTarget(self, action: "tail_segClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tail_seg5)
        
        /*
        var la_left = UIButton(frame: CGRectMake(self.view.frame.width*2+self.view.frame.width/2-(25+5+80)*宽比例, 20+90*高比例, 80*宽比例, 20*高比例))
        la_left.setTitle("标签1", forState: UIControlState.Normal)
        la_left.setBackgroundImage(fanbiaoqian, forState: UIControlState.Normal)
        la_left.titleLabel?.font = UIFont.systemFontOfSize(20*高比例)
        la_left.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(la_left)
        
        var small_head = UIButton(frame: CGRectMake(self.view.frame.width*2+self.view.frame.width/2-25*宽比例, 20+70*高比例, 宽比例*50, 50*高比例))
        small_head.setBackgroundImage(头, forState: UIControlState.Normal)
        small_head.layer.cornerRadius = 25*高比例
        small_head.layer.masksToBounds = true
        small_head.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(small_head)
        
        var la_right = UIButton(frame: CGRectMake(self.view.frame.width*2+self.view.frame.width/2+(25+5)*宽比例, 20+90*高比例, 80*宽比例, 20*高比例))
        la_right.setTitle("标签2", forState: UIControlState.Normal)
        la_right.titleLabel?.font = UIFont.systemFontOfSize(20*高比例)
        la_right.setBackgroundImage(biaoqian, forState: UIControlState.Normal)
        la_right.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(la_right)
        
        
        var la_name = UILabel(frame: CGRectMake(self.view.frame.width*2+self.view.frame.width/2-75*宽比例,20+130*高比例, 150*宽比例, 20*高比例))
        la_name.text = "Openrun Yiroote"
        la_name.font = UIFont.systemFontOfSize(20*高比例)
        la_name.textAlignment = NSTextAlignment.Center
        BG_ScrollView.addSubview(la_name)
        
        
        var bt_guanzhu = UIButton(frame: CGRectMake(self.view.frame.width*2+self.view.frame.width-(20+30)*宽比例,110+20*高比例, 40*宽比例, 20*高比例))
        bt_guanzhu.setTitle("关注", forState: UIControlState.Normal)
        //bt_guanzhu.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        bt_guanzhu.titleLabel?.font = UIFont(name:"Zapfino", size:13*高比例)
        bt_guanzhu.backgroundColor = UIColor.grayColor()
        bt_guanzhu.layer.cornerRadius = 10*高比例
        bt_guanzhu.addTarget(self, action: "关注:", forControlEvents: UIControlEvents.TouchUpInside)
        BG_ScrollView.addSubview(bt_guanzhu)

        var textview = UITextView(frame: CGRectMake(self.view.frame.width*2+20*宽比例,20+325*高比例,self.view.frame.width-20*宽比例,42*高比例))
        textview.layer.borderWidth=0  //边框粗细
        textview.editable=false
        textview.selectable=false
        //设置边框样式为圆角矩形
        textview.text = "从天南到海北，再从海北到天南，当所有繁华红尘都斑斑落尽的时候，我会回来。"
        textview.font = UIFont.systemFontOfSize(15*高比例)
        BG_ScrollView.addSubview(textview)*/
        
    }
    
    
        //UIViewAnimationOptions 出来的方式
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}