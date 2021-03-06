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
var navigation_height: CGFloat?

//通用字体、颜色
let font_name = "PingFangTC-Medium"
let fontTiny = UIFont(name: font_name, size: 9)!
let fontSmall = UIFont(name: font_name, size: 12)!
let fontMiddle = UIFont(name: font_name, size: 17)!
let fontBig = UIFont(name: font_name, size: 24)!
let fontHuge = UIFont(name: font_name, size: 44)!

//推送 /类型
let notiy = NotificationCenter.default
let unselect_notiy = NSNotification.Name(rawValue: "unselect")
let switch_notiy = NSNotification.Name("switch")
let calendar_notiy = NSNotification.Name("calendar")

//userDefaults
let userDefaults = UserDefaults.standard

//当前选择的日期
var selectDate = Date()

//当天日期
var preToday = Date()

//运动数据颜色
struct SportColor{
    static let running = UIColor(red: 249 / 255, green: 107 / 255, blue: 30 / 255, alpha: 1)
    static let walking = UIColor(red: 48 / 255, green: 114 / 255, blue: 225 / 255, alpha: 1)
    static let riding = UIColor(red: 251 / 255, green: 196 / 255, blue: 61 / 255, alpha: 1)
}

//趣玩背景图
let pathImg = UIImage(named: "resource/map/background/path")//?.transfromImage(size: view_size)
let recommendRouteImg = UIImage(named: "resource/map/background/recommendroute")//?.transfromImage(size: view_size)
let myRouteImg = UIImage(named: "resource/map/background/myroute")//?.transfromImage(size: view_size)
let spriteImg = UIImage(named: "resource/map/background/sprite")//?.transfromImage(size: view_size)

//背景颜色
let defaut_color = UIColor(colorHex: 0xf96b1e)                                              //主色调
let default_color2 = UIColor(colorHex: 0xffc09e)                                            //副色调
let defaultColor = UIColor.white                                                            //navigation颜色
let separatorColor = UIColor(colorHex: 0xd9d9d9)                                            //分割线颜色
let timeColor = UIColor(colorHex: 0xF0F0f0)                                                 //时间轴主颜色
let lightWordColor = UIColor(colorHex: 0xB4B4B4)                                            //高亮文字颜色
let subWordColor = UIColor(colorHex: 0x5E5E5E)                                              //灰文字颜色颜色
let wordColor = UIColor(colorHex: 0x181818)                                                 //文字颜色

//MARK:- 模块起始颜色
let modelStartColors: [DataCubeType: UIColor] = [
    .sport: UIColor(colorHex: 0xf06136),
    .heartrate: UIColor(colorHex: 0x2bbedd),
    .sleep: UIColor(colorHex: 0x5a2e96),
    .mindBody: UIColor(colorHex: 0x59d7a5)]

//MARK:- 模块结束颜色
let modelEndColors: [DataCubeType: UIColor] = [
    .sport: UIColor(colorHex: 0xe93c2c),
    .heartrate: UIColor(colorHex: 0x3fb6dd),
    .sleep: UIColor(colorHex: 0x4b238a),
    .mindBody: UIColor(colorHex: 0x54d09b)]

//MARK:- 数据类型颜色1
let recordStartColors: [RecordType: UIColor] = [
    .sport: modelStartColors[.sport]!,
    .sleep: modelStartColors[.sleep]!,
    .weight: modelStartColors[.mindBody]!,
    .mood: modelStartColors[.heartrate]!,
    .bloodPressure: modelStartColors[.heartrate]!,
    .heartrate: modelStartColors[.heartrate]!
]

//MARK:- 数据类型颜色2
let recordEndColors: [RecordType: UIColor] = [
    .sport: modelStartColors[.sport]!.withAlphaComponent(0.2),
    .sleep: modelStartColors[.sleep]!.withAlphaComponent(0.2),
    .weight: modelStartColors[.mindBody]!.withAlphaComponent(0.2),
    .mood: modelStartColors[.heartrate]!,
    .bloodPressure: modelStartColors[.heartrate]!.withAlphaComponent(0.2),
    .heartrate: modelStartColors[.heartrate]!.withAlphaComponent(0.2)
]

//MARK:- 数据类型颜色3
let recordDarkColors: [RecordType: UIColor] = [
    .sport: UIColor(colorHex: 0xc21404),
    .sleep: UIColor(colorHex: 0x24015a),
    .weight: UIColor(colorHex: 0x016a3f),
    .mood: UIColor(colorHex: 0x005e7d),
    .bloodPressure: UIColor(colorHex: 0x005e7d),
    .heartrate: UIColor(colorHex: 0x005e7d)
]

//MARK:- 正则表达式
struct Regex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        
        return false
    }
}
