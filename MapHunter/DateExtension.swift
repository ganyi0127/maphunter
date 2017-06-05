//
//  DateExtension.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/5.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
extension Date{
    func isToday() -> Bool{
        
        let format = DateFormatter()
        format.dateFormat = "yyy-M-d"
        let str = format.string(from: self)
        let todayStr = format.string(from: Date())
        return str == todayStr
    }
}
