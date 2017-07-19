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
    fileprivate var track: EachTrainningData!
    fileprivate var sportType: SportType!         //类型
    
    //详情数据视图
    private var dataViewTypeMap = [TrackDataViewType: TrackDataView]()
    private var dataViewTypeList = [TrackDataViewType](){
        didSet{
            dataViewTypeList.enumerated().forEach(){
                index, dataViewType in
                
                //移除已有数据
                if let view = dataViewTypeMap[dataViewType] {
                    view.removeFromSuperview()
                    dataViewTypeMap[dataViewType] = nil
                }
                
                //添加数据view
                let detailDataView = TrackDataView(with: dataViewType)
                detailDataView.frame.origin = CGPoint(x: CGFloat(index % 2) * self.frame.width / 2,
                                                      y: detailCenterHeight + CGFloat(index / 2) * detailDataView.frame.height)
                
                //获取数据
                if self.sportType == .sleep{               //睡眠
                    switch dataViewType {
                    case .deepSleep:
                        detailDataView.value = CGFloat(track.burnFatMinutes)
                    case .lightSleep:
                        detailDataView.value = CGFloat(track.limitMinutes)
                    case .wakeTime:
                        detailDataView.value = CGFloat(track.limitMinutes)
                    case .sleepState:
                        detailDataView.value = 1
                    default:
                        detailDataView.value = 0
                    }
                } else {
                    switch dataViewType {
                    case .step:
                        detailDataView.value = CGFloat(track.steps)
                    case .activityTime:
                        detailDataView.value = CGFloat(track.aerobicMinutes)
                    case .totalCalorie:
                        detailDataView.value = CGFloat(track.calories)
                    case .stride:
                        detailDataView.value = 123
                    case .level:
                        detailDataView.value = 1
                    default:
                        detailDataView.value = 123
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
    
    //图表视图
    private var chartViewTypeMap = [TrackChartViewType: TrackChartView]()
    private var chartViewTypeList = [TrackChartViewType](){
        didSet{
            var preViewHeight: CGFloat = 0
            chartViewTypeList.enumerated().forEach{
                index, chartViewType in
                
                //移除已有数据
                if let view = chartViewTypeMap[chartViewType]{
                    view.removeFromSuperview()
                    chartViewTypeMap[chartViewType] = nil
                }
                
                //添加数据view
                let detailChartView = TrackChartView(with: chartViewType)
                let y = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight + preViewHeight
                detailChartView.frame.origin = CGPoint(x: 0, y: y)
                
                
                //传数据
                detailChartView.track = track
                preViewHeight += detailChartView.bounds.height
                
                //回调
                
                
                
                chartViewTypeMap[chartViewType] = detailChartView
                addSubview(detailChartView)
            }
            
            let imageSize = CGSize(width: 22, height: 22)
            let finalY = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight + preViewHeight
            //添加底部隐私
            let privateFrame = CGRect(x: 0, y: finalY, width: 44, height: 44)
            let privateButton = UIButton(frame: privateFrame)
            let privateOn = UIImage(named: "resource/timedetail/private_on")?.transfromImage(size: imageSize)
            let privateOff = UIImage(named: "resource/timedetail/private_off")?.transfromImage(size: imageSize)
            privateButton.setImage(privateOff, for: .normal)
            privateButton.setImage(privateOn, for: .selected)
            privateButton.addTarget(self, action: #selector(setPrivate(sender:)), for: .touchUpInside)
            addSubview(privateButton)
            
            //添加底部分享
            let shareFrame = CGRect(x: frame.width - 44, y: finalY, width: 44, height: 44)
            let shareButton = UIButton(frame: shareFrame)
            let shareImage = UIImage(named: "resource/timedetail/share")?.transfromImage(size: imageSize)
            shareButton.setImage(shareImage, for: .normal)
            shareButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
            addSubview(shareButton)
            
            config()
        }
    }
    
    
    var delegate: DetailDelegate?
    var closure: (()->())?          //统一回调
    
    //是否公开
    private var isPrivate = false{
        didSet{
            
        }
    }
    
    //左标题
    private lazy var leftTitleLabel: UILabel = {
        let labelFrame = CGRect(x: 8, y: 20 + 8, width: (self.bounds.width - 8 * 2) / 3, height: 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .left
        label.font = fontSmall
        label.textColor = lightWordColor
        return label
    }()
    
    //中标题
    private lazy var centerTitleLabel: UILabel = {
        let labelFrame = CGRect(x: 8 + (self.bounds.width - 8 * 2) / 3, y: 20 + 8, width: (self.bounds.width - 8 * 2) / 3, height: 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.font = fontSmall
        label.textColor = lightWordColor
        return label
    }()
    
    //右标题
    private lazy var rightTitleLabel: UILabel = {
        let labelFrame = CGRect(x: 8 + (self.bounds.width - 8 * 2) / 3 * 2, y: 20 + 8, width: (self.bounds.width - 8 * 2) / 3, height: 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .right
        label.font = fontSmall
        label.textColor = lightWordColor
        return label
    }()
    
    
    private lazy var leftValueLabel: UILabel = {
        let labelFrame = CGRect(x: 8, y: 20 + 8 + 20, width: (self.bounds.width - 8 * 2) / 3, height: detailCenterHeight - 20 - 8 - 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .left
        return label
    }()
    private lazy var centerValueLabel: UILabel = {
        let labelFrame = CGRect(x: 8 + (self.bounds.width - 8 * 2) / 3, y: 20 + 8 + 20, width: (self.bounds.width - 8 * 2) / 3, height: detailCenterHeight - 20 - 8 - 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .center
        return label
    }()
    private lazy var rightValueLabel: UILabel = {
        let labelFrame = CGRect(x: 8 + (self.bounds.width - 8 * 2) / 3 * 2, y: 20 + 8 + 20, width: (self.bounds.width - 8 * 2) / 3, height: detailCenterHeight - 20 - 8 - 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .right
        return label
    }()
    //左数值
    private var leftValue: Int?{
        didSet{
            guard let value = leftValue else {
                leftTitleLabel.isHidden = true
                leftValueLabel.isHidden = true
                return
            }
            
            leftTitleLabel.isHidden = false
            leftValueLabel.isHidden = false
            
            switch sportType as SportType {
            case .sleep:
                let hour = value / 60
                let hourStr = "\(hour)"
                let hourUnit = "小时"
                let minute = value % 60
                let minuteStr = "\(minute)"
                let minuteUnit = "分钟"
                let text = hour > 0 ? hourStr + hourUnit + minuteStr + minuteUnit : minuteStr + minuteUnit
                
                let textColor = recordDarkColors[.sleep]!
                
                let mutableAttributes = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: textColor])
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - minuteUnit.characters.count, minuteUnit.characters.count))
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - minuteUnit.characters.count - minuteStr.characters.count - hourUnit.characters.count, hourUnit.characters.count))
                leftValueLabel.attributedText = mutableAttributes
                
                leftTitleLabel.text = "你睡了"
            case .walking, .hiking:
                let unitStr = "步"
                let text = "\(value)" + unitStr
                
                let textColor = recordDarkColors[.sport]!
                
                let mutableAttributes = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: textColor])
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - unitStr.characters.count, unitStr.characters.count))
                leftValueLabel.attributedText = mutableAttributes
                
                leftTitleLabel.text = "你走了"
            default:
                //sport
                let hour = value / 60
                let hourStr = "\(hour)"
                let hourUnit = "小时"
                let minute = value % 60
                let minuteStr = "\(minute)"
                let minuteUnit = "分钟"
                let text = hour > 0 ? hourStr + hourUnit + minuteStr + minuteUnit : minuteStr + minuteUnit
                
                let textColor = recordDarkColors[.sport]!
                
                let mutableAttributes = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: textColor])
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - minuteUnit.characters.count, minuteUnit.characters.count))
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - minuteUnit.characters.count - minuteStr.characters.count - hourUnit.characters.count, hourUnit.characters.count))
                leftValueLabel.attributedText = mutableAttributes
                
                leftTitleLabel.text = "你踢足球的时间"
            }
        }
    }
    //中数值
    private var centerValue: Int?{
        didSet{
            guard let value = centerValue else {
                centerTitleLabel.isHidden = true
                centerValueLabel.isHidden = true
                return
            }
            
            centerTitleLabel.isHidden = false
            centerValueLabel.isHidden = false
            
            switch sportType as SportType {
            case .sleep:
                centerValueLabel.text = ""
                centerTitleLabel.text = ""
            default:
                //sport
                centerValueLabel.text = ""
                centerTitleLabel.text = ""
            }
        }
    }
    //左数值
    private var rightValue: Int?{
        didSet{
            guard let value = rightValue else {
                rightTitleLabel.isHidden = true
                rightValueLabel.isHidden = true
                return
            }
            
            rightTitleLabel.isHidden = false
            rightValueLabel.isHidden = false
            
            switch sportType as SportType {
            case .sleep:
                
                let text = "\(CGFloat(value) / (7 * 60) * 100) %"
                
                let textColor = recordDarkColors[.sleep]!
                
                let mutableAttributes = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: textColor])
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - 1, 1))
                rightValueLabel.attributedText = mutableAttributes
                
                rightTitleLabel.text = "目标睡眠"
            case .walking, .hiking:
                let unitStr = "步"
                let text = "\(value)" + unitStr
                
                let textColor = recordDarkColors[.sport]!
                
                let mutableAttributes = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: textColor])
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - unitStr.characters.count, unitStr.characters.count))
                rightValueLabel.attributedText = mutableAttributes
                
                rightTitleLabel.text = "运动目标"
            default:
                //sport
                let unitStr = "公里"
                let text = String(format: "%.1f", CGFloat(value) / 1000) + unitStr
                
                let textColor = recordDarkColors[.sport]!
                
                let mutableAttributes = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: textColor])
                mutableAttributes.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(text.characters.count - unitStr.characters.count, unitStr.characters.count))
                rightValueLabel.attributedText = mutableAttributes
                
                rightTitleLabel.text = "距离"
            }
        }
    }
    
    
    //MARK:- init************************************************************************************************
    init(with track: EachTrainningData){
        let frame = CGRect(x: edgeWidth,
                           y: detailTopHeight,
                           width: view_size.width - edgeWidth * 2,
                           height: view_size.height - detailTopHeight - edgeWidth)
        super.init(frame: frame)
        
        self.track = track
        sportType = SportType(rawValue: track.type)!
        
        //config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var gradient: CAGradientLayer?
    override func didMoveToSuperview() {
        
        //createContents()
        config()
    }
    
    private func config(){
        
        gradient?.removeFromSuperlayer()
        
        var height = view_size.height - detailTopHeight - edgeWidth
        if !chartViewTypeList.isEmpty {
            height = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight + 44
            chartViewTypeList.forEach{
                chartViewType in
                if let chartView = chartViewTypeMap[chartViewType]{
                    height += chartView.frame.height
                }
            }
        }
        
        //绘制渐变
        let gradientFrame = CGRect(x: 0, y: 0,
                                   width: view_size.width - edgeWidth * 2,
                                   height: height)
        gradient = CAGradientLayer()
        gradient?.frame = gradientFrame
        
        gradient?.locations = [NSNumber(value: 20.0 / Double(height)), NSNumber(value: 20.0 / Double(height))]
        gradient?.startPoint = CGPoint(x: 1, y: 0)
        gradient?.endPoint = CGPoint(x: 1, y: 1)
        var startColor: UIColor
        switch sportType as SportType {
        case .sleep:
            startColor = modelStartColors[.sleep]!
        default:
            startColor = modelStartColors[.sport]!
        }
        gradient?.colors = [startColor.cgColor, UIColor.white.cgColor]
        gradient?.cornerRadius = detailRadius
        layer.insertSublayer(gradient!, at: 0)
        
        //修改scrollview高度
        guard let trackSV = superview as? TrackSV else{
            return
        }
        trackSV.contentSize = CGSize(width: view_size.width, height: height + detailTopHeight)
        
        //重新修改view大小
        frame = CGRect(x: edgeWidth,
                       y: detailTopHeight,
                       width: view_size.width - edgeWidth * 2,
                       height: height)
        
        trackSV.reloadInputViews()
    }

    private func createContents(){
        
        //数据展示
        switch sportType as SportType {
        case .sleep:
            dataViewTypeList = [.deepSleep, .lightSleep, .wakeTime, .sleepState]
            chartViewTypeList = [.heartrateZoneTime]
        default:
            dataViewTypeList = [.step, .stride, .level, .totalCalorie]
            
            //判断运动类型来显示chart...
            chartViewTypeList = [.activityHeartrate, .heartrateZoneTime, .pace]
        }
        
        //添加分割线
        let separator = UIView(frame: CGRect(x: 0, y: detailCenterHeight - 1, width: bounds.width, height: 1))
        separator.backgroundColor = subWordColor
        separator.alpha = 0.1
        addSubview(separator)
        
        //顶部展示
        addSubview(leftTitleLabel)
        addSubview(leftValueLabel)
        addSubview(centerTitleLabel)
        addSubview(centerValueLabel)
        addSubview(rightTitleLabel)
        addSubview(rightValueLabel)
        
        //顶部数据
        switch sportType as SportType {
        case .sleep:
            leftValue = Int(track.limitMinutes)
            centerValue = nil
            rightValue = Int(track.aerobicMinutes)
        default:
            leftValue = Int(track.steps)
            centerValue = Int(track.distances100TimesM)
            rightValue = Int(track.distances100TimesM)
        }        
    }
    
    //MARK:-点击切换公开状态
    @objc private func setPrivate(sender: UIButton){
        isPrivate = !isPrivate
        sender.isSelected = isPrivate
    }
    
    //MARK:-点击分享
    @objc private func share(sender: UIButton){
        
    }
}
