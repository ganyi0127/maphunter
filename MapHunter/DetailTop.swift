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

////模块数据代理
//protocol DetailTopDelegate {
//    func detailTopData(closure: @escaping ([CGFloat])->())
//    func detailHeartrateOffset(closure: @escaping ([CGFloat])->())
//    func detailSleepBeginTime() -> Date
//    func detailWeightDates() -> [Date]
//    
//    //添加总览数据
//    func detailTotalValue() -> CGFloat
//    func detailLeftValue() -> CGFloat
//    func detailRightValue() -> CGFloat
//}

class DetailTop: UIView {
    fileprivate var type: DataCubeType!
    
    var delegate: DetailDelegate?
    
    //main value
    private var value: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                unit = "%"
                text = "\(Int16(value / 10000 * 100))" + unit
            case .heartrate:
                unit = "Bmp"
                text = "\(Int16(value))" + unit
            case .sleep:
                unit = "%"
                text = "\(Int16(value / 10000 * 100))" + unit
            case .mindBody:
                unit = "Kg"
                text = "\(Int16(value))" + unit
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
                if rightValue > 1000 {
                    unit = "公里"
                    text = "\(rightValue / 1000)" + unit
                }else{
                    unit = "米"
                    text = "\(rightValue)" + unit
                }
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
        label.font = fontSmall
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
        var dataWidth = (self.bounds.size.width - self.radius * 2) / CGFloat(self.dataList.count)
        if self.type == .heartrate{
            dataWidth = 2
        }
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
        
        self.selectedLabel.frame.origin.x = dataWidth / 2 - 40
        selectedView.addSubview(self.selectedLabel)
        
