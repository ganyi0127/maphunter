//
//  PathCell0.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathCell0: UITableViewCell {
    
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func switchRemind(_ sender: UISwitch) {
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        titleLabel.font = fontSmall
    }
}
