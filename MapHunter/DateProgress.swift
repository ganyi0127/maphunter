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
    
    private lazy var shapeLayer:CAShapeLayer? = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = self.refreshRadius * 0.2
        
        return shapeLayer
    }()
    
    //当前进度_目标
    var curValues = [CGFloat](){
        didSet{
            if !maxValues.isEmpty{
                beginRefreshing()
            }
        }
    }
    var maxValues = [CGFloat](){
        didSet{
            if !curValues.isEmpty {
                beginRefreshing()
            }
        }
    }
    
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
                
                if !isOpen{
                    closure?(date!, true)
                }
            }
        }
    }
    var isSelected = false{
        didSet{
            if isSelected{
                let anim = CAKeyframeAnimation(keyPath: "transform.scale")
                anim.values = [1, 1.2, 0.9, 1]
                anim.keyTimes = [0, 0.4, 0.8, 1]
                anim.duration = 0.5
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                layer.add(anim, forKey: nil)    
            }
        }
    }
    
    //手动修改显示日期
    var text: String?{
        didSet{
            label.text = text
        }
    }
    
    private var refreshRadius:CGFloat!
    private var shapeList = [CAShapeLayer]()
    private let shapeColorList = [SportColor.running.cgColor,
                                  SportColor.walking.cgColor,
                                  SportColor.riding.cgColor]
    private let strokeAnim: CABasicAnimation = {
       let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = -0.5
        anim.duration = 1.5
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = false
        return anim
    }()
    
    private var tap: UITapGestureRecognizer?
    
    //MARK:- init
    init(_ text: String) {
        let radius = view_size.width / 12
        let initFrame = CGRect(x: 0, y: 0, width: radius, height: radius)
        super.init(frame: initFrame)
        
        label.text = text
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notiy.removeObserver(self, name: unselect_notiy, object: nil)
//        removeGestureRecognizer(tap!)
    }
    
    private func config(){
      
        backgroundColor = .clear
        
        isUserInteractionEnabled = true
        
        notiy.addObserver(self, selector: #selector(unselect(notify:)), name: unselect_notiy, object: nil)
        
        //添加点击事件
//        tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
//        tap?.numberOfTapsRequired = 1
//        tap?.numberOfTouchesRequired = 1
//        addGestureRecognizer(tap!)
    }
    
    //MARK:- 点击事件
    @objc private func click(recognizer: UITapGestureRecognizer){
        selectDate = date!
        
        notiy.post(name: unselect_notiy, object: nil)
        select(true)
        closure?(date!, false)
    }
    
    private func createContents(){
        
        //添加圆形进度条
        refreshRadius = frame.size.height/2 * 0.8
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                          radius: refreshRadius * 0.9,
                          startAngle: CGFloat(-M_PI_2),
                          endAngle: CGFloat(M_PI * 1.5),
                          clockwise: true)
        shapeLayer?.path = bezierPath.cgPath
        
        self.layer.addSublayer(shapeLayer!)
        
        //设置中央文字
        label.frame = CGRect(x: bounds.width / 2 - refreshRadius, y: -frame.width * 0.7, width: refreshRadius * 2, height: refreshRadius * 2)
        label.textAlignment = .center
        label.layer.zPosition = 3
        label.textColor = .gray
        addSubview(label)
    }
    
    private func beginRefreshing(){
        
        let bezierPath = UIBezierPath()
        if !maxValues.isEmpty && !curValues.isEmpty && maxValues.count == curValues.count {
        
            maxValues.enumerated().forEach(){
                index, maxValue in
                
                let curValue = curValues[index]

                //绘制
                let lineWidth = refreshRadius * 0.2
                let radius = frame.height / 2.0 * 0.7 - CGFloat(index) * lineWidth * 1.8
                
                bezierPath.removeAllPoints()
                bezierPath.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: radius, startAngle: -(CGFloat)(M_PI_2), endAngle: CGFloat(M_PI) * 1.5, clockwise: true)
                
                let listCount = shapeList.count
                
                if listCount - 1 < index{
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.lineWidth = lineWidth
                    shapeLayer.strokeColor = shapeColorList[index]
                    shapeLayer.fillColor = UIColor.clear.cgColor
                    shapeLayer.path = bezierPath.cgPath
                    shapeLayer.zPosition = 1
                    shapeLayer.lineCap = kCALineCapRound
                    
                    shapeList.append(shapeLayer)
                    layer.addSublayer(shapeLayer)
                }
                
                //添加动画
                let dataShapeLayer = shapeList[index]
                strokeAnim.toValue = curValue / maxValue
                dataShapeLayer.add(strokeAnim, forKey: "data")
            }
        }
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
            cgcolor = SportColor.running.cgColor
            label.textColor = .white
        }else{
            cgcolor = UIColor.clear.cgColor
            label.textColor = .gray
        }

        label.layer.backgroundColor = cgcolor
        label.layer.cornerRadius = label.bounds.width / 2
//        let anim = CABasicAnimation(keyPath: "fillColor")
//        anim.toValue = cgcolor
//        anim.duration = 0.3
//        anim.fillMode = kCAFillModeBoth
//        anim.isRemovedOnCompletion = false
//        shapeLayer?.add(anim, forKey: nil)
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
