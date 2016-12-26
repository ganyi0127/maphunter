//
//  DetailBack.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
let edgeWidth = view_size.width * 0.025 //边宽
class DetailBack: UIView {
    private var type: DataCubeType!         //类型
    
    private var detailTop: DetailTop?       //top view
    
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