        if self.type == .mindBody{
            selectedView.addSubview(self.weightDeltaLabel)
        }
        return selectedView
    }()
    //显示选择数据值
    fileprivate lazy var selectedLabel: UILabel = {
        let selectedLabel: UILabel = UILabel()
        selectedLabel.tag = 0
        selectedLabel.font = fontSmall
        
        var labelFrame = CGRect(x: -40, y: -34, width: 80, height: 34)
        selectedLabel.frame = labelFrame
        selectedLabel.layer.backgroundColor = UIColor.white.cgColor
        selectedLabel.textColor = .black
        
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
        weightDeltaLabel.frame = CGRect(x: -20, y: 0, width: 80, height: 44)
        weightDeltaLabel.textColor = UIColor.red.withAlphaComponent(0.5)
        weightDeltaLabel.textAlignment = .center
        weightDeltaLabel.layer.shadowColor = UIColor.black.cgColor
        return weightDeltaLabel
    }()
    
    //显示进度
    private lazy var progressLayer: CALayer = {
        let bezierRadius = self.bounds.height - 4 - 4
        let bezierRect = CGRect(x: 0,
                                y: 0,
                                width: bezierRadius,
                                height: bezierRadius)
        let bezier = UIBezierPath(ovalIn: bezierRect)
        
        let shapeLayer = CAShapeLayer()
        
        let transform = CATransform3DIdentity
        let rotateTransform = CATransform3DRotate(transform, -.pi / 2, 0, 0, 1)
        let translateTransform = CATransform3DTranslate(rotateTransform, self.bounds.height / 2 - bezierRadius / 2 - self.bounds.height, self.bounds.width / 2 - bezierRadius / 2, 0)
        shapeLayer.transform = translateTransform
        
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeEnd = self.value / 10000
        return shapeLayer
    }()
    
    //编辑按钮
    fileprivate lazy var weightEditButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.tintColor = .white
        button.backgroundColor = nil
        button.setTitle("编辑", for: .normal)
        button.titleLabel?.font = fontSmall
        button.addTarget(self, action: #selector(edit), for: .touchUpInside)
        button.frame = CGRect(x: self.bounds.width - self.bounds.width * 0.2 * 1.2,
                              y: (self.bounds.height - self.bounds.height * 0.3) / 2,
                              width: self.bounds.width * 0.2,
                              height: self.bounds.height * 0.3)
        let buttonRect = CGRect(origin: .zero, size: button.bounds.size)
        let bezier = UIBezierPath(roundedRect: buttonRect, cornerRadius: 3)
        
        let buttonLayer = CAShapeLayer()
        buttonLayer.path = bezier.cgPath
        buttonLayer.fillColor = nil
        buttonLayer.strokeColor = UIColor.white.cgColor
        buttonLayer.lineWidth = 1
        button.layer.addSublayer(buttonLayer)
        return button
    }()
    
    //MARK:- 无数据label
    private lazy var emptyLabel: UILabel = {
        var text: String
        switch self.type as DataCubeType{
        case .sport:
            text = "运动"
        case .heartrate:
            text = "心率"
        case .sleep:
            text = "睡眠"
        case .mindBody:
            text = "身心状态"
        }
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: -100, width: self.bounds.size.width, height: 20))
        label.text = "无" + text + "数据"
        label.font = fontSmall
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    //MARK:- 存储数据
    fileprivate var deltaMinute: Int = 0
    fileprivate let radius: CGFloat = 8
    fileprivate var headCount: Int!
    var dataList = [CGFloat]()
    
    //睡眠
    fileprivate var startSleepHour: Int = 0
    fileprivate var startSleepMinute: Int = 0
    
    //心率
    fileprivate var markCircleList = [(shape: CAShapeLayer, value: CGFloat, offset: CGFloat)]()
    
    //体重
    fileprivate var dateList: [Date]?
    
    //MARK:- 心率图
    fileprivate var heartrateDataScroll: UIScrollView?
    
    //点击事件
    private var tap: UITapGestureRecognizer?
    
    var closure: (()->())?
    var editClosure: (()->())?
    
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
    
    private var onceDraw = false
    override func didMoveToSuperview() {
        
        //绘制顶部图等
        if !onceDraw{
            onceDraw = true
            drawGraphic()
        }
    }
    
    deinit {
        removeGestureRecognizer(tap!)
    }
    
    private func config(){
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [modelStartColors[type]!.cgColor, modelEndColors[type]!.cgColor]
        gradient.cornerRadius = radius
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = CGSize(width: 0, height: 1)
        gradient.shadowRadius = 1
        gradient.shadowOpacity = 0.5
        gradient.masksToBounds = false
        layer.addSublayer(gradient)
        
        //添加点击事件
        isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
    
    //MARK:- weight编辑点击按钮
    @objc private func edit(){
        editClosure?()
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
        
        //添加empty label
        addSubview(emptyLabel)
        
        //添加左右标签与进度
        switch type as DataCubeType {
        case .sport:
            
            //左右标签
            addSubview(leftLabel)
            addSubview(rightLabel)
            
            //绘制进度
            layer.addSublayer(progressLayer)
        case .sleep:
            //左右标签
            addSubview(leftLabel)
            
            //添加编辑按钮
            addSubview(weightEditButton)
            
            //绘制进度
            layer.addSublayer(progressLayer)
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
        del.detailTopData{
            result in
            
            var dataList = result
            
            //获取常量
            let cornerRadius: CGFloat = 1                                               //圆角半径
            
            //获取最大数值
            guard var maxData = dataList.max(), maxData > 0 else {
                return
            }
            
            //隐藏empty label
            self.emptyLabel.isHidden = true
            
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
            var rectWidth = (self.bounds.size.width - self.radius * 2) / CGFloat(dataListCount)   //柱状图宽度
            let detailBackOriginY = self.superview!.frame.origin.y                      //柱状图高度
            
            //数据起始结束文字
            var beginText = ""
            var endText = ""
            
            //数据
            switch self.type as DataCubeType {
            case .sport:
                self.deltaMinute = 15
                
                //默认最大值
                if maxData < 100{
                    maxData = 100
                }
                
                let rectHeight = detailBackOriginY * 0.6
                //绘制柱状图
                dataList.enumerated().forEach(){
                    index, data in
                    
                    let bezier = UIBezierPath(roundedRect: CGRect(x: CGFloat(index) * rectWidth + self.radius + rectWidth * 0.1,
                                                                  y: -rectHeight + cornerRadius,
                                                                  width: rectWidth * 0.8,
                                                                  height: rectHeight),
                                              cornerRadius: cornerRadius)
                    
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = bezier.cgPath
                    shapeLayer.fillColor = UIColor.white.cgColor
                    shapeLayer.lineWidth = 0
                    self.layer.insertSublayer(shapeLayer, at: 0)
                    
                    //动画
                    let anim = CABasicAnimation(keyPath: "transform.scale.y")
                    anim.fromValue = 0
                    anim.toValue = data / maxData
                    anim.duration = 0.2
                    let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                    anim.beginTime = time + TimeInterval(index) * 0.01
                    anim.fillMode = kCAFillModeBoth
                    anim.isRemovedOnCompletion = false
                    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                    shapeLayer.add(anim, forKey: nil)
                }
                
                //起始文字
                let minute = headCount % (60 / self.deltaMinute) * self.deltaMinute
                let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
                beginText = "\(headCount / (60 / self.deltaMinute)):" + minuteStr
                endText = "\(23 - tailCount / (60 / self.deltaMinute)):\(59 - tailCount % (60 / self.deltaMinute) * self.deltaMinute)"
                
                //添加数据
                if let value = self.delegate?.detailTotalValue(){
                    self.value = value
                }
                if let leftValue = self.delegate?.detailLeftValue(){
                    self.leftValue = leftValue
                }
                if let rightValue = self.delegate?.detailRightValue(){
                    self.rightValue = rightValue
                }
            case .heartrate:
                self.deltaMinute = 5
                
                let screenCount = 360           //每屏数据量 改为 按时间 360min(每屏360分钟)
                
                let rectHeight = detailBackOriginY * 0.6        //scrollView y 坐标
                
                //创建滑动视图
                self.heartrateDataScroll = UIScrollView(frame: CGRect(x: self.radius,
                                                                      y: -rectHeight,
                                                                      width: self.bounds.size.width - self.radius * 2,
                                                                      height: rectHeight))
//                self.heartrateDataScroll?.contentSize = CGSize(width:
//                    CGFloat(dataListCount) / CGFloat(screenCount - 1) < 1 ?
//                        self.bounds.size.width - self.radius * 2 :
//                        (self.bounds.size.width - self.radius * 2) * CGFloat(dataListCount) / CGFloat(screenCount - 1),
//                                                               height: rectHeight)
//                self.heartrateDataScroll?.contentOffset.x = self.heartrateDataScroll!.contentSize.width - (self.bounds.size.width - self.radius * 2) / 2
                self.addSubview(self.heartrateDataScroll!)
                
                rectWidth = (self.bounds.size.width - self.radius * 2) / CGFloat(screenCount - 1) * 10         //修改数据宽度
                
                //曲线上下偏移量
                let lineOffset = rectWidth * 3
                
                
                let rangeValues: [CGFloat] = [200, 75, 40]
                
                //绘制曲线
                del.detailHeartrateOffset{          //获取偏移时间  minute
                    offsetList in
                    
                    let bezier = UIBezierPath()
                    bezier.move(to: .zero)
                    
                    var minutes: CGFloat = 0        //累加分钟数
                    var isValid = false             //记录开始累加
                    var validMinutes: CGFloat = 0    //累加有效分钟数
                    for (index, data) in result.enumerated(){
                        minutes += offsetList[index]
                        
                        if data >= rangeValues.last! && data <= rangeValues.first!{
                            if isValid{
                                validMinutes += offsetList[index]
                            }else{
                                isValid = true
                            }
                            
                            
                            let currentPoint = bezier.currentPoint
                            let nextPoint = CGPoint(x: validMinutes / CGFloat(screenCount) * (self.bounds.size.width - self.radius * 2) + rectWidth / 2,
                                                    y: (rectHeight - lineOffset) - (rectHeight - lineOffset) * (data - minData) / (maxData - minData) + lineOffset / 2)
                            let controlPoint1 = CGPoint(x: (currentPoint.x + nextPoint.x) / 2, y: currentPoint.y)
                            let controlPoint2 = CGPoint(x: (currentPoint.x + nextPoint.x) / 2, y: nextPoint.y)
                            if bezier.currentPoint == .zero{
                                bezier.move(to: nextPoint)
                            }else{
                                bezier.addCurve(to: nextPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                            }
                            
                            //添加小圆圈
                            let circleDiameter = rectWidth * 0.7
                            let markCircle = UIBezierPath(ovalIn: CGRect(x: nextPoint.x - circleDiameter / 2, y: nextPoint.y - circleDiameter / 2, width: circleDiameter, height: circleDiameter))
                            let markLayer = CAShapeLayer()
                            markLayer.path = markCircle.cgPath
                            markLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
                            markLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                            markLayer.lineWidth = 0
                            self.heartrateDataScroll?.layer.addSublayer(markLayer)
                            self.markCircleList.append((shape: markLayer, value: data, offset: minutes))
                        }
                    }
                    
                    //设置contentSize
                    self.heartrateDataScroll?.contentSize = CGSize(width:
                        validMinutes < CGFloat(screenCount) ?
                            self.bounds.size.width - self.radius * 2 :
                            (self.bounds.size.width - self.radius * 2) * validMinutes / CGFloat(screenCount),
                                                                   height: rectHeight)
                    self.heartrateDataScroll?.contentOffset.x = self.heartrateDataScroll!.contentSize.width - (self.bounds.size.width - self.radius * 2) / 2
                    
                    //绘制数据线
                    rangeValues.enumerated().forEach{
                        index, value in
                        let upLineBezier = UIBezierPath()
                        let y = (rectHeight - lineOffset) - (rectHeight - lineOffset) * (value - minData) / (maxData - minData) + lineOffset / 2
                        upLineBezier.move(to: CGPoint(x: 0, y: y))
                        upLineBezier.addLine(to: CGPoint(x: self.heartrateDataScroll!.contentSize.width, y: y))
                        let upLineLayer = CAShapeLayer()
                        upLineLayer.path = upLineBezier.cgPath
                        upLineLayer.strokeColor = UIColor.red.withAlphaComponent(0.5).cgColor
                        upLineLayer.lineWidth = 1
                        upLineLayer.lineCap = kCALineCapRound
                        if index != 1{
                            upLineLayer.lineDashPattern = [2, 2]
                        }
                        self.heartrateDataScroll?.layer.addSublayer(upLineLayer)
                        
                        let upLabel = UILabel()
                        upLabel.frame = CGRect(x: self.heartrateDataScroll!.contentSize.width, y:  y - 0.5, width: 25, height: 12)
                        upLabel.text = "\(Int(value))"
                        upLabel.font = fontSmall
                        upLabel.textColor = .white
                        upLabel.textAlignment = .center
                        upLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                        self.heartrateDataScroll?.addSubview(upLabel)
                    }
                    
                    //设置标记最后一个layer
                    if let lastMarkCircle = self.markCircleList.last?.shape{
                        lastMarkCircle.lineWidth = 4
                        lastMarkCircle.fillColor = UIColor.white.cgColor
                        lastMarkCircle.strokeColor = UIColor.white.cgColor
                    }
                    
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = bezier.cgPath
                    shapeLayer.fillColor = nil
                    shapeLayer.lineCap = kCALineCapRound
                    shapeLayer.strokeColor = modelEndColors[self.type]!.withAlphaComponent(0.5).cgColor
                    shapeLayer.lineWidth = rectWidth * 0.7
                    self.heartrateDataScroll?.layer.insertSublayer(shapeLayer, at: 0)
                    
                    let anim = CABasicAnimation(keyPath: "strokeEnd")
                    anim.fromValue = 0
                    anim.toValue = 1
                    anim.duration = 1
                    anim.fillMode = kCAFillModeBoth
                    anim.isRemovedOnCompletion = false
                    shapeLayer.add(anim, forKey: nil)
                    
                    //设置选择view显示
                    self.selectedView.isHidden = false
                    let selectedViewX = self.bounds.size.width / 2
                    self.selectedView.frame.origin.x = selectedViewX
                    
                    self.currentTouchesEnded([])
                    
                    //显示文字
                    if let data = dataList.last{
                        let hour = "\((headCount + dataListCount) / (60 / self.deltaMinute))"
                        let minute: String = (headCount + dataListCount) % (60 / self.deltaMinute) < 10 ? "0" : "" + "\((headCount + dataListCount) % (60 / self.deltaMinute) * self.deltaMinute)"
                        let time = hour + ":" + minute
                        self.selectedLabel.text = "\(Int16(data))" + "Bmp" + "\n\(time)"
                    }
                    
                    //添加总览数据
                    self.value = del.detailTotalValue()
                }
                

            case .sleep:
                
                //时间
                let sleepBeginTime = self.delegate?.detailSleepBeginTime()                   //获取开始时间
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: sleepBeginTime!)
                self.startSleepHour = components.hour!
                self.startSleepMinute = components.minute!
                
                
                //获取数据总和
                self.deltaMinute = 0
                dataList.forEach(){
                    data in
                    self.deltaMinute += Int(Int(data) % Int(sleepTypeBit))
                }
                
                var offsetX: CGFloat = self.radius                                                //计算数据x坐标值
                let rectHeight = detailBackOriginY * 0.5 / 4
                //绘制柱状图
                dataList.enumerated().forEach(){
                    index, data in
                    
                    let sleepType = Int(data) / Int(sleepTypeBit)                          //获取睡眠类型
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
                        sleepColor = UIColor(red: 255 / 255, green: 205 / 255, blue: 52 / 255, alpha: 1).cgColor
                        height *= 0.5
                    default:
                        sleepColor = UIColor.clear.cgColor
                        break
                    }
                    let sleepData = CGFloat(Int(data) % Int(sleepTypeBit))                           //获取数据
                    rectWidth = (self.bounds.size.width - self.radius * 2) * sleepData / CGFloat(self.deltaMinute)
                    
                    let bezier = UIBezierPath(rect: CGRect(x: offsetX,
                                                           y: -rectHeight * CGFloat(sleepType + 1) + (rectHeight - height),
                                                           width: rectWidth,
                                                           height: height))
                    
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
                
                //设置显示值 selected view
                let timeResult = self.getNewHourAndMinute(hour: self.startSleepHour, minute: self.startSleepMinute, deltaMinute: self.deltaMinute)
                let hour = "\(timeResult.hour)"
                let minute = timeResult.minute < 10 ? "0\(timeResult.minute)" : "\(timeResult.minute)"
                
                beginText = "\(self.startSleepHour):\(self.startSleepMinute)"
                endText = hour + ":" + minute
                
                //绘制类型文字
                let label0 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 1 , width: self.bounds.size.width / 2, height: rectHeight))
                label0.font = fontTiny
                label0.textAlignment = .left
                label0.textColor = UIColor.white.withAlphaComponent(0.5)
                label0.text = "深睡"
                self.insertSubview(label0, at: 0)
                
                //绘制类型文字
                let label1 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 2 , width: self.bounds.size.width / 2, height: rectHeight))
                label1.font = fontTiny
                label1.textAlignment = .left
                label1.textColor = UIColor.white.withAlphaComponent(0.5)
                label1.text = "浅睡"
                self.insertSubview(label1, at: 0)
                
                //绘制类型文字
                let label2 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 3 , width: self.bounds.size.width / 2, height: rectHeight))
                label2.font = fontTiny
                label2.textAlignment = .left
                label2.textColor = UIColor.white.withAlphaComponent(0.5)
                label2.text = "快速眼动"
                self.insertSubview(label2, at: 0)
                
                //绘制类型文字
                let label3 = UILabel(frame: CGRect(x: 0, y: -rectHeight * 4 , width: self.bounds.size.width / 2, height: rectHeight))
                label3.font = fontTiny
                label3.textAlignment = .left
                label3.textColor = UIColor.white.withAlphaComponent(0.5)
                label3.text = "清醒"
                self.insertSubview(label3, at: 0)
                
                //绘制数据线
                (0..<3).forEach(){
                    i in
                    let upLineBezier = UIBezierPath()
                    upLineBezier.move(to: CGPoint(x: 0, y: -rectHeight * CGFloat(i + 1)))
                    upLineBezier.addLine(to: CGPoint(x: self.bounds.width, y: -rectHeight * CGFloat(i + 1)))
                    let upLineLayer = CAShapeLayer()
                    upLineLayer.path = upLineBezier.cgPath
                    upLineLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
                    upLineLayer.lineWidth = 0.5
                    upLineLayer.lineCap = kCALineCapRound
                    self.layer.addSublayer(upLineLayer)
                }
                
                //添加总览数据
                self.value = del.detailTotalValue()
                self.leftValue = del.detailLeftValue()
                self.rightValue = del.detailRightValue()
                
            case .mindBody:
                self.deltaMinute = 1
                
                //获取日期列表
                self.dateList = self.delegate?.detailWeightDates()
                guard self.dateList != nil, self.dateList?.count == dataList.count else{
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
                upLineBezier.addLine(to: CGPoint(x: self.bounds.width, y: -totalHeight - bottomHeight))
                let upLineLayer = CAShapeLayer()
                upLineLayer.path = upLineBezier.cgPath
                upLineLayer.strokeColor = modelStartColors[self.type]!.cgColor
                upLineLayer.lineWidth = 1
                upLineLayer.lineCap = kCALineCapRound
                self.layer.addSublayer(upLineLayer)
                
                let upLabel = UILabel()
                upLabel.frame = CGRect(x: 0, y:  -totalHeight - bottomHeight - 17 / 2, width: 25, height: 17)
                upLabel.text = "\(maxData)"
                upLabel.font = fontSmall
                upLabel.textColor = modelStartColors[self.type]!
                upLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
                upLabel.layer.cornerRadius = 2
                self.addSubview(upLabel)
                
                let downLineBezier = UIBezierPath()
                downLineBezier.move(to: CGPoint(x: 25, y: -bottomHeight))
                downLineBezier.addLine(to: CGPoint(x: self.bounds.width, y: -bottomHeight))
                let downLineLayer = CAShapeLayer()
                downLineLayer.path = downLineBezier.cgPath
                downLineLayer.strokeColor = modelStartColors[self.type]!.cgColor
                downLineLayer.lineWidth = 1
                downLineLayer.lineCap = kCALineCapRound
                self.layer.addSublayer(downLineLayer)
                
                let downLabel = UILabel()
                downLabel.frame = CGRect(x: 0, y: -bottomHeight - 17 / 2, width: 25, height: 17)
                downLabel.text = "\(minData)"
                downLabel.font = fontSmall
                downLabel.textColor = modelStartColors[self.type]!
                downLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
                downLabel.layer.cornerRadius = 2
                self.addSubview(downLabel)
                
                if targetData != maxData && targetData != minData{
                    
                    let targetY = (targetData - minData) / (maxData - minData) * -totalHeight - bottomHeight
                    let targetLineBezier = UIBezierPath()
                    targetLineBezier.move(to: CGPoint(x: 25, y: targetY))
                    targetLineBezier.addLine(to: CGPoint(x: self.bounds.width, y: targetY))
                    let targetLineLayer = CAShapeLayer()
                    targetLineLayer.path = targetLineBezier.cgPath
                    targetLineLayer.lineDashPattern = [1, 2]
                    targetLineLayer.strokeColor = modelEndColors[self.type]!.cgColor
                    targetLineLayer.lineWidth = 1
                    targetLineLayer.lineCap = kCALineCapRound
                    self.layer.addSublayer(targetLineLayer)
                    
                    let targetLabel = UILabel()
                    targetLabel.frame = CGRect(x: 0, y: targetY - 17 / 2, width: 25, height: 17)
                    targetLabel.text = "\(targetData)"
                    targetLabel.font = fontSmall
                    targetLabel.textColor = modelEndColors[self.type]!
                    self.addSubview(targetLabel)
                }
                
                //绘制柱状图
                let bezier = UIBezierPath()
                dataList.enumerated().forEach(){
                    index, data in
                    
                    if index == 0{
                        let startPoint = CGPoint(x: rectWidth + self.radius,
                                                 y: (data - minData) / (maxData - minData) * -totalHeight - bottomHeight)
                        bezier.move(to: startPoint)
                        
                        //添加小圆圈
                        let markCircle = UIBezierPath(ovalIn: CGRect(x: startPoint.x - circleRadius / 2, y: startPoint.y - circleRadius / 2, width: circleRadius, height: circleRadius))
                        let markLayer = CAShapeLayer()
                        markLayer.path = markCircle.cgPath
                        markLayer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
                        markLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
                        markLayer.lineWidth = 2
                        self.layer.addSublayer(markLayer)
                        self.markCircleList.append((shape: markLayer, value: data, offset: 0))
                        
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
                        let nextPoint = CGPoint(x: CGFloat(index + 1) * rectWidth + self.radius,
                                                y: (data - minData) / (maxData - minData) * -totalHeight - bottomHeight)
                        bezier.addLine(to: nextPoint)
                        
                        //添加小圆圈
                        let markCircle = UIBezierPath(ovalIn: CGRect(x: nextPoint.x - circleRadius / 2, y: nextPoint.y - circleRadius / 2, width: circleRadius, height: circleRadius))
                        let markLayer = CAShapeLayer()
                        markLayer.path = markCircle.cgPath
                        markLayer.fillColor = UIColor.white.withAlphaComponent(1).cgColor
                        markLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
                        markLayer.lineWidth = 2
                        self.layer.addSublayer(markLayer)
                        self.markCircleList.append((shape: markLayer, value: data, offset: 0))
                        
                        //动画
                        let anim = CABasicAnimation(keyPath: "opacity")
                        anim.fromValue = 0
                        anim.toValue = 1
                        anim.duration = 0.3
                        let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
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
                self.layer.addSublayer(shapeLayer)
                
                //动画
                let anim = CABasicAnimation(keyPath: "strokeEnd")
                anim.fromValue = 0
                anim.toValue = 1
                anim.duration = 0.3
                let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                anim.beginTime = time + 1
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = true
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                shapeLayer.add(anim, forKey: nil)
                
                //获取日期
                let formatter = DateFormatter()
                formatter.dateFormat = "yyy年MM月dd日"
                beginText = formatter.string(from: self.dateList!.first!)
                endText = formatter.string(from: self.dateList!.last!)
                
                //添加总览数据
                self.value = del.detailTotalValue()
            }
            
            //绘制起始文字
            let startLabel = UILabel()
            startLabel.frame = CGRect(x: self.radius, y: 8, width: self.bounds.size.width / 2, height: 12)
            startLabel.textColor = .white
            startLabel.font = fontSmall
            startLabel.textAlignment = .left
            startLabel.text = beginText
            self.addSubview(startLabel)
            
            //绘制结束文字
            let endLabel = UILabel()
            endLabel.frame = CGRect(x: self.bounds.size.width / 2 - self.radius, y: 8, width: self.bounds.size.width / 2, height: 12)
            endLabel.textColor = .white
            endLabel.font = fontSmall
            endLabel.textAlignment = .right
            endLabel.text = endText
            self.addSubview(endLabel)
            
            //添加选择view
            self.addSubview(self.selectedView)
        }
    }
}

