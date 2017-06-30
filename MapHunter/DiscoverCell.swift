//
//  DiscoverCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/30.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class DiscoverCell: UITableViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var name: String? {
        didSet{
            titleLabel.text = name            
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
}
