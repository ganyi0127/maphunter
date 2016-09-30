//
//  CellCube.swift
//  MapHunter
//
//  Created by ganyi on 16/9/30.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class CellCube: UIView {
    
    var colorValue: CGFloat = 0{
        didSet{
            
            var value = colorValue
            if value > 1{
                value = 1
            }else if value < 0{
                value = 0
            }
            
            anim(value)
        }
    }
    
    private var anim = CABasicAnimation(keyPath: "opacity")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .red
        
    }
    
    //MARK:- 颜色动画——传入红色比例范围 0~1
    private func anim(_ redRateValue: CGFloat){
        
        anim.fromValue = layer.opacity
        anim.toValue = redRateValue
        anim.fillMode = kCAFillModeBoth
        anim.duration = 2
        layer.add(anim, forKey: "opacity")
        
        layer.opacity = Float(redRateValue)
    }
}
