//
//  DayProgress.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//
/*
*/

import UIKit
@IBDesignable
class DateProgress: UIView {
    
    private var shapeLayer:CAShapeLayer? = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.fillColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = kCALineCapRound
        
        return shapeLayer
    }()
    
    //当前进度_目标
    var curProgress:CGFloat?{
        didSet{
            beginRefreshing()            
        }
    }
    private var preProgress:CGFloat = 0
    private var targetProgress:CGFloat = 100
    
    //显示当前lable
    private var label = UILabel()
    
    //点击回调
    var closure: ((_ date: Date, _ needDisplayDate: Bool)->())?
    
    var date:Date?{
        didSet{
            //判断是否为当前选择的日期
            let formatter = DateFormatter()
            formatter.dateFormat = "yyy-MM-dd"
            let dateStr = formatter.string(from: date!)
            let selectStr = formatter.string(from: selectDate)
            
            //修改显示日期 有重复
            formatter.dateFormat = "dd"
            let dayStr = formatter.string(from: date!)
            label.text = dayStr
            
            if dateStr == selectStr{
                notiy.post(name: unselect_notiy, object: nil)
                select(true)
                closure?(date!, true)
            }
        }
    }
    var isSelected = false
    
    //手动修改显示日期
    var text: String?{
        didSet{
            label.text = text
        }
    }
    
    //MARK:- init
    init(_ text: String) {
        let radius = view_size.width / 8
        let initFrame = CGRect(x: 0, y: 0, width: radius, height: radius)
        super.init(frame: initFrame)
        
        label.text = text
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
      
        backgroundColor = .clear
        
        isUserInteractionEnabled = true
        
        notiy.addObserver(self, selector: #selector(unselect(notify:)), name: unselect_notiy, object: nil)
    }
    
    private func createContents(){
        
        //添加圆形进度条
        let refreshRadius = frame.size.height/2 * 0.8
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                          radius: refreshRadius * 0.9,
                          startAngle: CGFloat(-M_PI_2),
                          endAngle: CGFloat(M_PI * 1.5),
                          clockwise: true)
        shapeLayer?.path = bezierPath.cgPath
        
        self.layer.addSublayer(shapeLayer!)
        
        //设置中央文字
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        label.textAlignment = .center
        addSubview(label)
    }
    
    private func beginRefreshing(){
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = curProgress! / targetProgress
        strokeStartAnimation.duration = 1.5
        strokeStartAnimation.fillMode = kCAFillModeBoth
        strokeStartAnimation.isRemovedOnCompletion = false
        shapeLayer?.add(strokeStartAnimation, forKey: nil)

    }
    
    @objc private func unselect(notify:NSNotification){
        select(false)
    }
    
    fileprivate func select(_ flag: Bool){
        
        guard isSelected || flag else {
            return
        }
        
        isSelected = flag
        
        var cgcolor:CGColor?
        if flag{
            cgcolor = UIColor.green.withAlphaComponent(0.5).cgColor
        }else{
            cgcolor = UIColor.orange.withAlphaComponent(0.5).cgColor
        }
        
        let anim = CABasicAnimation(keyPath: "fillColor")
        anim.toValue = cgcolor
        anim.duration = 0.3
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = false
        shapeLayer?.add(anim, forKey: nil)
    }
    
    deinit {
        notiy.removeObserver(self, name: unselect_notiy, object: nil)
    }
}

extension DateProgress{
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        selectDate = date!
        
        notiy.post(name: unselect_notiy, object: nil)
        select(true)
        closure?(date!, false)
    }
}
