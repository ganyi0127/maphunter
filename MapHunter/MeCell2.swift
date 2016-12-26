//
//  MeCell2.swift
//  MapHunter
//
//  Created by YiGan on 19/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class MeCell2: UITableViewCell {
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        selectionStyle = .default
    }
    
    private func createContents(){
        
        //设置文字
        let labelFrame = CGRect(x: 0, y: 10, width: view_size.width, height: 24)
        let label = UILabel(frame: labelFrame)
        label.text = "个人总成绩"
        label.textColor = wordColor
        label.font = UIFont(name: font_name, size: 12)
        label.textAlignment = .center
        contentView.addSubview(label)
    }
}
