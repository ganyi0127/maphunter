//
//  DataBall.swift
//  MapHunter
//
//  Created by YiGan on 28/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
enum DataBallType{
    case walking
    case running
    case riding
}
struct DataBallData {
    var step: Int = 0
    var calorie: CGFloat = 0
    var distance: CGFloat = 0
    var time: CGFloat = 0
}
class DataBall: UIView {
    
    private var bgShapeLayer:CAShapeLayer?  //背景层
    private var shapeLayer:CAShapeLayer?    //边缘层
    
    fileprivate var sportType: DataBallType!          //气球类型 跑步、骑行、走路
    fileprivate let dataTypeMap: [DataBallType: [DataType]] = [.walking: [.step, .calorie, .distance, .time],
                                                          .running: [.step, .calorie, .distance, .time],
                                                          .riding: [.calorie, .distance, .time]]
    
    //数据类型
    fileprivate enum DataType: Int {
        case step = 0
        case calorie
        case distance
        case time
        mutating func next(byMap map: [DataBallType: [DataType]], bySportType sportType: DataBallType){
            guard let list = map[sportType] else{
                return
            }
            guard let index = list.index(of: self) else{
                return
            }
            var newIndex: Int
            if index == list.count - 1 {
                newIndex = 0
            }else{
                newIndex = index + 1
            }
            self = list[newIndex]
        }
    }
    fileprivate var dataType: DataType?{
        didSet{
            guard let dt = dataType else {
                return
            }
            switch dt {
            case .step:
                mainLabel.text = "\(data.step)"
                subLabel.text = "步"
            case .calorie:
                mainLabel.text = "\(Int(data.calorie))"
                subLabel.text = "卡路里"
            case .distance:
                mainLabel.text = "\(Int(data.distance))"
                subLabel.text = "米"
            case .time:
                mainLabel.text = "\(Int(data.time))"
                subLabel.text = "分钟"
            }
        }
    }
    
    //MARK:- 需传入的数据
    var data = { ()->DataBallData in
        var dataBallData = DataBallData()
        dataBallData.step = 12345
        dataBallData.calorie = 67890
        dataBallData.distance = 23456
        dataBallData.time = 1234
        return dataBallData
        }(){
        didSet{
            
        }
    }
    
