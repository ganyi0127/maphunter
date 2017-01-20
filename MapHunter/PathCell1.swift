//
//  PathCell1.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathCell1: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        titleLabel.font = fontSmall
        valueLabel.font = fontSmall
    }
}
