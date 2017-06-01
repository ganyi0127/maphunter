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
class DetailBottom: UIView {
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
    
    var delegate: DetailDelegate?
    var closure: (()->())?          //统一回调
    
    //MARK:- init
    init(detailType: DataCubeType){
        let frame = CGRect(x: edgeWidth,
                           y: detailTopHeight,
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
        gradient.cornerRadius = detailRadius
        layer.addSublayer(gradient)
        
        /*
        //添加top
        detailTop = DetailTop(detailType: type)
        detailTop?.delegate = self
        addSubview(detailTop!)
         */
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
        
        //趋势
        
    }
}


