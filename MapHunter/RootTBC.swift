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
import CoreLocation
import CoreBluetooth
import HealthKit
class RootTBC: UITabBarController {
    
    //子按钮
    private lazy var subButtonList: [MainSubMenuButton]? = {
        var list = [MainSubMenuButton]()
        let buttonImageSize = CGSize(width: 48, height: 48)
        (0..<6).forEach{
            i in
            let subButton: MainSubMenuButton = MainSubMenuButton(index: i)
            subButton.addTarget(self, action: #selector(self.clickSubMenuButton(sender:)), for: .touchUpInside)
            list.append(subButton)
            self.view.addSubview(subButton)
        }
       return list
    }()
    
    //展开按钮
    var menuButtonFlag: Bool = false{
        didSet{
            let key = "rotation"
            
            menuButton.isSelected = menuButtonFlag
            if menuButtonFlag{
                
                //移除之前动画
                menuButton.layer.removeAnimation(forKey: key)
                
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = 0
                animation.toValue = Double.pi / 4 + .pi
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                menuButton.layer.add(animation, forKey: key)
                
                
                //添加高斯模糊
                effectView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.effectView.alpha = 1
                }, completion: nil)
                self.selectedViewController?.view.addSubview(effectView)
                effectView.addGestureRecognizer(tap)
                
                //显示子按钮
                self.subButtonList?.forEach{
                    button in
                    button.setHidden(flag: false)
                }
                
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
                    _ in
                    if self.menuButtonFlag{
                        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                            let buttonOffsetY: CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : -tabbarFrame.height * 2
                            self.menuButton.frame = buttonFrame.offsetBy(dx: 0, dy: buttonOffsetY)
                        }, completion: nil)
                    }
                }
                
            }else{
                
                //移除之前动画
                menuButton.layer.removeAnimation(forKey: key)
                
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = Double.pi / 4 + .pi
                animation.toValue = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                menuButton.layer.add(animation, forKey: key)
                
                //隐藏子按钮
                self.subButtonList?.forEach{
                    button in
                    button.setHidden(flag: true)
                }
                
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
        let height: CGFloat = 49 * 0.75 //self.tabBar.backgroundImage!.size.height / 2
        let itemSize = CGSize(width: height, height: height)
        let image = UIImage(named: "resource/tabbar/main")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        menuButton.setImage(image, for: .normal)
        if let selectedImage = UIImage(named: "resource/tabbar/main_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal){
            menuButton.setImage(selectedImage, for: .selected)
        }
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
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
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
    
    //MARK:- init************************************************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置item大小
        let height: CGFloat = 49 / 2 //tabBar.backgroundImage!.size.height / 2
        let itemSize = CGSize(width: height, height: height)
        
        //载入趣玩(覆盖之前的趣玩)
        let playVC = UIStoryboard(name: "Map", bundle: Bundle.main).instantiateViewController(withIdentifier: "map")
        viewControllers?[1] = playVC
        tabBar.items?[1].image = UIImage(named: "resource/tabbar/map")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[1].selectedImage = UIImage(named: "resource/tabbar/map_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        
        //发现
        let discoverVC = UIStoryboard(name: "Discover", bundle: Bundle.main).instantiateViewController(withIdentifier: "discover")
        viewControllers?[3] = discoverVC
        tabBar.items?[3].image = UIImage(named: "resource/tabbar/health")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].selectedImage = UIImage(named: "resource/tabbar/health_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        
        //我的
        let meVC = UIStoryboard(name: "Me", bundle: Bundle.main).instantiateViewController(withIdentifier: "me")
        viewControllers?[4] = meVC
        tabBar.items?[4].image = UIImage(named: "resource/tabbar/me")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[4].selectedImage = UIImage(named: "resource/tabbar/me_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
    }
    
    private func config(){
        
        let godManager = GodManager.share()
        godManager.isAutoReconnect = true
        _ = AngelManager.share()
        
        //修改默认界面
        selectedIndex = 0
        
        //初始化sdk
        let satanManager = SatanManager.share()
        satanManager?.delegate = self
        
        //获取手环状态
        NotificationCenter.default.addObserver(self, selector: #selector(binded), name: connected_notiy, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disConnected), name: disconnected_notiy, object: nil)
    }
    
    @objc private func binded(){
//        linkBarButton.setState(withLinkButtonState: .connecting)
        if let imageView = bandItem?.customView as? UIImageView{
            imageView.image = globalBandImageMap[.binded]!
            _ = delay(4){
                imageView.image = globalBandImageMap[.normal]!
            }
        }
    }
    
    @objc private func disConnected(){
//        linkBarButton.setState(withLinkButtonState: .disconnected)
        if let imageView = bandItem?.customView as? UIImageView{
            imageView.image = globalBandImageMap[.disConnected]!
        }
    }
    
    private func createContents(){
        
        //添加主按钮
        tabBar.addSubview(menuButton)
        menuButtonFlag = false
        
        //设置自动重连，当引导页出现时，已连接手环，无需再次连接
//        if !PeripheralManager.share().selectUUIDStringList().isEmpty{
//            GodManager.share().startScan()
//        }
    }

    //MARK:- 切换状态时 取消menubutton选中
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        menuButtonFlag = false
        
    }
    
    //MARK:- 点击sub menu按钮 ["运动", "睡眠", "体重", "心情", "血压", "心率"]
    @objc private func clickSubMenuButton(sender: MainSubMenuButton){
        let tag = sender.tag
        debugPrint("<main menu> sub button tag: \(tag)")
        
        //关闭子按钮
        clickMenuButton(sender: menuButton)
        
        //初始化手动设置页面
        var manualRecordVC: UIViewController?
        switch tag {
        case 0:
            manualRecordVC = RecordSportVC()
        case 1:
            manualRecordVC = RecordSleepVC()
        case 2:
            manualRecordVC = RecordWeightVC()
        case 3:
            manualRecordVC = RecordMoodVC()
        case 4:
            manualRecordVC = RecordBloodPressureVC()
        case 5:
            manualRecordVC = RecordHeartrateVC()
        default:
            break
        }
        
        //推出页面
        if let vc = manualRecordVC{
            present(vc, animated: true, completion: nil)
        }else{
            debugPrint("<Menu Button> 创建手动记录类型错误")
        }
    }
    
    //MARK:- 点击展开按钮
    @objc private func clickMenuButton(sender: UIButton){
        menuButtonFlag = !menuButtonFlag
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
