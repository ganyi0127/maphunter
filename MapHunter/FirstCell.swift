//
//  FirstCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class FirstCell: UITableViewCell {
    
    //步数
    var step = 0{
        didSet{
            stepProgress.curProgress = CGFloat(step)
        }
    }
    
    //卡路里
    var calorie = 0{
        didSet{
            calorieIcon.value = Int(calorie)
        }
    }
    private var calorieIcon:IconView = {
        let calorieIcon = IconView(.calorie)
        return calorieIcon
    }()
    
    //距离
    var distance = 0{
        didSet{
            distanceIcon.value = Int(distance)
        }
    }
    private var distanceIcon:IconView = {
        let distanceIcon = IconView(.distance)
        return distanceIcon
    }()
    
    //运动时间
    var time = 0{
        didSet{
            timeIcon.value = Int(time)
        }
    }
    private var timeIcon:IconView = {
        let timeIcon = IconView(.time)
        return timeIcon
    }()
    
    //步数
    private var stepProgress:StepProgress = {
        let stepProgress = StepProgress()
        return stepProgress
    }()
    
    //MARK:- init
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
    }
    
    override func layoutIfNeeded() {
      
        createContents()
    }
    private func config(){
        
        var rotation = CATransform3DIdentity
        rotation.m34 = -1 / 500
        rotation = CATransform3DRotate(rotation, CGFloat(M_PI_2) / 4, 0, 0, 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.transform = rotation
        
    }
    
    private func createContents(){
        
        //添加步数
        stepProgress.frame.origin = CGPoint(x: frame.width / 2 - stepProgress.frame.width / 2, y: 0)
        addSubview(stepProgress)
        
        //添加三个数据
        let calorieOrigin = CGPoint(x: 0, y: frame.height - calorieIcon.frame.height)
        calorieIcon.frame.origin = calorieOrigin
        addSubview(calorieIcon)
        
        let distanceOrigin = CGPoint(x: frame.width / 2 - distanceIcon.frame.width / 2, y: frame.height - distanceIcon.frame.height)
        distanceIcon.frame.origin = distanceOrigin
        addSubview(distanceIcon)
        
        let timeOrigin = CGPoint(x: frame.width - timeIcon.frame.width, y: frame.height - timeIcon.frame.height)
        timeIcon.frame.origin = timeOrigin
        addSubview(timeIcon)
        
    }
}

extension FirstCell{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let anim = CABasicAnimation(keyPath: "transform.scale.x")
        anim.toValue = 0.5
        anim.duration = 0.05
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = true
        anim.autoreverses = true
        layer.add(anim, forKey: "began")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
