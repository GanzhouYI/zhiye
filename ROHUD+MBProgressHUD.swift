//
//  ROHUD+MBProgressHUD.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/4/15.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation
import CoreAudioKit
extension MBProgressHUD
{
    static func showDelayHUDToView(view:UIView,message:String)
    {
        let hud = MBProgressHUD(view:view)
        view.addSubview(hud)
        print("MBHUYD")
        print(view.frame)
        print(hud.frame)
        //hud.yOffset = -Float(view.frame.size.height)/4
        print(hud.frame)
        hud.customView = UIImageView(frame:CGRectZero)//没有图形
        hud.mode = MBProgressHUDMode.CustomView
        hud.labelText = message
        hud.show(true)
        hud.hide(true,afterDelay:1.0)
    }
}