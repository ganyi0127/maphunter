//
//  WeeklySportVice.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/10.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class WeeklySportViceVC: WeeklyViceVC {
    
    override func config() {
        super.config()
        
        let backgroundColor = weeklyScrollColorList[0]
        view0.backgroundColor = backgroundColor
        view1.backgroundColor = backgroundColor
    }
    
    override func createContents() {
        super.createContents()
    }
}
