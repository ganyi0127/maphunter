//
//  TrackBottom.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
import CoreData
class TrackBottom: UIView {
    fileprivate var type: DataCubeType!         //类型
    
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
                                                      y: detailCenterHeight + CGFloat(index / 2) * detailDataView.frame.height)
                /*
                 //运动
                 case totalTime
                 case activityTime
                 case restTime
                 case totalCalorie
                 case activityCalorie
                 case restCalorie
                 
                 //睡眠
                 case deepSleep
                 case lightSleep
                 case sleepTime
                 case quiteSleep
                 case wakeTime
                 case wakeCount
                 
                 //体重
                 case weightStartTime
                 case weightDelta
                 */
                
                //获取数据
                let coredataHandler = CoreDataHandler.share()
                if let macaddress = AngelManager.share()?.macAddress{
                    let userId = UserManager.share().userId
                    if self.type == .sport {                   //运动
                        let sportdataList = coredataHandler.selectSportData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
                        if let sportdata = sportdataList.first{
                            switch dataViewType {
                            case .totalTime:
                                detailDataView.value = CGFloat(sportdata.totalActiveTime)
                            case .totalCalorie:
                                detailDataView.value = CGFloat(sportdata.totalCal)
                            case .activityTime:
                                detailDataView.value = CGFloat(sportdata.totalActiveTime)
                            case .activityCalorie:
                                detailDataView.value = CGFloat(sportdata.totalCal)
                            case .restTime:
                                detailDataView.value = 123
                            case .restCalorie:
                                detailDataView.value = 123
                            default:
                                detailDataView.value = 0
                            }
                        }
                    }else if self.type == .sleep{               //睡眠
                        let sleepDataList = coredataHandler.selectSleepData(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
                        if let sleepData = sleepDataList.first{
                            switch dataViewType {
                            case .heartrate:
                                detailDataView.value = 70
                            case .sleepState:
                                detailDataView.value = CGFloat(sleepData.faultingState)
                            case .deepSleep:
                                detailDataView.value = CGFloat(sleepData.deepSleepMinute * 60)
                            case .quiteSleep:
                                detailDataView.value = 0
                            case .lightSleep:
                                detailDataView.value = CGFloat(sleepData.lightSleepMinute * 60)
                            case .wakeTime:
                                detailDataView.value = CGFloat(sleepData.totalMinute - sleepData.lightSleepMinute - sleepData.deepSleepMinute) * 60
                            case .sleepTime:
                                detailDataView.value = CGFloat(sleepData.totalMinute * 60)
                            case .wakeCount:
                                detailDataView.value = CGFloat(sleepData.wakeCount)
                            default:
                                detailDataView.value = 0
                            }
                        }
                    }
                }
                
                //回调
                detailDataView.closure = {
                    self.closure?()
                }
                dataViewTypeMap[dataViewType] = detailDataView
                addSubview(detailDataView)
            }
        }
    }
    
    var delegate: DetailDelegate?
    var closure: (()->())?          //统一回调
    
    //MARK:- init
    init(detailType: DataCubeType){
        let frame = CGRect(x: edgeWidth,
                           y: detailTopHeight,
                           width: view_size.width - edgeWidth * 2,
                           height: view_size.height - detailTopHeight - edgeWidth)
        super.init(frame: frame)
        
        type = detailType
        
        //config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var gradient: CAGradientLayer?
    override func didMoveToSuperview() {
        
        //修改scrollview高度
        let detailSV = superview as! TrackSV
        detailSV.contentSize = CGSize(width: view_size.width, height: detailTopHeight)
        
        //重新修改view大小
        frame = CGRect(x: edgeWidth,
                       y: detailTopHeight,
                       width: view_size.width - edgeWidth * 2,
                       height: view_size.height - detailTopHeight - edgeWidth)
        
        detailSV.reloadInputViews()
        
        config()
    }
    
    private func config(){
        gradient?.removeFromSuperlayer()
        //绘制渐变
        gradient = CAGradientLayer()
        gradient?.frame = CGRect(x: 0, y: 0,
                                 width: view_size.width - edgeWidth * 2,
                                 height: view_size.height - detailTopHeight - edgeWidth)
        gradient?.locations = [0.2, 0.8]
        gradient?.startPoint = CGPoint(x: 1, y: 0)
        gradient?.endPoint = CGPoint(x: 1, y: 1)
        gradient?.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        gradient?.cornerRadius = detailRadius
        layer.insertSublayer(gradient!, at: 0)
        
    }

    private func createContents(){
        
        //数据展示
        switch type as DataCubeType {
        case .sport:
            dataViewTypeList = [.totalTime, .totalCalorie, .activityTime, .activityCalorie, .restTime, .restCalorie]
        case .heartrate:
            dataViewTypeList = []
        case .sleep:
            dataViewTypeList = [.heartrate, .sleepState, .deepSleep, .quiteSleep, .lightSleep, .wakeTime, .sleepTime, .wakeCount]
        case .mindBody:
            dataViewTypeList = [.weightStartTime, .weightDelta]
        }
    }
}
