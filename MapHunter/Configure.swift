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
