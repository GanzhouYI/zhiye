
//
//  MainViewController_P.swift
//  衣洛特
//
//  Created by __________V|R__________ on 16/6/3.
//  Copyright © 2016年 __________V|R__________. All rights reserved.
//

import Foundation

protocol First_Table_Delegate :NSObjectProtocol{
    
    func First_Table_DidSelect(index : Int,bubbleSection:FirstTableMessageItem)

}

protocol Plan_Table_Delegate :NSObjectProtocol{
    
    func Plan_Table_DidSelect(index : Int,bubbleSection:PlanTableMessageItem)
    
}