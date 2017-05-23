//
//  RecordHeaderView.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordHeaderView: UIView {
    
    private var type: RecordType!
    
    //高亮选择
    fileprivate lazy var selectedView: UIView = {
        let selectedView: UIView = UIView()
        selectedView.backgroundColor = .clear
        
        selectedView.alpha = 1
        selectedView.isHidden = true
        let dataWidth: CGFloat = 2
        let superViewOriginY = self.frame.origin.y
        selectedView.frame = CGRect(x: 0, y: 20, width: dataWidth, height: self.bounds.height)
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: dataWidth, height: superViewOriginY - 24)
        gradient.locations = [0.2, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gradient.name = "layer"
        selectedView.layer.addSublayer(gradient)
        
        self.selectedLabel.frame.origin.x = dataWidth / 2 - 60
        selectedView.addSubview(self.selectedLabel)
        
        if self.type == .weight{
            selectedView.addSubview(self.weightDeltaLabel)
        }
        
        //添加小三角
        let triangleFrame = CGRect(x: -8, y: 0, width: 11, height: 4)
        let triangle = UIImageView(frame: triangleFrame)
        let triangleImage = UIImage(named: "resource/sporticons/mood/triangle")
        triangle.image = triangleImage
        selectedView.addSubview(triangle)
        
        return selectedView
    }()
    //显示选择数据值
    fileprivate lazy var selectedLabel: UILabel = {
        let selectedLabel: UILabel = UILabel()
        selectedLabel.tag = 0
        selectedLabel.font = fontSmall
        
        var labelFrame = CGRect(x: -60, y: -34, width: 120, height: 34)
        selectedLabel.frame = labelFrame
        selectedLabel.layer.backgroundColor = UIColor.white.cgColor
        selectedLabel.textColor = wordColor
        
        selectedLabel.textAlignment = .center
        selectedLabel.numberOfLines = -1
        selectedLabel.layer.cornerRadius = 2
        selectedLabel.layer.shadowColor = UIColor.black.cgColor
        selectedLabel.layer.shadowOpacity = 0.5
        selectedLabel.layer.shadowRadius = 1
        selectedLabel.layer.shadowOffset = .zero
        labelFrame.origin = .zero
        selectedLabel.layer.shadowPath = CGPath(rect: labelFrame, transform: nil)
        selectedLabel.clipsToBounds = false
        return selectedLabel
    }()
    
    //显示体重数据
    fileprivate lazy var weightDeltaLabel: UILabel = {
        let weightDeltaLabel: UILabel = UILabel()
        weightDeltaLabel.tag = 1
        weightDeltaLabel.font = fontBig
        weightDeltaLabel.frame = CGRect(x: -20, y: self.frame.height * 0.4, width: 80, height: 44)
        weightDeltaLabel.textColor = UIColor.red.withAlphaComponent(0.5)
        weightDeltaLabel.textAlignment = .center
        weightDeltaLabel.layer.shadowColor = UIColor.black.cgColor
        return weightDeltaLabel
    }()
    
    
    
    //MARK:- sport
    private lazy var sportImageView: UIImageView? = {
        let length: CGFloat = min(self.bounds.width, self.bounds.height) * 0.8
        let imageFrame = CGRect(x: (self.bounds.width - length) / 2, y: (self.bounds.height - length) / 2, width: length, height: length)
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = UIImage(named: "resource/sporticons/bigicon/none")?.transfromImage(size: imageFrame.size)
        return imageView
    }()
    var sportType: SportType?{
        didSet{
            guard let t = sportType else {
                return
            }
            
            if let name = sportTypeNameMap[t]{
                let image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: sportImageView!.bounds.size)
                sportImageView?.image = image
            }else{
                sportImageView?.image = nil
            }
        }
    }
    
    //MARK:- sleep
    private lazy var sleepTimeLabel: UILabel? = {
        let labelFrame = CGRect(x: 0, y: self.frame.height * 0.2, width: self.frame.width, height: 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    var sleepMinute: Int?{
        didSet{
            guard let totalMinute = sleepMinute else {
                return
            }

            //修改生日文字
            sleepTimeLabel?.textColor = .white
            
            let hour = totalMinute / 60
            let minute = totalMinute - hour * 60
            let hourStr = hour > 0 ? "\(hour)小时" : ""
            var minuteStr = ""
            if minute > 0 {
                if minute > 10{
                    minuteStr = "\(minute)分钟"
                }else{
                    minuteStr = "0\(minute)分钟"
                }
            }
            let text = hourStr + minuteStr
            let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle])
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))   //minute
            if hourStr != "" {
                attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2 - 4, 2))   //hour
            }
            sleepTimeLabel?.attributedText = attributeString
        }
    }
    
    //MARK:- weight
    var weightDataList: [(date: Date, weight: CGFloat)]?{
        didSet{
            updateWeights()
        }
    }
    var weightTarget: CGFloat?{
        didSet{
            updateWeights()
        }
    }
    fileprivate let weightStartX: CGFloat = 38
    fileprivate let weightEndX: CGFloat = 16
    fileprivate var markCircleList = [(shape: CAShapeLayer, weight: CGFloat, offset: CGFloat)]()
    
    
    //MARK:- init *********************************************************************************
    init(withRecordType type: RecordType, top: CGFloat, bottom: CGFloat) {
        let frame = CGRect(x: 0, y: top - 8, width: view_size.width, height: bottom - (top - 8) - 22)
        super.init(frame: frame)
        
        self.type = type
        
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
        switch type as RecordType {
        case .sport:
            addSubview(sportImageView!)
        case .sleep:
            (0..<10).forEach{
                i in
                let subViewFrame = CGRect(x: (frame.width - 20 * 2) / 10 * CGFloat(i) + 20, y: frame.height * 0.7, width: (frame.width - 20 * 2) / 10 - 2, height: frame.height * 0.3)
                let subView = UIView(frame: subViewFrame)
                subView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                addSubview(subView)
            }
        case .weight:
            addSubview(selectedView)
        default:
            break
        }
    }
    
    //MARK:- 更新体重
    private func updateWeights(){
        
        subviews.forEach{
            v in
            v.removeFromSuperview()
        }
        layer.sublayers?.forEach{
            l in
            l.removeFromSuperlayer()
        }
        
        layer.sublayers?.removeAll()
        markCircleList.removeAll()
        
        guard let dataList = weightDataList else {
            return
        }
        
        guard let sortedDataList = weightDataList?.sorted(by: {$0.weight > $1.weight}) else{
            return
        }
        guard var maxWeight = sortedDataList.first?.weight, var minWeight = sortedDataList.last?.weight else{
            return
        }
        
        //调整最大值与最小值
        let targetWeight = weightTarget ?? 65                               //默认目标值
        if targetWeight > maxWeight{
            maxWeight = targetWeight
        }else if targetWeight < minWeight{
            minWeight = targetWeight
        }
        
        //定义常量
        let bottomIntervalHeight: CGFloat = 20                              //底部间隔
        let topIntervalHeight: CGFloat = 20                                 //顶部间隔
        let totalHeight = frame.height - topIntervalHeight - bottomIntervalHeight       //获取绘图区域总高度
        let circleRadius: CGFloat = 8                                       //小圆圈半径
        
        //绘制数据线
        let upLineBezier = UIBezierPath()
        upLineBezier.move(to: CGPoint(x: 38, y: topIntervalHeight))
        upLineBezier.addLine(to: CGPoint(x: frame.width - 16, y: topIntervalHeight))
        let upLineLayer = CAShapeLayer()
        upLineLayer.path = upLineBezier.cgPath
        upLineLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        upLineLayer.lineWidth = 1
        upLineLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(upLineLayer)
        
        let upLabel = UILabel()
        upLabel.frame = CGRect(x: 0, y:  topIntervalHeight - 17 / 2, width: 38, height: 17)
        upLabel.text = "\(maxWeight)"
        upLabel.textAlignment = .center
        upLabel.font = fontSmall
        upLabel.textColor = .white
        upLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
        upLabel.layer.cornerRadius = 2
        self.addSubview(upLabel)
        
        let downLineBezier = UIBezierPath()
        downLineBezier.move(to: CGPoint(x: 38, y: topIntervalHeight + totalHeight))
        downLineBezier.addLine(to: CGPoint(x: frame.width - 16, y: topIntervalHeight + totalHeight))
        let downLineLayer = CAShapeLayer()
        downLineLayer.path = downLineBezier.cgPath
        downLineLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        downLineLayer.lineWidth = 1
        downLineLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(downLineLayer)
        
        let downLabel = UILabel()
        downLabel.frame = CGRect(x: 0, y: topIntervalHeight + totalHeight - 17 / 2, width: 38, height: 17)
        downLabel.text = "\(minWeight)"
        downLabel.textAlignment = .center
        downLabel.font = fontSmall
        downLabel.textColor = .white
        downLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
        downLabel.layer.cornerRadius = 2
        self.addSubview(downLabel)
        
        if targetWeight != maxWeight && targetWeight != maxWeight{
            
            let targetY = (1 - (targetWeight - minWeight) / (maxWeight - minWeight)) * totalHeight + topIntervalHeight
            let targetLineBezier = UIBezierPath()
            targetLineBezier.move(to: CGPoint(x: 0, y: targetY))
            targetLineBezier.addLine(to: CGPoint(x: frame.width, y: targetY))
            let targetLineLayer = CAShapeLayer()
            targetLineLayer.path = targetLineBezier.cgPath
            targetLineLayer.lineDashPattern = [2, 3]
            targetLineLayer.strokeColor = UIColor.white.cgColor
            targetLineLayer.lineWidth = 2
            targetLineLayer.lineCap = kCALineCapRound
            self.layer.addSublayer(targetLineLayer)
            
            let targetLabel = UILabel()
            targetLabel.frame = CGRect(x: 0, y: targetY - 17, width: 64, height: 17)
            targetLabel.text = "目标\(targetWeight)"
            targetLabel.textAlignment = .center
            targetLabel.font = fontSmall
            targetLabel.textColor = .white
            self.addSubview(targetLabel)
        }
        
        //绘制柱状图
        let dataListCount = dataList.count
        let bezier = UIBezierPath()
        dataList.enumerated().forEach(){
            index, element in
            
            if index == 0{
                let startPoint = CGPoint(x: weightStartX, y: (1 - (element.weight - minWeight) / (maxWeight - minWeight)) * totalHeight + topIntervalHeight)
                bezier.move(to: startPoint)
                
                //添加小圆圈
                let markCircle = UIBezierPath(ovalIn: CGRect(x: startPoint.x - circleRadius / 2, y: startPoint.y - circleRadius / 2, width: circleRadius, height: circleRadius))
                let markLayer = CAShapeLayer()
                markLayer.path = markCircle.cgPath
                markLayer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
                markLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
                markLayer.lineWidth = 2
                self.layer.addSublayer(markLayer)
                self.markCircleList.append((shape: markLayer, weight: element.weight, offset: 0))
                
                //动画
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.fromValue = 0
                anim.toValue = 1
                anim.duration = 0.3
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = true
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                markLayer.add(anim, forKey: nil)
            }else{
                let nextPoint = CGPoint(x: CGFloat(index) * ((frame.width - weightStartX - weightEndX) / CGFloat(dataListCount)) + weightStartX,
                                        y: (1 - (element.weight - minWeight) / (maxWeight - minWeight)) * totalHeight + topIntervalHeight)
                bezier.addLine(to: nextPoint)
                
                //添加小圆圈
                let markCircle = UIBezierPath(ovalIn: CGRect(x: nextPoint.x - circleRadius / 2, y: nextPoint.y - circleRadius / 2, width: circleRadius, height: circleRadius))
                let markLayer = CAShapeLayer()
                markLayer.path = markCircle.cgPath
                markLayer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
                markLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
                markLayer.lineWidth = 2
                self.layer.addSublayer(markLayer)
                self.markCircleList.append((shape: markLayer, weight: element.weight, offset: 0))
                
                //动画
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.fromValue = 0
                anim.toValue = 1
                anim.duration = 0.3
                let time = layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                anim.beginTime = time + 0.5
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = true
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                markLayer.add(anim, forKey: nil)
            }
            
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 2
        self.layer.addSublayer(shapeLayer)
        
        //动画
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.3
        let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
        anim.beginTime = time + 0.3
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        shapeLayer.add(anim, forKey: nil)
    }
}

