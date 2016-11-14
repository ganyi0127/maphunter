//
//  TopScrollDelegate.swift
//  MapHunter
//
//  Created by ganyi on 2016/10/23.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
protocol TopScrollDelegate {
    func topScrollDidSelected(withData date: Date)
    func topScrollData(withDay day: Int, withMonth month: Int, withYear year: Int) -> (curValues: [CGFloat], maxValues: [CGFloat])
}
