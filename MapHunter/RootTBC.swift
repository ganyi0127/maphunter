//
//  RootTBVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import MediaPlayer
import AngelFit
import CoreBluetooth
class RootTBC: UITabBarController {
    
    //展开按钮
    private var menuButtonFlag: Bool = false{
        didSet{
            if menuButtonFlag{
                
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = 0
                animation.toValue = M_PI_2 / 2 + M_PI
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                menuButton.layer.add(animation, forKey: nil)
                
                
                //添加高斯模糊
                effectView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.effectView.alpha = 1
                }, completion: nil)
                self.selectedViewController?.view.addSubview(effectView)
                effectView.addGestureRecognizer(tap)
                
                //隐藏tabbar
                let tabbarFrame = self.tabBar.frame
                let offsetY:CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : tabbarFrame.height
                let buttonFrame = menuButton.frame
                let buttonOffsetY: CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : -tabbarFrame.height * 2.2
                let duration: TimeInterval = 0.1
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.tabBar.frame = tabbarFrame.offsetBy(dx: 0, dy: offsetY)
                    self.menuButton.frame = buttonFrame.offsetBy(dx: 0, dy: buttonOffsetY)
                }){
                    complete in
                    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        let buttonOffsetY: CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : -tabbarFrame.height * 2
                        self.menuButton.frame = buttonFrame.offsetBy(dx: 0, dy: buttonOffsetY)
                    }, completion: nil)
                }
                
            }else{
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = M_PI_2 / 2 + M_PI
                animation.toValue = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                menuButton.layer.add(animation, forKey: nil)
                
                //移除高斯模糊
                effectView.removeGestureRecognizer(tap)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.effectView.alpha = 0
                }){
                    _ in
                    
                    //当动画结束后、页面为关闭状态时移除效果
                    if !self.menuButtonFlag{
                        self.effectView.removeFromSuperview()
                    }
                }
                
                //显示tabbar
                var tabbarFrame = self.tabBar.frame
                tabbarFrame.origin.y = view_size.height - tabbarFrame.height
                var buttonFrame = menuButton.frame
                buttonFrame.origin.y = tabbarFrame.height / 2 - buttonFrame.height / 2
                let duration: TimeInterval = 0.1
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.tabBar.frame = tabbarFrame
                    self.menuButton.frame = buttonFrame
                }){
                    _ in
                    
                }
            }
        }
    }
    
    //按钮
    private lazy var menuButton: UIButton! = { () -> UIButton in
        let menuButtonWidth = self.tabBar.frame.height * 1.2
        //按钮位置(在set方法中修改)
        let menuButtonFrame = CGRect(x: view_size.width / 2 - menuButtonWidth / 2,
                                     y: -menuButtonWidth * 0.3 * 0,
                                     width: menuButtonWidth,
                                     height: menuButtonWidth)
        let menuButton = UIButton(frame: menuButtonFrame)
        let height = self.tabBar.backgroundImage!.size.height / 2
        let itemSize = CGSize(width: height, height: height)
        let image = UIImage(named: "resource/tabbar/main")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        menuButton.setImage(image, for: .normal)
        menuButton.addTarget(self, action: #selector(clickMenuButton(sender:)), for: .touchUpInside)
        return menuButton
    }()
    
    
    //取消点击事件
    private var tap: UITapGestureRecognizer{
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(recognizer:)))
        tap.numberOfTapsRequired = 1
        return tap
    }
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
    //定位相关
    fileprivate var isLocation = false
    fileprivate var preCoordinate: CLLocationCoordinate2D?
    fileprivate var deltaDistance: UInt32 = 0
    fileprivate var startTime: Date?
    fileprivate var totalTime: TimeInterval = 0
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        //修改默认界面
        selectedIndex = 0
        
        //初始化sdk
        let satanManager = SatanManager.share()
        satanManager?.delegate = self
        _ = AngelManager.share()
    }
    
    private func createContents(){
        
        tabBar.addSubview(menuButton)
        menuButtonFlag = false

        
        //设置自动重连
        if !PeripheralManager.share().selectUUIDStringList().isEmpty{
            GodManager.share().startScan()
        }
    }
    
    //MARK:- 切换状态时 取消menubutton选中
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        super.tabBar(tabBar, didSelect: item)
//        if menuButtonFlag {
//            menuButtonFlag = false
//        }
//    }
    
    //MARK:- 点击展开按钮
    @objc private func clickMenuButton(sender: UIButton){

        menuButtonFlag = !menuButtonFlag
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    //MARK:- 点击关闭按钮
    @objc private func tap(recognizer: UITapGestureRecognizer){
        clickMenuButton(sender: menuButton)
    }
}

//MARK:- 交换数据代理
extension RootTBC: SatanManagerDelegate{
    
    
    //发送app持续时间
    func satanManagerDuration() -> Int {
        if let staTime = startTime{
            let dltTime = deltaTime(from: staTime, to: Date())
            startTime = Date()
            totalTime += dltTime
        }
        return Int(totalTime)
    }
    
    //状态 start pause restore end
    func satanManager(didUpdateState state: SatanManagerState) {
        switch state {
        case .start:
            if CLLocationManager.locationServicesEnabled(){
                globalLocationManager.startUpdatingLocation()   //开始定位
                globalLocationManager.delegate = self
                isLocation = true
            }
            
            startTime = Date()
        case .pause:
            isLocation = false
            startTime = nil
        case .restore:
            isLocation = true
            startTime = Date()
        case .end:
            globalLocationManager.stopUpdatingLocation()
            globalLocationManager.delegate = nil
            isLocation = false
            
            startTime = nil
            totalTime = 0
        }
    }
    
    //发送距离
    func satanManagerDistanceByLocation(withBleDistance distance: UInt32) -> UInt32 {
        let delta = deltaDistance
        deltaDistance = 0
        return distance + delta
    }
    
    //交换数据 间隔2s
    func satanManager(didSwitchingReplyCalories calories: UInt32, distance: UInt32, step: UInt32, curHeartrate: UInt8, heartrateSerial: UInt8, available: Bool, heartrateValue: [UInt8]) {
        
    }
}

//MARK:- location delegate
extension RootTBC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isLocation {
            //获取最后记录点
            guard let location = locations.last else {
                print("location get last error!")
                return
            }
            let coordinate = location.coordinate
            
            //精度
            debugPrint("水平精度", location.horizontalAccuracy)
            debugPrint("垂直精度", location.verticalAccuracy)
            guard location.horizontalAccuracy <= 65 && location.horizontalAccuracy > 0, location.verticalAccuracy <= 25 && location.verticalAccuracy > 0 else {
                //无信号
                return
            }
            
            //展示信号强度
//            if fabs(location.horizontalAccuracy) <= 5 {
//                delegate?.map(gps: .high)
//            }else if fabs(location.horizontalAccuracy) <= 15{
//                delegate?.map(gps: .middle)
//            }else{
//                delegate?.map(gps: .low)
//            }
            
            //计算距离
            if let preCoor = preCoordinate{
                deltaDistance += UInt32(calculateDistance(start: preCoor, end: coordinate))
            }else{
                preCoordinate = coordinate
            }
            
        }
    }
}
