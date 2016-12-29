//
//  DetailTop.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation

//睡眠类型标示位
let sleepTypeBit: Int16 = 1000

//模块数据代理
protocol DetailTopDelegate {
    func detailTopData() -> [CGFloat]
    func detailSleepBeginTime() -> Date
    func detailWeightDates() -> [Date]
}

class DetailTop: UIView {
    fileprivate var type: DataCubeType!
    
    var delegate: DetailTopDelegate?
    
    //main value
    private var value: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                unit = "%"
                text = "\(value / 10000 * 100)" + unit
            case .heartrate:
                unit = "Bmp"
                text = "\(Int16(value))\n" + unit
            case .sleep:
                unit = "%"
                text = "\(value / 10000 * 100)" + unit
            case .weight:
                unit = "Kg"
                text = "\(Int16(value))\n" + unit
            }
            
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontHuge])
            let unitLength = unit.characters.count, textLength = text.characters.count
            
            //字体大小
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(textLength - unitLength, unitLength))
            
            valueLabel.attributedText = mainAttributedString
        }
    }
    private var leftValue: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                unit = "步"
                text = "\(Int16(leftValue))" + unit
            case .sleep:
                unit = "分钟"
                let hour = Int16(leftValue) / 60
                let minute = Int16(leftValue) % 60
                let minuteStr = "\(minute)"
                text = "\(hour)小时" + minuteStr + "分钟"
                
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontMiddle])
                let unitLength = unit.characters.count
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength * 2 - minuteStr.characters.count, unitLength))
                leftLabel.attributedText = mainAttributedString
                return
            default:
                unit = ""
                text = ""
            }
            
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontMiddle])
            let unitLength = unit.characters.count
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            leftLabel.attributedText = mainAttributedString
        }
    }
    private var rightValue: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                unit = "公里"
                text = "\(rightValue)" + unit
            default:
                unit = ""
                text = ""
            }
            
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontMiddle])
            let unitLength = unit.characters.count
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            rightLabel.attributedText = mainAttributedString
        }
    }
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: (self.bounds.size.width - self.bounds.size.height * 1.5) / 2,
                             y: 0,
                             width: self.bounds.size.height * 1.5,
                             height: self.bounds.size.height)
        label.textAlignment = .center
        label.font = fontMiddle
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: self.bounds.size.height,
                             height: self.bounds.size.height)
        label.textAlignment = .center
        label.font = fontMiddle
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: self.bounds.size.width - self.bounds.size.height,
                             y: 0,
                             width: self.bounds.size.height,
                             height: self.bounds.size.height)
        label.textAlignment = .center
        label.font = fontMiddle
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //高亮选择
    lazy var selectedView: UIView = {
        let selectedView: UIView = UIView()
        selectedView.backgroundColor = .clear
        
        selectedView.alpha = 1
        selectedView.isHidden = true
        let dataWidth = (self.bounds.size.width - self.radius * 2) / CGFloat(self.dataList.count)
        let superViewOriginY = self.superview!.frame.origin.y
        selectedView.frame = CGRect(x: 0, y: -superViewOriginY + 24, width: dataWidth, height: superViewOriginY - 24)
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: dataWidth, height: superViewOriginY - 24)
        gradient.locations = [0.2, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor.white.withAlphaComponent(0.3).cgColor, modelStartColors[self.type]!.cgColor]
        gradient.name = "layer"
        selectedView.layer.addSublayer(gradient)
        
        self.selectedLabel.frame.origin.x = dataWidth / 2 - 20
        selectedView.addSubview(self.selectedLabel)
        
        if self.type == .weight{
            selectedView.addSubview(self.weightDeltaLabel)
        }
        return selectedView
    }()
    //显示选择数据值
    fileprivate lazy var selectedLabel: UILabel = {
        let selectedLabel: UILabel = UILabel()
        selectedLabel.tag = 0
        selectedLabel.font = fontSmall
        if self.type == .sleep || self.type == .weight{
            selectedLabel.frame = CGRect(x: -20, y: -34, width: 80, height: 34)
            selectedLabel.layer.backgroundColor = UIColor.white.cgColor
            selectedLabel.textColor = .black
        }else{
            selectedLabel.frame = CGRect(x: -20, y: -34, width: 40, height: 34)
            selectedLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
            selectedLabel.textColor = .white
        }
        selectedLabel.textAlignment = .center
        selectedLabel.numberOfLines = -1
        selectedLabel.layer.cornerRadius = 2
        selectedLabel.layer.shadowColor = UIColor.black.cgColor
        selectedLabel.layer.shadowOpacity = 0.5
        selectedLabel.layer.shadowRadius = 1
        selectedLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        selectedLabel.clipsToBounds = false
        return selectedLabel
    }()
    
    //显示体重数据
    fileprivate lazy var weightDeltaLabel: UILabel = {
        let weightDeltaLabel: UILabel = UILabel()
        weightDeltaLabel.tag = 1
        weightDeltaLabel.font = fontBig
        weightDeltaLabel.frame = CGRect(x: -20, y: 0, width: 80, height: 44)
        weightDeltaLabel.textColor = UIColor.red.withAlphaComponent(0.5)
        weightDeltaLabel.textAlignment = .center
        weightDeltaLabel.layer.shadowColor = UIColor.black.cgColor
        return weightDeltaLabel
    }()
    
    //MARK:- 存储数据
    fileprivate var deltaMinute: Int = 0
    fileprivate let radius: CGFloat = 10
    fileprivate var headCount: Int!
    var dataList: [CGFloat]!
    
    //睡眠
    fileprivate var startSleepHour: Int = 0
    fileprivate var startSleepMinute: Int = 0
    
    //心率
    fileprivate var markCircleList = [CAShapeLayer]()
    
    //体重
    fileprivate var dateList: [Date]?
    
    //MARK:- 心率图
    fileprivate var heartrateDataScroll: UIScrollView!
    
    //点击事件
    private var tap: UITapGestureRecognizer?
    
    var closure: (()->())?
    
    //MARK:- init
    init(detailType: DataCubeType){
        let frame = CGRect(x: 0,
                           y: 0,
                           width: view_size.width - edgeWidth * 2,
                           height: view_size.width * 0.3)
        super.init(frame: frame)
        
        type = detailType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        
        //绘制顶部图等
        drawGraphic()
    }
    
    deinit {
        removeGestureRecognizer(tap!)
    }
    
    private func config(){
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [modelStartColors[type]!.cgColor, modelEndColors[type]!.cgColor]
        gradient.cornerRadius = radius
        layer.addSublayer(gradient)
        
        //添加点击事件
        isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
    
    //MARK:- 点击事件
    @objc private func click(recognizer: UITapGestureRecognizer){
        closure?()
    }
    
    private func createContents(){
        
        //绘制大圆圈
        let bezierRadius = bounds.size.height - 4
        let bezierRect = CGRect(x: bounds.size.width / 2 - bezierRadius / 2,
                                y: bounds.size.height / 2 - bezierRadius / 2,
                                width: bezierRadius,
                                height: bezierRadius)
        let bezier = UIBezierPath(ovalIn: bezierRect)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        layer.addSublayer(shapeLayer)
        
        //添加圆圈label
        addSubview(valueLabel)
        
        //添加数据
        value = 6000
        
        //添加左右标签
        switch type as DataCubeType {
        case .sport:
            addSubview(leftLabel)
            addSubview(rightLabel)
            
            leftValue = 123
            rightValue = 456
        case .sleep:
            addSubview(leftLabel)
            leftValue = 123
        default:
            break
        }
    }
    
    //MARK:- 绘制图形
    private func drawGraphic(){
        
        guard let del = delegate else {
            return
        }
        
        //获取数据
        var dataList = del.detailTopData()
        
        //获取常量
        let cornerRadius: CGFloat = 2                                               //圆角半径
        
        //获取最大数值
        guard var maxData = dataList.max(), maxData > 0 else {
            return
        }
        
        //移除开始与结束为0的数据
        var headCount = 0, tailCount = 0
        while dataList.first! <= 0 {
            dataList.removeFirst()
            headCount += 1
        }
        while dataList.last! <= 0 {
            dataList.removeLast()
            tailCount += 1
        }
        
        //获取最小数值
        guard var minData = dataList.min() else {
            return
        }
        
        self.dataList = dataList                                                    //存储有效数据
        self.headCount = headCount                                                  //存储有效head offset
        
        let dataListCount = dataList.count                                          //数据数量
        var rectWidth = (bounds.size.width - radius * 2) / CGFloat(dataListCount)   //柱状图宽度
        let detailBackOriginY = self.superview!.frame.origin.y                      //柱状图高度
        
        //数据间隔分钟时间
        switch type as DataCubeType {
        case .sport:
            deltaMinute = 15
            
            //绘制柱状图
            dataList.enumerated().forEach(){
                index, data in
                
                let bezier = UIBezierPath(roundedRect: CGRect(x: CGFloat(index) * rectWidth + radius + rectWidth * 0.1,
                                                              y: -detailBackOriginY + cornerRadius,
                                                              width: rectWidth * 0.8,
                                                              height: detailBackOriginY),
                                          cornerRadius: cornerRadius)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                shapeLayer.fillColor = UIColor.yellow.cgColor
                shapeLayer.lineWidth = 0
                layer.insertSublayer(shapeLayer, at: 0)
                
                //动画
                let anim = CABasicAnimation(keyPath: "transform.scale.y")
                anim.fromValue = 0
                anim.toValue = data / maxData
                anim.duration = 0.3
                let time = layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                anim.beginTime = time + TimeInterval(index) * 0.01
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = false
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                shapeLayer.add(anim, forKey: nil)
            }
            
            //绘制起始文字
            let startLabel = UILabel()
            startLabel.frame = CGRect(x: radius, y: 0, width: bounds.size.width / 2, height: 12)
            startLabel.textColor = .white
            startLabel.font = fontSmall
            startLabel.textAlignment = .left
            startLabel.text = "\(headCount / (60 / deltaMinute)):\(headCount % (60 / deltaMinute) * deltaMinute)"
            addSubview(startLabel)
            
            //绘制结束文字
            let endLabel = UILabel()
            endLabel.frame = CGRect(x: bounds.size.width / 2 - radius, y: 0, width: bounds.size.width / 2, height: 12)
            endLabel.textColor = .white
            endLabel.font = fontSmall
            endLabel.textAlignment = .right
            endLabel.text = "\(23 - tailCount / (60 / deltaMinute)):\(59 - tailCount % (60 / deltaMinute) * deltaMinute)"
            addSubview(endLabel)
            
        case .heartrate:
            deltaMinute = 5
            
            let screenCount = 80           //每屏数据量
            
            //创建滑动视图
            heartrateDataScroll = UIScrollView(frame: CGRect(x: radius,
                                                             y: -detailBackOriginY,
                                                             width: bounds.size.width - radius * 2,
                                                             height: detailBackOriginY))
            heartrateDataScroll.contentSize = CGSize(width: (bounds.size.width - radius * 2) * CGFloat(dataListCount) / CGFloat(screenCount) + radius,
                                                     height: detailBackOriginY)
            heartrateDataScroll.contentOffset.x = heartrateDataScroll.contentSize.width - (bounds.size.width - radius * 2) / 2
            addSubview(heartrateDataScroll)
            
            rectWidth = (bounds.size.width - radius * 2) / CGFloat(screenCount)         //修改数据宽度
            
            //绘制数据线
            let upLineBezier = UIBezierPath()
            upLineBezier.move(to: CGPoint(x: 0, y: detailBackOriginY * 0.2))
            upLineBezier.addLine(to: CGPoint(x: heartrateDataScroll.contentSize.width, y: detailBackOriginY * 0.2))
            let upLineLayer = CAShapeLayer()
            upLineLayer.path = upLineBezier.cgPath
            upLineLayer.strokeColor = UIColor.red.withAlphaComponent(0.5).cgColor
            upLineLayer.lineWidth = 1
            upLineLayer.lineCap = kCALineCapRound
            heartrateDataScroll.layer.addSublayer(upLineLayer)
            
            let upLabel = UILabel()
            upLabel.frame = CGRect(x: heartrateDataScroll.contentSize.width, y:  detailBackOriginY * 0.2 - 0.5, width: 25, height: 17)
            upLabel.text = "120"
            upLabel.font = fontSmall
            upLabel.textColor = .white
            upLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            heartrateDataScroll.addSubview(upLabel)
            
            //曲线上下偏移量
            let lineOffset = rectWidth * 3
            
            //绘制曲线
            let bezier = UIBezierPath()
            dataList.enumerated().forEach(){
                index, data in
                if index == 0{
                    let startPoint = CGPoint(x: rectWidth / 2 + radius,
                                             y: (detailBackOriginY - lineOffset) - (detailBackOriginY - lineOffset) * (data - minData) / (maxData - minData) + lineOffset / 2)
                    bezier.move(to: startPoint)
                    
                    //添加小圆圈
                    let markCircle = UIBezierPath(ovalIn: CGRect(x: startPoint.x - rectWidth / 2, y: startPoint.y - rectWidth / 2, width: rectWidth, height: rectWidth))
                    let markLayer = CAShapeLayer()
                    markLayer.path = markCircle.cgPath
                    markLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
                    markLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                    markLayer.lineWidth = 2
                    heartrateDataScroll.layer.addSublayer(markLayer)
                    markCircleList.append(markLayer)
                    
                }else{
                    let currentPoint = bezier.currentPoint
                    let nextPoint = CGPoint(x: CGFloat(index) * rectWidth + rectWidth / 2 + radius,
                                            y: (detailBackOriginY - lineOffset) - (detailBackOriginY - lineOffset) * (data - minData) / (maxData - minData) + lineOffset / 2)
                    let controlPoint1 = CGPoint(x: currentPoint.x + rectWidth * 0.8, y: currentPoint.y)
                    let controlPoint2 = CGPoint(x: nextPoint.x - rectWidth * 0.8, y: nextPoint.y)
                    bezier.addCurve(to: nextPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                    
                    //添加小圆圈
                    let markCircle = UIBezierPath(ovalIn: CGRect(x: nextPoint.x - rectWidth / 2, y: nextPoint.y - rectWidth / 2, width: rectWidth, height: rectWidth))
                    let markLayer = CAShapeLayer()
                    markLayer.path = markCircle.cgPath
                    markLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
                    markLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                    markLayer.lineWidth = 2
                    heartrateDataScroll.layer.addSublayer(markLayer)
                    markCircleList.append(markLayer)
                }
            }
            
            //设置标记最后一个layer
            if let lastMarkCircle = markCircleList.last{
                lastMarkCircle.lineWidth = 4
                lastMarkCircle.fillColor = UIColor.white.cgColor
                lastMarkCircle.strokeColor = UIColor.white.cgColor
            }
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezier.cgPath
            shapeLayer.fillColor = nil
            shapeLayer.lineCap = kCALineCapRound
            shapeLayer.strokeColor = modelEndColors[type]!.withAlphaComponent(0.5).cgColor
            shapeLayer.lineWidth = rectWidth * 0.7
            heartrateDataScroll.layer.insertSublayer(shapeLayer, at: 0)
            
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = 0
            anim.toValue = 1
            anim.duration = 0.5
            anim.fillMode = kCAFillModeBoth
            anim.isRemovedOnCompletion = false
            shapeLayer.add(anim, forKey: nil)
            
            //设置选择view显示
            selectedView.isHidden = false
            let selectedViewX = bounds.size.width / 2
            selectedView.frame.origin.x = selectedViewX
            
            //显示文字
            if let data = dataList.last{
                let hour = "\((headCount + dataListCount) / (60 / deltaMinute))"
                let minute: String = (headCount + dataListCount) % (60 / deltaMinute) == 0 ? "00" : "\((headCount + dataListCount) % (60 / deltaMinute) * deltaMinute)"
                let time = hour + ":" + minute
                selectedLabel.text = "\(Int16(data))" + "Bmp" + "\n\(time)"
            }
        case .sleep:
            
            //时间
            let sleepBeginTime = delegate?.detailSleepBeginTime()                   //获取开始时间
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: sleepBeginTime!)
            startSleepHour = components.hour!
            startSleepMinute = components.minute!
            
            
            //获取数据总和
            deltaMinute = 0
            dataList.forEach(){
                data in
                deltaMinute += Int(Int16(data) % sleepTypeBit)
            }
            
            var offsetX: CGFloat = radius                                                //计算数据x坐标值
            let rectHeight = detailBackOriginY * 0.5 / 4
            //绘制柱状图
            dataList.enumerated().forEach(){
                index, data in
                
                let sleepType = Int16(data) / sleepTypeBit                          //获取睡眠类型
                var sleepColor: CGColor                                             //获取睡眠颜色
                
                var height = rectHeight
                switch sleepType{
                case 0:
                    //深睡
                    sleepColor = UIColor(red: 29 / 255, green: 57 / 255, blue: 181 / 255, alpha: 1).cgColor
                case 1:
                    //浅睡
                    sleepColor = UIColor(red: 14 / 255, green: 128 / 255, blue: 245 / 255, alpha: 1).cgColor
                case 2:
                    //快速眼动
                    sleepColor = UIColor(red: 85 / 255, green: 187 / 255, blue: 252 / 255, alpha: 1).cgColor
                case 3:
                    //清醒
                    sleepColor = UIColor.orange.cgColor
                    height *= 0.5
                default:
                    sleepColor = UIColor.clear.cgColor
                    break
                }
                let sleepData = CGFloat(Int16(data) % sleepTypeBit)                           //获取数据
                rectWidth = (bounds.size.width - radius * 2) * sleepData / CGFloat(deltaMinute)
                
                let bezier = UIBezierPath(rect: CGRect(x: offsetX,
                                                       y: -rectHeight * CGFloat(sleepType + 1) + (rectHeight - height),
                                                       width: rectWidth,
                                                       height: height))

                offsetX += rectWidth
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                shapeLayer.fillColor = sleepColor
                shapeLayer.lineWidth = 0
                layer.addSublayer(shapeLayer)
                
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
                let time = layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                group.beginTime = time + TimeInterval(index) * duration * 0.5
                group.fillMode = kCAFillModeBoth
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                shapeLayer.add(group, forKey: nil)
            }
            
            //设置显示值 selected view
            let timeResult = getNewHourAndMinute(hour: startSleepHour, minute: startSleepMinute, deltaMinute: deltaMinute)
            let hour = "\(timeResult.hour)"
            let minute = timeResult.minute < 10 ? "0\(timeResult.minute)" : "\(timeResult.minute)"
            
            let timeStart = "\(startSleepHour):\(startSleepMinute)"
            let timeEnd = hour + ":" + minute
            
            //绘制起始文字
            let startLabel = UILabel()
            startLabel.frame = CGRect(x: radius, y: 0, width: bounds.size.width / 2, height: 12)
            startLabel.textColor = .white
            startLabel.font = fontSmall
            startLabel.textAlignment = .left
            startLabel.text = timeStart
            addSubview(startLabel)
            
            //绘制结束文字
            let endLabel = UILabel()
            endLabel.frame = CGRect(x: bounds.size.width / 2 - radius, y: 0, width: bounds.size.width / 2, height: 12)
            endLabel.textColor = .white
            endLabel.font = fontSmall
            endLabel.textAlignment = .right
            endLabel.text = timeEnd
            addSubview(endLabel)
            
            //绘制类型文字
            let label0 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 1 , width: bounds.size.width / 2, height: rectHeight))
            label0.font = fontTiny
            label0.textAlignment = .left
            label0.textColor = UIColor.white.withAlphaComponent(0.5)
            label0.text = "深睡"
            insertSubview(label0, at: 0)
            
            //绘制类型文字
            let label1 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 2 , width: bounds.size.width / 2, height: rectHeight))
            label1.font = fontTiny
            label1.textAlignment = .left
            label1.textColor = UIColor.white.withAlphaComponent(0.5)
            label1.text = "浅睡"
            insertSubview(label1, at: 0)
            
            //绘制类型文字
            let label2 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 3 , width: bounds.size.width / 2, height: rectHeight))
            label2.font = fontTiny
            label2.textAlignment = .left
            label2.textColor = UIColor.white.withAlphaComponent(0.5)
            label2.text = "快速眼动"
            insertSubview(label2, at: 0)
            
            //绘制类型文字
            let label3 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 4 , width: bounds.size.width / 2, height: rectHeight))
            label3.font = fontTiny
            label3.textAlignment = .left
            label3.textColor = UIColor.white.withAlphaComponent(0.5)
            label3.text = "清醒"
            insertSubview(label3, at: 0)
            
            //绘制数据线
            (0..<3).forEach(){
                i in
                let upLineBezier = UIBezierPath()
                upLineBezier.move(to: CGPoint(x: 0, y: -rectHeight * CGFloat(i + 1)))
                upLineBezier.addLine(to: CGPoint(x: bounds.width, y: -rectHeight * CGFloat(i + 1)))
                let upLineLayer = CAShapeLayer()
                upLineLayer.path = upLineBezier.cgPath
                upLineLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
                upLineLayer.lineWidth = 0.5
                upLineLayer.lineCap = kCALineCapRound
                layer.addSublayer(upLineLayer)
            }
        case .weight:
            deltaMinute = 1
            
            //获取日期列表
            dateList = delegate?.detailWeightDates()
            guard dateList != nil, dateList?.count == dataList.count else{
                break
            }
            
            //调整最大值与最小值
            let targetData: CGFloat = 65                                        //获取目标值
            if targetData > maxData{
                maxData = targetData
            }else if targetData < minData{
                minData = targetData
            }
            
            //定义常量
            let totalHeight = detailBackOriginY * 0.6                           //获取绘图区域总高度
            let bottomHeight: CGFloat = 20                                      //获取底部高度
            let circleRadius: CGFloat = 8                                       //小圆圈半径
            
            //绘制数据线
            let upLineBezier = UIBezierPath()
            upLineBezier.move(to: CGPoint(x: 25, y: -totalHeight - bottomHeight))
            upLineBezier.addLine(to: CGPoint(x: bounds.width, y: -totalHeight - bottomHeight))
            let upLineLayer = CAShapeLayer()
            upLineLayer.path = upLineBezier.cgPath
            upLineLayer.strokeColor = modelStartColors[type]!.cgColor
            upLineLayer.lineWidth = 1
            upLineLayer.lineCap = kCALineCapRound
            layer.addSublayer(upLineLayer)
            
            let upLabel = UILabel()
            upLabel.frame = CGRect(x: 0, y:  -totalHeight - bottomHeight - 17 / 2, width: 25, height: 17)
            upLabel.text = "\(maxData)"
            upLabel.font = fontSmall
            upLabel.textColor = modelStartColors[type]!
            upLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
            upLabel.layer.cornerRadius = 2
            addSubview(upLabel)
            
            let downLineBezier = UIBezierPath()
            downLineBezier.move(to: CGPoint(x: 25, y: -bottomHeight))
            downLineBezier.addLine(to: CGPoint(x: bounds.width, y: -bottomHeight))
            let downLineLayer = CAShapeLayer()
            downLineLayer.path = downLineBezier.cgPath
            downLineLayer.strokeColor = modelStartColors[type]!.cgColor
            downLineLayer.lineWidth = 1
            downLineLayer.lineCap = kCALineCapRound
            layer.addSublayer(downLineLayer)
            
            let downLabel = UILabel()
            downLabel.frame = CGRect(x: 0, y: -bottomHeight - 17 / 2, width: 25, height: 17)
            downLabel.text = "\(minData)"
            downLabel.font = fontSmall
            downLabel.textColor = modelStartColors[type]!
            downLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
            downLabel.layer.cornerRadius = 2
            addSubview(downLabel)
            
            if targetData != maxData && targetData != minData{
                
                let targetY = (targetData - minData) / (maxData - minData) * -totalHeight - bottomHeight
                let targetLineBezier = UIBezierPath()
                targetLineBezier.move(to: CGPoint(x: 25, y: targetY))
                targetLineBezier.addLine(to: CGPoint(x: bounds.width, y: targetY))
                let targetLineLayer = CAShapeLayer()
                targetLineLayer.path = targetLineBezier.cgPath
                targetLineLayer.lineDashPattern = [1, 2]
                targetLineLayer.strokeColor = modelEndColors[type]!.cgColor
                targetLineLayer.lineWidth = 1
                targetLineLayer.lineCap = kCALineCapRound
                layer.addSublayer(targetLineLayer)
                
                let targetLabel = UILabel()
                targetLabel.frame = CGRect(x: 0, y: targetY - 17 / 2, width: 25, height: 17)
                targetLabel.text = "\(targetData)"
                targetLabel.font = fontSmall
                targetLabel.textColor = modelEndColors[type]!
                addSubview(targetLabel)
            }
            
            //绘制柱状图
            let bezier = UIBezierPath()
            dataList.enumerated().forEach(){
                index, data in
                
                if index == 0{
                    let startPoint = CGPoint(x: rectWidth + radius,
                                             y: (data - minData) / (maxData - minData) * -totalHeight - bottomHeight)
                    bezier.move(to: startPoint)
                    
                    //添加小圆圈
                    let markCircle = UIBezierPath(ovalIn: CGRect(x: startPoint.x - circleRadius / 2, y: startPoint.y - circleRadius / 2, width: circleRadius, height: circleRadius))
                    let markLayer = CAShapeLayer()
                    markLayer.path = markCircle.cgPath
                    markLayer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
                    markLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
                    markLayer.lineWidth = 2
                    layer.addSublayer(markLayer)
                    markCircleList.append(markLayer)
                    
                    //动画
                    let anim = CABasicAnimation(keyPath: "opacity")
                    anim.fromValue = 0
                    anim.toValue = 1
                    anim.duration = 0.6
                    anim.fillMode = kCAFillModeBoth
                    anim.isRemovedOnCompletion = true
                    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                    markLayer.add(anim, forKey: nil)
                }else{
                    let nextPoint = CGPoint(x: CGFloat(index + 1) * rectWidth + radius,
                                            y: (data - minData) / (maxData - minData) * -totalHeight - bottomHeight)
                    bezier.addLine(to: nextPoint)
                    
                    //添加小圆圈
                    let markCircle = UIBezierPath(ovalIn: CGRect(x: nextPoint.x - circleRadius / 2, y: nextPoint.y - circleRadius / 2, width: circleRadius, height: circleRadius))
                    let markLayer = CAShapeLayer()
                    markLayer.path = markCircle.cgPath
                    markLayer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
                    markLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
                    markLayer.lineWidth = 2
                    layer.addSublayer(markLayer)
                    markCircleList.append(markLayer)
                    
                    //动画
                    let anim = CABasicAnimation(keyPath: "opacity")
                    anim.fromValue = 0
                    anim.toValue = 1
                    anim.duration = 0.3
                    let time = layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                    anim.beginTime = time + 1
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
            layer.addSublayer(shapeLayer)
            
            //动画
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = 0
            anim.toValue = 1
            anim.duration = 0.3
            let time = layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
            anim.beginTime = time + 1
            anim.fillMode = kCAFillModeBoth
            anim.isRemovedOnCompletion = true
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            shapeLayer.add(anim, forKey: nil)
            
            //获取日期
            let formatter = DateFormatter()
            formatter.dateFormat = "yyy年MM月dd日"
            let beginDateStr = formatter.string(from: dateList!.first!)
            let endDateStr = formatter.string(from: dateList!.last!)
            
            //绘制起始文字
            let startLabel = UILabel()
            startLabel.frame = CGRect(x: radius, y: 0, width: bounds.size.width / 2, height: 12)
            startLabel.textColor = .white
            startLabel.font = fontSmall
            startLabel.textAlignment = .left
            startLabel.text = beginDateStr
            addSubview(startLabel)
            
            //绘制结束文字
            let endLabel = UILabel()
            endLabel.frame = CGRect(x: bounds.size.width / 2 - radius, y: 0, width: bounds.size.width / 2, height: 12)
            endLabel.textColor = .white
            endLabel.font = fontSmall
            endLabel.textAlignment = .right
            endLabel.text = endDateStr
            addSubview(endLabel)
        }
        
        //添加选择view
        addSubview(selectedView)
    }
}

