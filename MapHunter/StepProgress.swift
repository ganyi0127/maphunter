//
//  StepProgress.swift
//  MapHunter
//
//  Created by ganyi on 16/9/28.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
@IBDesignable
class StepProgress: UIView {
    
    private var bgShapeLayer:CAShapeLayer?
    
    private var shapeLayer:CAShapeLayer?
    
    //当前进度_目标
    var curProgress:CGFloat?{
        didSet{
            label.text = "\(Int(curProgress!))步"
            beginRefreshing()
        }
    }
    private var preProgress:CGFloat = 0
    private var targetProgress:CGFloat = 10000
    
    //显示当前lable
    private var label = UILabel()
    
    //点击回调
    var closure: (()->())?
    
    var isSelected = false
    
    //MARK:- init
    init() {
        let radius = view_size.width * 0.5
        let initFrame = CGRect(x: 0, y: 0, width: radius, height: radius)
        super.init(frame: initFrame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
        
        isUserInteractionEnabled = true
        
    }
    
    private func createContents(){
        
        //添加圆形进度条
        if bgShapeLayer == nil{
            
            bgShapeLayer = CAShapeLayer()
            bgShapeLayer?.strokeColor = UIColor.lightGray.cgColor
            bgShapeLayer?.fillColor = nil
            bgShapeLayer?.lineWidth = 16
            bgShapeLayer?.lineCap = kCALineCapRound
            
            let refreshRadius = frame.size.height/2 * 0.8
            let bezierPath = UIBezierPath()
            bezierPath.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2 - refreshRadius * 0.1),
                              radius: refreshRadius,
                              startAngle: CGFloat(-M_PI_2),
                              endAngle: CGFloat(M_PI * 1.5),
                              clockwise: true)
            bgShapeLayer?.path = bezierPath.cgPath
            layer.addSublayer(bgShapeLayer!)
        }
        
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil
        
        if shapeLayer == nil{
            
            shapeLayer = CAShapeLayer()
            shapeLayer?.strokeColor = UIColor.orange.cgColor
            shapeLayer?.fillColor = nil
            shapeLayer?.lineWidth = 16
            shapeLayer?.lineCap = kCALineCapRound
            
            shapeLayer?.path = bgShapeLayer?.path
            layer.addSublayer(shapeLayer!)
        }
        
        //设置中央文字
        label.frame = CGRect(x: 0, y: frame.height / 2 + 18, width: frame.width, height: 18)
        label.textAlignment = .center
        addSubview(label)
        
        //添加icon
        let stepImageView = UIImageView(image: UIImage(named: "icon_step"))
        let stepImageViewOrigin = CGPoint(x: frame.width / 2 - stepImageView.frame.width / 2, y: frame.height / 2 - stepImageView.frame.height / 2)
        stepImageView.frame.origin = stepImageViewOrigin
        addSubview(stepImageView)
    }
    
    private func beginRefreshing(){
        
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil
        
        if shapeLayer == nil{
            
            shapeLayer = CAShapeLayer()
            shapeLayer?.strokeColor = UIColor.orange.cgColor
            shapeLayer?.fillColor = nil
            shapeLayer?.lineWidth = 16
            shapeLayer?.lineCap = kCALineCapRound
            
            shapeLayer?.path = bgShapeLayer?.path
            layer.addSublayer(shapeLayer!)
        }
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = curProgress! / targetProgress
        strokeEndAnimation.duration = 1.5
        strokeEndAnimation.fillMode = kCAFillModeBoth
        strokeEndAnimation.isRemovedOnCompletion = false
        shapeLayer?.add(strokeEndAnimation, forKey: nil)
        
    }
    
//    fileprivate func select(_ flag: Bool){
//        
//        isSelected = flag
//        
//        var cgcolor:CGColor?
//        if flag{
//            cgcolor = UIColor.green.cgColor
//        }else{
//            cgcolor = UIColor.orange.cgColor
//        }
//        
//        let anim = CABasicAnimation(keyPath: "fillColor")
//        anim.toValue = cgcolor
//        anim.duration = 0.3
//        anim.fillMode = kCAFillModeBoth
//        anim.isRemovedOnCompletion = false
//        shapeLayer?.add(anim, forKey: nil)
//    }
}

extension StepProgress{
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        select(true)
        closure?()
    }
}
