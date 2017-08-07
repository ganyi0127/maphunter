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
                if let accessoryId = AngelManager.share()?.accessoryId{
                    let userId = UserManager.share().userId
                    if self.type == .sport {                   //运动
                        let sportdataList = coredataHandler.selectSportEverydayDataList(withAccessoryId: accessoryId, byUserId: userId, withDate: selectDate, withCDHRange: CDHRange.day)
                        if let sportdata = sportdataList.first{
                            switch dataViewType {
                            case .totalTime:
                                detailDataView.value = CGFloat(sportdata.totalActiveTimeSeconds)
                            case .totalCalorie:
                                detailDataView.value = CGFloat(sportdata.totalCalories)
                            case .activityTime:
                                detailDataView.value = CGFloat(sportdata.totalActiveTimeSeconds)
                            case .activityCalorie:
                                detailDataView.value = CGFloat(sportdata.totalCalories)
                            case .restTime:
                                detailDataView.value = 123
                            case .restCalorie:
                                detailDataView.value = 123
                            default:
                                detailDataView.value = 0
                            }
                        }
                    }else if self.type == .sleep{               //睡眠
                        let sleepDataList = coredataHandler.selectSleepEverydayDataList(withAccessoryId: accessoryId, byUserId: userId, withDate: selectDate, withCDHRange: CDHRange.day)
                        if let sleepData = sleepDataList.first{
                            switch dataViewType {
                            case .heartrate:
                                detailDataView.value = 70
                            case .sleepState:
                                detailDataView.value = CGFloat(sleepData.faultingState)
                            case .deepSleep:
                                detailDataView.value = CGFloat(sleepData.deepSleepMinutes * 60)
                            case .quiteSleep:
                                detailDataView.value = 0
                            case .lightSleep:
                                detailDataView.value = CGFloat(sleepData.lightSleepMinutes * 60)
                            case .wakeTime:
                                detailDataView.value = CGFloat(sleepData.totalMinutes - sleepData.lightSleepMinutes - sleepData.deepSleepMinutes) * 60
                            case .sleepTime:
                                detailDataView.value = CGFloat(sleepData.totalMinutes * 60)
                            case .wakeCount:
                                detailDataView.value = CGFloat(sleepData.awakeCount)
                            default:
                                detailDataView.value = 0
                            }
                        }
                    }else if self.type == .heartrate{           //心肺功能
                        detailDataView.value = 123
                    }else if self.type == .mindBody{            //身心状态
                        switch dataViewType {
                        case .resetStateDuration:
                            resetStateDurationValue = 12
                            detailDataView.value = resetStateDurationValue
                        case .lowStateDuration:
                            lowStateDurationValue = 34
                            detailDataView.value = lowStateDurationValue
                        case .middleStateDuration:
                            middleStateDurationValue = 45
                            detailDataView.value = middleStateDurationValue
                        case .highStateDuration:
                            highStateDurationValue = 99
                            detailDataView.value = highStateDurationValue
                        default:
                            break
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
    private var resetStateDurationValue: CGFloat = 10
    private var lowStateDurationValue: CGFloat = 20
    private var middleStateDurationValue: CGFloat = 30
    private var highStateDurationValue: CGFloat = 40
    
    //附加cell
    private var dataViewTypeAdditionalList: [DetailDataViewType.Additional]! {
        didSet{
            guard let list = dataViewTypeAdditionalList else {
                return
            }
            
            list.enumerated().forEach{
                index, type in
                let detailDataCell = DetailDataCell(with: type)
                let y = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight + CGFloat(index) * detailDataCell.bounds.height
                detailDataCell.frame.origin = CGPoint(x: 0, y: y)
                
                
                //获取数据
                let coredataHandler = CoreDataHandler.share()
                if let accessoryId = AngelManager.share()?.accessoryId{
                    let userId = UserManager.share().userId
                    
                    //获取数据。。。
                    
                    switch type {
                    case .exercise:
                        detailDataCell.value = (58, 4)                                              //锻炼总分钟数，锻炼次数
                    case .stepTarget:
                        detailDataCell.value = [250, 123, 456, 123, 324, 786, 12, 456, 876]         //9小时内每小时步数
                    case .restHeartrate:
                        detailDataCell.value = (60, 67)                                             //静息心率，30天平均心率
                    case .bloodPressureTrend:
                        detailDataCell.value = (1, 105, 65)                                         //血压趋势类型，平均舒张压，平均收缩压
                    default:
                        break
                    }
                }
                
                detailDataCell.closure = {
                    cellType in
                    self.additionalClosure?(cellType)
                }
                addSubview(detailDataCell)
            }
        }
    }
    
    private var isDetail = false
    
    var delegate: DetailDelegate?
    var closure: (()->())?                                  //统一回调
    var additionalClosure: ((DetailDataViewType.Additional)->())? //附加回调
    
    //MARK:- init
    init(detailType: DataCubeType, isDetail: Bool){
        let frame = CGRect(x: edgeWidth,
                           y: detailTopHeight,
                           width: view_size.width - edgeWidth * 2,
                           height: isDetail ? view_size.height * 2 : view_size.height + subHeight - detailTopHeight - edgeWidth)
        super.init(frame: frame)
        
        self.isDetail = isDetail
        type = detailType
        
        //config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var gradient: CAGradientLayer?
    override func didMoveToSuperview() {
        tableView?.reloadData()
        
        //修改scrollview高度
        let detailSV = superview as! DetailSV
        detailSV.contentSize = CGSize(width: view_size.width, height: detailTopHeight + tableViewY + tableViewHeight)
        
        //重新修改view大小
        frame = CGRect(x: edgeWidth,
                       y: detailTopHeight,
                       width: view_size.width - edgeWidth * 2,
                       height: isDetail ? tableViewY + tableViewHeight : tableViewY + subHeight)
        
        detailSV.reloadInputViews()
        
        config()
    }
    
    private func config(){
        gradient?.removeFromSuperlayer()
        //绘制渐变
        gradient = CAGradientLayer()
        gradient?.frame = bounds
        gradient?.locations = [0.2, 0.8]
        gradient?.startPoint = CGPoint(x: 1, y: 0)
        gradient?.endPoint = CGPoint(x: 1, y: 1)
        gradient?.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        gradient?.cornerRadius = detailRadius
        layer.insertSublayer(gradient!, at: 0)
        
        /*
        //添加top
        detailTop = DetailTop(detailType: type)
        detailTop?.delegate = self
        addSubview(detailTop!)
         */
    }
    
    private var tableView: UITableView?
    private var tableViewY: CGFloat = view_size.width * 0.2 * 4 + detailCenterHeight
    private var tableViewHeight: CGFloat = 0
    private var subHeight: CGFloat = 0
    private func createContents(){
        
        //数据展示
        switch type as DataCubeType {
        case .sport:
            dataViewTypeList = [.totalTime, .totalCalorie, .activityTime, .activityCalorie, .restTime, .restCalorie]
            dataViewTypeAdditionalList = [.exercise, .stepTarget]
        case .heartrate:
            dataViewTypeList = [.averageBloodPressure, .maxBloodPressure, .averageHeartrate, .restHeartrate, .maxHeartrate]
            dataViewTypeAdditionalList = [.restHeartrate]
        case .sleep:
            dataViewTypeList = [.heartrate, .sleepState, .deepSleep, .quiteSleep, .lightSleep, .wakeTime, .sleepTime, .wakeCount]
            dataViewTypeAdditionalList = []
        case .mindBody:
            dataViewTypeList = [.resetStateDuration, .lowStateDuration, .middleStateDuration, .highStateDuration]
            dataViewTypeAdditionalList = []
        }
        
        tableViewY = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight + CGFloat(dataViewTypeAdditionalList.count) * 44
        
        if isDetail{        //当前选择日
            /*
            //趋势
            guard let angleManager = AngelManager.share() else{
                return
            }
            guard let macAddress = angleManager.macAddress else {
                return
            }
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: Date())    //1:星期天 7:星期六
            
            let userId = UserManager.share().userId
            let coredataHandler = CoreDataHandler.share()
            let lastDate = Date(timeIntervalSinceNow: -TimeInterval(weekday) * 60 * 60 * 24)
            
            if type == .sport {
                thisWeek = coredataHandler.selectSportData(userId: userId, withMacAddress: macAddress, withDate: Date(), withDayRange: weekday - 1)
                lastWeek = coredataHandler.selectSportData(userId: userId, withMacAddress: macAddress, withDate: lastDate, withDayRange: -7)
            }else if type == .sleep{
                thisWeek = coredataHandler.selectSleepData(userId: userId, withMacAddress: macAddress, withDate: Date(), withDayRange: weekday - 1)
                lastWeek = coredataHandler.selectSleepData(userId: userId, withMacAddress: macAddress, withDate: lastDate, withDayRange: -7)
            }
            
            //创建tableview
            tableViewY = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight + CGFloat(dataViewTypeAdditionalList.count) * 44
            tableViewHeight = 44 * CGFloat(1 + weekday + 1 + lastWeek.count)
            let tableViewFrame = CGRect(x: 0, y: tableViewY, width: bounds.width, height: tableViewHeight)
            tableView = UITableView(frame: tableViewFrame, style: .grouped)
            tableView?.isScrollEnabled = false
            tableView?.separatorColor = .white
            tableView?.delegate = self
            tableView?.dataSource = self
            addSubview(tableView!)
             */
            
            let subTableView = SubTableView(withType: type)
            subTableView.startDate = selectDate
            subTableView.type = type
            subTableView.frame = CGRect(x: 0, y: tableViewY, width: subTableView.bounds.width, height: subTableView.bounds.height)
            tableViewHeight = subTableView.bounds.height
            addSubview(subTableView)            
        }else{
            if type == .mindBody{   //身心状态
                //添加扇形图
                subHeight = view_size.width * 0.75
                
                let labelFrame = CGRect(x: 0, y: tableViewY + edgeWidth, width: bounds.width, height: 17)
                let label = UILabel(frame: labelFrame)
                label.text = "状态百分比"
                label.font = fontMiddle
                label.textColor = wordColor
                label.textAlignment = .center
                addSubview(label)
                
                //设置常量
                let circleColors = [UIColor.blue.withAlphaComponent(0.5),
                                    UIColor.yellow.withAlphaComponent(0.5),
                                    UIColor.orange.withAlphaComponent(0.5),
                                    UIColor.red.withAlphaComponent(0.5)]
                let values = [resetStateDurationValue, lowStateDurationValue, middleStateDurationValue, highStateDurationValue]
                
                //设置贝塞尔属性
                let centerPoint = CGPoint(x: bounds.width * 0.6 / 2, y: tableViewY + edgeWidth + labelFrame.height + (subHeight - labelFrame.height) / 2)
                let radius = (subHeight - labelFrame.height) / 2 / 2
                
                //绘制圆圈
                var startAngle: CGFloat = -.pi / 2
                let totalValue = values.reduce(0){$0 + $1}
                if totalValue != 0{
                    for (index, value) in values.enumerated(){
                        let endAngle = value / totalValue * .pi * 2 + startAngle
                        
                        let bezier = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                        
                        startAngle = endAngle
                        
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.path = bezier.cgPath
                        shapeLayer.fillColor = nil
                        shapeLayer.strokeColor = circleColors[index].cgColor
                        shapeLayer.lineWidth = 8
                        layer.addSublayer(shapeLayer)
                    }
                }
                
                //添加圆圈中央文字
                let centerLabelFrame = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: radius * 2, height: radius * 2)
                let centerLabel = UILabel(frame: centerLabelFrame)
                centerLabel.numberOfLines = 0
                centerLabel.textAlignment = .center
                
                let unitString = "整体压力水平"
                let text = "\(Int(totalValue))\n" + unitString
                let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontBig, NSForegroundColorAttributeName: wordColor])
                attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor], range: NSMakeRange(text.characters.count - unitString.characters.count, unitString.characters.count))
                centerLabel.attributedText = attributedString
                addSubview(centerLabel)
                
                //创建图片
                func getImage(_ pressureType: Int) -> UIImage{
                    
                    let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                    v.layer.cornerRadius = v.frame.height / 2
                    v.backgroundColor = circleColors[pressureType]
                    
                    UIGraphicsBeginImageContextWithOptions(CGSize(width: 17, height: 17), false, UIScreen.main.scale)
                    let ctx = UIGraphicsGetCurrentContext()!
                    v.layer.render(in: ctx)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    return image!
                }
                
                //添加标注
                let texts = ["休息", "低压", "中压", "高压"]
                let startY = tableViewY + edgeWidth + labelFrame.height + (subHeight - labelFrame.height) / 2 - radius
                for (index, value) in values.enumerated(){
                    
                    let tipLabelFrame = CGRect(x: bounds.width * 0.6, y: startY + (radius * 2 - 17) * CGFloat(index) / CGFloat(values.count - 1), width: bounds.width * 0.4, height: 17)
                    let tipLabel: UILabel = UILabel(frame: tipLabelFrame)
                    tipLabel.font = fontSmall
                    tipLabel.textColor = subWordColor
                    tipLabel.textAlignment = .center
                    tipLabel.backgroundColor = .clear
                    
                    //添加图片混排
                    let text = texts[index] + " \(Int(value / totalValue * 100))%"
                    let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
                    let length = fontSmall.pointSize * 1
                    let imageSize = CGSize(width: length, height: length)
                    let imageBounds = CGRect(x: 0, y: length / 2 - tipLabelFrame.height / 2, width: length, height: length)
                    let endIndex: Int = 0       //插入位置
                    let startAttach = NSTextAttachment()
                    startAttach.bounds = imageBounds
                    startAttach.image = getImage(index)
                    
                    let startAttributed = NSAttributedString(attachment: startAttach)
                    attributedString.insert(startAttributed, at: endIndex)
                    tipLabel.attributedText = attributedString
                    
                    addSubview(tipLabel)
                }
                
            }
        }
    }
}

