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
    fileprivate weak var mapVC: MapVC?                   //地图
    @IBOutlet weak var gpsImageView: UIImageView!
    
    //lock按钮
    @IBOutlet weak var lockButton: UIButton!
    private var originLockbuttonFrame: CGRect?
    private var originPausebuttonFrame: CGRect?
    private var isLocked = false{
        didSet{
            if isLocked{
                let img = UIImage(named: "resource/map/lock/locked")
                lockButton.setImage(img, for: .normal)
                
                effectView.alpha = 0
                UIView.animate(withDuration: 0.4){
                    self.effectView.alpha = 1
                    self.mapView.alpha = 0
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
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                    self.effectView.alpha = 0
                    self.mapView.alpha = 1
                    if let f = self.originLockbuttonFrame {
                        self.lockButton.frame.origin.y = f.origin.y
                    }
                }, completion: {
                    _ in
                    self.effectView.removeFromSuperview()
                })
                
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
    private lazy var initEffectView = { () -> UIVisualEffectView in 
        let blur: UIBlurEffect = UIBlurEffect(style: .dark)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(origin: .zero, size: view_size)
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
            let minute = Int(pace) / 60
            let sec = Int(pace) - minute * 60
            let minuteStr = "\(minute)\""
            let secStr = sec < 10 ? "0\(sec)\'" : "\(sec)\'"
            speedLabel.text = minuteStr + secStr
        }
    }
    fileprivate var timeTask: Task?
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
    fileprivate var finishShape: CAShapeLayer?
    
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
        
        //开始计时
        
        //321倒计时
        startCountDown{
            self.countSec()
        }
    }
    
    //MARK:- 添加倒计时页面
    private func startCountDown(closure: @escaping ()->()){
        
        view.addSubview(effectView)
        
        let imgSize = CGSize(width: view_size.width / 2, height: view_size.width / 2)
        let imgOrigin = CGPoint(x: view_size.width / 2 - imgSize.width / 2, y: view_size.height / 2 - imgSize.height / 2)
        let imgInitFrame = CGRect(x: view_size.width / 2, y: view_size.height / 2, width: 0, height: 0)
        let imgFinalFrame = CGRect(origin: imgOrigin, size: imgSize)
        let img3 = UIImage(named: "resource/map/3")?.transfromImage(size: imgSize)
        let img2 = UIImage(named: "resource/map/2")?.transfromImage(size: imgSize)
        let img1 = UIImage(named: "resource/map/1")?.transfromImage(size: imgSize)
        let imgView3 = UIImageView(image: img3)
        imgView3.frame = imgInitFrame
        let imgView2 = UIImageView(image: img2)
        imgView2.frame = imgInitFrame
        let imgView1 = UIImageView(image: img1)
        imgView1.frame = imgInitFrame
        
        view.addSubview(imgView3)
        view.addSubview(imgView2)
        view.addSubview(imgView1)
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
            imgView3.frame = imgFinalFrame
        }, completion: {
            complete in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                imgView3.frame = imgInitFrame
            }, completion: {
                complete in
                UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                    imgView3.removeFromSuperview()
                    imgView2.frame = imgFinalFrame
                }, completion: {
                    complete in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                        imgView2.frame = imgInitFrame
                    }, completion: {
                        complete in
                        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                            imgView2.removeFromSuperview()
                            imgView1.frame = imgFinalFrame
                        }, completion: {
                            complete in
                            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                                imgView1.frame = imgInitFrame
                                self.effectView.alpha = 0
                            }, completion: {
                                complete in
                                imgView1.removeFromSuperview()
                                self.effectView.removeFromSuperview()
                                closure()
                            })
                        })
                    })
                })
            })
        })
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
            self.continueButton.alpha = 1
            self.finishButton.alpha = 1
            self.pauseButton.alpha = 0
        }, completion: {
            complete in
        })
    }
    
    //MARK:- 继续
    @IBAction func pressContinue(_ sender: UIButton) {
        drawBackground(true)
        
        mapVC?.isPause = false
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.continueButton.alpha = 0
            self.finishButton.alpha = 0
            self.pauseButton.alpha = 1
        }, completion: {
            complete in
        })
    }
    
    //MARK:- 结束inside
    @IBAction func pressFinish(_ sender: UIButton) {
        removeAnimationFromFinishShape()
    }
    
    //MARK:- 结束outside
    @IBAction func pressFinishOutside(_ sender: UIButton) {
        removeAnimationFromFinishShape()
    }
    
    //MARK:- 移动动效 loading
    fileprivate func removeAnimationFromFinishShape(){
        
        finishShape?.removeAllAnimations()
        finishShape?.removeFromSuperlayer()
        finishShape = nil
    }
    
    //MARK:- 结束 按下
    @IBAction func touchDownFinish(_ sender: UIButton) {
        
        guard finishShape == nil else {
            return
        }
        
        let bezier = UIBezierPath(arcCenter: CGPoint(x: finishButton.bounds.width / 2, y: finishButton.bounds.height / 2),
                                  radius: finishButton.bounds.width / 2 + 2,
                                  startAngle: -CGFloat(M_PI_2),
                                  endAngle: CGFloat(M_PI_2 * 3),
                                  clockwise: true)
        finishShape = CAShapeLayer()
        finishShape?.path = bezier.cgPath
        finishShape?.fillColor = nil
        finishShape?.lineWidth = 4
        finishShape?.strokeColor = UIColor.white.cgColor
        finishButton.layer.addSublayer(finishShape!)
        
        //动画
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = 1.5
        strokeEndAnimation.fillMode = kCAFillModeBoth
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.delegate = self
        finishShape?.add(strokeEndAnimation, forKey: nil)
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

//MARK:- 结束动画代理
extension PremapVC: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //判断是否合法结束
        if flag {
            if distance < 1000 {
                let alert = UIAlertController(title: "结束运动", message: "距离不足1KM,无法保存运动路径", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "结束运动", style: .cancel){
                    _ in
                    self.mapVC?.isRecording = false
                    cancel(self.timeTask)
                    _ = self.navigationController?.popViewController(animated: true)
                }
                let continueAction = UIAlertAction(title: "继续运动", style: .default){
                    _ in
                    self.removeAnimationFromFinishShape()
                }
                alert.addAction(cancelAction)
                alert.addAction(continueAction)
                alert.setBlackTextColor()
                present(alert, animated: true, completion: nil)
            }else{
                //分享路径
                let pathShareVC = storyboard?.instantiateViewController(withIdentifier: "pathshare") as! PathShareVC
                pathShareVC.distance = distance
                navigationController?.pushViewController(pathShareVC, animated: true)
            }
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
    
    func map(gps status: MapGPSStatus) {
        var imgName: String
        switch status {
        case .high:
            imgName = "resource/map/gps/high"
        case .middle:
            imgName = "resource/map/gps/middle"
        case .low:
            imgName = "resource/map/gps/low"
        case .disConnect:
            imgName = "resource/map/gps/disconnect"
        case .close:
            imgName = "resource/map/gps/disconnect"
        }
        let image = UIImage(named: imgName)
        gpsImageView.image = image
    }
}