extension DetailTop{
    func currentTouchesBegan(_ touches: Set<UITouch>) {
        
        touches.forEach(){
            touch in
            
            guard !dataList.isEmpty else{
                return
            }
            
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
                let data = dataList[dataIndex]
                let hour = "\((headCount + dataIndex) / (60 / deltaMinute))"
                let minute: String = (headCount + dataIndex) % (60 / deltaMinute) == 0 ? "00" : "\((headCount + dataIndex) % (60 / deltaMinute) * deltaMinute)"
                let time = hour + ":" + minute
                selectedLabel.text = "\(Int16(data))" + unit + "\n\(time)"
                
            case .heartrate:
                unit = "Bmp"
                
                if let scroll = heartrateDataScroll{
                    
                    //修改scrollview偏移
                    let preLocation = touch.previousLocation(in: self)
                    let deltaX = preLocation.x - location.x
                    heartrateDataScroll?.contentOffset.x += deltaX * 2
                    
                    let minOffsetX = -(bounds.size.width - radius * 2) / 2
                    let maxOffsetX = scroll.contentSize.width - (bounds.size.width - radius * 2) / 2
                    if scroll.contentOffset.x < minOffsetX{
                        heartrateDataScroll?.contentOffset.x = minOffsetX
                    }else if scroll.contentOffset.x > maxOffsetX{
                        heartrateDataScroll?.contentOffset.x = maxOffsetX
                    }
                    
                    //获取数据
//                    dataIndex = Int((scroll.contentOffset.x - minOffsetX) / (maxOffsetX - minOffsetX) * CGFloat(dataList.count < 80 ? 80 : dataList.count))
//                    if dataIndex < 0{
//                        dataIndex = 0
//                    }else if dataIndex > dataList.count - 1{
//                        dataIndex = dataList.count - 1
//                    }
//                    
//                    //设置显示值 selected view
//                    let data = tuple.value
//                    let hour = Int(tuple.offset) / 60
//                    let minute = (Int(tuple.offset) - hour * 60)
//                    let hourStr = "\(hour)"
//                    let minuteStr: String = minute < 10 ? "0\(minute)" : "\(minute)"
//                    let time = hourStr + ":" + minuteStr
//                    selectedLabel.text = "\(Int16(data))" + "Bmp" + "\n\(time)"
                }
                
            case .sleep:
                selectedView.isHidden = false
                unit = "~"
                
                var preOffsetX: CGFloat = 0
                var width: CGFloat = 0
                var offsetX: CGFloat = 0
                for i in 0..<dataList.count{
                    let data = dataList[i]
                    let sleepData = Int16(Int(data) % Int(sleepTypeBit))
                    
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
                        subEndMinute = subStartMinute + Int(Int(dataList[dataIndex]) % Int(sleepTypeBit))
                        break
                    }
                    subStartMinute += Int(Int(data) % Int(sleepTypeBit))
                }
                
                var timeResult = getNewHourAndMinute(hour: startSleepHour, minute: startSleepMinute, deltaMinute: subStartMinute)
                var hour = "\(timeResult.hour)"
                var minute = timeResult.minute < 10 ? "0\(timeResult.minute)" : "\(timeResult.minute)"
                let timeStart = hour + ":" + minute
                
                timeResult = getNewHourAndMinute(hour: startSleepHour, minute: startSleepMinute, deltaMinute: subEndMinute)
                hour = "\(timeResult.hour)"
                minute = timeResult.minute < 10 ? "0\(timeResult.minute)" : "\(timeResult.minute)"
                let timeEnd = hour + ":" + minute
                
                let typeIndex = Int(dataList[dataIndex]) / Int(sleepTypeBit)
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
            case .mindBody:
                
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
                let dateStr = formatter.string(from: dateList![dataIndex])
                
                selectedLabel.text = "\(data)" + unit + "\n" + dateStr
                
                //体重差值
                if dataIndex == dataList.count - 1{
                    weightDeltaLabel.text = ""
                }else{
                    let lastData = dataList.last!
                    weightDeltaLabel.text = lastData - data >= 0 ? "+\(lastData - data)" : "-\(data - lastData)"
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
                tuple in
                let markCircle = tuple.shape
                markCircle.lineWidth = 0
                markCircle.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
                markCircle.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
            }
            
            if let scroll = heartrateDataScroll {
                let offsetX = scroll.contentOffset.x + scroll.bounds.size.width / 2
                let newList = markCircleList.sorted(){
                    circle0, circle1 -> Bool in
                    let distance0 = fabs(circle0.shape.path!.currentPoint.x - offsetX)
                    let distance1 = fabs(circle1.shape.path!.currentPoint.x - offsetX)
                    return distance0 < distance1
                }
                
                if let tuple = newList.first{
                    let nearMarkCircle = tuple.shape
                    let plusWidth = nearMarkCircle.path!.boundingBoxOfPath.size.width / 2 + nearMarkCircle.lineWidth * 0 + 1 - selectedView.bounds.width / 2 * 0
                    let roundOffsetX = nearMarkCircle.path!.currentPoint.x - scroll.bounds.size.width / 2 - plusWidth
                    let offset = CGPoint(x: roundOffsetX, y: 0)
                    heartrateDataScroll?.setContentOffset(offset, animated: true)
                    
                    let minOffsetX = -(bounds.size.width - radius * 2) / 2
                    let maxOffsetX = scroll.contentSize.width - (bounds.size.width - radius * 2) / 2
                    if scroll.contentOffset.x < minOffsetX{
                        heartrateDataScroll?.contentOffset.x = minOffsetX
                    }else if scroll.contentOffset.x > maxOffsetX{
                        heartrateDataScroll?.contentOffset.x = maxOffsetX
                    }
                    
                    //获取数据
                    var dataIndex = Int((offset.x - minOffsetX) / (maxOffsetX - minOffsetX) * CGFloat(dataList.count < 80 ? 80 : dataList.count))
                    if dataIndex < 0{
                        dataIndex = 0
                    }else if dataIndex > dataList.count - 1{
                        dataIndex = dataList.count - 1
                    }
                    
                    //设置显示值 selected view
                    let data = tuple.value
                    let hour = Int(tuple.offset) / 60
                    let minute = (Int(tuple.offset) - hour * 60)
                    let hourStr = "\(hour)"
                    let minuteStr: String = minute < 10 ? "0\(minute)" : "\(minute)"
                    let time = hourStr + ":" + minuteStr
                    selectedLabel.text = "\(Int16(data))" + "Bmp" + "\n\(time)"
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        
                        nearMarkCircle.lineWidth = 4
                        nearMarkCircle.fillColor = UIColor.white.cgColor
                        nearMarkCircle.strokeColor = UIColor.white.cgColor
                    }, completion: nil)
                }
            }
        default:
            selectedView.isHidden = true
        }
    }
}
