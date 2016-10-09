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
    
    //按钮
    private var leftButton = { () -> UIButton in 
        let button = UIButton(type: .custom)
        button.setTitle("<", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont(name: font_name, size: 24)
        button.tag = 0
        return button
    }()
    private var rightButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        button.setTitle(">", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont(name: font_name, size: 24)
        button.tag = 1
        return button
    }()
    
    //MARK:- init
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
        createContents()
    }
    
    override func layoutIfNeeded() {
      
        stepProgress.frame.origin = CGPoint(x: frame.width / 2 - stepProgress.frame.width / 2, y: 0)
        
        let calorieOrigin = CGPoint(x: 0, y: frame.height - calorieIcon.frame.height)
        calorieIcon.frame.origin = calorieOrigin
        
        let distanceOrigin = CGPoint(x: frame.width / 2 - distanceIcon.frame.width / 2, y: frame.height - distanceIcon.frame.height)
        distanceIcon.frame.origin = distanceOrigin
        
        let timeOrigin = CGPoint(x: frame.width - timeIcon.frame.width, y: frame.height - timeIcon.frame.height)
        timeIcon.frame.origin = timeOrigin
        
        leftButton.frame = CGRect(x: 0, y: frame.height * 0.3, width: frame.width * 0.2, height: frame.height * 0.2)
        rightButton.frame = CGRect(x: frame.width - frame.width * 0.2, y: frame.height * 0.3, width: frame.width * 0.2, height: frame.height * 0.2)
    }
    
    private func config(){
        
        var rotation = CATransform3DIdentity
        rotation.m34 = -1 / 500
        rotation = CATransform3DRotate(rotation, CGFloat(M_PI_2) / 4, 0, 0, 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.transform = rotation
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        leftSwipe.direction = .left
        contentView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        rightSwipe.direction = .right
        contentView.addGestureRecognizer(rightSwipe)
    }
    
    private func createContents(){
        
        //添加步数
        addSubview(stepProgress)
        
        //添加三个数据
        addSubview(calorieIcon)
        
        addSubview(distanceIcon)
        
        addSubview(timeIcon)
        
        //左右按钮
        leftButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        addSubview(leftButton)
        
        rightButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        addSubview(rightButton)
    }
    
    @objc private func swipe(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .left{
            switchWithDirectionTag(tag: 1)
        }else{
            switchWithDirectionTag(tag: 0)
        }
    }
    
    @objc private func clickButton(sender: UIButton){
        //0:left 1:right
        switchWithDirectionTag(tag: sender.tag)
    }
    
    //MARK:- 发送切换日期消息
    private func switchWithDirectionTag(tag: Int){
        notiy.post(name: switch_notiy, object: tag, userInfo: nil)
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
