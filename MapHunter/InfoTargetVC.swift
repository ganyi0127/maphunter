//
//  InfoTargetVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
class InfoTargetVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var stepSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var sleepView: UIView!
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepDetailLabel: UILabel!
    
    @IBOutlet weak var centerImageView: UIImageView!
    
    //步数
    var stepValue: Int32 = 8000{
        didSet{
            DispatchQueue.main.async {
                let text = "\(self.stepValue)步"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontBig])
                let unitLength = 1
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
                self.stepLabel.attributedText = mainAttributedString
            }
        }
    }
    
    //体重
    var weightValue: Float = 60{
        didSet{
            DispatchQueue.main.async {
                let text = "\(lroundf(self.weightValue))kg" //String(format: "%.1f", self.weightValue) + "kg"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontBig])
                let unitLength = 2
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
                self.weightLabel.attributedText = mainAttributedString
            }
        }
    }
    
    //睡眠
    var sleepTime: (hour: Int16, minute: Int16) = (0, 0){
        didSet{
            DispatchQueue.main.async {
                self.setStroke()
                self.setSleepLabel()
            }
        }
    }
    var wakeTime: (hour: Int16, minute: Int16) = (0, 0){
        didSet{
            DispatchQueue.main.async {
                self.setStroke()
                self.setSleepLabel()
            }
        }
    }
    
    //时间轴
    private let bottomBezier = UIBezierPath()
    private var timeLayer: CAShapeLayer?
    private var circleRadius: CGFloat!
    fileprivate var centerPoint: CGPoint!
    
    //摇杆
    fileprivate let sleepJoystick: UIImageView = {
        let image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: CGSize(width: 30, height: 30))
        let sleepJoystick = UIImageView(image: image)
        sleepJoystick.tag = 1
        sleepJoystick.isUserInteractionEnabled = true
        return sleepJoystick
    }()
    fileprivate let wakeJoystick: UIImageView = {
        let image = UIImage(named: "resource/target/target_sleep_end")?.transfromImage(size: CGSize(width: 30, height: 30))
        let wakeJoystick = UIImageView(image: image)
        wakeJoystick.tag = 2
        wakeJoystick.isUserInteractionEnabled = true
        return wakeJoystick
    }()
    fileprivate var selectTag = 0       //1:左摇杆 2:右摇杆
    
    //MARK:- init
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //绘制睡眠控件
        drawSleepGraphic()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        //获取按钮高度
        let buttonHeight = view_size.width / 16

        //设置下一步颜色
        nextButton.setTitleColor(defaut_color, for: .normal)
        //设置返回图片
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)

        //设置步数摇杆图片
        let stepThumbImage = UIImage(named: "resource/target/target_step_thumb")?.transfromImage(size: CGSize(width: 30, height: 30))
        stepSlider.setThumbImage(stepThumbImage, for: .normal)
        stepSlider.setThumbImage(stepThumbImage, for: .highlighted)
        
        //设置体重摇杆图片
        let weightThumbImage = UIImage(named: "resource/target/target_weight_thumb")?.transfromImage(size: CGSize(width: 30, height: 30))
        weightSlider.setThumbImage(weightThumbImage, for: .normal)
        weightSlider.setThumbImage(weightThumbImage, for: .highlighted)
        
        //设置center IMAGE
        let centerImage = UIImage(named: "resource/target/target_sleep_center.png")//?.transfromImage(size: centerImageView.bounds.size)
        centerImageView.image = centerImage
        
    }
    
    private var bottomLayer: CAShapeLayer?          //底部圆圈
    
    private var stepSuggestLayer: CAShapeLayer?     //运动建议步数圆圈
    private var stepSuggestLabel: UILabel?          //运动建议标签
    
    private var weightCurrentLayer: CAShapeLayer?   //当前体重位置
    private var weightMinSuggestLayer: CAShapeLayer?//最小值建议
    private var weightMaxSuggestLayer: CAShapeLayer?//最大值建议
    private var weightCurrentLabel: UILabel?        //当前体重标签
    private var weightRangeLabel: UILabel?          //体重范围标签
    
    private var sleepBeginLayer: CAShapeLayer?      //建议开始睡眠位置
    private var sleepEndLayer: CAShapeLayer?        //建议结束睡眠位置
    private var sleepBeginLabel: UILabel?           //建议开始睡眠标签
    private var sleepEndLabel: UILabel?             //建议结束睡眠标签
    
    private func drawSleepGraphic(){
        
        //获取常量
        let lineWidth: CGFloat = 4
        let circleFrame = centerImageView.frame
        circleRadius = circleFrame.width / 2
        centerPoint = CGPoint(x: circleFrame.width / 2 + circleFrame.origin.x, y: circleFrame.height / 2 + circleFrame.origin.y)
        
        //绘制路径
        bottomBezier.addArc(withCenter: centerPoint, radius: circleRadius, startAngle: -.pi / 2, endAngle: .pi * 1.5, clockwise: true)
        
        //绘制底部圆圈
        if bottomLayer == nil{
            bottomLayer = CAShapeLayer()
            bottomLayer?.path = bottomBezier.cgPath
            bottomLayer?.fillColor = nil
            bottomLayer?.strokeColor = separatorColor.cgColor
            bottomLayer?.lineWidth = lineWidth
            centerImageView.superview?.layer.addSublayer(bottomLayer!)
        }
        
        //绘制动态圆圈
        if timeLayer == nil{
            timeLayer = CAShapeLayer()
            timeLayer?.path = bottomBezier.cgPath
            timeLayer?.fillColor = nil
            timeLayer?.strokeColor = modelStartColors[.sleep]?.cgColor
            timeLayer?.lineWidth = lineWidth
            timeLayer?.lineCap = kCALineCapRound
            centerImageView.superview?.layer.addSublayer(timeLayer!)
        }
        
        //添加摇杆
        centerImageView.superview?.addSubview(sleepJoystick)
        centerImageView.superview?.addSubview(wakeJoystick)
        
        //初始化设置
        let userId = UserManager.share().userId
        let coredataHandler = CoreDataHandler.share()
        if let goal = coredataHandler.currentUser()?.goal{
            
            stepValue = goal.steps
            stepSlider.setValue(Float(stepValue), animated: true)
            weightValue = Float(goal.weight10000TimesKG)
            weightSlider.setValue(weightValue, animated: true)
            sleepTime = (hour: goal.sleepMinutes / 60, minute: goal.sleepMinutes % 60)
            wakeTime = (hour: 7, minute: 20)
        }else{
            sleepTime = (hour: 23, minute: 0)
            wakeTime = (hour: 7, minute: 0)
        }
        
        //MARK:- 绘制建议值
        let udGender = userDefaults.integer(forKey: "gender")
        let udHeight = userDefaults.integer(forKey: "height")
        let udWeight = userDefaults.float(forKey: "weight") / 10000
        let radius: CGFloat = 15
        
        //运动目标建议
        if stepSuggestLayer == nil && stepSuggestLabel == nil {
            bottomBezier.removeAllPoints()
            let maxValue = CGFloat(stepSlider.maximumValue)
            let minValue = CGFloat(stepSlider.minimumValue)
            let centerStepPoint = CGPoint(x: stepSlider.frame.origin.x + radius + (stepSlider.frame.width - radius * 2) * (8000 - minValue) / (maxValue - minValue),
                                          y: stepSlider.frame.origin.y + stepSlider.frame.height / 2)
            bottomBezier.addArc(withCenter: centerStepPoint, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 1.5, clockwise: true)
            stepSuggestLayer = CAShapeLayer()
            stepSuggestLayer?.path = bottomBezier.cgPath
            stepSuggestLayer?.fillColor = nil
            stepSuggestLayer?.strokeColor = UIColor.lightGray.cgColor
            stepSuggestLayer?.lineWidth = 1.5
            stepView.layer.insertSublayer(stepSuggestLayer!, below: stepSlider.layer)
            
            let labelWidth: CGFloat = 32
            let labelHeight: CGFloat = 20
            let labelFrame = CGRect(x: centerStepPoint.x - labelWidth / 2, y: centerStepPoint.y - radius - labelHeight, width: labelWidth, height: labelHeight)
            stepSuggestLabel = UILabel(frame: labelFrame)
            stepSuggestLabel?.textAlignment = .center
            stepSuggestLabel?.font = fontTiny
            stepSuggestLabel?.textColor = .lightGray
            stepSuggestLabel?.text = "建议"
            stepView.addSubview(stepSuggestLabel!)
        }
        
        //体重目标建议
        if weightCurrentLayer == nil && weightCurrentLayer == nil && weightMinSuggestLayer == nil && weightMaxSuggestLayer == nil && weightCurrentLabel == nil{
            
            
            let targetValue = 22 * pow(Float(udHeight) / 100, 2)
            //重新设置体重范围  
            var reMin = udWeight * 0.6
            var reMax = udWeight * 1.6
            if reMin > Float(udWeight){
                reMin = Float(udWeight)
            }
            if reMax < Float(udWeight){
                reMax = Float(udWeight)
            }
            weightSlider.minimumValue = reMin
            weightSlider.maximumValue = reMax
            if targetValue > reMax || targetValue < reMin {
                weightValue = udWeight
                weightSlider.setValue(udWeight, animated: true)
            }else{
                weightValue = targetValue       //设置默认目标体重
                weightSlider.setValue(targetValue, animated: true)
            }
            
            let maxValue = CGFloat(weightSlider.maximumValue)
            let minValue = CGFloat(weightSlider.minimumValue)
            
            let minWeightValue = 18.5 * pow(CGFloat(udHeight) / 100, 2)
            let maxWeightValue = 23.9 * pow(CGFloat(udHeight) / 100, 2)
            let currentWeightPoint = CGPoint(x: weightSlider.frame.origin.x + radius + (weightSlider.frame.width - radius * 2) * (CGFloat(udWeight) - minValue) / (maxValue - minValue),
                                             y: weightSlider.frame.origin.y + weightSlider.frame.height / 2)
            var tmp0 = minWeightValue - minValue
            if tmp0 < 0 {
                tmp0 = 0
            }else if tmp0 > maxValue - minValue{
                tmp0 = maxValue - minValue
            }
            let minWeightPoint = CGPoint(x: weightSlider.frame.origin.x + radius + (weightSlider.frame.width - radius * 2) * tmp0 / (maxValue - minValue),
                                         y: weightSlider.frame.origin.y + weightSlider.frame.height / 2)
            var tmp1 = maxWeightValue - minValue
            if tmp1 < 0{
                tmp1 = 0
            }else if tmp1 > maxValue - minValue{
                tmp1 = maxValue - minValue
            }
            let maxWeightPoint = CGPoint(x: weightSlider.frame.origin.x + radius + (weightSlider.frame.width - radius * 2) * tmp1 / (maxValue - minValue),
                                         y: weightSlider.frame.origin.y + weightSlider.frame.height / 2)
            
            let lineLength: CGFloat = 10
            let lineSpacing: CGFloat = 4
            
            //绘制当前体重
            bottomBezier.removeAllPoints()
            var line0 = CGPoint(x: currentWeightPoint.x, y: currentWeightPoint.y + lineSpacing)
            var line1 = CGPoint(x: currentWeightPoint.x, y: currentWeightPoint.y + lineSpacing + lineLength)
            bottomBezier.move(to: line0)
            bottomBezier.addLine(to: line1)
            weightCurrentLayer = CAShapeLayer()
            weightCurrentLayer?.path = bottomBezier.cgPath
            weightCurrentLayer?.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            weightCurrentLayer?.lineWidth = lineWidth
            weightCurrentLayer?.lineCap = kCALineCapRound
            weightView.layer.insertSublayer(weightCurrentLayer!, below: weightSlider.layer)
            
            let labelWidth: CGFloat = 80
            let labelHeight: CGFloat = 20
            var labelFrame = CGRect(x: currentWeightPoint.x - labelWidth / 2, y: currentWeightPoint.y + lineSpacing + lineLength, width: labelWidth, height: labelHeight)
            weightCurrentLabel = UILabel(frame: labelFrame)
            weightCurrentLabel?.textAlignment = .center
            weightCurrentLabel?.font = fontTiny
            weightCurrentLabel?.textColor = .lightGray
            weightCurrentLabel?.text = "当前\(Int(udWeight))kg"
            weightView.addSubview(weightCurrentLabel!)
            
            //绘制最小体重
            bottomBezier.removeAllPoints()
            line0 = CGPoint(x: minWeightPoint.x, y: minWeightPoint.y - lineSpacing)
            line1 = CGPoint(x: minWeightPoint.x, y: minWeightPoint.y - lineSpacing - lineLength)
            bottomBezier.move(to: line0)
            bottomBezier.addLine(to: line1)
            weightMinSuggestLayer = CAShapeLayer()
            weightMinSuggestLayer?.path = bottomBezier.cgPath
            weightMinSuggestLayer?.strokeColor = weightSlider.minimumTrackTintColor?.cgColor
            weightMinSuggestLayer?.lineWidth = lineWidth
            weightMinSuggestLayer?.lineCap = kCALineCapRound
            weightView.layer.insertSublayer(weightMinSuggestLayer!, below: weightSlider.layer)
            
            //绘制最大体重
            bottomBezier.removeAllPoints()
            line0 = CGPoint(x: maxWeightPoint.x, y: maxWeightPoint.y - lineSpacing)
            line1 = CGPoint(x: maxWeightPoint.x, y: maxWeightPoint.y - lineSpacing - lineLength)
            bottomBezier.move(to: line0)
            bottomBezier.addLine(to: line1)
            weightMaxSuggestLayer = CAShapeLayer()
            weightMaxSuggestLayer?.path = bottomBezier.cgPath
            weightMaxSuggestLayer?.strokeColor = weightSlider.minimumTrackTintColor?.cgColor
            weightMaxSuggestLayer?.lineWidth = lineWidth
            weightMaxSuggestLayer?.lineCap = kCALineCapRound
            weightView.layer.insertSublayer(weightMaxSuggestLayer!, below: weightSlider.layer)
            
            //绘制范围文字
            if tmp0 != tmp1{
                labelFrame = CGRect(x: minWeightPoint.x, y: maxWeightPoint.y - lineSpacing - lineLength - labelHeight, width: maxWeightPoint.x - minWeightPoint.x, height: labelHeight)
                //当范围过小 不显示范围文字
                if labelFrame.width > 40{
                    weightRangeLabel = UILabel(frame: labelFrame)
                    weightRangeLabel?.textAlignment = .center
                    weightRangeLabel?.font = fontTiny
                    weightRangeLabel?.textColor = weightSlider.minimumTrackTintColor
                    weightRangeLabel?.text = "健康范围"
                    weightView.insertSubview(weightRangeLabel!, belowSubview: weightSlider)
                }
            }
        }
        
        //睡眠目标建议 23:00~7:00
        if sleepBeginLayer == nil && sleepEndLayer == nil && sleepBeginLabel == nil && sleepEndLabel == nil {
            
            let startAngel = .pi * 2 * 23.0 / 24.0 - .pi / 2
            let endAngel = .pi * 2 * 7.0 / 24.0 - .pi / 2
            
            let labelWidth: CGFloat = 32
            let labelHeight: CGFloat = 20
            
            let startPoint = CGPoint(x: centerPoint.x + circleRadius * CGFloat(cos(startAngel)), y: centerPoint.y + circleRadius * CGFloat(sin(startAngel)))
            bottomBezier.removeAllPoints()
            bottomBezier.addArc(withCenter: startPoint, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            sleepBeginLayer = CAShapeLayer()
            sleepBeginLayer?.path = bottomBezier.cgPath
            sleepBeginLayer?.fillColor = nil
            sleepBeginLayer?.strokeColor = separatorColor.cgColor
            sleepBeginLayer?.lineWidth = lineWidth
            sleepView.layer.insertSublayer(sleepBeginLayer!, below: timeLayer!)
            
            let beginLabelFrame = CGRect(x: startPoint.x - labelWidth / 2, y: startPoint.y - radius - labelHeight, width: labelWidth, height: labelHeight)
            sleepBeginLabel = UILabel(frame: beginLabelFrame)
            sleepBeginLabel?.textAlignment = .center
            sleepBeginLabel?.font = fontTiny
            sleepBeginLabel?.textColor = separatorColor
            sleepBeginLabel?.text = "建议"
            sleepView.addSubview(sleepBeginLabel!)
            
            let endPoint = CGPoint(x: centerPoint.x + circleRadius * CGFloat(cos(endAngel)), y: centerPoint.y + circleRadius * CGFloat(sin(endAngel)))
            bottomBezier.removeAllPoints()
            bottomBezier.addArc(withCenter: endPoint, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            sleepEndLayer = CAShapeLayer()
            sleepEndLayer?.path = bottomBezier.cgPath
            sleepEndLayer?.fillColor = nil
            sleepEndLayer?.strokeColor = separatorColor.cgColor
            sleepEndLayer?.lineWidth = lineWidth
            sleepView.layer.insertSublayer(sleepEndLayer!, below: timeLayer!)
            
            let endLabelFrame = CGRect(x: endPoint.x + radius, y: endPoint.y - labelHeight / 2, width: labelWidth, height: labelHeight)
            sleepEndLabel = UILabel(frame: endLabelFrame)
            sleepEndLabel?.textAlignment = .center
            sleepEndLabel?.font = fontTiny
            sleepEndLabel?.textColor = separatorColor
            sleepEndLabel?.text = "建议"
            sleepView.addSubview(sleepEndLabel!)
        }
    }
    
    //MARK:- 修改圆盘路径起始结束点
    private func setStroke(){
        
        //计算
        let startValue = (CGFloat(sleepTime.hour) / 24 + CGFloat(sleepTime.minute) / 60 / 24) * .pi * 2
        let endValue = (CGFloat(wakeTime.hour) / 24 + CGFloat(wakeTime.minute) / 60 / 24) * .pi * 2
        
        bottomBezier.removeAllPoints()
        let startAngle = -.pi / 2 + startValue
        let endAngle = -.pi / 2 + endValue
        bottomBezier.addArc(withCenter: centerPoint, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //修改joystick位置
        sleepJoystick.frame.origin = CGPoint(x: centerPoint.x + cos(startAngle) * circleRadius - sleepJoystick.bounds.width / 2,
                                             y: centerPoint.y + sin(startAngle) * circleRadius - sleepJoystick.bounds.height / 2)
        wakeJoystick.frame.origin = CGPoint(x: centerPoint.x + cos(endAngle) * circleRadius - wakeJoystick.bounds.width / 2,
                                            y: centerPoint.y + sin(endAngle) * circleRadius - wakeJoystick.bounds.height / 2)
        
        //修改路径
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.toValue = bottomBezier.cgPath
        pathAnim.duration = 0.01
        pathAnim.isRemovedOnCompletion = false
        pathAnim.fillMode = kCAFillModeBoth
        timeLayer?.add(pathAnim, forKey: nil)
    }
    
    //MARK:- 返回上一层页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到主页
    @IBAction func next(_ sender: UIButton) {

        //临时存储运动目标设置
        let coredataHandler = CoreDataHandler.share()
        let user = coredataHandler.currentUser()
//        user?.sleepHour = sleepTime.hour
//        user?.sleepMinute = sleepTime.minute
//        user?.wakeHour = wakeTime.hour
//        user?.wakeMinute = wakeTime.minute
//        user?.goalWeight = weightValue
//        user?.goalStep = stepValue
        user?.goal?.isSyncedServer = false
        user?.goal?.sleepMinutes = 60 * 8
        user?.goal?.steps = stepValue
        user?.goal?.weight10000TimesKG = Int32(weightValue)
        guard coredataHandler.commit() else{
            let alertController = UIAlertController(title: nil, message: "保存目标设置失败", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "确定", style: .cancel){
                _ in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancel)
            alertController.setBlackTextColor()
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //跳转到注册页面 bootregist
        if let bootRegisterVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootregist") as? BootRegisterVC{
            navigationController?.show(bootRegisterVC, sender: nil)
        }
    }
    
    //MARK:- 数据更改
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let tag = sender.tag
        let value = sender.value
        
        if tag == 0 {
            //step
            let stepDelta: Int32 = 500
            stepValue = Int32(round(value)) / stepDelta * stepDelta
            sender.value = Float(stepValue)
        }else{
            //weight
            weightValue = Float(Int(value))
            sender.value = weightValue
        }
    }
    
    //MARK:- 更新时间
    private func setSleepLabel(){
        
        let sleepHour = sleepTime.hour, sleepMinute = sleepTime.minute
        let wakeHour = wakeTime.hour, wakeminute = wakeTime.minute
        
        //显示起始时间
        let sleepTimeMinute = sleepMinute < 10 ? "0\(sleepMinute)" : "\(sleepMinute)"
        let wakeTimeMinute = wakeminute < 10 ? "0\(wakeminute)" : "\(wakeminute)"
        var text = "\(sleepHour):\(sleepTimeMinute)~\(wakeHour):\(wakeTimeMinute)"
        let sleepDetailAttributed = NSMutableAttributedString(string: text,
                                                              attributes: [NSFontAttributeName: fontSmall])
        
        //添加图片混排
        let length = fontSmall.pointSize * 1.2
        let imageSize = CGSize(width: length, height: length)
        let imageBounds = CGRect(x: 0, y: length / 2 - sleepDetailLabel.bounds.height / 2, width: length, height: length)
        let startAttach = NSTextAttachment()
        startAttach.image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: imageSize)
        startAttach.bounds = imageBounds
        let startAttributed = NSAttributedString(attachment: startAttach)
        sleepDetailAttributed.insert(startAttributed, at: 0)
        let endAttach = NSTextAttachment()
        endAttach.image = UIImage(named: "resource/target/target_sleep_end")?.transfromImage(size: imageSize)
        endAttach.bounds = imageBounds
        let endAttributed = NSAttributedString(attachment: endAttach)
        let endIndex: Int       //插入位置
        if sleepHour < 10 {
            endIndex = 6
        }else{
            endIndex = 7
        }
        sleepDetailAttributed.insert(endAttributed, at: endIndex)
        sleepDetailLabel.attributedText = sleepDetailAttributed
        
        //计算时间差
        var offsetHour: Int16 = 0
        var daltaMinute = wakeminute - sleepMinute
        while daltaMinute < 0 {
            daltaMinute += 60
            offsetHour += 1
        }
        
        var daltaHour = wakeHour - offsetHour - sleepHour
        while daltaHour < 0 {
            daltaHour += 24
        }
        
        //设置间隔时间显示
        text = daltaMinute == 0 ? "\(daltaHour)小时" : "\(daltaHour)小时\(daltaMinute)分钟"
        let mainAttributedString = NSMutableAttributedString(string: text,
                                                             attributes: [NSFontAttributeName: fontBig])
        let unitLength = 2
        mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
        if daltaMinute != 0 {
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength * 2 - 2, unitLength))
        }
        sleepLabel.attributedText = mainAttributedString
    }
}

