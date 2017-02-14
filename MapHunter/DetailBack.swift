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
                detailDataView.value = 123
                detailDataView.closure = {
                    self.closure?()
                }
                dataViewTypeMap[dataViewType] = detailDataView
                addSubview(detailDataView)
            }
        }
    }
    
    
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
            angelManager?.getMacAddressFromBand{
                errorCode, macaddress in
                guard errorCode == ErrorCode.success else{
                    return
                }
                angelManager?.getSportData{
                    sportDataList in
                    guard let sportData = sportDataList.last else{
                        return
                    }
                    
                    let sportItems = sportData.sportItem
                    print("sportItems count:", sportItems?.count)
                    var sportList = [SportItem]()
                    sportItems?.forEach{
                        item in
                        sportList.append(item as! SportItem)
                    }
                    sportList = sportList.sorted{$0.id < $1.id}
                    result = sportList.map{CGFloat($0.sportCount)}
                    print(sportData.totalStep, "total")
                    print("result", result)
                    
                    DispatchQueue.main.async {
                        closure(result)
                    }
                }
            }
        case .heartrate:
            //心率数据
            var result = [CGFloat]()
            let angelManager = AngelManager.share()
            angelManager?.getMacAddressFromBand{
                errorCode, macaddress in
                guard errorCode == ErrorCode.success else{
                    return
                }
                angelManager?.getHeartRateData{
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
                    print("result", result)
                    
                    DispatchQueue.main.async {
                        closure(result)
                    }
                }
            }
        case .sleep:
            //睡眠数据
            var result = [CGFloat]()
            let count = Int(arc4random_uniform(20)) + 5
            (0..<count).forEach(){
                i in
                
                var data = CGFloat(arc4random_uniform(200)) + 10
                
                //添加类型 0深睡 1浅睡 2快速眼动 3清醒
                var sleepType = Int16(arc4random_uniform(4))
                if let last = result.last{
                    while sleepType == Int16(last) / sleepTypeBit{
                        sleepType = Int16(arc4random_uniform(4))
                    }
                }
                data += CGFloat(sleepType * sleepTypeBit)
                result.append(data)
            }
            closure(result)
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
    
    //获取睡眠开始时间
    func detailSleepBeginTime() -> Date {
        let yesterday = Date(timeIntervalSinceNow: -60 * 60 * 24)
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: yesterday)
        components.hour = 22
        components.minute = 30
        let date = calendar.date(from: components)
        return date!
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
}
