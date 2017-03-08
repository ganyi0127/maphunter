//
//  DetailBack.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
import CoreData
let edgeWidth = view_size.width * 0.025 //边宽
class DetailBack: UIView {
    fileprivate var type: DataCubeType!         //类型
    
    var detailTop: DetailTop?       //top view
    var closure: (()->())?          //统一回调
    
    private var dataViewTypeMap = [DetailDataViewType: DetailDataView]()
    private var dataViewTypeList = [DetailDataViewType](){
        didSet{
            dataViewTypeList.enumerated().forEach(){
                index, dataViewType in
                
                //移除已有数据
                if let view = dataViewTypeMap[dataViewType] {
                    view.removeFromSuperview()
                    dataViewTypeMap[dataViewType] = nil
                }
                
                //添加数据view
                let detailDataView = DetailDataView(detailDataViewType: dataViewType)
                detailDataView.frame.origin = CGPoint(x: CGFloat(index % 2) * self.frame.width / 2,
                                                      y: detailTop!.frame.height + CGFloat(index / 2) * detailDataView.frame.height)
                //获取数据
                //运动
//                case totalTime
//                case activityTime
//                case restTime
//                case totalCalorie
//                case activityCalorie
//                case restCalorie
//                
//                //睡眠
//                case deepSleep
//                case lightSleep
//                case sleepTime
//                case quiteSleep
//                case wakeTime
//                case wakeCount
//                
//                //体重
//                case weightStartTime
//                case weightDelta
                let coredataHandler = CoreDataHandler.share()
                if let macaddress = AngelManager.share()?.macAddress{
                    let userId = UserManager.share().userId
                    let sportdataList = coredataHandler.selectSportData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
                    if let sportdata = sportdataList.first{
                        switch dataViewType {
                        case .activityCalorie:
                            detailDataView.value = CGFloat(sportdata.totalCal)
                        case .activityTime:
                            detailDataView.value = CGFloat(sportdata.totalActiveTime)
                        case .restTime:
                            detailDataView.value = 123
                        default:
                            detailDataView.value = 0
                        }
                    }
                }
                detailDataView.closure = {
                    self.closure?()
                }
                dataViewTypeMap[dataViewType] = detailDataView
                addSubview(detailDataView)
            }
        }
    }
    
    
    //MARK:- init
    init(detailType: DataCubeType){
        let frame = CGRect(x: edgeWidth,
                           y: view_size.width / 2,
                           width: view_size.width - edgeWidth * 2,
                           height: view_size.height * 2)
        super.init(frame: frame)
        
        type = detailType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        gradient.cornerRadius = 10
        layer.addSublayer(gradient)
        
        //添加top
        detailTop = DetailTop(detailType: type)
        detailTop?.delegate = self
        addSubview(detailTop!)
    }
    
    private func createContents(){
        
        //数据展示
        switch type as DataCubeType {
        case .sport:
            dataViewTypeList = [.totalTime, .totalCalorie, .activityTime, .activityCalorie, .restTime, .restCalorie]
        case .heartrate:
            dataViewTypeList = []
        case .sleep:
            dataViewTypeList = [.deepSleep, .quiteSleep, .lightSleep, .wakeTime, .sleepTime, .wakeCount]
        case .weight:
            dataViewTypeList = [.weightStartTime, .weightDelta]
        }
        
        //趋势
        
    }
}

//MARK:- 数据代理
extension DetailBack: DetailTopDelegate{
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
        case .weight:
            //体重数据
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
        case .weight:
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
