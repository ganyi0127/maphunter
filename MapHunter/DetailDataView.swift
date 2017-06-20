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
    case heartrate
    case deepSleep
    case lightSleep
    case sleepTime
    case sleepState
    case quiteSleep
    case wakeTime
    case wakeCount
    
    //心肺功能
    case averageBloodPressure
    case maxBloodPressure
    case averageHeartrate
    case restHeartrate
    case maxHeartrate
    
    //身心状态
    case resetStateDuration
    case highStateDuration
    case middleStateDuration
    case lowStateDuration
}
class DetailDataView: UIView {
    
    private var type: DetailDataViewType!
    
    private var secondLabel: UILabel?
    var value: CGFloat?{
        didSet{
            //展示数据
            var text: String
            var unit: String
            switch type as DetailDataViewType {
            case .totalTime, .activityTime, .restTime, .deepSleep, .lightSleep, .sleepTime, .quiteSleep, .wakeTime, .resetStateDuration, .highStateDuration, .middleStateDuration, .lowStateDuration:
                unit = "分钟"
                
                let hour = Int16(value!) / 3600
                let minute = (Int16(value!) - hour * 3600) / 60
                let second = Int16(value!) % 60
                
                let minuteStr = minute < 10 && hour > 0 ? "0\(minute)" : "\(minute)"
                let secondStr = "\(second)"
                if hour > 0 {
                    text = "\(hour)小时" + minuteStr + "分钟"
                }else if minute > 0{
                    text = minuteStr + "分钟" + secondStr + "秒"
                }else{
                    text = secondStr + "秒"
                }

                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontBig])
                let unitLength = unit.characters.count
                if hour > 0{
                    mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
                    mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength * 2 - minuteStr.characters.count, unitLength))
                }else if minute > 0{
                    mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 1, 1))
                    mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength - 1 - secondStr.characters.count, unitLength))
                }else{
                    mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 1, 1))
                }
                secondLabel?.attributedText = mainAttributedString
                return
            case .wakeCount:
                unit = "次"
            case .heartrate, .averageHeartrate, .restHeartrate, .maxHeartrate:
                unit = "次／分钟"
            case .sleepState:
                unit = ""
            case .averageBloodPressure, .maxBloodPressure:
                unit = "mmHg"
            default:
                unit = "大卡"
            }
            
            text = "\(Int16(value!))" + unit
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontBig])
            let unitLength = unit.characters.count
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            secondLabel?.attributedText = mainAttributedString            
        }
    }
    
    //点击事件
    var tap: UITapGestureRecognizer?
    var closure: (()->())?
    
    //MARK:- init
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
    
    deinit {
        removeGestureRecognizer(tap!)
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
        
        //初始化点击事件
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recongnizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
    
    @objc func click(recongnizer: UITapGestureRecognizer){
        closure?()
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
        case .heartrate:
            firstLabelStr = "静息心率"
            iconName = "resource/dataicon/heartrate"
        case .deepSleep:
            firstLabelStr = "深度睡眠"
            iconName = "resource/dataicon/deepsleep"
        case .lightSleep:
            firstLabelStr = "轻度睡眠"
            iconName = "resource/dataicon/lightsleep"
        case .sleepTime:
            firstLabelStr = "入睡"
            iconName = "resource/dataicon/sleeptime"
        case .sleepState:
            firstLabelStr = "睡眠质量"
            iconName = "resource/dataicon/sleepstate"
        case .quiteSleep:
            firstLabelStr = "快速动眼睡眠"
            iconName = "resource/dataicon/quitesleep"
        case .wakeTime:
            firstLabelStr = "清醒时间"
            iconName = "resource/dataicon/waketime"
        case .wakeCount:
            firstLabelStr = "醒来次数"
            iconName = "resource/dataicon/wakecount"
        case .averageBloodPressure:
            firstLabelStr = "平均血压"
            iconName = "resource/dataicon/averagebloodpressure"
        case .maxBloodPressure:
            firstLabelStr = "最大血压"
            iconName = "resource/dataicon/maxbloodpressure"
        case .averageHeartrate:
            firstLabelStr = "平均心率"
            iconName = "resource/dataicon/averageheartrate"
        case .restHeartrate:
            firstLabelStr = "静息心率"
            iconName = "resource/dataicon/restheartrate"
        case .maxHeartrate:
            firstLabelStr = "最大心率"
            iconName = "resource/dataicon/maxheartrate"
        case .resetStateDuration:
            firstLabelStr = "休息"
            iconName = "resource/dataicon/resetstate"
        case .highStateDuration:
            firstLabelStr = "高"
            iconName = "resource/dataicon/highstate"
        case .middleStateDuration:
            firstLabelStr = "中"
            iconName = "resource/dataicon/middlestate"
        case .lowStateDuration:
            firstLabelStr = "低"
            iconName = "resource/dataicon/lowstate"
        default:
            break
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
