//
//  DetaiSV.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/1.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit

let edgeWidth: CGFloat = 8 //边宽
let detailTopHeight: CGFloat = view_size.width / 2
let detailCenterHeight: CGFloat = 88
let detailRadius: CGFloat = 10

//模块数据代理
protocol DetailDelegate {
    func detailTopData(closure: @escaping ([CGFloat])->())
    func detailHeartrateOffset(closure: @escaping ([CGFloat])->())
    func detailSleepBeginTime() -> Date
    func detailWeightDates() -> [Date]
    
    //添加总览数据
    func detailTotalValue() -> CGFloat
    func detailLeftValue() -> CGFloat
    func detailRightValue() -> CGFloat
}

class DetailSV: UIScrollView {
    fileprivate var type: DataCubeType!
    
    var detailBottom: DetailBottom!
    var detailCenter: DetailCenter!
    var detailTop: DetailTopBase!
    
    init(detailType: DataCubeType, date: Date) {
        let frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        super.init(frame: frame)
        
        type = detailType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        self.showsVerticalScrollIndicator = true
        
        delegate = self
    }
    
    private func createContents(){
        
        //添加底部面板
        detailBottom = DetailBottom(detailType: type)
        detailBottom.delegate = self
        addSubview(detailBottom)
        contentSize = CGSize(width: view_size.width, height: detailBottom.frame.origin.y + detailBottom.frame.height)
        
        //添加顶部面板
        if type == .sport{
            detailTop = SportDetailTop()
        }else if type == .sleep{
            detailTop = SleepDetailTop()
        }else if type == .heartrate{
            detailTop = HeartrateDetailTop()
        }else{
            detailTop = MindbodyDetailTop()
        }
        detailTop.delegate = self
        addSubview(detailTop)
        
        //添加中部面板
        detailCenter = DetailCenter(detailType: type)
        detailCenter.delegate = self
        addSubview(detailCenter)
    }
}

//MARK:- 触摸事件
extension DetailSV{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        detailTop.currentTouchesBegan(touches)
        isScrollEnabled = false
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        detailTop.currentTouchesMoved(touches)
        isScrollEnabled = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        detailTop.currentTouchesEnded(touches)
        isScrollEnabled = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isScrollEnabled = true
    }
}

//MARK:- scroll delegate
extension DetailSV: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < (detailBottom.frame.origin.y - 64) / 2 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -66), animated: true)
        }else if offsetY < detailBottom.frame.origin.y - 64 {
            scrollView.setContentOffset(CGPoint(x: 0, y: detailBottom.frame.origin.y - 66), animated: true)
        }
    }
}

//MARK:- 数据代理
extension DetailSV: DetailDelegate{
    func detailTopData(closure: @escaping ([CGFloat])->()) {
        switch type as DataCubeType  {
        case .sport:
            //运动数据
            var result = [CGFloat]()
            
            let angelManager = AngelManager.share()
            angelManager?.getSportData(nil, date: selectDate, offset: 0){
                sportDataList in
                guard let sportData = sportDataList.last else{
                    return
                }
                
                let sportItems = sportData.sportItem
                debugPrint("sportItems count:", sportItems?.count ?? 0)
                var sportList = [SportItem]()
                sportItems?.forEach{
                    item in
                    sportList.append(item as! SportItem)
                }
                sportList = sportList.sorted{$0.id < $1.id}
                result = sportList.map{CGFloat($0.sportCount)}
                print(sportData.totalStep, "total")
                debugPrint("sport result list:", result)
                
                DispatchQueue.main.async {
                    closure(result)
                }
            }
            
        case .heartrate:
            //心率数据
            var result = [CGFloat]()
            let angelManager = AngelManager.share()
            DispatchQueue.global().async {
                angelManager?.getHeartRateData(nil, date: selectDate, offset: 0){
                    heartRateDataList in
                    guard let heartRateData = heartRateDataList.last else{
                        return
                    }
                    
                    let heartRateItems = heartRateData.heartRateItem
                    var heartRateList = [HeartRateItem]()
                    heartRateItems?.forEach{
                        item in
                        heartRateList.append(item as! HeartRateItem)
                    }
                    heartRateList = heartRateList.sorted{$0.id < $1.id}
                    result = heartRateList.map{CGFloat($0.data)}
                    debugPrint("heartrate result list:", result)
                    
                    DispatchQueue.main.async {
                        closure(result)
                    }
                }
            }
        case .sleep:
            //睡眠数据
            var result = [CGFloat]()
            let angelManager = AngelManager.share()
            angelManager?.getSleepData{
                sleepDataList in
                guard let sleepData = sleepDataList.last else{
                    closure(result)
                    return
                }
                
                let sleepItems = sleepData.sleepItem
                var sleepItemList = [SleepItem]()
                sleepItems?.forEach{
                    item in
                    sleepItemList.append(item as! SleepItem)
                }
                sleepItemList = sleepItemList.sorted{$0.id < $1.id}
                result = sleepItemList.map{CGFloat($0.sleepStatus) * CGFloat(sleepTypeBit) + CGFloat($0.durations)}
                debugPrint("sleep result list:", result)
                
                DispatchQueue.main.async {
                    closure(result)
                }
            }
        case .mindBody:
            //身心状态数据
            var result = [CGFloat]()
            (0..<7).forEach(){
                i in
                let data = CGFloat(arc4random_uniform(40)) + 50
                result.append(data)
            }
            closure(result)
        }
    }
    
