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
let font_name = "AvenirNextCondensed-DemiBold"
let fontTiny = UIFont(name: font_name, size: 9)!
let fontSmall = UIFont(name: font_name, size: 12)!
let fontMiddle = UIFont(name: font_name, size: 17)!
let fontBig = UIFont(name: font_name, size: 24)!
let fontHuge = UIFont(name: font_name, size: 44)!

let defaut_color = UIColor.orange

let notiy = NotificationCenter.default
let unselect_notiy = NSNotification.Name(rawValue: "unselect")
let switch_notiy = NSNotification.Name("switch")
let calendar_notiy = NSNotification.Name("calendar")

//当前选择的日期
var selectDate = Date()

//运动数据颜色
struct SportColor{
    static let running = UIColor(red: 249 / 255, green: 107 / 255, blue: 30 / 255, alpha: 1)
    static let walking = UIColor(red: 48 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1)
    static let riding = UIColor(red: 251 / 255, green: 196 / 255, blue: 61 / 255, alpha: 1)
}

//背景颜色
let defaultColor = UIColor.white                                                            //navigation颜色
let timeColor = UIColor(red: 238 / 255, green: 243 / 255, blue: 244 / 255, alpha: 1)        //时间轴主颜色
let lightWordColor = UIColor(red: 217 / 255, green: 217 / 255, blue: 217 / 255, alpha: 1)   //高亮文字颜色
let subWordColor = UIColor(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1)     //灰文字颜色颜色
let wordColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1)           //文字颜色

let modelStartColors: [DataCubeType: UIColor] = [
    .sport: UIColor(red: 245 / 255, green: 113 / 255, blue: 41 / 255, alpha: 1),
    .heartrate: UIColor(red: 54 / 255, green: 172 / 255, blue: 205 / 255, alpha: 1),
    .sleep: UIColor(red: 92 / 255, green: 43 / 255, blue: 143 / 255, alpha: 1),
    .weight: UIColor(red: 63 / 255, green: 205 / 255, blue: 140 / 255, alpha: 1)]

let modelEndColors: [DataCubeType: UIColor] = [
    .sport: UIColor(red: 241 / 255, green: 68 / 255, blue: 52 / 255, alpha: 1),
    .heartrate: UIColor(red: 46 / 255, green: 143 / 255, blue: 188 / 255, alpha: 1),
    .sleep: UIColor(red: 57 / 255, green: 16 / 255, blue: 122 / 255, alpha: 1),
    .weight: UIColor(red: 2 / 255, green: 183 / 255, blue: 153 / 255, alpha: 1)]