//MARK:- 触摸事件
extension RecordHeaderView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        guard let dataList = weightDataList, !dataList.isEmpty else {
            return
        }
        
        addSubview(selectedView)
        
        let location = touch.location(in: self)
        let dataWidth = (bounds.width - weightStartX - weightEndX) / CGFloat(dataList.count)
        let dataIndex = Int((location.x - weightStartX) / dataWidth)
        guard dataIndex < dataList.count, dataIndex >= 0 else{
            return
        }
        
        let newSelectedViewOriginX = CGFloat(dataIndex) * dataWidth + weightStartX
        selectedView.frame.origin.x = newSelectedViewOriginX
        
        selectedView.isHidden = false
        
        touchesMoved(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        guard let dataList = weightDataList, !dataList.isEmpty else {
            return
        }
        
        let location = touch.location(in: self)
        let dataWidth = (bounds.width - weightStartX - weightEndX) / CGFloat(dataList.count)
        let dataIndex = Int((location.x - weightStartX + dataWidth / 2) / dataWidth)
        guard dataIndex < dataList.count, dataIndex >= 0 else{
            return
        }
        
        selectedView.isHidden = false
        let unit = "kg"
        
        //改变显示view x轴位置
        var currentX = location.x
        let firstCircleX = (bounds.width - weightStartX - weightEndX) / CGFloat(dataList.count) * 0 + weightStartX
        if currentX < firstCircleX{
            currentX = firstCircleX
        }
        selectedView.frame.origin.x = currentX
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0,
                                width: bounds.width - weightStartX - weightEndX - (currentX - weightStartX),
                                height: self.frame.height - 20)
        gradient.locations = [0.2, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.name = "layer"
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        if let oldLayers = selectedView.layer.sublayers?.filter({$0.name == "layer"}){
            if let last = oldLayers.last{
                last.removeFromSuperlayer()
            }
        }
        selectedView.layer.addSublayer(gradient)
        
        //改变label位置
        let labels = selectedView.subviews.filter(){$0.isKind(of: UILabel.self)}
        labels.forEach(){
            label in
            UIView.animate(withDuration: 0.3){
                
                if label.tag == 0{
                    
                    var posX: CGFloat = -label.bounds.width / 2
                    let convertX = self.convert(CGPoint(x: posX, y: 0), from: self.selectedView).x
                    if convertX < 0{
                        posX = self.convert(.zero, to: self.selectedView).x
                    }else if convertX + label.frame.width > self.bounds.width{
                        posX = self.convert(CGPoint(x: self.bounds.width - label.frame.width, y: 0), to: self.selectedView).x
                    }
                    label.frame.origin.x = posX
                }else{
                    label.frame.origin.x = (self.bounds.width - currentX - label.frame.width) / 2
                }
            }
        }
        
        //设置显示值 selected view
        let data = dataList[dataIndex]
        
        //获取日期
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        let dateStr = formatter.string(from: dataList[dataIndex].date)
        
        //体脂率
        let fatWeight = 13
        
        selectedLabel.text = "\(data.weight)" + unit + "\n" + "体脂率\(fatWeight)%"
        
        //体重差值
        if dataIndex == dataList.count - 1{
            weightDeltaLabel.text = ""
        }else{
            let lastData = dataList.last!
            if lastData.weight - data.weight >= 0{
                weightDeltaLabel.text = "+\(lastData.weight - data.weight)"
                weightDeltaLabel.textColor = .white
            }else{
                weightDeltaLabel.text = "-\(data.weight - lastData.weight)"
                weightDeltaLabel.textColor = UIColor.red.withAlphaComponent(0.5)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedView.isHidden = true
        selectedView.removeFromSuperview()
    }
}
