//
//  InfoBaseView.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/15.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
enum InfoType{
    case gender
    case height
    case weight
    case birthday
}
class InfoBaseView: UIView {
    
    private var lineShapeLayer: CAShapeLayer?
    
    var closure: ((InfoType)->())?
    var type: InfoType?
    
    //MARK:- init
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
        createContents()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //添加分割线
        let bezierPath = UIBezierPath(rect: bounds)
        if lineShapeLayer == nil{
            lineShapeLayer = CAShapeLayer()
            lineShapeLayer?.fillColor = UIColor.clear.cgColor
            lineShapeLayer?.strokeColor = lightWordColor.cgColor
            lineShapeLayer?.lineWidth = 1
            layer.addSublayer(lineShapeLayer!)
        }
        lineShapeLayer?.path = bezierPath.cgPath
    }
    
    func config(){
        //接收触摸事件
        isUserInteractionEnabled = true
    }
    
    func createContents(){
        
    }
}

//MARK:- 触摸事件
extension InfoBaseView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //点击动效
        let anim = CABasicAnimation(keyPath: "transform.scale.x")
        anim.toValue = 0.5
        anim.duration = 0.05
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = true
        anim.autoreverses = true
        anim.duration = 0.3
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layer.add(anim, forKey: "began")
        
        //点击回调
        if let t = type{
            closure?(t)
        }
    }
}