/*
//MARK:- 日期tableView delegate
extension DetailBottom: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return thisWeek.count
        }
        return lastWeek.count
    }
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //header高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //footer高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        let headerView = UIView(frame: headerViewFrame)
        headerView.layer.cornerRadius = 2
        headerView.backgroundColor = modelEndColors[type]?.withAlphaComponent(0.5)
        
        //添加label
        let titleFrame = CGRect(x: 8, y: 0, width: bounds.width / 2 - 8, height: 44)
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        headerView.addSubview(titleLabel)
        
        //添加detaiLabel
        let detailFrame = CGRect(x: bounds.width / 2, y: 0, width: bounds.width / 2 - 8, height: 44)
        let detailLabel = UILabel(frame: detailFrame)
        detailLabel.text = "8000步"
        detailLabel.textColor = .white
        detailLabel.textAlignment = .right
        headerView.addSubview(detailLabel)
        
        //日期
        if section == 0{        //本周总数据
            if thisWeek.isEmpty{
                titleLabel.text = "无本周数据"
                detailLabel.text = ""
            }else{
                titleLabel.text = "本周"
                
                var detailText: String
                if type == .sport {         //运动
                    let thisSportDataWeek = thisWeek as! [SportData]
                    let sumStep = thisSportDataWeek.reduce(0){$0 + $1.totalStep}
                    detailText = "\(sumStep)步"
                    let mutableAttributed = NSMutableAttributedString(string: detailText, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                    mutableAttributed.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(detailText.characters.count - 1, 1))
                    detailLabel.attributedText = mutableAttributed
                }else if type == .sleep{    //睡眠
                    let thisSleepDataWeek = thisWeek as! [SleepData]
                    let sumStep = thisSleepDataWeek.reduce(0){$0 + $1.totalMinute}
                    detailText = "\(sumStep)分钟"
                    let mutableAttributed = NSMutableAttributedString(string: detailText, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                    mutableAttributed.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(detailText.characters.count - 2, 2))
                    detailLabel.attributedText = mutableAttributed
                }
            }
        }else{                  //上周总数据
            //日期
            if lastWeek.isEmpty{
                titleLabel.text = "无上周数据"
                detailLabel.text = ""
            }else{
                var startDate = Date()
                var endDate = Date()
                if type == .sport{
                    startDate = (lastWeek.first! as! SportData).date! as Date
                    endDate = (lastWeek.last! as! SportData).date! as Date
                }else if type == .sleep{
                    startDate = (lastWeek.first! as! SleepData).date! as Date
                    endDate = (lastWeek.last! as! SleepData).date! as Date
                }
                
                let formatStr = "M月d日"
                let startStr = startDate.formatString(with: formatStr)
                let endStr = endDate.formatString(with: formatStr)
                
                titleLabel.text = startStr + "~" + endStr
                //步数
                var detailText: String
                if type == .sport {         //运动
                    let thisSportDataWeek = thisWeek as! [SportData]
                    let sumStep = thisSportDataWeek.reduce(0){$0 + $1.totalStep}
                    detailText = "\(sumStep)步"
                    let mutableAttributed = NSMutableAttributedString(string: detailText, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                    mutableAttributed.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(detailText.characters.count - 1, 1))
                    detailLabel.attributedText = mutableAttributed
                }else if type == .sleep{    //睡眠
                    let thisSleepDataWeek = thisWeek as! [SleepData]
                    let sumStep = thisSleepDataWeek.reduce(0){$0 + $1.totalMinute}
                    detailText = "\(sumStep)分钟"
                    let mutableAttributed = NSMutableAttributedString(string: detailText, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                    mutableAttributed.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(detailText.characters.count - 2, 2))
                    detailLabel.attributedText = mutableAttributed
                }
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let calendar = Calendar.current
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = subWordColor
        if type == .sport{
            let sportData = section == 0 ? thisWeek[row] as! SportData : lastWeek[row] as! SportData
            
            let date = sportData.date! as Date
            if date.isToday() {
                cell.textLabel?.text = "今天"
            }else{
                cell.textLabel?.text = date.weekdayString()
            }
            
            let step = sportData.totalStep
            let detailText = "\(step)步"
            let mutableAttributed = NSMutableAttributedString(string: detailText, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: subWordColor])
            mutableAttributed.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(detailText.characters.count - 1, 1))
            cell.detailTextLabel?.attributedText = mutableAttributed
        }else if type == .sleep{
            let sleepData = section == 0 ? thisWeek[row] as! SleepData : lastWeek[row] as! SleepData
            
            let date = sleepData.date! as Date
            if date.isToday() {
                cell.textLabel?.text = "今天"
            }else{
                let weekday = calendar.component(.weekday, from: date)
                cell.textLabel?.text = weekStrList[weekday - 1]
            }
            
            let minute = sleepData.totalMinute
            let detailText = "\(minute)分钟"
            let mutableAttributed = NSMutableAttributedString(string: detailText, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: subWordColor])
            mutableAttributed.addAttributes([NSFontAttributeName: fontSmall], range: NSMakeRange(detailText.characters.count - 2, 2))
            cell.detailTextLabel?.attributedText = mutableAttributed
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var date: Date
        if section == 0 {
            date = (thisWeek[row] as! SportData).date! as Date
            
        }else{
            date = (lastWeek[row] as! SleepData).date! as Date
        }
        //进入详情页面
        let detailVC = DetailVC(detailType: type, date: date, isDetail: false)
        viewController()?.navigationController?.show(detailVC, sender: nil)
    }
}
*/
