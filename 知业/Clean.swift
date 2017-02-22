//
//  Clean.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/6/2.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation

class Clean {
    static var MyClean:Clean?
    static var predicate:dispatch_once_t = 0
    class func sharedLoginModel()->Clean?{
        
        dispatch_once(&predicate) { () -> Void in
            MyClean = Clean()
        }
        return MyClean
    }
    
    func cleanOtherUser(username:String)
    {
        MySQL.shareMySQL().deleteOtherUser(username)
        zhiyeDirectory.sharezhiyeDir().zhiyeDeleteOtherDirectory(username)
    }
    
    
    
}