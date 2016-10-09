//
//  SubCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
enum SubCellType{
    case cell1, cell2, cell3, cell4, cell5, cell6
}
class SubCell: UIView {
    
    //回调
    var closure: ((_ type: SubCellType) -> ())?
    
    //类型
    fileprivate var type: SubCellType?
    
    //cell3运动类型: 峰值锻炼、心肺锻炼、脂肪燃烧
    private enum SportType{
        case value1, value2, value3
    }
    //cell3遮罩
    private var gradientLayerMap = [SportType: CAGradientLayer]()
    //cell4体重移动点
    private var weightPointView:UIView?
    //cell5遮罩
    private var shapeLayer: CAShapeLayer?
    fileprivate var foodImageHeight: CGFloat!
    //cell5饮食情况
    fileprivate let foodTextList = ["过低", "较低", "正常", "较多", "过多"]
    //cell6
    private var cellContent: Cell6Content?
    
    //保存形状 数组or字典
    private var shapeLayerList = [CAShapeLayer]()
    private var sportShapeLayerMap = [SportType: CAShapeLayer]()

    
    //--------------------------------------------------------------------------------
    var value1: CGFloat = 0{
        didSet{
            switch type! {
            case .cell1:
                
                label1.text = "\(value1)bpm"
            case .cell2:
                let hour = Int(value1) / 60
                let min = Int(value1) % 60
                let hourStr = hour > 10 ? "\(hour)" : "0\(hour)"
                let minStr = min > 10 ? "\(min)" : "0\(min)"
                label1.text = hourStr + ":" + minStr
            case .cell3:
                
                drawCell3(value1, forSportType: .value1)
                
                let hour = Int(value1) / 60
                let min = Int(value1) % 60
                label1.text = " \(hour)小时\(min)分钟\n 峰值锻炼"
            case .cell4:
                label1.text = " \(value1)kg"
            case .cell5:
                let index = Int(value1) / 456
                label1.text = "饮食情况:\(foodTextList[index])"
                drawCell5(1 - (CGFloat(index) * 0.2 + 0.1))
            case .cell6:
                label1.text = "需消耗:\(value1)卡路里"
            }
        }
    }
    var value2: CGFloat = 0{
        didSet{
            switch type! {
            case .cell1:
                label2.text = "静息心率:\(value2)bpm"
            case .cell2:
                let hour = Int(value2) / 60
                let min = Int(value2) % 60
                let hourStr = hour > 10 ? "\(hour)" : "0\(hour)"
                let minStr = min > 10 ? "\(min)" : "0\(min)"
                label2.text = hourStr + ":" + minStr
            case .cell3:
                
                drawCell3(value2, forSportType: .value2)
                
                let hour = Int(value2) / 60
                let min = Int(value2) % 60
                label2.text = " \(hour)小时\(min)分钟\n 心肺锻炼"
            case .cell4:
                label2.text = " \(value2)kg"
            case .cell6:
                drawCell6(value1, completeValue: value2)
                
                label2.text = "已消耗:\(value2)卡路里"
            default:
                break
            }
        }
    }
    var value3: CGFloat = 0{
        didSet{
            switch type! {
            case .cell2:
                let hour = Int(value3) / 60
                let min = Int(value3) % 60
                label3.text = "\(hour)小时\(min)分钟"
            case .cell3:
                
                drawCell3(value3, forSportType: .value3)
                
                let hour = Int(value3) / 60
                let min = Int(value3) % 60
                label3.text = " \(hour)小时\(min)分钟\n 脂肪燃烧"
            case .cell4:
                
                label3.text = "当前体重:\n\(value3)kg"
                
                //刷新体重
                moveCell4()
            default:
                break
            }
        }
    }
    var value4: CGFloat = 0{
        didSet{
            switch type! {
            case .cell4:
                label4.text = "减重起始:\(value4)月日"
            default:
                break
            }
        }
    }
    var value5: CGFloat = 0
    var value6 = [CGFloat](){
        didSet{
            switch type! {
            case .cell2:
                drawCell2(value6)
            default:
                break
            }
        }
    }
    
