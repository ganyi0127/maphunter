//
//  LabelExtension.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
extension UILabel{
    open override func awakeFromNib() {
        let font = UIFont(name: font_name, size: self.font.pointSize)
        self.font = font
    }
}
