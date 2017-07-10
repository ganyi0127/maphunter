//
//  DateExtension.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/5.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
extension Date{
    
    //判断是否为当天
    func isToday() -> Bool{
        
        let dateFormat = "yyy-M-d"
        let str = formatString(with: dateFormat)
        let todayStr = Date().formatString(with: dateFormat)
        return str == todayStr
    }
    
    //转换为字符串
    func formatString(with dateFormat: String) -> String{
        let format = DateFormatter()
        format.dateFormat = dateFormat
        return format.string(from: self)
    }
    
    //获取星期字符串
    func weekdayString() -> String{
        let list = ["周日","周一","周二","周三","周四","周五","周六"]        
        return list[weekday() - 1]
    }
    
    //获取星期 1234567
    func weekday() -> Int{
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    //偏移
    func offset(with offsetDay: Int, withTime timeFlag: Bool = false) -> Date {
        let resultDate = Date(timeInterval: TimeInterval(offsetDay) * 60 * 60 * 24, since: self)
        
        if timeFlag {
            return resultDate
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: resultDate)
        return calendar.date(from: components)!
    }
}
