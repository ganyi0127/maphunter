//
//  FirstCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
import CoreBluetooth
let dataCubeSpacing: CGFloat = 6            //模块间距
let dataCubeAspectRatio: CGFloat = 1.35     //模块宽高比
class FirstCell: UITableViewCell {
    
    //运动
    fileprivate var sportDataCube: DataCube = {
        let sportDataCube = DataCube(dataCubeType: .sport)
        return sportDataCube
    }()
    var goalStep: UInt32 = 10000
    
    //心率
    fileprivate var heartRateDataCube: DataCube = {
        let heartRateDataCube = DataCube(dataCubeType: .heartrate)
        return heartRateDataCube
    }()
    
    //睡眠
    fileprivate var sleepDataCube: DataCube = {
        let sleepDataCube = DataCube(dataCubeType: .sleep)
        return sleepDataCube
    }()
    var goalSleep: UInt32 = 60 * 7
    
    //体重
    var weightDataCube: DataCube = {
        let weightDataCube = DataCube(dataCubeType: .weight)
        return weightDataCube
    }()
    
    //MARK:- 定时器
    private var task: Task?
    fileprivate var timer: DispatchSourceTimer?
    private var stepTime: DispatchTimeInterval = .seconds(2)
    
    //MARK:- 点击回调
    var closure: ((DataCubeType)->())?
    