    //property --------------------------------------------------------------------------------
    fileprivate var label1 = { () -> UILabel in
        let label = UILabel()
        label.frame.size = CGSize(width: 0, height: 18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private var label2 = { () -> UILabel in
        let label = UILabel()
        label.frame.size = CGSize(width: 0, height: 18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private var label3 = { () -> UILabel in
        let label = UILabel()
        label.frame.size = CGSize(width: 0, height: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private var label4 = { () -> UILabel in
        let label = UILabel()
        label.frame.size = CGSize(width: 0, height: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    //MARK:- init--------------------------------------------------------------------------------
    init(_ subCellType: SubCellType) {
        let subCellFrame = CGRect(x: 0, y: 0, width: view_size.width / 2 - 1, height: view_size.width / 2)
        super.init(frame: subCellFrame)
        
        type = subCellType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .white
    }
    
    private func createContents(){

        switch type! {
        case .cell1:
            //心率
            let imageView = UIImageView(image: UIImage(named: "icon_heartrate"))
            imageView.frame.origin = CGPoint(x: frame.width / 2 - imageView.frame.width / 2, y: frame.height * 0.3)
            addSubview(imageView)
            
            label1.frame = CGRect(x: 0, y: imageView.frame.height * 0.2 + imageView.frame.origin.y + imageView.frame.height, width: frame.width, height: label1.frame.height)
            label1.text = "0bpm"
            addSubview(label1)
            
            label2.frame = CGRect(x: 0, y: frame.height - label2.frame.height * 1.5, width: frame.width, height: label2.frame.height)
            label2.text = "静息心率:0bpm"
            addSubview(label2)
        case .cell2:
            //睡眠
            let imageView = UIImageView(image: UIImage(named: "icon_night"))
            imageView.frame.origin = CGPoint(x: frame.width / 2 - imageView.frame.width / 2, y: frame.height * 0.3)
            addSubview(imageView)
            
            //显示睡眠开始时间
            label1.frame = CGRect(x: 0, y: frame.height - label1.frame.height * 4.1, width: frame.width, height: label1.frame.height)
            label1.text = "00:00"
            label1.textAlignment = .left
            addSubview(label1)
            
            //显示睡眠结束时间
            label2.frame = CGRect(x: 0, y: frame.height - label2.frame.height * 4.1, width: frame.width, height: label2.frame.height)
            label2.text = "00:00"
            label2.textAlignment = .right
            addSubview(label2)
            
            //显示睡眠时长
            label3.frame = CGRect(x: 0, y: frame.height - label3.frame.height * 2.8, width: frame.width, height: label3.frame.height)
            label3.text = "0小时0分钟"
            addSubview(label3)
            
            label4.frame = CGRect(x: 0, y: frame.height - label4.frame.height * 1.5, width: frame.width, height: label4.frame.height)
            label4.text = " 睡眠等级"
            label4.textAlignment = .left
            addSubview(label4)
            
            //绘制半圆——睡眠曲线
            drawCell2([])
        case .cell3:
            let imageView = UIImageView(image: UIImage(named: "icon_run"))
            imageView.frame.origin = CGPoint(x: frame.width / 2 - imageView.frame.width / 2, y: frame.height * 0.05)
            addSubview(imageView)
            
            //显示峰值锻炼
            label1.frame = CGRect(x: 0, y: frame.height / 5, width: frame.width, height: label1.frame.height * 2)
            label1.text = " 0分钟\n 峰值锻炼"
            label1.textAlignment = .left
            label1.numberOfLines = 0
            addSubview(label1)
            label1.layer.zPosition = 10
            label1.font = UIFont(name: font_name, size: 12)
            
            //显示心肺锻炼
            label2.frame = CGRect(x: 0, y: frame.height / 5 * 2, width: frame.width, height: label2.frame.height * 2)
            label2.text = " 0分钟\n 心肺锻炼"
            label2.textAlignment = .left
            label2.numberOfLines = 0
            addSubview(label2)
            label2.layer.zPosition = 10
            label2.font = UIFont(name: font_name, size: 12)
            
            //显示脂肪燃烧
            label3.frame = CGRect(x: 0, y: frame.height / 5 * 3, width: frame.width, height: label3.frame.height * 2)
            label3.text = " 0分钟\n 脂肪燃烧"
            label3.textAlignment = .left
            label3.numberOfLines = 0
            addSubview(label3)
            label3.layer.zPosition = 10
            label3.font = UIFont(name: font_name, size: 12)
            
            drawCell3(0, forSportType: .value1)
            drawCell3(0, forSportType: .value2)
            drawCell3(0, forSportType: .value3)
        case .cell4:
            //绘制下降曲线
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.fillColor = nil
            shapeLayer.lineWidth = 1
            shapeLayer.lineJoin = kCALineJoinRound
            shapeLayer.lineCap = kCALineCapRound
            
            let bezierPath = UIBezierPath()
            let startPoint =    CGPoint(x: frame.width * 0.05, y: frame.height * 0.5)
            let endPoint =      CGPoint(x: frame.width * 0.95, y: frame.height * 0.5)
            let controlPoint =  CGPoint(x: frame.width * 0.5, y: frame.height * 0.0)
            bezierPath.move(to: startPoint)
//            bezierPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
            let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
            bezierPath.addArc(withCenter: centerPoint, radius: frame.width * 0.45, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
            
            shapeLayer.path = bezierPath.cgPath
            
            layer.addSublayer(shapeLayer)
            shapeLayerList.append(shapeLayer)
            
            //绘制开始点and结束点
            let pointSize = CGSize(width: frame.width * 0.08, height: frame.height * 0.08)
            
            let startView = UIView(frame: CGRect(x: startPoint.x - pointSize.width / 2, y: startPoint.y - pointSize.height / 2, width: pointSize.width, height: pointSize.height))
            startView.backgroundColor = .lightGray
            startView.layer.cornerRadius = pointSize.width / 2
            addSubview(startView)
            
            let endView = UIView(frame: CGRect(x: endPoint.x - pointSize.width / 2, y: endPoint.y - pointSize.height / 2, width: pointSize.width, height: pointSize.height))
            endView.backgroundColor = .lightGray
            endView.layer.cornerRadius = pointSize.width / 2
            addSubview(endView)
            
            //绘制控制点
            weightPointView = UIView(frame: startView.frame)
            weightPointView?.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            weightPointView?.layer.cornerRadius = pointSize.width / 2
            weightPointView?.layer.borderColor = UIColor.green.cgColor
            weightPointView?.layer.borderWidth = 2
            addSubview(weightPointView!)
            
            //显示起始体重
            label1.frame = CGRect(x: 0, y: startPoint.y + pointSize.height / 2, width: frame.width, height: label1.frame.height)
            label1.text = " 0kg"
            label1.textAlignment = .left
            addSubview(label1)
            label1.font = UIFont(name: font_name, size: 12)
            
            //显示目标体重
            label2.frame = CGRect(x: 0, y: endPoint.y + pointSize.height / 2, width: frame.width, height: label2.frame.height)
            label2.text = "0kg "
            label2.textAlignment = .right
            addSubview(label2)
            label2.font = UIFont(name: font_name, size: 12)
            
            //显示当前体重
            label3.frame = CGRect(x: 0, y: frame.height - label2.frame.height * 4.1, width: frame.width, height: label3.frame.height * 2)
            label3.text = "当前体重:\n0kg"
            label3.textAlignment = .left
            addSubview(label3)
            label3.numberOfLines = 0
            label3.font = UIFont(name: font_name, size: 12)
            
            //显示起始时间
            label4.frame = CGRect(x: 0, y: frame.height - label4.frame.height * 1.5, width: frame.width, height: label4.frame.height)
            label4.text = "减重起始:..."
            label4.textAlignment = .left
            addSubview(label4)
            
        case .cell5:
            let imageView = UIImageView(image: UIImage(named: "icon_food"))
            imageView.frame.origin = CGPoint(x: frame.width / 2 - imageView.frame.width / 2, y: frame.height * 0.05)
            addSubview(imageView)
            
            //显示饮食状况
            label1.frame = CGRect(x: 0, y: frame.height - label1.frame.height * 1.5, width: frame.width, height: label1.frame.height)
            label1.text = "饮食情况:正常"
            addSubview(label1)
            
            //底图
            let imageView0 = UIImageView(image: UIImage(named: "icon_food_0"))
            imageView0.frame = CGRect(x: frame.width / 2 - frame.width * 0.6 / 2, y: frame.height / 2 - frame.height * 0.6 / 2, width: frame.width * 0.6, height: frame.height * 0.6)
            addSubview(imageView0)
            
            //正常food图
            let imageView1 = UIImageView(image: UIImage(named: "icon_food_1"))
            imageView1.frame = imageView0.frame
            addSubview(imageView1)
            imageView1.isUserInteractionEnabled = true

            foodImageHeight = imageView0.frame.height
            
            //添加遮罩
            let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageView0.frame.width, height: imageView0.frame.height))
            shapeLayer = CAShapeLayer()
            shapeLayer?.path = bezierPath.cgPath
            imageView1.layer.mask = shapeLayer
        case .cell6:
            
            cellContent = Cell6Content(frame: frame)
            addSubview(cellContent!)
            
            //显示需消耗卡路里
            label1.frame = CGRect(x: 0, y: frame.height - label1.frame.height * 2.8, width: frame.width, height: label1.frame.height)
            label1.text = "需消耗:0卡路里"
            label1.textAlignment = .left
            addSubview(label1)
            
            label2.frame = CGRect(x: 0, y: frame.height - label1.frame.height * 1.5, width: frame.width, height: label1.frame.height)
            label2.text = "已消耗:0卡路里"
            label2.textAlignment = .left
            addSubview(label2)
        }
    }
    
    //MARK:- Cell2 睡眠等级绘制
    private func drawCell2(_ values: [CGFloat]){
        
        //清除之前的图形
        shapeLayerList.forEach(){
            shapeLayer in
            shapeLayer.removeFromSuperlayer()
        }
        shapeLayerList.removeAll()
        
        //设置中心点
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        //添加半圆
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 20
        shapeLayer.lineJoin = kCALineJoinRound
        
        
        
        let refreshRadius = frame.size.height/2 * 0.8
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: centerPoint,
                          radius: refreshRadius * 0.9,
                          startAngle: -CGFloat(M_PI),
                          endAngle: 0,
                          clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        
        layer.addSublayer(shapeLayer)
        shapeLayerList.append(shapeLayer)
        
        //属性
        let colorList = [UIColor.red.cgColor,
                         UIColor.green.withAlphaComponent(0.4).cgColor,
                         UIColor.green.cgColor,
                         UIColor.red.withAlphaComponent(0.4).cgColor,
                         UIColor.red.withAlphaComponent(0.2).cgColor]
        
        let sumValue = values.reduce(0){$0 + $1}
        var curValue:CGFloat = 0
        
        //添加圆形进度条
        values.enumerated().forEach(){
            index, value in
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = colorList[index]
            shapeLayer.fillColor = nil
            shapeLayer.lineWidth = 20
            shapeLayer.lineJoin = kCALineJoinRound
            
            let refreshRadius = frame.size.height/2 * 0.8
            let bezierPath = UIBezierPath()
            let startAngle = -CGFloat(M_PI) + CGFloat(M_PI) * curValue / sumValue
            let endAngle = -CGFloat(M_PI) + CGFloat(M_PI) * (value + curValue) / sumValue
            curValue += value
            bezierPath.addArc(withCenter: centerPoint,
                              radius: refreshRadius * 0.9,
                              startAngle: startAngle,
                              endAngle: endAngle,
                              clockwise: true)
            shapeLayer.path = bezierPath.cgPath
            
            layer.addSublayer(shapeLayer)
            shapeLayerList.append(shapeLayer)
        }
    }
    
    //MARK:- Cell3 运动消耗绘制
    private func drawCell3(_ value: CGFloat, forSportType sportType: SportType){
        
        //清除之前的图形
        if let oldShapeLayer = sportShapeLayerMap[sportType]{
            oldShapeLayer.removeFromSuperlayer()
            sportShapeLayerMap[sportType] = nil
        }
        
        //遮罩颜色
        if gradientLayerMap[sportType] == nil{
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = frame
            layer.addSublayer(gradientLayer)
            
            //设置渐变颜色方向
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            
            //设置颜色组
            var colors: [CGColor]
            switch sportType {
            case .value1:
                colors = [UIColor.red.cgColor, UIColor.white.cgColor]
            case .value2:
                colors = [UIColor.orange.cgColor, UIColor.white.cgColor]
            case .value3:
                colors = [UIColor.yellow.cgColor, UIColor.white.cgColor]
            }
            gradientLayer.colors = colors
            gradientLayer.locations = [0, 1]
            
            gradientLayerMap[sportType] = gradientLayer
        }
        layer.addSublayer(gradientLayerMap[sportType]!)
        
        //y轴偏移
        var posY:CGFloat
        switch sportType {
        case .value1:
            posY = frame.height / 5 + frame.height / 5 / 2
        case .value2:
            posY = frame.height / 5 * 2 + frame.height / 5 / 2
        case .value3:
            posY = frame.height / 5 * 3 + frame.height / 5 / 2
        }
        
        //绘制
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = frame.height / 5 * 0.8
        shapeLayer.lineJoin = kCALineJoinRound
        
        let bezierPath = UIBezierPath()
        let startPoint = CGPoint(x: 0, y: posY)
        let endPoint = CGPoint(x: frame.width, y: startPoint.y)
        bezierPath.move(to: startPoint)
        bezierPath.addLine(to: endPoint)
        shapeLayer.path = bezierPath.cgPath
        
        layer.addSublayer(shapeLayer)
        sportShapeLayerMap[sportType] = shapeLayer
        
        gradientLayerMap[sportType]?.mask = shapeLayer
        
        
        //动画
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeStartAnimation.fromValue = -0.1
        strokeStartAnimation.toValue = value / 789 * 0.9
        strokeStartAnimation.duration = 1.5
        strokeStartAnimation.fillMode = kCAFillModeBoth
        strokeStartAnimation.isRemovedOnCompletion = false
        shapeLayer.add(strokeStartAnimation, forKey: nil)
    }
    
    //MARK:- Cell4体重——移动——获取到value3时调用
    private func moveCell4(){
        
        guard let path = shapeLayerList.first?.path else {
            return
        }
        
        let pathAnim = CAKeyframeAnimation(keyPath: "position")
        pathAnim.path = path
        pathAnim.calculationMode = kCAAnimationPaced
        pathAnim.rotationMode = kCAAnimationRotateAutoReverse
        pathAnim.isRemovedOnCompletion = false
        pathAnim.fillMode = kCAFillModeForwards
        pathAnim.duration = 1.0
        
        var offsetRate = Double(fabs(value2 - value1) / fabs(value3 - value1))
        if offsetRate > 1{
            offsetRate = 1
        }
        pathAnim.timeOffset = offsetRate * pathAnim.duration
        weightPointView?.layer.add(pathAnim, forKey: "path")
        
        //渐入_只是为了掩盖bug - -
        let fadeInAnim = CAKeyframeAnimation(keyPath: "opacity")
        fadeInAnim.values = [0, 0, 1, 1]
        fadeInAnim.keyTimes = [0, NSNumber(value: pathAnim.timeOffset), NSNumber(value: pathAnim.timeOffset), 1]
        fadeInAnim.duration = pathAnim.duration
        weightPointView?.layer.add(fadeInAnim, forKey: nil)
    }
    
    //MARK:- Cell5饮食情况
    fileprivate func drawCell5(_ rateValue: CGFloat){
        guard let shape = shapeLayer else {
            return
        }
        
        let anim = CABasicAnimation(keyPath: "position.y")
        let plusValue = foodImageHeight * 0.1 * (1 - rateValue * 10 / 9)
        anim.toValue = foodImageHeight * rateValue - plusValue
        anim.duration = 0.5
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = false
        shape.add(anim, forKey: nil)
    }
    
    //MARK:- Cell6颜色动画——赋值
    private func drawCell6(_ demandValue: CGFloat, completeValue: CGFloat){
        
        //需消耗卡路里、已消耗卡路里
        cellContent?.value = (demandValue, completeValue)
    }
}

extension SubCell{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach(){
            touch in
            let view = touch.view
            
            //cell5点击
            if let imageView = view as? UIImageView, type == SubCellType.cell5 {
                let location = touch.location(in: imageView)
                let index = foodTextList.count - 1 - Int(location.y) / Int(foodImageHeight / 5)
                label1.text = "饮食情况:\(foodTextList[index])"
                drawCell5(1 - (CGFloat(index) * 0.2 + 0.1))
                
                return
            }else{
                
                let anim = CABasicAnimation(keyPath: "transform.scale.x")
                anim.toValue = 0.5
                anim.duration = 0.05
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = true
                anim.autoreverses = true
                layer.add(anim, forKey: "began")
            }
        }        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closure?(type!)
    }
    
    
}
