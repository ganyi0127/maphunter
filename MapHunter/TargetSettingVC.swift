//
//  TargetSettingVC.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class TargetSettingVC: UIViewController {
    
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var stepSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepDetailLabel: UILabel!
    
    @IBOutlet weak var centerImageView: UIImageView!
    
    //步数
    var stepValue: Int16 = 10000{
        didSet{
            let text = "\(stepValue)步"
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontBig])
            let unitLength = 1
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            stepLabel.attributedText = mainAttributedString
        }
    }
    
    //体重
    var weightValue: Float = 60{
        didSet{
            let text = String(format: "%.1f", weightValue) + "kg"
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontBig])
            let unitLength = 2
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            weightLabel.attributedText = mainAttributedString
        }
    }
    
    //睡眠
    var sleepTime: (hour: Int16, minute: Int16) = (0, 0){
        didSet{
            setStroke()
            setSleepLabel()
        }
    }
    var wakeTime: (hour: Int16, minute: Int16) = (0, 0){
        didSet{
            setStroke()
            setSleepLabel()
        }
    }
    
    //时间轴
    private let bottomBezier = UIBezierPath()
    private let timeLayer = CAShapeLayer()
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
        
        //设置取消按钮图片
        let refuseImage = UIImage(named: "resource/target/target_refuse")?.transfromImage(size: CGSize(width: buttonHeight, height: buttonHeight))
        refuseButton.setBackgroundImage(refuseImage, for: .normal)
        
        //设置确定按钮图片
        let acceptImage = UIImage(named: "resource/target/target_accept")?.transfromImage(size: CGSize(width: buttonHeight, height: buttonHeight))
        acceptButton.setBackgroundImage(acceptImage, for: .normal)
        
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
    
    private func drawSleepGraphic(){
        
        //获取常量
        let lineWidth: CGFloat = 4
        let circleFrame = centerImageView.frame
        circleRadius = circleFrame.width / 2
        centerPoint = CGPoint(x: circleFrame.width / 2 + circleFrame.origin.x, y: circleFrame.height / 2 + circleFrame.origin.y)
        
        //绘制路径
        bottomBezier.addArc(withCenter: centerPoint, radius: circleRadius, startAngle: -(CGFloat)(M_PI_2), endAngle: CGFloat(M_PI) * 1.5, clockwise: true)
        
        //绘制底部圆圈
        let bottomLayer = CAShapeLayer()
        bottomLayer.path = bottomBezier.cgPath
        bottomLayer.fillColor = nil
        bottomLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        bottomLayer.lineWidth = lineWidth
        centerImageView.superview?.layer.addSublayer(bottomLayer)
        
        //绘制动态圆圈
        timeLayer.path = bottomBezier.cgPath
        timeLayer.fillColor = nil
        timeLayer.strokeColor = modelStartColors[.sleep]?.cgColor
        timeLayer.lineWidth = lineWidth
        timeLayer.lineCap = kCALineCapRound
        centerImageView.superview?.layer.addSublayer(timeLayer)
        
        //添加摇杆
        centerImageView.superview?.addSubview(sleepJoystick)
        centerImageView.superview?.addSubview(wakeJoystick)
        
        //初始化设置
        stepValue = 10000
        weightValue = 65
        
        sleepTime = (hour: 19, minute: 40)
        wakeTime = (hour: 7, minute: 30)
    }
    
    //MARK:- 修改圆盘路径起始结束点
    private func setStroke(){
        
        //计算
        let startValue = (CGFloat(sleepTime.hour) / 24 + CGFloat(sleepTime.minute) / 60 / 24) * CGFloat(M_PI * 2)
        let endValue = (CGFloat(wakeTime.hour) / 24 + CGFloat(wakeTime.minute) / 60 / 24) * CGFloat(M_PI * 2)
        
        bottomBezier.removeAllPoints()
        let startAngle = -CGFloat(M_PI_2) + startValue
        let endAngle = -CGFloat(M_PI_2) + endValue
        bottomBezier.addArc(withCenter: centerPoint, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        //修改joystick位置
        sleepJoystick.frame.origin = CGPoint(x: centerPoint.x + cos(startAngle) * circleRadius - sleepJoystick.bounds.width / 2,
                                             y: centerPoint.y + sin(startAngle) * circleRadius - sleepJoystick.bounds.height / 2)
        wakeJoystick.frame.origin = CGPoint(x: centerPoint.x + cos(endAngle) * circleRadius - wakeJoystick.bounds.width / 2,
                                            y: centerPoint.y + sin(endAngle) * circleRadius - wakeJoystick.bounds.height / 2)
        
        //修改路径
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.toValue = bottomBezier.cgPath
        pathAnim.duration = 0.4
        pathAnim.isRemovedOnCompletion = false
        pathAnim.fillMode = kCAFillModeBoth
        timeLayer.add(pathAnim, forKey: nil)
    }
    
    //MARK:- 取消按钮
    @IBAction func refuseSetting(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 确定按钮
    @IBAction func acceptSetting(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 数据更改
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let tag = sender.tag
        let value = sender.value
        
        if tag == 0 {
            //step
            stepValue = Int16(round(value))
        }else{
            //weight
            weightValue = value
        }
    }
    
    //MARK:- 更新时间
    private func setSleepLabel(){
        
        let sleepHour = sleepTime.hour, sleepMinute = sleepTime.minute
        let wakeHour = wakeTime.hour, wakeminute = wakeTime.minute
        
        //显示起始时间
        let sleepTimeMinute = sleepMinute < 10 ? "0\(sleepMinute)" : "\(sleepMinute)"
        let wakeTimeMinute = wakeminute < 10 ? "0\(wakeminute)" : "\(wakeminute)"
        sleepDetailLabel.text = "\(sleepHour):\(sleepTimeMinute)~\(wakeHour):\(wakeTimeMinute)"
        
        //计算时间差
        var offsetHour = 0
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
        let text = daltaMinute == 0 ? "\(daltaHour)小时" : "\(daltaHour)小时\(daltaMinute)分钟"
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

extension TargetSettingVC{
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
            let angel = atan2(deltaPoint.y, deltaPoint.x) + CGFloat(M_PI)
            
            //根据角度计算选择时间
            var originHour = angel / CGFloat(M_PI * 2) * 24 - 6
            while originHour < 0{
                originHour += 24
            }
            let hour = Int16(originHour)
            let minute = Int16((originHour - CGFloat(hour)) * 60) / 5 * 5
            var tuple = (hour: hour, minute: minute)

            //设置最小间隔
            if selectTag == 1{
                let digitSleeptime = CGFloat(hour) + CGFloat(minute) / 60
                let digitWaketime = CGFloat(wakeTime.hour) + CGFloat(wakeTime.minute) / 60
                var deltatime = digitWaketime - digitSleeptime
                while deltatime < 0{
                    deltatime += 24
                }
                
                if deltatime < 1{
                    tuple = (hour: wakeTime.hour - 1, minute: wakeTime.minute)
                    warn()
                }
                sleepTime = tuple       //赋值
            }else if selectTag == 2{
                let digitSleeptime = CGFloat(sleepTime.hour) + CGFloat(sleepTime.minute) / 60
                let digitWaketime = CGFloat(hour) + CGFloat(minute) / 60
                var deltatime = digitWaketime - digitSleeptime
                while deltatime < 0{
                    deltatime += 24
                }

                if deltatime < 1{
                    tuple = (hour: sleepTime.hour + 1, minute: sleepTime.minute)
                    warn()
                }
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
