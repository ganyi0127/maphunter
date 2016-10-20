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

    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
   
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
    
    fileprivate var curTag = 0
    //MARK:- 发送切换日期消息
    private func switchWithDirectionTag(tag: Int){
        
        //翻页动画效果
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        
        layer.transform = transform
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.y")
        anim.fromValue = 0
        anim.toValue = tag == 0 ? M_PI : -M_PI
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let fadeAnim = CAKeyframeAnimation(keyPath: "opacity")
        fadeAnim.values = [1, 0, 1]
        fadeAnim.keyTimes = [0, 0.5, 1]
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [1, 0.7, 1]
        scaleAnim.keyTimes = [0, 0.5, 1]
        scaleAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.animations = [anim, fadeAnim, scaleAnim]
        group.delegate = self
        layer.add(group, forKey: "swith")
        
        //切换日期
        curTag = tag
    }
}

//MARK:- Animation delegate
extension FirstCell: CAAnimationDelegate{
    //完成动画后切换日期
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        notiy.post(name: switch_notiy, object: curTag, userInfo: nil)

    }
}

extension FirstCell{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let anim = CABasicAnimation(keyPath: "transform.scale.x")
        anim.toValue = 0.8
        anim.duration = 0.05
        anim.fillMode = kCAFillModeBoth
        anim.autoreverses = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layer.add(anim, forKey: "began")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
