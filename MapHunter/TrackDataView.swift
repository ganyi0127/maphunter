//
//  TrackDataView.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
enum TrackDataViewType{
    //运动
    case step               //步数
    case activityTime       //活动时长
    case stride             //步幅
    case level              //强度
    case totalCalorie    //燃烧总量
    
    //睡眠
    case deepSleep          //深度睡眠
    case lightSleep         //浅度睡眠
    case wakeTime           //清醒时间
    case sleepState         //睡眠状态
    
}
class TrackDataView: UIView {
    
    private var type: TrackDataViewType!
    
    private var secondLabel: UILabel?
    var value: CGFloat?{
        didSet{
            //展示数据
            var text: String
            var unit: String
            switch type as TrackDataViewType {
            case .activityTime, .deepSleep, .lightSleep, .wakeTime:
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
            case .step:
                unit = ""
            case .stride:
                unit = ""
            case .level:
                unit = ""
                let sportLevel = Int16(value!)
                secondLabel?.font = fontSmall
                if sportLevel == 1{
                    secondLabel?.text = "非常吃力"
                }else {
                    secondLabel?.text = "一般般"
                }
                return
            case .sleepState:
                unit = ""
            default:
                //燃烧量
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
    init(with trackDataViewType: TrackDataViewType){
        let frame = CGRect(x: 0,
                           y: 0,
                           width: view_size.width / 2 - edgeWidth,
                           height: view_size.width * 0.2)
        super.init(frame: frame)
        
        type = trackDataViewType
        
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
        switch type as TrackDataViewType {
        case .step:
            firstLabelStr = "步"
            iconName = "resource/dataicon/stride"
        case .activityTime:
            firstLabelStr = "最长活动时间"
            iconName = "resource/dataicon/activitytime"
        case .stride:
            firstLabelStr = "步幅"
            iconName = "resource/dataicon/stride"
        case .level:
            firstLabelStr = "活动强度"
            iconName = "resource/dataicon/sportlevel"
        case .totalCalorie:
            firstLabelStr = "燃烧总量"
            iconName = "resource/dataicon/totalcalorie"
        case .deepSleep:
            firstLabelStr = "深度睡眠"
            iconName = "resource/dataicon/deepsleep"
        case .lightSleep:
            firstLabelStr = "轻度睡眠"
            iconName = "resource/dataicon/lightsleep"
        case .wakeTime:
            firstLabelStr = "清醒时间"
            iconName = "resource/dataicon/waketime"
        case .sleepState:
            firstLabelStr = "睡眠质量"
            iconName = "resource/dataicon/sleepstate"
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