extension InfoTargetVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            
            guard let joystick: UIImageView = touch.view as? UIImageView, joystick.tag == 1 || joystick.tag == 2 else{
                return
            }
            selectTag = joystick.tag
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        touches.forEach(){
            touch in
            
            guard selectTag != 0 else{
                return
            }
            
            //坐标转换为view坐标
            let centerSuperPoint = view.convert(centerPoint, from: centerImageView.superview)
            let location = touch.location(in: view)
            let deltaPoint = CGPoint(x: location.x - centerSuperPoint.x, y: location.y - centerSuperPoint.y)
            let angel = atan2(deltaPoint.y, deltaPoint.x) + .pi
            
            //根据角度计算步进选择时间
            let stepDelta: Int16 = 10
            var originHour = angel / (CGFloat.pi * 2) * 24 - 6
            while originHour < 0{
                originHour += 24
            }
            let hour = Int16(originHour)
            let minute = Int16((originHour - CGFloat(hour)) * 60) / stepDelta * stepDelta
            var tuple = (hour: hour, minute: minute)
            
            //设置最小间隔
            let leastDelta: CGFloat = 2         //最小间隔两小时
            if selectTag == 1{
                let digitSleeptime = CGFloat(hour) + CGFloat(minute) / 60
                let digitWaketime = CGFloat(wakeTime.hour) + CGFloat(wakeTime.minute) / 60
                var deltatime = digitWaketime - digitSleeptime
                while deltatime < 0{
                    deltatime += 24
                }
                
//                if deltatime < leastDelta{
//                    tuple = (hour: wakeTime.hour - Int16(leastDelta), minute: wakeTime.minute)
//                    warn()
//                }
                sleepTime = tuple       //赋值
            }else if selectTag == 2{
                let digitSleeptime = CGFloat(sleepTime.hour) + CGFloat(sleepTime.minute) / 60
                let digitWaketime = CGFloat(hour) + CGFloat(minute) / 60
                var deltatime = digitWaketime - digitSleeptime
                while deltatime < 0{
                    deltatime += 24
                }
                
//                if deltatime < leastDelta{
//                    tuple = (hour: sleepTime.hour + Int16(leastDelta), minute: sleepTime.minute)
//                    warn()
//                }
                wakeTime = tuple        //赋值
            }
        }
    }
    
    //MARK:- 圆盘抖动
    private func warn(){
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [1, 1.1, 0.95, 1]
        scaleAnim.keyTimes = [0, 0.3, 0.8, 1]
        scaleAnim.duration = 0.1
        centerImageView.layer.add(scaleAnim, forKey: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectTag = 0
    }
}
