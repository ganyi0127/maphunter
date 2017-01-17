//
//  PremapVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/14.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PremapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    private var mapVC: MapVC?
    
    //lock按钮
    @IBOutlet weak var lockButton: UIButton!
    private var originLockbuttonFrame: CGRect?
    private var originPausebuttonFrame: CGRect?
    private var isLocked = false{
        didSet{
            if isLocked{
                let img = UIImage(named: "resource/map/lock/locked")
                lockButton.setImage(img, for: .normal)
                
                UIView.animate(withDuration: 0.4){
                    if let f = self.originPausebuttonFrame {
                        self.lockButton.frame.origin.y = f.origin.y
                    }
                }
                view.insertSubview(effectView, aboveSubview: pauseButton)
                
                //添加手势事件
                if swip == nil {
                    swip = UISwipeGestureRecognizer(target: self, action: #selector(unlock(recognizer:)))
                    swip?.direction = .down
                    swip?.numberOfTouchesRequired = 1
                    lockButton.addGestureRecognizer(swip!)
                }
            }else{
                let img = UIImage(named: "resource/map/lock/unlock")
                lockButton.setImage(img, for: .normal)
                
                UIView.animate(withDuration: 0.4){
                    if let f = self.originLockbuttonFrame {
                        self.lockButton.frame.origin.y = f.origin.y
                    }
                    
                    self.effectView.removeFromSuperview()
                }
                
                //移除手势事件
                if let s = swip {
                    view.removeGestureRecognizer(s)
                    swip = nil
                }
            }
        }
    }
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
    //数据
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var heartrateLabel: UILabel!
    
    //计算数据
    var distance: Double = 0{
        didSet{
            distanceLabel.text = String(format: "%.2f", distance / 1000)
            
            //计算配速
            let pace = CGFloat(totalTime) / CGFloat(distance / 1000)
            print(totalTime, distance, pace)
            let minute = Int16(pace) / 60
            let sec = Int16(pace) - minute * 60
            let minuteStr = "\(minute)\""
            let secStr = sec < 10 ? "0\(sec)\'" : "\(sec)\'"
            speedLabel.text = minuteStr + secStr
        }
    }
    private var timeTask: Task?
    var totalTime: Int16 = 0{
        didSet{
            let hour = totalTime / 3600
            let minute = (totalTime - hour * 3600) / 60
            let sec = (totalTime - hour * 3600 - minute * 60)
            let hourStr = hour <= 0 ? "" : hour < 10 ? "0\(hour):" : "\(hour):"
            let minuteStr = minute < 10 ? "0\(minute):" : "\(minute):"
            let secStr = sec < 10 ? "0\(sec)" : "\(sec)"
            if hour <= 0 {
                timeLabel.font = UIFont(name: font_name, size: 120)
            }else{
                timeLabel.font = UIFont(name: font_name, size: 80)
            }
            timeLabel.text = hourStr + minuteStr + secStr
        }
    }
    
    //按钮
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
//    private lazy var continueButton: UIButton = {
//        let frame = CGRect(x: view_size.width / 2 - self.pauseButton.bounds.width * 1.1 * 2, y: self.pauseButton.frame.origin.y, width: self.pauseButton.bounds.width / 2, height: self.pauseButton.bounds.height / 2)
//        let button: UIButton = UIButton(frame: frame)
//        let img = UIImage(named: "resource/map/continue")
//        button.setImage(img, for: .normal)
//        button.isHidden = true
//        button.addTarget(self, action: #selector(self.pressContinue(_:)), for: .touchUpInside)
//        return button
//    }()
//    private lazy var finishButton: UIButton = {
//        let frame = CGRect(x: view_size.width / 2 + self.pauseButton.bounds.width * 0.1 * 2, y: self.pauseButton.frame.origin.y, width: self.pauseButton.bounds.width / 2, height: self.pauseButton.bounds.height / 2)
//        let button: UIButton = UIButton(frame: frame)
//        let img = UIImage(named: "resource/map/finish")
//        button.setImage(img, for: .normal)
//        button.isHidden = true
//        button.addTarget(self, action: #selector(self.pressFinish(_:)), for: .touchUpInside)
//        return button
//    }()
    
    //设置地图开关
    private let closeImg = UIImage(named: "resource/map/itemclose")?.transfromImage(size: CGSize(width: 20, height: 20))        //叉叉
    private var mapOpen: Bool = false{
        didSet{
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                if self.mapOpen {
                    self.mapView.isUserInteractionEnabled = true
                }else{
                    self.mapView.isUserInteractionEnabled = false
                }
            }, completion: {
                complete in
                if self.mapOpen{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.closeImg, style: .done, target: self, action: #selector(self.clickMap(_:)))
                }else{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "   ", style: .done, target: self, action: #selector(self.clickMap(_:)))
                }
            })
            
            let anim = CABasicAnimation(keyPath: "path")
            anim.toValue = mapOpen ? self.bigPath : self.smallPath
            anim.duration = 0.5
            anim.isRemovedOnCompletion = false
            anim.fillMode = kCAFillModeBoth
            self.maskLayer.add(anim, forKey: nil)
        }
    }
    
    //路径
    private let smallRadius: CGFloat = 44 / 2
    private let bigRadius: CGFloat = view_size.height * 1.5
    private lazy var centerPoint: CGPoint = {return CGPoint(x: view_size.width - self.smallRadius - 20, y: self.smallRadius + 20)}()
    private lazy var smallPath: CGPath = {
        let bezier = UIBezierPath(arcCenter: self.centerPoint, radius: self.smallRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        return bezier.cgPath
    }()
    private lazy var bigPath: CGPath = {
        let bezier = UIBezierPath(arcCenter: self.centerPoint, radius: self.bigRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        return bezier.cgPath
    }()
    private lazy var maskLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.path = self.smallPath
        return shape
    }()
    
    //背景图层
    private var backgroundLayer: CAGradientLayer?
    
    //手势
    private var swip: UISwipeGestureRecognizer?
    
    //MARK:- init -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        originLockbuttonFrame = lockButton.frame
        originPausebuttonFrame = pauseButton.frame
    }
    
    //MARK:- 获取mapVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map"{
            mapVC = segue.destination as? MapVC
            mapVC?.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let s = swip {
            view.removeGestureRecognizer(s)
        }
    }
    
    private func config(){
        
        //绘制渐变背景
        drawBackground(true)
        
        //隐藏navigation与tabbar
        navigationController?.setTabbar(hidden: true)
        navigationController?.setNavigation(hidden: true)
        
        //设置地图遮罩,默认遮蔽
        self.mapView.layer.mask = maskLayer
        mapOpen = false
    }
    
    private func createContents(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "   ", style: .done, target: self, action: #selector(self.clickMap(_:)))
        navigationItem.hidesBackButton = true               //隐藏返回按钮
        
        //自动开始地图轨迹记录
        mapVC?.isRecording = true
        countSec()
    }
    
    //MARK:- 绘制背景
    private func drawBackground(_ open: Bool){
        
        if let bg = backgroundLayer {
            let startColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1).cgColor
            let endColor = open ? UIColor(red: 76 / 255, green: 108 / 255, blue: 110 / 255, alpha: 1).cgColor : UIColor(red: 114 / 255, green: 87 / 255, blue: 68 / 255, alpha: 1).cgColor
            bg.colors = [startColor, endColor]
        }else{
            
            backgroundLayer = CAGradientLayer()
            backgroundLayer?.frame = view.bounds
            backgroundLayer?.locations = [0, 1]
            backgroundLayer?.startPoint = CGPoint(x: 0, y: 0)
            backgroundLayer?.endPoint = CGPoint(x: 0, y: 1)
            let startColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1).cgColor
            let endColor = open ? UIColor(red: 76 / 255, green: 108 / 255, blue: 110 / 255, alpha: 1).cgColor : UIColor(red: 114 / 255, green: 87 / 255, blue: 68 / 255, alpha: 1).cgColor
            backgroundLayer?.colors = [startColor, endColor]
            view.layer.insertSublayer(backgroundLayer!, at: 0)
        }
    }
    
    //MARK:- 打开或关闭地图
    @objc private func clickMap(_ sender: UIButton){
        if !isLocked {
            mapOpen = !mapOpen
        }
    }
    
    //MARK:- 暂停
    @IBAction func pause(_ sender: UIButton) {
        drawBackground(false)
        
        mapVC?.isPause = true
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.continueButton.isHidden = false
            self.finishButton.isHidden = false
            self.pauseButton.isHidden = true
        }, completion: {
            complete in
        })
    }
    
    //MARK:- 继续
    @IBAction func pressContinue(_ sender: UIButton) {
        drawBackground(true)
        
        mapVC?.isPause = false
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.continueButton.isHidden = true
            self.finishButton.isHidden = true
            self.pauseButton.isHidden = false
        }, completion: {
            complete in
        })
    }
    
    //MARK:- 结束
    @IBAction func pressFinish(_ sender: UIButton) {
        mapVC?.isRecording = false
        cancel(timeTask)
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 计时器
    private func countSec(){
        timeTask = delay(1){
            if let map = self.mapVC {
                if !map.isPause {
                    self.totalTime += 1
                }
            }
            self.countSec()
        }
    }
    
    //MARK:- 锁定
    @IBAction func lock(_ sender: UIButton) {
        if !isLocked {
            isLocked = true
        }
    }
    
    //MARK:- 下滑解锁
    @objc private func unlock(recognizer: UISwipeGestureRecognizer){
        if isLocked {
            isLocked = false
        }
    }
}

//MARK:- 地图代理
extension PremapVC: MapDelegate{
    func map(totalDistance distance: Double, addedDistance subDistance: Double) {
        self.distance = distance
    }
    
    func map(pastTime time: TimeInterval) {
    }
}