    //MARK:- init
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    
    deinit {
        //移除定时器
        if let t = timer{
            t.cancel()
            timer = nil
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("draw")
        
        sportDataCube.frame.origin = CGPoint(x: dataCubeSpacing, y: dataCubeSpacing)
        heartRateDataCube.frame.origin = CGPoint(x: dataCubeSpacing, y: dataCubeSpacing + sportDataCube.frame.height + dataCubeSpacing)
        sleepDataCube.frame.origin = CGPoint(x: frame.width / 2 + dataCubeSpacing / 2, y: dataCubeSpacing)
        weightDataCube.frame.origin = CGPoint(x: frame.width / 2 + dataCubeSpacing / 2, y: dataCubeSpacing + heartRateDataCube.frame.height + dataCubeSpacing)
        
        startTimer()
        //开始计时
//        self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: .main)
//        self.timer?.scheduleRepeating(deadline: .now() + stepTime, interval: stepTime)
//        self.timer?.setEventHandler{self.startTimer()}
//        self.timer?.resume()        //启动定时器
    }
    
    private func config(){
        
        backgroundColor = UIColor.clear
        
        var rotation = CATransform3DIdentity
        rotation.m34 = -1 / 500
        rotation = CATransform3DRotate(rotation, .pi / 2 / 4, 0, 0, 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.transform = rotation
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        leftSwipe.direction = .left
        contentView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        rightSwipe.direction = .right
        contentView.addGestureRecognizer(rightSwipe)
    }
    
    private func createContents(){
        
        //添加主页气泡 running walking riding

        var data = DataCubeData()
        
        sportDataCube.data = data
        addSubview(sportDataCube)
        
        heartRateDataCube.data = data
        addSubview(heartRateDataCube)
        
        //获取睡眠数据
        sleepDataCube.data = data
        data.value1 = 123
        data.value2 = CGFloat(goalSleep)
        sleepDataCube.data = data
        addSubview(sleepDataCube)
        
        //获取体重数据
        if let user = CoreDataHandler.share().selectUser(userId: UserManager.share().userId){
            data.value1 = CGFloat(user.currentWeight)
            data.value2 = CGFloat(user.goalWeight)
        }
        weightDataCube.data = data
        addSubview(weightDataCube)
        
        //添加回调
        sportDataCube.closure = clickedCube
        heartRateDataCube.closure = clickedCube
        sleepDataCube.closure = clickedCube
        weightDataCube.closure = clickedCube
        
        
    }
    
    //MARK:- 定时器
    func startTimer(){
        cancel(task)
        task = delay(2){

            if let vc = self.viewController(){                
                if vc.isKind(of: StateVC.self){
                    if !(vc as! StateVC).initFresh && vc.view.window != nil && vc.isViewLoaded {
                        self.getLivedata()
                    }
                    self.startTimer()
                }
            }
        }
    }
    
    //MARK:- 获取实时数据
    private func getLivedata(){
        //判断是否有绑定设备
        let peripheral = PeripheralManager.share().currentPeripheral
        guard peripheral != nil else {
            startTimer()
            return
        }
        
        guard peripheral?.state == CBPeripheralState.connected  else {
            startTimer()
            return
        }
        let angelManager = AngelManager.share()
        
        //心率相关api 条件:1已连接手环 2.已同步
        angelManager?.getHeartRateData{
            heartrateDatas in
            guard let heartrateData = heartrateDatas.first else{
                return
            }
            var data = DataCubeData()
            data.value1 = CGFloat(heartrateData.silentHeartRate)
            data.value2 = CGFloat(heartrateData.burnFatMinutes)     //血压
            data.value3 = CGFloat(heartrateData.aerobicMinutes)
            data.value4 = CGFloat(heartrateData.limitMinutes)
            self.heartRateDataCube.data = data
        }
        
        //获取目标步数,目标睡眠
        let coredataHandler = CoreDataHandler.share()
        let userId = UserManager.share().userId
        if let user = coredataHandler.selectUser(userId: userId){
            goalStep = UInt32(user.goalStep)
        }
        
        //实时数据api
        angelManager?.getLiveDataFromBand{
            errorCode, value in
            guard errorCode == ErrorCode.success else{
                return
            }
            
            guard let livedata = value as? protocol_start_live_data else{
                return
            }
            
            DispatchQueue.main.async {
                debugPrint("livedata:", livedata)
                let step = livedata.step
                let calories = livedata.calories
                let distances = livedata.distances
                let activeTime = livedata.active_time
                let heartRate = livedata.heart_rate
                
                var data = DataCubeData()
                data.value1 = CGFloat(step)
                data.value2 = CGFloat(self.goalStep)
//                data.value3 = 40        //最后运动的时长
//                data.value4 = 2         //最后运动的类型
                self.sportDataCube.data = data
                
            }
        }
        
        //更新体重目标
//        if let user = CoreDataHandler.share().selectUser(userId: UserManager.share().userId){
//            var data = DataCubeData()
//            data.value1 = CGFloat(user.currentWeight)
//            data.value2 = CGFloat(user.goalWeight)
//            weightDataCube.data = data
//        }
        
        //循环调用
        //self.startTimer()
    }
    
    //MARK:- cube点击回调
    private func clickedCube(_ type: DataCubeType){
        
        closure?(type)
    }
    
    @objc private func swipe(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .left{
            switchWithDirectionTag(tag: 1)
        }else{
            switchWithDirectionTag(tag: 0)
        }
    }
    
    @objc private func clickButton(sender: UIButton){
        //0:left 1:right
        switchWithDirectionTag(tag: sender.tag)
    }
    
    fileprivate var curTag = 0
    //MARK:- 发送切换日期消息
    fileprivate func switchWithDirectionTag(tag: Int){
        
        //翻页动画效果
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        
        layer.transform = transform
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.y")
        anim.fromValue = 0
        //            anim.toValue = tag == 0 ? M_PI : -M_PI
        //            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let fadeAnim = CAKeyframeAnimation(keyPath: "opacity")
        fadeAnim.values = [1, 0, 0, 1]
        fadeAnim.keyTimes = [0, 0.5, 0.8, 1]
        fadeAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [1, 0.7, 0.7, 1, 1.1, 1]
        scaleAnim.keyTimes = [0, 0.5, 0.8, 0.9, 0.95, 1]
        scaleAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let moveAnim = CAKeyframeAnimation(keyPath: "position.x")
        moveAnim.values = [view_size.width / 2, tag == 0 ? view_size.width * 1.5 : -view_size.width / 2, view_size.width / 2, view_size.width / 2]
        moveAnim.keyTimes = [0, 0.5, 0.8, 1]
        moveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 1.0
        group.animations = [fadeAnim, scaleAnim, moveAnim]
        group.fillMode = kCAFillModeBoth
        group.delegate = self
        
        layer.add(group, forKey: "swith")
        
        //切换日期
        curTag = tag
        
    }
}

//MARK:- Animation delegate
extension FirstCell: CAAnimationDelegate{
    //完成动画后切换日期
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //发送切换日期消息
        notiy.post(name: switch_notiy, object: curTag, userInfo: nil)

//        runningDataCube.randomAction()
//        walkingDataCube.randomAction()
//        ridingDataCube.randomAction()
    }
}

extension FirstCell{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        let anim = CABasicAnimation(keyPath: "transform.scale.x")
//        anim.toValue = 0.8
//        anim.duration = 0.05
//        anim.fillMode = kCAFillModeBoth
//        anim.autoreverses = true
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        layer.add(anim, forKey: "began")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
