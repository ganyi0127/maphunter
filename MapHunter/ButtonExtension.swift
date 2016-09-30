//
//  ButtonExtension.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
extension UIButton{
    open override func awakeFromNib() {
        let font = UIFont(name: font_name, size: titleLabel!.font.pointSize)
        self.titleLabel?.font = font
    }
}
