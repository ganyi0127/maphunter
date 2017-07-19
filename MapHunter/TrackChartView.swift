//
//  TrackChartView.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/8.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
enum TrackChartViewType {
    case heartrateZoneTime
    case activityHeartrate
    case pace
}

class TrackChartView: UIView {
    
    //类型
    private var trackChartViewType: TrackChartViewType!
    
    //input value
    var track: EachTrainningData?{
        didSet{
            guard let trk = track else {
                return
            }
            
            //更新内容
            if trackChartViewType == .heartrateZoneTime {     //更新心率区间ui
                let minutesList = [trk.limitMinutes, trk.aerobicMinutes, trk.burnFatMinutes]
                
                guard let maxMinutes = minutesList.max(), maxMinutes != 0 else{
                    return
                }
                
                
                //比率
                minutesList.enumerated().forEach{
                    index, minutes in
                    
                    let rate = CGFloat(minutes) / CGFloat(maxMinutes)
                    
                    if index < zoneTimeProgressList.count{
                        let progress = zoneTimeProgressList[index]
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                            progress.frame = CGRect(x: progress.frame.origin.x, y: progress.frame.origin.y, width: self.frame.width / 3 * 1.5 * rate, height: progress.frame.height)
                        }, completion: nil)
                    }
                }
            }else if trackChartViewType == .activityHeartrate{                  //更新活动心率
                
                //更新平均心率值
                let avgrageHeartrate = trk.averageHeartRate
                
                let avgrageHeartrateStr = "\(avgrageHeartrate)"
                let unitStr = "Bmp"
                let subText = "平均每分钟" + avgrageHeartrateStr + unitStr
                let subMutableAttribute = NSMutableAttributedString(string: subText, attributes: [NSForegroundColorAttributeName: subWordColor, NSFontAttributeName: fontSmall])
                subMutableAttribute.addAttributes([NSForegroundColorAttributeName: wordColor, NSFontAttributeName: fontMiddle],
                                                  range: NSMakeRange(subText.characters.count - avgrageHeartrateStr.characters.count - unitStr.characters.count, avgrageHeartrateStr.characters.count))
                avgrageHeartrateLabel?.attributedText = subMutableAttribute
                
                //绘制心率曲线
                let heartrateList = trk.heartRateActivityItems?.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as! [EachTrainningHeartRateItem]
                
                let sortHeartrateList = heartrateList.sorted{$0.value < $1.value}
//                guard let maxHeartrate = sortHeartrateList.last?.data, let minHeartrate = sortHeartrateList.first?.data else{
//                    return
//                }
                var textList = [Int]()
                (0..<100).forEach{
                    _ in
                    let random = Int(arc4random_uniform(225 - 40)) + 40
                    textList.append(random)
                }
                let maxHeartrate = textList.max()!
                let minHeartrate = textList.min()!
                
                let baseY: CGFloat = 17 + 40
                let startX: CGFloat = 40
                let height: CGFloat = heartrateHeight
                let width: CGFloat = bounds.width - 8 - startX
                let count = textList.count //heartrateList.count
                
                let bezier = UIBezierPath()
                textList.enumerated().forEach{
                    index, item in
                    
                    let x = 1 + width * CGFloat(index) / CGFloat(count)
                    let y = 1 + height * CGFloat(item - minHeartrate) / CGFloat(maxHeartrate - minHeartrate)
                    
                    if index == 0 {
                        bezier.move(to: CGPoint(x: x, y: y))
                    }else{
                        let preX = bezier.currentPoint.x
                        bezier.addLine(to: CGPoint(x: preX, y: y))
                        bezier.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                let shape = CAShapeLayer()
                shape.path = bezier.cgPath
                shape.fillColor = nil
                shape.lineWidth = 1
                shape.strokeColor = UIColor.green.cgColor
                shape.zPosition = 10
                layer.addSublayer(shape)
                
                //添加曲线遮罩
                let gradientFrame = CGRect(x: startX - 2, y: baseY + 8 - 2,
                                           width: width + 2 * 2,
                                           height: height + 2 * 2)
                let gradient = CAGradientLayer()
                gradient.frame = gradientFrame
                gradient.locations = [0, 0.33, 0.33, 0.66, 0.66, 1]
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 0, y: 1)
                gradient.colors = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.yellow.cgColor, UIColor.cyan.cgColor, UIColor.cyan.cgColor]
                gradient.mask = shape
                layer.addSublayer(gradient)
                
                //修改开始与结束时间
                let format = DateFormatter()
                format.dateFormat = "hh:mm"
                
                let startStr = format.string(from: trk.date! as Date)
                heartrateBeginDateLabel?.text = startStr
                
                let endStr = format.string(from: trk.date! as Date)
                heartrateEndDateLabel?.text = endStr
            }else if trackChartViewType == .pace {                      //更新配速
                let distance: Double = 18000 //trk.distance
                let kmCount = lround(distance / 1000)
                (0..<kmCount).forEach{
                    i in
                }
                
                //重新计算view高度
                let newHeight = 8 + 17 + CGFloat(kmCount) * (17 + 8) + CGFloat(kmCount / 5 + 1) * ((17 + 8) * 2) + 8
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: newHeight)
                
