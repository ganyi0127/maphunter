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
let calendar_notiy = NSNotification.Name("calendar")

//当前选择的日期
var selectDate = Date()

//运动数据颜色
struct SportColor{
    static let running = UIColor(red: 27 / 255, green: 227 / 255, blue: 114 / 255, alpha: 1)
    static let walking = UIColor(red: 82 / 255, green: 158 / 255, blue: 242 / 255, alpha: 1)
    static let riding = UIColor(red: 251 / 255, green: 196 / 255, blue: 61 / 255, alpha: 1)
}

//背景颜色
let defaultColor = UIColor.white                                                        //navigation颜色
let timeColor = UIColor(red: 238 / 255, green: 243 / 255, blue: 244 / 255, alpha: 1)    //时间轴主颜色
let subWordColor = UIColor(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1) //灰文字颜色颜色
let wordColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1)       //文字颜色

let modelStartColors: [DataCubeType: UIColor] = [
    .sport: UIColor(red: 245 / 255, green: 102 / 255, blue: 46 / 255, alpha: 1),
    .heartrate: UIColor(red: 251 / 255, green: 90 / 255, blue: 147 / 255, alpha: 1),
    .sleep: UIColor(red: 2 / 255, green: 160 / 255, blue: 206 / 255, alpha: 1),
    .weight: UIColor(red: 45 / 255, green: 196 / 255, blue: 148 / 255, alpha: 1)]

let modelEndColors: [DataCubeType: UIColor] = [
    .sport: UIColor(red: 241 / 255, green: 68 / 255, blue: 51 / 255, alpha: 1),
    .heartrate: UIColor(red: 232 / 255, green: 55 / 255, blue: 134 / 255, alpha: 1),
    .sleep: UIColor(red: 0 / 255, green: 130 / 255, blue: 168 / 255, alpha: 1),
    .weight: UIColor(red: 55 / 255, green: 183 / 255, blue: 128 / 255, alpha: 1)]
