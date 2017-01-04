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
            stepLabel.text = "\(stepValue)步"
        }
    }
    
    //体重
    var weightValue: Float = 60{
        didSet{
            weightLabel.text = String(format: "%.1f", weightValue)
        }
    }
    
    //睡眠
    var sleepTime: (hour: Int16, minute: Int16) = (0, 0){
        didSet{
            resetSleepLabel()
        }
    }
    var wakeTime: (hour: Int16, minute: Int16) = (7, 0){
        didSet{
            resetSleepLabel()
        }
    }
    
    override func viewDidLoad() {
        config()
        createContents()
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
        
        //绘制睡眠控件
        drawSleepGraphic()
    }
    
    private func drawSleepGraphic(){
        
        let circleFrame = centerImageView.frame
        let circleRadius = circleFrame.width / 2
        let bottomBezier = UIBezierPath(ovalIn: centerImageView.bounds)
        
        let bottomLayer = CAShapeLayer()
        bottomLayer.path = bottomBezier.cgPath
        bottomLayer.fillColor = nil
        bottomLayer.strokeColor = UIColor.lightGray.cgColor
        bottomLayer.lineWidth = 8
        centerImageView.layer.addSublayer(bottomLayer)
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
    private func resetSleepLabel(){
        let sleepTimeMinute = sleepTime.minute < 10 ? "0\(sleepTime.minute)" : "\(sleepTime.minute)"
        let wakeTimeMinute = wakeTime.minute < 10 ? "0\(wakeTime.minute)" : "\(wakeTime.minute)"
        sleepLabel.text = "\(sleepTime.hour):\(sleepTimeMinute)~\(wakeTime.hour):\(wakeTimeMinute)"
    }
}

extension TargetSettingVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
