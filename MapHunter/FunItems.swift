//
//  FunItems.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
let itemColors = [
    UIColor(red: 249/255, green: 84/255,  blue: 7/255,   alpha: 1),
    UIColor(red: 69/255,  green: 59/255,  blue: 55/255,  alpha: 1),
    UIColor(red: 249/255, green: 194/255, blue: 7/255,   alpha: 1),
    UIColor(red: 32/255,  green: 188/255, blue: 32/255,  alpha: 1),
    UIColor(red: 207/255, green: 34/255,  blue: 156/255, alpha: 1),
    UIColor(red: 14/255,  green: 88/255,  blue: 149/255, alpha: 1),
    UIColor(red: 15/255,  green: 193/255, blue: 231/255, alpha: 1)
]

enum FunItemType{
    case path
    case recommendRoute
    case myRoute
    case sprite
}

class FunItems {
    
    static var sharedItems:[FunItems] {
        var items = [FunItems]()
        
        items.append(FunItems(type: .path, color: itemColors[0]))
        items.append(FunItems(type: .recommendRoute, color: itemColors[1]))
        items.append(FunItems(type: .myRoute, color: itemColors[2]))
        items.append(FunItems(type: .sprite, color: itemColors[3]))
        return items
    }
    
    let type: FunItemType   //类型
    let color: UIColor      //背景色
    
    init(type: FunItemType, color: UIColor) {
        self.type = type
        self.color = color
    }
}
