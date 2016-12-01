//
//  Configure.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit

//尺寸
let view_size = UIScreen.main.bounds.size

//navigation高度
var navigation_height:CGFloat?

//通用字体、颜色
let font_name = "GillSans-Italic"
let defaut_color = UIColor.orange

let notiy = NotificationCenter.default
let unselect_notiy = NSNotification.Name(rawValue: "unselect")
let switch_notiy = NSNotification.Name("switch")

//当前选择的日期
var selectDate = Date()

//运动数据颜色
struct SportColor{
    static let running = UIColor(red: 27 / 255, green: 227 / 255, blue: 114 / 255, alpha: 1)
    static let walking = UIColor(red: 82 / 255, green: 158 / 255, blue: 242 / 255, alpha: 1)
    static let riding = UIColor(red: 251 / 255, green: 196 / 255, blue: 61 / 255, alpha: 1)
}

//背景颜色
let defaultColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