                //获取最高配速
                let sortPace = trk.gpsLoggerItems?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as! [EachTrainningGPSLoggerItem]
                let maxPace: CGFloat = 6.45      //6分45秒
                
                //绘制配速
                (0..<kmCount).forEach{
                    i in
                    let height: CGFloat = 17
                    let y = CGFloat(i) * (height + 8) + CGFloat(i / 5) * ((height + 8) * 2) + 17 + 8
                    
                    //显示类型文字
                    let labelFrame = CGRect(x: 0, y: y, width: frame.width / 3, height: height)
                    let label = UILabel(frame: labelFrame)
                    label.text = "\(i + 1)"
                    label.font = fontSmall
                    label.textAlignment = .center
                    addSubview(label)
                    
                    //绘制进度
                    let maskFrame = CGRect(x: (-frame.width / 3 * 1.5) / 2, y: 0, width: frame.width / 3 * 1.5, height: height)
                    let maskLayer = CALayer()
                    maskLayer.frame = maskFrame
                    maskLayer.backgroundColor = UIColor.blue.cgColor
                    layer.addSublayer(maskLayer)
                    
                    //计算比例
                    let rate = CGFloat(arc4random_uniform(8)) / 10 + 0.2
                    maskLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
                    maskLayer.transform = CATransform3DMakeScale(rate, 1, 1)
                    
                    let gradientFrame = CGRect(x: frame.width / 3, y: y, width: frame.width / 3 * 1.5, height: height)
                    let gradient = CAGradientLayer()
                    gradient.frame = gradientFrame
                    gradient.locations = [0, 1]
                    gradient.startPoint = CGPoint(x: 0, y: 0)
                    gradient.endPoint = CGPoint(x: 1, y: 0)
                    gradient.colors = [UIColor.orange.cgColor, UIColor.red.cgColor]
                    gradient.mask = maskLayer
                    layer.addSublayer(gradient)
                    
                    //绘制label
                    let valueFrame = CGRect(x: frame.width / 3 * 2.5 + 8, y: y, width: frame.width / 3 * 0.5 - 8, height: height)
                    let valueLabel = UILabel(frame: valueFrame)
                    valueLabel.textAlignment = .left
                    valueLabel.textColor = UIColor.red.withAlphaComponent(0.5)
                    valueLabel.font = fontSmall
                    valueLabel.text = "6\'12\""
                    zoneTimeLabelList.append(valueLabel)
                    addSubview(valueLabel)
                    
                    //添加汇总
                    if (i + 1) % 5 == 0{
                        let totalFrame = CGRect(x: frame.width / 2, y: y + height, width: frame.width / 2 - 8, height: height)
                        let totalLabel = UILabel(frame: totalFrame)
                        totalLabel.textAlignment = .right
                        totalLabel.font = fontSmall
                        addSubview(totalLabel)
                        
                        //计算用时
                        let intervalTime = 60 * 12            //秒
                        let hour = intervalTime / (60 * 60)
                        let minute = (intervalTime % (60 * 60)) / 60
                        let second = intervalTime % 60
                        let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
                        let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
                        let secondStr = second < 10 ? "0\(second)" : "\(second)"
                        let intervalStr = hourStr + ":" + minuteStr + ":" + secondStr
                        let text = "\(i + 1)" + "公里 用时 " + intervalStr
                        let totalAttribute = NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName: lightWordColor])
                        totalAttribute.addAttributes([NSForegroundColorAttributeName: wordColor], range: NSMakeRange(text.characters.count - intervalStr.characters.count, intervalStr.characters.count))
                        totalLabel.attributedText = totalAttribute
                    }
                }
                
                //下分割线
                let separator = UIView(frame: CGRect(x: 0, y: newHeight - 1, width: bounds.width, height: 1))
                separator.backgroundColor = subWordColor
                separator.alpha = 0.1
                addSubview(separator)
            }
        }
    }
    
    //心率区间
    private var zoneTimeProgressList = [UIView]()
    private var zoneTimeLabelList = [UILabel]()
    
    //活动心率
    private var avgrageHeartrateLabel: UILabel?
    private let heartrateStartX: CGFloat = 40
    private let heartrateHeight: CGFloat = 100
    private var heartrateBeginDateLabel: UILabel?
    private var heartrateEndDateLabel: UILabel?
    
    //MARK:-init******************************************************************************************************
    init(with trackChartViewType: TrackChartViewType){
        var height: CGFloat
        switch trackChartViewType as TrackChartViewType {
        case .heartrateZoneTime:
            height = (17 + 8) * 3 + 17 + 40 + 8
        case .activityHeartrate:
            height =  17 + 40 + 8 + 100 + 8 + 17 + 8
        case .pace:
            height = view_size.width * 1.4
        }
        let frame = CGRect(x: 0, y: 0, width: view_size.width - edgeWidth * 2, height: height)
        super.init(frame: frame)
        
        self.trackChartViewType = trackChartViewType
        
        config()
        createContents()
    }
    
    override func didMoveToSuperview() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        //绘制相应图标
        switch trackChartViewType as TrackChartViewType {
        case .heartrateZoneTime:    //心率区间
            //标题
            let titleLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.font = fontMiddle
            titleLabel.textColor = subWordColor
            titleLabel.text = "心率区间的时间"
            titleLabel.textAlignment = .center
            addSubview(titleLabel)
            
            //副标题
            let subTitleFrame = CGRect(x: 0, y: 40, width: frame.width / 2, height: 17)
            let subTitleLabel = UILabel(frame: subTitleFrame)
            subTitleLabel.font = fontSmall
            subTitleLabel.textAlignment = .center
            let subText = "  类型  /  时间"
            let subMutableAttribute = NSMutableAttributedString(string: subText, attributes: [NSForegroundColorAttributeName: subWordColor])
            subMutableAttribute.addAttributes([NSForegroundColorAttributeName: UIColor.red.withAlphaComponent(0.5)], range: NSMakeRange(6, 3))
            subTitleLabel.attributedText = subMutableAttribute
            addSubview(subTitleLabel)
            
            //进度
            (0..<3).forEach{
                i in
                
                let height: CGFloat = 17
                let y = CGFloat(i) * (height + 8) + 17 + 40
                
                //显示类型文字
                let labelFrame = CGRect(x: 0, y: y, width: frame.width / 3, height: height)
                let label = UILabel(frame: labelFrame)
                var text: String
                if i == 0{
                    text = "峰值锻炼"
                }else if i == 1{
                    text = "心肺锻炼"
                }else{
                    text = "脂肪燃烧"
                }
                label.text = text
                label.font = fontSmall
                label.textAlignment = .center
                addSubview(label)

                //绘制进度
                let progressFrame = CGRect(x: frame.width / 3, y: y, width: frame.width / 3 * 1.5, height: height)
                let progressView = UIView(frame: progressFrame)
                var progressBackgroundColor: UIColor
                if i == 0{
                    progressBackgroundColor = UIColor.red
                }else if i == 1{
                    progressBackgroundColor = UIColor.orange
                }else {
                    progressBackgroundColor = UIColor.yellow
                }
                progressView.backgroundColor = progressBackgroundColor
                zoneTimeProgressList.append(progressView)
                addSubview(progressView)
                
                //绘制label
                let valueFrame = CGRect(x: frame.width / 3 * 2.5 + 8, y: y, width: frame.width / 3 * 0.5 - 8, height: height)
                let valueLabel = UILabel(frame: valueFrame)
                valueLabel.textAlignment = .left
                valueLabel.textColor = subWordColor
                valueLabel.font = fontSmall
                valueLabel.text = "-分钟"
                zoneTimeLabelList.append(valueLabel)
                addSubview(valueLabel)
            }
            
            //下分割线
            let separator = UIView(frame: CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1))
            separator.backgroundColor = subWordColor
            separator.alpha = 0.1
            addSubview(separator)
        case .activityHeartrate:    //活动心率
            //标题
            let titleLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.font = fontMiddle
            titleLabel.textColor = subWordColor
            titleLabel.text = "活动心率"
            titleLabel.textAlignment = .center
            addSubview(titleLabel)
            
            //副标题
            let subTitleFrame = CGRect(x: 0, y: 40, width: frame.width / 2, height: 17)
            avgrageHeartrateLabel = UILabel(frame: subTitleFrame)
            avgrageHeartrateLabel?.font = fontSmall
            avgrageHeartrateLabel?.textAlignment = .center
            let subText = "平均每分钟-Bmp"
            let subMutableAttribute = NSMutableAttributedString(string: subText, attributes: [NSForegroundColorAttributeName: subWordColor, NSFontAttributeName: fontSmall])
            subMutableAttribute.addAttributes([NSForegroundColorAttributeName: wordColor, NSFontAttributeName: fontMiddle], range: NSMakeRange(subText.characters.count - 4, 1))
            avgrageHeartrateLabel?.attributedText = subMutableAttribute
            addSubview(avgrageHeartrateLabel!)
            
            //开始时间
            let bottomLabelY = 40 + 17 + 8 + heartrateHeight + 8
            let bottomLabelWidth = (frame.width - heartrateStartX - 8) / 2
            let beginFrame = CGRect(x: heartrateStartX, y: bottomLabelY, width: bottomLabelWidth, height: 17)
            heartrateBeginDateLabel = UILabel(frame: beginFrame)
            heartrateBeginDateLabel?.font = fontSmall
            heartrateBeginDateLabel?.textColor = lightWordColor
            heartrateBeginDateLabel?.textAlignment = .left
            addSubview(heartrateBeginDateLabel!)
            
            //结束时间
            let endFrame = CGRect(x: frame.width - 8 - (frame.width - heartrateStartX - 8) / 2, y: bottomLabelY, width: bottomLabelWidth, height: 17)
            heartrateEndDateLabel = UILabel(frame: endFrame)
            heartrateEndDateLabel?.font = fontSmall
            heartrateEndDateLabel?.textColor = lightWordColor
            heartrateEndDateLabel?.textAlignment = .right
            addSubview(heartrateEndDateLabel!)
            
            //下分割线
            let separator = UIView(frame: CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1))
            separator.backgroundColor = subWordColor
            separator.alpha = 0.1
            addSubview(separator)
        case .pace:                 //配速
            //副标题
            let subTitleFrame = CGRect(x: 0, y: 8, width: frame.width / 2, height: 17)
            let subTitleLabel = UILabel(frame: subTitleFrame)
            subTitleLabel.font = fontSmall
            subTitleLabel.textAlignment = .center
            let subText = "  公里  /  配速"
            let subMutableAttribute = NSMutableAttributedString(string: subText, attributes: [NSForegroundColorAttributeName: subWordColor])
            subMutableAttribute.addAttributes([NSForegroundColorAttributeName: UIColor.red.withAlphaComponent(0.5)], range: NSMakeRange(6, 3))
            subTitleLabel.attributedText = subMutableAttribute
            addSubview(subTitleLabel)
        }
    }
}