    func detailHeartrateOffset(closure: @escaping ([CGFloat]) -> ()) {
        //心率数据
        var result = [CGFloat]()
        let angelManager = AngelManager.share()
        angelManager?.getHeartRateData(nil, date: selectDate, offset: 0){
            heartRateDataList in
            guard let heartRateData = heartRateDataList.last else{
                return
            }
            
            let heartRateItems = heartRateData.heartRateItem
            var heartRateList = [HeartRateItem]()
            heartRateItems?.forEach{
                item in
                heartRateList.append(item as! HeartRateItem)
            }
            heartRateList = heartRateList.sorted{$0.id < $1.id}
            result = heartRateList.map{CGFloat($0.offset)}
            debugPrint("heartrate offset list:", result)
            DispatchQueue.main.async {
                closure(result)
            }
        }
    }
    
    //获取睡眠开始时间
    func detailSleepBeginTime() -> Date {
        
        let angelManager = AngelManager.share()
        guard let macaddress = angelManager?.macAddress else {
            return Date()
        }
        let coredataHandle = CoreDataHandler.share()
        let userId = UserManager.share().userId
        let sleepDataList = coredataHandle.selectSleepData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
        if let sleepData = sleepDataList.first{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.hour, .minute], from: selectDate)
            components.hour = Int(sleepData.startTimeHour)
            components.minute = Int(sleepData.startTimeMinute)
            if let date = calendar.date(from: components){
                return date
            }
        }
        return Date()
    }
    
    //获取日期数组
    func detailWeightDates() -> [Date] {
        var result = [Date]()
        var date: Date = Date()
        result.append(date)
        (0..<6).forEach(){
            i in
            let random = Double(arc4random_uniform(5)) + 1
            let newDate = Date(timeInterval: -60 * 60 * 24 * random, since: date)
            date = newDate
            result.append(newDate)
        }
        return result.reversed()
    }
    
    //总览数据
    func detailTotalValue() -> CGFloat {
        let angelManager = AngelManager.share()
        guard let macaddress = angelManager?.macAddress else {
            return 0
        }
        let coredataHandle = CoreDataHandler.share()
        let userId = UserManager.share().userId
        switch type as DataCubeType {
        case .sport:
            let sportDataList = coredataHandle.selectSportData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
            if let sportData = sportDataList.first{
                return CGFloat(sportData.totalStep)
            }
        case .heartrate:
            let heartrateDataList = coredataHandle.selectHeartRateData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
            if let heartrateData = heartrateDataList.first{
                return CGFloat(heartrateData.silentHeartRate)
            }
        case .sleep:
            let sleepDataList = coredataHandle.selectSleepData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
            if let sleepData = sleepDataList.first{
                return CGFloat(sleepData.deepSleepMinute)
            }
        case .mindBody:
            return 0
        }
        return 0
    }
    
    func detailLeftValue() -> CGFloat {
        let angelManager = AngelManager.share()
        guard let macaddress = angelManager?.macAddress else {
            return 0
        }
        let coredataHandle = CoreDataHandler.share()
        let userId = UserManager.share().userId
        switch type as DataCubeType {
        case .sport:
            let sportDataList = coredataHandle.selectSportData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
            if let sportData = sportDataList.first{
                return CGFloat(sportData.totalStep)
            }
        case .sleep:
            let sleepDataList = coredataHandle.selectSleepData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
            if let sleepData = sleepDataList.first{
                return CGFloat(sleepData.deepSleepMinute)
            }
        default:
            return 0
        }
        return 0
    }
    
    func detailRightValue() -> CGFloat {
        let angelManager = AngelManager.share()
        guard let macaddress = angelManager?.macAddress else {
            return 0
        }
        let coredataHandle = CoreDataHandler.share()
        let userId = UserManager.share().userId
        switch type as DataCubeType {
        case .sport:
            let sportDataList = coredataHandle.selectSportData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
            if let sportData = sportDataList.first{
                return CGFloat(sportData.totalDistance)
            }
        default:
            return 0
        }
        return 0
    }
}
