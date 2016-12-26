//
//  DetailDataView.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
enum DetailDataViewType{
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
}
class DetailDataView: UIView {
    
    private var type: DetailDataViewType!
    
    private var secondLabel: UILabel?
    var value: CGFloat?{
        didSet{
            //展示数据
            var text: String
            switch type as DetailDataViewType {
            case .totalTime, .activityTime, .restTime:
                text = "\(value!)分钟"
            default:
                text = "\(value!)大卡"
            }
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontBig])
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))
            secondLabel?.attributedText = mainAttributedString            
        }
    }
    
    init(detailDataViewType: DetailDataViewType){
        let frame = CGRect(x: 0,
                           y: 0,
                           width: view_size.width / 2 - edgeWidth,
                           height: view_size.width * 0.2)
        super.init(frame: frame)
        
        type = detailDataViewType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .clear
        
        let separator = UIView(frame: CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1))
        separator.backgroundColor = subWordColor
        separator.alpha = 0.1
        addSubview(separator)
        
        let leftSeparator = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: bounds.height))
        leftSeparator.backgroundColor = subWordColor
        leftSeparator.alpha = 0.05
        addSubview(leftSeparator)
        
        let rightSeparator = UIView(frame: CGRect(x: bounds.width, y: 0, width: 1, height: bounds.height))
        rightSeparator.backgroundColor = subWordColor
        rightSeparator.alpha = 0.05
        addSubview(rightSeparator)
    }
    
    private func createContents(){
        
        var firstLabelStr: String
        var iconName: String
        switch type as DetailDataViewType {
        case .totalTime:
            firstLabelStr = "活动时间"
            iconName = "resource/dataicon/totaltime"
        case .activityTime:
            firstLabelStr = "最长活动时间"
            iconName = "resource/dataicon/activitytime"
        case .restTime:
            firstLabelStr = "最长空闲时间"
            iconName = "resource/dataicon/resttime"
        case .totalCalorie:
            firstLabelStr = "燃烧总量"
            iconName = "resource/dataicon/totalcalorie"
        case .activityCalorie:
            firstLabelStr = "活动消耗量"
            iconName = "resource/dataicon/activitycalorie"
        case .restCalorie:
            firstLabelStr = "休息消耗量"
            iconName = "resource/dataicon/restcalorie"
        case .deepSleep:
            firstLabelStr = "深度睡眠"
            iconName = "resource/dataicon/deepsleep"
        case .lightSleep:
            firstLabelStr = "轻度睡眠"
            iconName = "resource/dataicon/lightsleep"
        case .sleepTime:
            firstLabelStr = "入睡"
            iconName = "resource/dataicon/sleeptime"
        case .quiteSleep:
            firstLabelStr = "快速动眼睡眠"
            iconName = "resource/dataicon/quitesleep"
        case .wakeTime:
            firstLabelStr = "清醒时间"
            iconName = "resource/dataicon/waketime"
        case .wakeCount:
            firstLabelStr = "醒来次数"
            iconName = "resource/dataicon/wakecount"
        case .weightStartTime:
            firstLabelStr = "减重起始时间"
            iconName = "resource/dataicon/weightstarttime"
        case .weightDelta:
            firstLabelStr = "目标距离差距"
            iconName = "resource/dataicon/weightdelta"
        }
        
        //image icon
        let radius = bounds.height * 0.5
        let iconImageView = UIImageView(frame: CGRect(x: (bounds.height - radius) / 2,
                                                      y: (bounds.height - radius) / 2,
                                                      width: radius,
                                                      height: radius))
        iconImageView.image = UIImage(named: iconName)
        addSubview(iconImageView)
        
        //first label
        let firstLabel = UILabel(frame: CGRect(x: bounds.height,
                                               y: bounds.height / 2 - 14,
                                               width: bounds.width - radius - iconImageView.frame.origin.x * 2,
                                               height: 12))
        firstLabel.font = UIFont(name: font_name, size: 12)
        firstLabel.textColor = subWordColor
        firstLabel.text = firstLabelStr
        addSubview(firstLabel)
        
        //second label
        secondLabel = UILabel(frame: CGRect(x: bounds.height,
                                            y: bounds.height / 2 - 2,
                                            width: bounds.width - radius - iconImageView.frame.origin.x * 2,
                                            height: 20))
        secondLabel?.textColor = wordColor
        addSubview(secondLabel!)
    }
}
