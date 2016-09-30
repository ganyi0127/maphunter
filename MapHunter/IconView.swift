//
//  IconView.swift
//  MapHunter
//
//  Created by ganyi on 16/9/28.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
enum IconViewType{
    case calorie
    case distance
    case time
}
class IconView: UIImageView {
    
    //icon类型
    private var type: IconViewType!
    
    //数据
    var value = 0{
        didSet{
            switch type! {
            case .calorie:
                
                label.text = "\(value)卡路里"
            case .distance:
                
                label.text = "\(value)公里"
            case .time:
                
                label.text = "\(value)分钟"
            }
        }
    }
    
    //文字
    private let label:UILabel = {
        let labelFrame = CGRect(x: 0, y: 0, width: view_size.width / 4, height: view_size.height / 16)
        let label = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    init(_ iconType: IconViewType){
        let frame = CGRect(x: 0, y: 0, width: view_size.width / 4, height: view_size.width / 4)
        super.init(frame: frame)
        
        type = iconType
        
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        contentMode = .center
    }
    
    private func createContents(){
        
        label.frame.origin = CGPoint(x: frame.width / 2 - label.frame.width / 2, y: frame.height - label.frame.height)
        addSubview(label)
       
        switch type! {
        case .calorie:
            image = UIImage(named: "icon_calorie")
            label.text = "\(value)卡路里"
        case .distance:
            image = UIImage(named: "icon_distance")
            label.text = "\(value)公里"
        case .time:
            image = UIImage(named: "icon_time")
            label.text = "\(value)分钟"
        }
    }
}
