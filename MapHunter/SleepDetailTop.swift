//
//  SleepDetailTop.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/1.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SleepDetailTop: DetailTopBase {
    
    fileprivate var sleepDate = Date()
    fileprivate var wakeHour = 0
    fileprivate var wakeMinute = 0
    fileprivate var sleepDuration = 0
    fileprivate var sleepDataList = [(type: Int, minutes: Int)]()
    fileprivate var heartrateDataList = [(offset: Int, heartrate: Int)]()
    
    fileprivate let heartrateButtonLength: CGFloat = 44
    private lazy var heartrateButton: UIButton = {
        let buttonFrame = CGRect(x: 0, y: self.frame.height - self.heartrateButtonLength * 2, width: self.heartrateButtonLength, height: self.heartrateButtonLength)
        let button: UIButton = UIButton(frame: buttonFrame)
        let imageSize = CGSize(width: self.heartrateButtonLength / 2, height: self.heartrateButtonLength / 2)
        button.setImage(UIImage(named: "resource/cube/sleep_heartrate_close")?.transfromImage(size: imageSize), for: .normal)
        button.setImage(UIImage(named: "resource/cube/sleep_heartrate_open")?.transfromImage(size: imageSize), for: .selected)
        button.addTarget(self, action: #selector(self.clickHeartrate(sender:)), for: .touchUpInside)
        return button
    }()
    fileprivate var heartrateView = UIView()
    fileprivate var isHeartrateShow = false{
        didSet{
            heartrateButton.isSelected = isHeartrateShow
            
            heartrateView.isHidden = !isHeartrateShow
        }
    }
    
    //睡眠说明文字
    fileprivate lazy var tipLabel: UILabel = {

        let tipLabelFrame = CGRect(x: 0, y: 8, width: self.frame.width, height: 17)
        let tipLabel: UILabel = UILabel(frame: tipLabelFrame)
        tipLabel.font = fontSmall
        tipLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        tipLabel.textAlignment = .center
        tipLabel.backgroundColor = .clear
        
        //添加图片混排
        let text = "清醒 快速眼动 浅睡 深睡"
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
        let length = fontSmall.pointSize * 1
        let imageSize = CGSize(width: length, height: length)
        let imageBounds = CGRect(x: 0, y: length / 2 - tipLabelFrame.height / 2, width: length, height: length)
        var endIndex: Int = 0       //插入位置
        (0..<4).forEach{
            i in
            let startAttach = NSTextAttachment()
            startAttach.bounds = imageBounds
            
            if i == 0{
                endIndex = 0
                startAttach.image = self.getImage(1)
            }else if i == 1{
                endIndex = 3 + i
                startAttach.image = self.getImage(0)
            }else if i == 2{
                endIndex = 8 + i
                startAttach.image = self.getImage(2)
            }else if i == 3{
                endIndex = 11 + i
                startAttach.image = self.getImage(3)
            }
            
            let startAttributed = NSAttributedString(attachment: startAttach)
            attributedString.insert(startAttributed, at: endIndex)
        }
        tipLabel.attributedText = attributedString
        
        return tipLabel
    }()
    
    private func getImage(_ sleepType: Int) -> UIImage{
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        v.layer.cornerRadius = v.frame.height / 2
        v.backgroundColor = self.sleepColors[sleepType]
        
        UIGraphicsBeginImageContextWithOptions(v.frame.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        v.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //睡眠类型颜色
    private let sleepColors = [UIColor(red: 85 / 255, green: 187 / 255, blue: 252 / 255, alpha: 1),
                               UIColor(red: 255 / 255, green: 205 / 255, blue: 52 / 255, alpha: 1),
                               UIColor(red: 14 / 255, green: 128 / 255, blue: 245 / 255, alpha: 1),
                               UIColor(red: 29 / 255, green: 57 / 255, blue: 181 / 255, alpha: 1)]
    
    //MARK:-init*****************************************************************************
    init() {
        super.init(detailType: .sleep)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func config() {
        super.config()
        
        addSubview(tipLabel)
        addSubview(heartrateButton)
        addSubview(heartrateView)
        
        isHeartrateShow = false
    }
    
    @objc private func clickHeartrate(sender: UIButton){
        isHeartrateShow = !isHeartrateShow
    }
    
    override func createContents() {
        
        //处理数据
        delegate?.sleepData(withSleepClosure: {
            wakeDate, result in
            
            let tmpResult = result
            let tmpWakeDate = wakeDate
            
            //隐藏empty label
            self.emptyLabel.isHidden = true
            
            self.sleepDataList = tmpResult                                   //存储有效数据
            
            let dataListCount = tmpResult.count                         //数据数量
            
            //起床时间
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: tmpWakeDate)
            self.wakeHour = components.hour!
            self.wakeMinute = components.minute!
            
            
            //获取数据总和
            tmpResult.forEach(){
                subResult in
                //累加总分钟
                self.sleepDuration += subResult.1
            }
            
            var offsetX: CGFloat = self.heartrateButtonLength                //计算数据x坐标值
            
            var rectWidth: CGFloat = 0
            let rectHeight = self.frame.height * 0.6 / 4                //柱状图高度
            
            //绘制柱状图
            tmpResult.enumerated().forEach(){
                index, subResult in
                
                let sleepType = subResult.0                             //获取睡眠类型
                let sleepColor = self.sleepColors[sleepType].cgColor         //获取睡眠颜色

                let sleepMinute = CGFloat(subResult.1)                            //获取数据
                rectWidth = (self.bounds.size.width - detailRadius - self.heartrateButtonLength) * sleepMinute / CGFloat(self.sleepDuration)
            
                var y: CGFloat                  //y坐标
                if sleepType == 0x00{           //眼动睡眠(这个00为自定，需确认)
                    y = self.bounds.height - rectHeight * 3
                }else if sleepType == 0x01{     //清醒
                    y = self.bounds.height - rectHeight * 4
                }else if sleepType == 0x02{     //浅睡
                    y = self.bounds.height - rectHeight * 2
                }else{                          //深睡
                    y = self.bounds.height - rectHeight * 1
                }
                let bezier = UIBezierPath(rect: CGRect(x: offsetX,
                                                       y: y,
                                                       width: rectWidth,
                                                       height: rectHeight))
                
                //累加宽度
                offsetX += rectWidth
                
                
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                shapeLayer.fillColor = sleepColor
                shapeLayer.lineWidth = 0
                self.layer.addSublayer(shapeLayer)
                
                //动画
                let alphaAnim = CABasicAnimation(keyPath: "opacity")
                alphaAnim.fromValue = 0
                alphaAnim.toValue = 0.8
                
                let scaleAnim = CABasicAnimation(keyPath: "transform.scale.x")
                scaleAnim.fromValue = 0
                scaleAnim.toValue = 1
                
                let group = CAAnimationGroup()
                let duration = 0.1
                group.animations = [alphaAnim, scaleAnim]
                group.duration = duration
                let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                group.beginTime = time + TimeInterval(index) * duration * 0.5
                group.fillMode = kCAFillModeBoth
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                shapeLayer.add(group, forKey: nil)
            }
            
            //入睡时间
            self.sleepDate = Date(timeInterval: -TimeInterval(self.sleepDuration) * 60, since: wakeDate)
            let sleepComponents = calendar.dateComponents([.hour, .minute], from: self.sleepDate)
            let sleepHour = sleepComponents.hour!
            let sleepMinute = sleepComponents.minute!
            
            //设置显示值 selected view
            let sleepHourStr = sleepHour < 10 ? "0\(sleepHour)" : "\(sleepHour)"
            let sleepMinuteStr = sleepMinute < 10 ? "0\(sleepMinute)" : "\(sleepMinute)"
            
            let wakeHourStr = self.wakeHour < 10 ? "0\(self.wakeHour)" : "\(self.wakeHour)"
            let wakeMinuteStr = self.wakeMinute < 10 ? "0\(self.wakeMinute)" : "\(self.wakeMinute)"
            
            let beginText = sleepHourStr + ":" + sleepMinuteStr
            let endText = wakeHourStr + ":" + wakeMinuteStr
            
            //添加总览数据
            self.detailCenter.value = self.delegate?.detailTotalValue()
            self.detailCenter.leftValue = self.delegate?.detailLeftValue()
            self.detailCenter.rightValue = self.delegate?.detailRightValue()
            
            //绘制起始文字
            let startLabel = UILabel()
            startLabel.frame = CGRect(x: detailRadius, y: 8, width: self.bounds.size.width / 2, height: 12)
            startLabel.textColor = .white
            startLabel.font = fontSmall
            startLabel.textAlignment = .left
            startLabel.text = beginText
            self.detailCenter.addSubview(startLabel)
            
            //绘制结束文字
            let endLabel = UILabel()
            endLabel.frame = CGRect(x: self.bounds.size.width / 2 - detailRadius, y: 8, width: self.bounds.size.width / 2, height: 12)
            endLabel.textColor = .white
            endLabel.font = fontSmall
            endLabel.textAlignment = .right
            endLabel.text = endText
            self.detailCenter.addSubview(endLabel)
            
            //添加选择view
            self.addSubview(self.selectedView)
        }, heartrateClosure: {
            heartrateDataList in
            //0:offset 1:heartrate
            
            self.heartrateDataList = heartrateDataList
            
            //获取最大值与最小值
            guard let maxHeartrate = heartrateDataList.sorted(by: {$0.1 > $1.1}).first, let minHeartrate = heartrateDataList.sorted(by: {$0.1 < $1.1}).first else{
                return
            }
            
            var offsetX: CGFloat = self.heartrateButtonLength                   //计算数据x坐标值
            let rectHeight = self.frame.height * 0.6                            //总高度
            let circleRadius: CGFloat = 8                                       //圆点半径
            
            //偏移
            var offset = 0
            let totalOffset = heartrateDataList.reduce(0){$0 + $1.0}
            
            let bezier = UIBezierPath()
            heartrateDataList.enumerated().forEach{
                index, element in
                
                let rate = CGFloat(element.1 - minHeartrate.1) / CGFloat(maxHeartrate.1 - minHeartrate.1)
                let x = CGFloat(offset) / CGFloat(totalOffset) * (self.frame.width - self.heartrateButtonLength - detailRadius)
                let y = (self.bounds.height - rectHeight) + rectHeight * (1 - rate) - circleRadius
                offset += element.0
                offsetX += CGFloat(x)
                
                let heartratePoint = CGPoint(x: x + self.heartrateButtonLength, y: y)
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
        })
    }
}

extension SleepDetailTop{
    override func currentTouchesBegan(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        guard location.y < detailTopHeight else {
            return
        }
        
        guard !sleepDataList.isEmpty else{
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
            
            let dataWidth = (bounds.size.width - detailRadius - heartrateButtonLength) / CGFloat(heartrateDataList.count)
            var dataIndex = Int((location.x - heartrateButtonLength) / dataWidth)
            guard dataIndex < heartrateDataList.count, dataIndex >= 0 else{
                return
            }
            
            //改变显示view x轴位置
            UIView.animate(withDuration: 0.3){
                self.selectedView.isHidden = false
                let x = self.heartrateButtonLength + CGFloat(dataIndex) * dataWidth - 1
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
            selectedLabel.text = "\(heartrate)" + "次／分钟" + "\n静止心率"
            
        }else{                  //睡眠数据
            
            var preOffsetX: CGFloat = 0
            var width: CGFloat = 0
            var offsetX: CGFloat = 0
            
            var dataIndex = 0
            for i in 0..<sleepDataList.count{
                let data = sleepDataList[i]
                let minutes = Int16(data.minutes)
                
                preOffsetX = offsetX
                
                width = (bounds.size.width - detailRadius - heartrateButtonLength) * CGFloat(minutes) / CGFloat(sleepDuration)
                offsetX += width
                
                dataIndex = i
                if offsetX + heartrateButtonLength >= location.x{
                    break
                }
            }
            
            //改变layer宽度
            let labels = selectedView.subviews.filter(){$0.isKind(of: UILabel.self)}
            if let label = labels.last{
                UIView.animate(withDuration: 0.3){
                    
                    self.selectedView.isHidden = false
                    let x = self.heartrateButtonLength + preOffsetX
                    let newFrame = CGRect(x: x, y: self.selectedView.frame.origin.y, width: width, height: self.selectedView.frame.height)
                    self.selectedView.frame = newFrame
                    
                    //改变小三角x位置
                    self.triangleView.frame.origin.x = width / 2 - self.triangleView.frame.width / 2
                    
                    
                    if let oldLayers = self.selectedView.layer.sublayers?.filter({$0.name == "layer"}){
                        if let last = oldLayers.last{
                            last.frame = self.selectedView.bounds
                        }
                    }
                    
                    var posX = (width - label.frame.width) / 2
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
            var subStartMinute: Int = 0
            var subEndMinute: Int = 0
            for i in 0..<sleepDataList.count{
                let data = sleepDataList[i]
                if i >= dataIndex{
                    subEndMinute = subStartMinute + sleepDataList[dataIndex].minutes
                    break
                }
                subStartMinute += data.minutes
            }
            
            let startDate = Date(timeInterval: TimeInterval(subStartMinute) * 60, since: sleepDate)
            let startComponents = Calendar.current.dateComponents([.hour, .minute], from: startDate)
            let startHour = startComponents.hour!
            let startMinute = startComponents.minute!
            let startHourStr = startHour < 10 ? "0\(startHour)" : "\(startHour)"
            let startMinuteStr = startMinute < 10 ? "0\(startMinute)" : "\(startMinute)"
            let startStr = startHourStr + ":" + startMinuteStr
            
            let endDate = Date(timeInterval: TimeInterval(subEndMinute) * 60, since: sleepDate)
            let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endDate)
            let endHour = endComponents.hour!
            let endMinute = endComponents.minute!
            let endHourStr = endHour < 10 ? "0\(endHour)" : "\(endHour)"
            let endMinuteStr = endMinute < 10 ? "0\(endMinute)" : "\(endMinute)"
            let endStr = endHourStr + ":" + endMinuteStr
            
            var typeStr: String = ""
            if dataIndex < sleepDataList.count{
                let typeIndex = sleepDataList[dataIndex].type
                switch typeIndex{
                case 0x00:
                    typeStr = "快速眼动"
                case 0x01:
                    typeStr = "清醒"
                case 0x02:
                    typeStr = "浅睡"
                case 0x03:
                    typeStr = "深睡"
                default:
                    typeStr = ""
                }
            }
            selectedLabel.text = startStr + "~" + endStr + "\n" + typeStr
        }
    }
    
    override func currentTouchesEnded(_ touches: Set<UITouch>){
        selectedView.isHidden = true
    }
}