extension DetailTop{
    func currentTouchesBegan(_ touches: Set<UITouch>) {
        
        touches.forEach(){
            touch in
            let location = touch.location(in: self)
            let dataWidth = (bounds.size.width - radius * 2) / CGFloat(dataList.count)
            let dataIndex = Int((location.x - radius) / dataWidth)
            guard dataIndex < dataList.count, dataIndex >= 0 else{
                return
            }
            
            switch type as DataCubeType{
            case .sport, .sleep:
                selectedView.frame.origin.x = self.radius + CGFloat(dataIndex) * dataWidth
            default:
                break
            }
        }
        currentTouchesMoved(touches)
    }
    
    func currentTouchesMoved(_ touches: Set<UITouch>) {
        
        
        touches.forEach(){
            touch in
            let location = touch.location(in: self)
            let dataWidth = (bounds.size.width - radius * 2) / CGFloat(dataList.count)
            var dataIndex = Int((location.x - radius) / dataWidth)
            guard dataIndex < dataList.count, dataIndex >= 0 else{
                return
            }
            
            //修改具体项
            var unit: String
            switch type as DataCubeType{
            case .sport:
                unit = "步"
                
                //改变显示view x轴位置
                UIView.animate(withDuration: 0.3){
                    self.selectedView.isHidden = false
                    self.selectedView.frame.origin.x = self.radius + CGFloat(dataIndex) * dataWidth
                }
                
                //设置显示值 selected view
                let data = dataList[dataIndex]
                let hour = "\((headCount + dataIndex) / (60 / deltaMinute))"
                let minute: String = (headCount + dataIndex) % (60 / deltaMinute) == 0 ? "00" : "\((headCount + dataIndex) % (60 / deltaMinute) * deltaMinute)"
                let time = hour + ":" + minute
                selectedLabel.text = "\(Int16(data))" + unit + "\n\(time)"
            case .heartrate:
                unit = "Bmp"
                
                //修改scrollview偏移
                let preLocation = touch.previousLocation(in: self)
                let deltaX = preLocation.x - location.x
                heartrateDataScroll.contentOffset.x += deltaX * 2
                
                let minOffsetX = -(bounds.size.width - radius * 2) / 2
                let maxOffsetX = heartrateDataScroll.contentSize.width - (bounds.size.width - radius * 2) / 2
                if heartrateDataScroll.contentOffset.x < minOffsetX{
                    heartrateDataScroll.contentOffset.x = minOffsetX
                }else if heartrateDataScroll.contentOffset.x > maxOffsetX{
                    heartrateDataScroll.contentOffset.x = maxOffsetX
                }
                
                //获取数据
                dataIndex = Int((heartrateDataScroll.contentOffset.x - minOffsetX) / (maxOffsetX - minOffsetX) * CGFloat(dataList.count))
                if dataIndex < 0{
                    dataIndex = 0
                }else if dataIndex > dataList.count - 1{
                    dataIndex = dataList.count - 1
                }
                
                //设置显示值 selected view
                let data = dataList[dataIndex]
                let hour = "\((headCount + dataIndex) / (60 / deltaMinute))"
                let minute: String = (headCount + dataIndex) % (60 / deltaMinute) == 0 ? "00" : "\((headCount + dataIndex) % (60 / deltaMinute) * deltaMinute)"
                let time = hour + ":" + minute
                selectedLabel.text = "\(Int16(data))" + unit + "\n\(time)"
            case .sleep:
                selectedView.isHidden = false
                unit = "~"
                
                var preOffsetX: CGFloat = 0
                var width: CGFloat = 0
                var offsetX: CGFloat = 0
                for i in 0..<dataList.count{
                    let data = dataList[i]
                    let sleepData = Int16(data) % sleepTypeBit
                    
                    preOffsetX = offsetX
                    offsetX += (bounds.size.width - radius * 2) * CGFloat(sleepData) / CGFloat(deltaMinute)
                    width = (bounds.size.width - radius * 2) * CGFloat(sleepData) / CGFloat(deltaMinute)
                    dataIndex = i
                    if offsetX >= location.x{
                        break
                    }
                }
                
                //改变显示view x轴位置
                
                //改变label位置
                let labels = selectedView.subviews.filter(){$0.isKind(of: UILabel.self)}
                if let label = labels.last{
                    UIView.animate(withDuration: 0.3){
                        
                        self.selectedView.frame.origin.x = self.radius + preOffsetX
                        
                        //绘制渐变
                        let gradient = CAGradientLayer()
                        gradient.frame = CGRect(x: 0, y: 0, width: width, height: self.superview!.frame.origin.y - 24)
                        gradient.locations = [0.2, 1]
                        gradient.startPoint = CGPoint(x: 1, y: 0)
                        gradient.endPoint = CGPoint(x: 1, y: 1)
                        gradient.name = "layer"
                        gradient.colors = [UIColor.white.withAlphaComponent(0.3).cgColor, modelStartColors[self.type]!.cgColor]
                        if let oldLayers = self.selectedView.layer.sublayers?.filter({$0.name == "layer"}){
                            if let last = oldLayers.last{
                                last.removeFromSuperlayer()
                            }
                        }
                        self.selectedView.layer.addSublayer(gradient)
                        
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
                for i in 0..<dataList.count{
                    let data = dataList[i]
                    if i >= dataIndex{
                        subEndMinute = subStartMinute + Int(Int16(dataList[dataIndex]) % sleepTypeBit)
                        break
                    }
                    subStartMinute += Int(Int16(data) % sleepTypeBit)
                }
                
                var timeResult = getNewHourAndMinute(hour: startSleepHour, minute: startSleepMinute, deltaMinute: subStartMinute)
                var hour = "\(timeResult.hour)"
                var minute = timeResult.minute < 10 ? "0\(timeResult.minute)" : "\(timeResult.minute)"
                let timeStart = hour + ":" + minute
                
                timeResult = getNewHourAndMinute(hour: startSleepHour, minute: startSleepMinute, deltaMinute: subEndMinute)
                hour = "\(timeResult.hour)"
                minute = timeResult.minute < 10 ? "0\(timeResult.minute)" : "\(timeResult.minute)"
                let timeEnd = hour + ":" + minute
                
                let typeIndex = Int16(dataList[dataIndex]) / sleepTypeBit
                var typeStr: String
                switch typeIndex{
                case 0:
                    typeStr = "深睡"
                case 1:
                    typeStr = "浅睡"
                case 2:
                    typeStr = "快速眼动"
                case 3:
                    typeStr = "清醒"
                default:
                    typeStr = ""
                }
                selectedLabel.text = timeStart + unit + timeEnd + "\n" + typeStr
            case .weight:
                
                //重置触摸位置
                dataIndex = Int((location.x - radius - dataWidth / 2) / dataWidth)
                
                selectedView.isHidden = false
                unit = "kg"
                
                //改变显示view x轴位置
                var currentX = location.x
                let firstCircleX = (bounds.size.width - radius * 2) / CGFloat(dataList.count) + radius
                if currentX < firstCircleX{
                    currentX = firstCircleX
                }
                selectedView.frame.origin.x = currentX
                
                //绘制渐变
                let gradient = CAGradientLayer()
                gradient.frame = CGRect(x: 0, y: 0,
                                        width: bounds.width - radius - currentX,
                                        height: self.superview!.frame.origin.y - 24)
                gradient.locations = [0.2, 1]
                gradient.startPoint = CGPoint(x: 1, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 1)
                gradient.name = "layer"
                gradient.colors = [UIColor.white.withAlphaComponent(0.3).cgColor, modelStartColors[self.type]!.cgColor]
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
                            
                            var posX = (currentX - label.frame.width) / 2
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
                let dateStr = formatter.string(from: dateList![dataIndex])
                
                selectedLabel.text = "\(data)" + unit + "\n" + dateStr
                
                //体重差值
                if dataIndex == dataList.count - 1{
                    weightDeltaLabel.text = ""
                }else{
                    let lastData = dataList.last!
                    weightDeltaLabel.text = "\(lastData - data)"
                }
            }
            
            
            
            //设置区间值
        }
    }
    
    //MARK:- 时间计算
    func getNewHourAndMinute(hour: Int, minute: Int, deltaMinute: Int) -> (hour: Int, minute: Int){
        let newHour = (minute + deltaMinute) / 60
        let resultMinute = (minute + deltaMinute) % 60
        let resultHour = (hour + newHour) % 24
        
        return (resultHour, resultMinute)
    }
    
    func currentTouchesEnded(_ touches: Set<UITouch>) {
        switch type as DataCubeType {
        case .sport:
            selectedView.isHidden = true
        case .heartrate:
            markCircleList.forEach(){
                markCircle in
                markCircle.lineWidth = 2
                markCircle.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
                markCircle.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
            }
            
            let offsetX = heartrateDataScroll.contentOffset.x + heartrateDataScroll.bounds.size.width / 2
            let newList = markCircleList.sorted(){
                circle0, circle1 -> Bool in
                let distance0 = fabs(circle0.path!.currentPoint.x - offsetX)
                let distance1 = fabs(circle1.path!.currentPoint.x - offsetX)
                return distance0 < distance1
            }
           
            if let nearMarkCircle = newList.first{
                let roundOffsetX = nearMarkCircle.path!.currentPoint.x - heartrateDataScroll.bounds.size.width / 2 - nearMarkCircle.path!.boundingBoxOfPath.size.width / 2
                let offset = CGPoint(x: roundOffsetX, y: 0)
                heartrateDataScroll.setContentOffset(offset, animated: true)
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    
                    nearMarkCircle.lineWidth = 4
                    nearMarkCircle.fillColor = UIColor.white.cgColor
                    nearMarkCircle.strokeColor = UIColor.white.cgColor
                }, completion: nil)
            }
        default:
            selectedView.isHidden = true
        }
    }
}
