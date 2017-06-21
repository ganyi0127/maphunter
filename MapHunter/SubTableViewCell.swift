//
//  SubTableViewCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/20.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SubTableViewCell: UITableViewCell {
    init(with identifier: String?){
        super.init(style: .value1, reuseIdentifier: identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