    //显示curLable
    private lazy var mainLabel: UILabel = {
        let frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height * 0.2)
        let curLabel = UILabel(frame: frame)
        curLabel.textAlignment = .center
        curLabel.font = UIFont(name: font_name, size: self.frame.height * 0.2)
        return curLabel
    }()
    
    //显示subLable
    private lazy var subLabel: UILabel = {
        let frame = CGRect(x: 0, y: self.frame.height / 2 + 15, width: self.frame.width, height: self.frame.height * 0.2)
        let targetLabel = UILabel(frame: frame)
        targetLabel.textAlignment = .center
        targetLabel.font = UIFont(name: font_name, size: self.frame.height * 0.1)
        return targetLabel
    }()
    
    //点击回调
    var closure: (()->())?
    var isSelected = false
    
    //颜色
    private var color: UIColor{
        get{
            switch sportType as DataBallType {
            case .running:
                return SportColor.running
            case .walking:
                return SportColor.walking
            case .riding:
                return SportColor.riding
            }
        }
    }
    
    //MARK:- init
    init(dataBallType type: DataBallType){
        sportType = type
        
        let radius = (view_size.width + view_size.height) * 0.12
        let initFrame = CGRect(x: 0, y: 0, width: radius, height: radius)
        super.init(frame: initFrame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        isUserInteractionEnabled = true
        
        dataType = dataTypeMap[sportType]?[0]
    }
    
    private func createContents(){
        //添加圆形进度条
        if bgShapeLayer == nil{
            
            bgShapeLayer = CAShapeLayer()
            bgShapeLayer?.fillColor = defaultColor.cgColor //color.cgColor
            
            let refreshRadius = frame.size.height / 2 * 0.8
            let bezierPath = UIBezierPath()
            bezierPath.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2 - refreshRadius * 0.0),
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
            shapeLayer?.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
            shapeLayer?.fillColor = nil
            shapeLayer?.lineWidth = 0
            shapeLayer?.lineCap = kCALineCapRound
            
            shapeLayer?.path = bgShapeLayer?.path
            layer.addSublayer(shapeLayer!)
        }
        
        //设置中央文字
        addSubview(mainLabel)
        addSubview(subLabel)
        
        //添加icon
//        let stepImageView = UIImageView(image: UIImage(named: "icon_step"))
//        let stepImageViewOrigin = CGPoint(x: frame.width / 2 - stepImageView.frame.width / 2, y: frame.height / 2 - stepImageView.frame.height / 2)
//        stepImageView.frame.origin = stepImageViewOrigin
//        addSubview(stepImageView)
        
        //初始化随机飘动
        randomAction()
        
        //初始化粒子特效
        addEmitter()
    }
    
    //MARK:- 随机运动
    func randomAction(){
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.values = { ()->[Any] in
            var list = [Any]()
            let positon = layer.position
            let range = UInt32((view_size.width + view_size.height) * 0.01)
            list.append(NSValue(cgPoint: positon))
            (0..<10).forEach(){
                i in
                var x = positon.x + CGFloat(arc4random_uniform(range))
                var y = positon.y + CGFloat(arc4random_uniform(range))
                
                if i == 9{
                    x = positon.x
                    y = positon.y
                }
                let value = NSValue(cgPoint: CGPoint(x: x, y: y))
                list.append(value)
            }
            
            return list
        }()
        anim.keyTimes = { ()->[NSNumber] in
            var list = [NSNumber]()
            list.append(NSNumber(value: 0))
            (0..<10).forEach(){
                i in
                let value = Float(i) / 10 + 0.1
                let number = NSNumber(value: value)
                list.append(number)
            }
            return list
        }()
        anim.duration = 10
        anim.repeatCount = HUGE
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.fillMode = kCAFillModeBoth
        layer.add(anim, forKey: nil)
    }
    
    //MARK:- 刷新
    private func beginRefreshing(){
        
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil
        
        if shapeLayer == nil{
            
            shapeLayer = CAShapeLayer()
            shapeLayer?.strokeColor = UIColor(red: 98 / 255, green: 236 / 255, blue: 161 / 255, alpha: 1).cgColor
            shapeLayer?.fillColor = nil
            shapeLayer?.lineWidth = 16
            shapeLayer?.lineCap = kCALineCapRound
            
            shapeLayer?.path = bgShapeLayer?.path
            layer.addSublayer(shapeLayer!)
        }
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
//        strokeEndAnimation.toValue = curProgress! / targetProgress
        strokeEndAnimation.duration = 1.5
        strokeEndAnimation.fillMode = kCAFillModeBoth
        strokeEndAnimation.isRemovedOnCompletion = false
        shapeLayer?.add(strokeEndAnimation, forKey: nil)
        
    }
    
    //MARK:- 添加粒子特效
    fileprivate func addEmitter(){
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: 0, y: 0)
        //发射源大小
        emitter.emitterSize = CGSize(width: frame.width * 0.8, height: frame.height * 0.8)
        emitter.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        emitter.emitterMode = kCAEmitterLayerOutline    //发射模式
        emitter.emitterShape = kCAEmitterLayerCircle    //发射源形状
        
        emitter.renderMode = kCAEmitterLayerBackToFront    //渲染模式
        emitter.zPosition = -10
        
        let flake = CAEmitterCell.init()
        
        
        //颗粒大小
        flake.scale = 0.15
        flake.scaleRange = 0.05
        
        //缩放比例速度
        flake.scaleSpeed = -0.05
        
        //因子
        flake.birthRate = 1500
        
        //生命周期
        flake.lifetime = 5
        
        flake.alphaSpeed = -0.4
        
        //粒子速度
        flake.velocity = 5
        flake.velocityRange = 1
        
        //方向加速度分量
        flake.yAcceleration = 0
        
        //发射角度
        flake.emissionRange = CGFloat(M_PI) * 2
        
        //自动旋转
        flake.spinRange = CGFloat(M_PI) * 0.5
        
        flake.contents = UIImage(named: "fire")?.cgImage
        flake.color = color.cgColor
        
//        emitter.shadowOpacity = 1
//        emitter.shadowRadius = 0
//        emitter.shadowOffset = CGSize(width: 0, height: 1)
//        emitter.shadowColor = UIColor.gray.cgColor
        
        emitter.emitterCells = [flake]
        
        layer.addSublayer(emitter)
    }
}

//MARK:- 点击事件
extension DataBall{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.values = [1, 1.15, 0.9, 1]
        anim.keyTimes = [0, 0.4, 0.8, 1]
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let moveAnim = CABasicAnimation(keyPath: "position")
        moveAnim.toValue = layer.position
        moveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [moveAnim, anim]
        groupAnim.duration = 0.3
        layer.add(groupAnim, forKey: nil)
        
        randomAction()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dataType?.next(byMap: dataTypeMap, bySportType: sportType)
        closure?()
    }
}
