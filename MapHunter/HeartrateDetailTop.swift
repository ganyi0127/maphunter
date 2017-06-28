//
//  HeartrateDetailTop.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/1.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class HeartrateDetailTop: DetailTopBase {
    
    fileprivate let circleRadius: CGFloat = 8                                   //小圆圈直径
    fileprivate let startX: CGFloat = 38
    fileprivate let endX: CGFloat = 16
    
    fileprivate var deltaMinute = 30
    fileprivate var headCount = 0
    fileprivate var tailCount = 0
    
    fileprivate var bloodPressureMarkCircleList = [(diastolicShape: CAShapeLayer, diastolic: Int, systolic: Int, offset: Int)]()
    
    fileprivate var isHeartrateShow = true{
        didSet{
            if isHeartrateShow {
                emptyLabel.isHidden = !heartrateDataList.isEmpty
            }else{
                emptyLabel.isHidden = !bloodpressureDataList.isEmpty
            }
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.heartrateView.isHidden = !self.isHeartrateShow
                self.bloodpressureView.isHidden = self.isHeartrateShow
                self.buttonSeparator.frame.origin.x = self.isHeartrateShow ? (self.bounds.width / 2 - 36) / 2 : (self.bounds.width / 2 - 36) / 2 + self.bounds.width / 2
            })
        }
    }
    
    //下分割线
    private lazy var buttonSeparator: UIView = {
        let separatorFrame = CGRect(x: (self.bounds.width / 2 - 36) / 2, y: 24 - 2, width: 36, height: 2)
        let separator = UIView(frame: separatorFrame)
        separator.backgroundColor = .white
        return separator
    }()
    
    //心率按钮
    private lazy var heartrateButton: UIButton = {
        let buttonFrame = CGRect(x: 0, y: 0, width: self.bounds.width / 2, height: 32)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("心率", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(self.selectMode(sender:)), for: .touchUpInside)
        return button
    }()
    
    //血压按钮
    private lazy var bloodPressureButton: UIButton = {
        let buttonFrame = CGRect(x: self.bounds.width / 2, y: 0, width: self.bounds.width / 2, height: 32)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("血压", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(self.selectMode(sender:)), for: .touchUpInside)
        return button
    }()
    
    private var heartrateView = UIView()
    private var bloodpressureView = UIView()
    
    fileprivate var heartrateDataList = [(offset: Int, heartrate: Int)](){
        didSet{
            if !heartrateDataList.isEmpty {
                self.emptyLabel.isHidden = true
            }
        }
    }
    fileprivate var bloodpressureDataList = [(date: Date, diastolic: Int, systolic: Int)]()
    
    //MARK:-init**************************************************************************
    init() {
        super.init(detailType: .heartrate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-切换心率与血压
    @objc private func selectMode(sender: UIButton){
        let tag = sender.tag
        isHeartrateShow = tag == 0
    }
    
    override func config() {
        super.config()
        
        addSubview(heartrateButton)
        addSubview(bloodPressureButton)
        addSubview(buttonSeparator)
        
        addSubview(heartrateView)
        bloodpressureView.isHidden = true
        addSubview(bloodpressureView)
    }
    
    override func createContents() {
        super.createContents()
        
        let circleRadius: CGFloat = 8                                       //圆点半径
        let rectHeight = self.frame.height * 0.6                            //总高度
        
        delegate?.heartrateAndBloodpressure(withHeartrateClosure: {
            heartrateDataList in
            //0:offset 1:heartrate
            
            self.heartrateDataList = heartrateDataList
            
            //获取最大值与最小值
            guard let maxHeartrate = heartrateDataList.sorted(by: {$0.1 > $1.1}).first, let minHeartrate = heartrateDataList.sorted(by: {$0.1 < $1.1}).first else{
                return
            }
            
            //偏移
            var offset = 0
            self.headCount = heartrateDataList.first!.0
            self.tailCount = heartrateDataList.last!.0
            let totalOffset = heartrateDataList.reduce(0, {$0 + $1.0}) //- self.headCount - self.tailCount
            
            let bezier = UIBezierPath()
            heartrateDataList.enumerated().forEach{
                index, element in
                
                offset += element.0
                let rate = CGFloat(element.1 - minHeartrate.1) / CGFloat(maxHeartrate.1 - minHeartrate.1)
                let x = CGFloat(offset) / CGFloat(totalOffset) * (self.frame.width - detailRadius * 2)
                let y = (self.bounds.height - rectHeight) + rectHeight * (1 - rate) - circleRadius
                
                let heartratePoint = CGPoint(x: x + detailRadius, y: y)
                if index == 0{
                    bezier.move(to: heartratePoint)
                }else{
                    let prePoint = bezier.currentPoint
                    let cornerPoint = CGPoint(x: prePoint.x, y: y)
                    bezier.addLine(to: cornerPoint)
                    bezier.addLine(to: heartratePoint)
                }
            }
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezier.cgPath
            shapeLayer.lineWidth = 1
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.white.cgColor
            self.heartrateView.layer.addSublayer(shapeLayer)
            self.bringSubview(toFront: self.heartrateView)
            
            //动画
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = 0
            anim.toValue = 1
            anim.duration = 1
            anim.fillMode = kCAFillModeBoth
            anim.isRemovedOnCompletion = true
            shapeLayer.add(anim, forKey: nil)
        }, bloodPressureClosure: {
            bloodPressureResult in
            
            self.bloodpressureDataList = bloodPressureResult
            
            

            let rangeValues: [Int] = [250, 200, 150, 100, 50, 0]
            let rangeMin = rangeValues.min()!, rangeMax = rangeValues.max()!
            //绘制数据线
            rangeValues.enumerated().forEach{
                index, value in
                let upLineBezier = UIBezierPath()
                let y = (1 - CGFloat(value - rangeMin) / CGFloat(rangeMax - rangeMin)) * rectHeight + (self.bounds.height - rectHeight) - circleRadius
                upLineBezier.move(to: CGPoint(x: self.startX, y: y))
                upLineBezier.addLine(to: CGPoint(x: self.bounds.width - self.endX, y: y))
                let upLineLayer = CAShapeLayer()
                upLineLayer.path = upLineBezier.cgPath
                upLineLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                upLineLayer.lineWidth = 1
                upLineLayer.lineCap = kCALineCapRound
                self.bloodpressureView.layer.addSublayer(upLineLayer)
                
                let upLabel = UILabel()
                upLabel.frame = CGRect(x: 0, y:  y - 17 / 2, width: self.startX, height: 17)
                upLabel.text = "\(Int(value))"
                upLabel.font = fontSmall
                upLabel.textColor = .white
                upLabel.textAlignment = .center
                //upLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
                //upLabel.layer.cornerRadius = 2
                self.bloodpressureView.addSubview(upLabel)
            }
            
            let dataListCount = self.bloodpressureDataList.count
            
            for (index, element) in self.bloodpressureDataList.enumerated(){
                
                let x = (self.bounds.width - self.startX - self.endX) / CGFloat(dataListCount) * CGFloat(index) + self.startX
                let y0 = (1 - CGFloat(element.diastolic - rangeMin) / CGFloat(rangeMax - rangeMin)) * rectHeight + (self.bounds.height - rectHeight)
                let y1 = (1 - CGFloat(element.systolic - rangeMin) / CGFloat(rangeMax - rangeMin)) * rectHeight + (self.bounds.height - rectHeight) - circleRadius
                
                let bezier = UIBezierPath()
                bezier.move(to: CGPoint(x: x, y: y0))
                bezier.addLine(to: CGPoint(x: x, y: y1))
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                shapeLayer.fillColor = nil
                shapeLayer.lineCap = kCALineCapRound
                shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                shapeLayer.lineWidth = self.circleRadius * 0.5
                self.bloodpressureView.layer.insertSublayer(shapeLayer, at: 5)
                
                let anim = CABasicAnimation(keyPath: "strokeEnd")
                anim.fromValue = 0
                anim.toValue = 1
                anim.duration = 0.5
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = false
                shapeLayer.add(anim, forKey: nil)
                
                //添加小圆圈
                let markCircle0 = UIBezierPath(ovalIn: CGRect(x: x - self.circleRadius / 2, y: y0 - self.circleRadius / 2, width: self.circleRadius, height: self.circleRadius))
                let markCircle1 = UIBezierPath(ovalIn: CGRect(x: x - self.circleRadius / 2, y: y1 - self.circleRadius / 2, width: self.circleRadius, height: self.circleRadius))
                let markLayer0 = CAShapeLayer()
                markLayer0.path = markCircle0.cgPath
                markLayer0.fillColor = UIColor.white.cgColor
                markLayer0.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                markLayer0.lineWidth = 0
                self.bloodpressureView.layer.addSublayer(markLayer0)
                self.bloodPressureMarkCircleList.append((diastolicShape: markLayer0, diastolic: element.diastolic, systolic: element.systolic, offset: index))
                
                let markLayer1 = CAShapeLayer()
                markLayer1.path = markCircle1.cgPath
                markLayer1.fillColor = UIColor.white.cgColor
                markLayer1.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                markLayer1.lineWidth = 0
                self.bloodpressureView.layer.addSublayer(markLayer1)
            }
        })
        
        //起始文字*需要放入数据回调部分*
        var beginText = ""
        var endText = ""
        let countPerMinute: Int = 60 / self.deltaMinute
        let minute = headCount % countPerMinute * self.deltaMinute
        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        beginText = "\(headCount / (60 / self.deltaMinute)):" + minuteStr
        endText = "\(23 - tailCount / (60 / self.deltaMinute)):\(59 - tailCount % (60 / self.deltaMinute) * self.deltaMinute)"
        
        //获取 detail center
        let detailCenter = (self.superview as! DetailSV).detailCenter
        
        //添加数据
        if let value = self.delegate?.detailTotalValue(){
            detailCenter?.value = value
        }
        if let leftValue = self.delegate?.detailLeftValue(){
            detailCenter?.leftValue = leftValue
        }
        if let rightValue = self.delegate?.detailRightValue(){
            detailCenter?.rightValue = rightValue
        }
        
        //绘制起始文字
        let startLabel = UILabel()
        startLabel.frame = CGRect(x: detailRadius, y: 8, width: self.bounds.size.width / 2, height: 12)
        startLabel.textColor = .white
        startLabel.font = fontSmall
        startLabel.textAlignment = .left
        startLabel.text = beginText
        detailCenter?.addSubview(startLabel)
        
        //绘制结束文字
        let endLabel = UILabel()
        endLabel.frame = CGRect(x: self.bounds.size.width / 2 - detailRadius, y: 8, width: self.bounds.size.width / 2, height: 12)
        endLabel.textColor = .white
        endLabel.font = fontSmall
        endLabel.textAlignment = .right
        endLabel.text = endText
        detailCenter?.addSubview(endLabel)
        
        //添加选择view
        self.addSubview(self.selectedView)
    }
}

extension HeartrateDetailTop{
    override func currentTouchesBegan(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        guard location.y < detailTopHeight else {
            return
        }
        
        guard (!heartrateDataList.isEmpty && isHeartrateShow) || (!bloodpressureDataList.isEmpty && !isHeartrateShow) else{
            return
        }
        
        currentTouchesMoved(touches)
    }
    
    override func currentTouchesMoved(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        guard location.y < detailTopHeight else {
            return
        }        
        
        selectedView.isHidden = false
        
        if isHeartrateShow {    //心率数据
            
            let list = heartrateDataList
            guard !list.isEmpty else {
                return
            }
            
            let totalOffset = list.reduce(0, {$0 + $1.offset})
            var dataIndex = -1
            var offset = 0
            
            while (bounds.width - detailRadius * 2) * CGFloat(offset) / CGFloat(totalOffset) < (location.x - detailRadius) {
                dataIndex += 1
                if dataIndex < list.count {
                    offset += list[dataIndex].offset                    
                }else{
                    return
                }
            }

            guard dataIndex < list.count, dataIndex >= 0 else{
                return
            }
            
            //计算修正后x轴位置
            let x = (bounds.width - detailRadius * 2) * CGFloat(offset) / CGFloat(totalOffset) + detailRadius - 1
            
            
            //改变显示view x轴位置
            UIView.animate(withDuration: 0.3){
                self.selectedView.isHidden = false
                let width: CGFloat = 2
                let newFrame = CGRect(x: x, y: self.selectedView.frame.origin.y, width: width, height: self.selectedView.frame.height)
                self.selectedView.frame = newFrame
                
                //改变小三角x位置
                self.triangleView.frame.origin.x = width / 2 - self.triangleView.frame.width / 2
                
                
                if let oldLayers = self.selectedView.layer.sublayers?.filter({$0.name == "layer"}){
                    if let last = oldLayers.last{
                        last.frame = self.selectedView.bounds
                    }
                }
            }
            
            //改变label位置
            let labels = selectedView.subviews.filter(){$0.isKind(of: UILabel.self)}
            labels.forEach(){
                label in
                UIView.animate(withDuration: 0.3){
                    
                    if label.tag == 0{
                        
                        var posX: CGFloat = (self.selectedView.bounds.width - label.bounds.width) / 2
                        let convertX = self.convert(CGPoint(x: posX, y: 0), from: self.selectedView).x
                        if convertX < 0{
                            posX = self.convert(.zero, to: self.selectedView).x
                        }else if convertX + label.frame.width > self.bounds.width{
                            posX = self.convert(CGPoint(x: self.bounds.width - label.frame.width, y: 0), to: self.selectedView).x
                        }
                        label.frame.origin.x = posX
                    }
                }
            }
            
            //设置显示值 selected view
            let data = heartrateDataList[dataIndex]
            let heartrate = data.heartrate
            
            selectedLabel.text = "\(heartrate)" + "次／分钟" + "\n\(data.offset)"
            
        }else{                  //血压数据
            let dataList = bloodpressureDataList
            guard !dataList.isEmpty else {
                return
            }
            
            let location = touch.location(in: self)
            let dataWidth = (bounds.width - startX - endX) / CGFloat(dataList.count)
            let dataIndex = Int((location.x - startX + dataWidth / 2) / dataWidth)
            guard dataIndex < dataList.count, dataIndex >= 0 else{
                return
            }
            
            selectedView.isHidden = false
            let unit = "mmHg"
            
            //改变显示view x轴位置
            UIView.animate(withDuration: 0.3){
                self.selectedView.isHidden = false
                let x = self.startX + CGFloat(dataIndex) * dataWidth - self.circleRadius / 2
                self.selectedView.frame.origin.x = x
            }
            
            //改变label位置
            let labels = selectedView.subviews.filter(){$0.isKind(of: UILabel.self)}
            labels.forEach(){
                label in
                UIView.animate(withDuration: 0.3){
                    
                    let x = self.startX + CGFloat(dataIndex) * dataWidth - self.circleRadius / 2
                    let newFrame = CGRect(x: x, y: self.selectedView.frame.origin.y, width: self.circleRadius, height: self.selectedView.frame.height)
                    self.selectedView.frame = newFrame
                    
                    //改变小三角x位置
                    self.triangleView.frame.origin.x = self.circleRadius / 2 - self.triangleView.frame.width / 2
                    
                    
                    if let oldLayers = self.selectedView.layer.sublayers?.filter({$0.name == "layer"}){
                        if let last = oldLayers.last{
                            last.frame = self.selectedView.bounds
                        }
                    }
                    
                    var posX = (self.circleRadius - label.frame.width) / 2
                    let convertX = self.convert(CGPoint(x: posX, y: 0), from: self.selectedView).x
                    if convertX < 0{
                        posX = self.convert(.zero, to: self.selectedView).x
                    }else if convertX + label.frame.width > self.bounds.width{
                        posX = self.convert(CGPoint(x: self.bounds.width - label.frame.width, y: 0), to: self.selectedView).x
                    }
                    label.frame.origin.x = posX
                }
            }
            
            //设置显示值 selected view
            let data = dataList[dataIndex]
            let format = DateFormatter()
            format.dateFormat = "yyy-M-d h:m"
            let dateStr = format.string(from: data.date)
            
            selectedLabel.text = "\(data.diastolic)" + unit + "\n" + "\(data.systolic)" + unit
        }
    }
    
    override func currentTouchesEnded(_ touches: Set<UITouch>){
        selectedView.isHidden = true
    }
}
