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
                    }else if self.type == .heartrate{
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
    
    private var isDetail = false
    
    var delegate: DetailDelegate?
    var closure: (()->())?          //统一回调
    
    //MARK:- init
    init(detailType: DataCubeType, isDetail: Bool){
        let frame = CGRect(x: edgeWidth,
                           y: detailTopHeight,
                           width: view_size.width - edgeWidth * 2,
                           height: isDetail ? view_size.height * 2 : view_size.height - detailTopHeight - edgeWidth)
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
                       height: isDetail ? tableViewY + tableViewHeight : view_size.height - detailTopHeight - edgeWidth)
        
        detailSV.reloadInputViews()
        
        config()
    }
    
    private func config(){
        gradient?.removeFromSuperlayer()
        //绘制渐变
        gradient = CAGradientLayer()
        gradient?.frame = CGRect(x: 0, y: 0,
                                 width: view_size.width - edgeWidth * 2,
                                 height: isDetail ? tableViewY + tableViewHeight : view_size.height - detailTopHeight - edgeWidth)
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
    
    fileprivate var thisWeek = [Any]()
    fileprivate var lastWeek = [Any]()
    private var tableView: UITableView?
    private var tableViewY: CGFloat = view_size.width * 0.2 * 4 + detailCenterHeight
    private var tableViewHeight: CGFloat = 0
    fileprivate let weekStrList = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    private func createContents(){
        
        //数据展示
        switch type as DataCubeType {
        case .sport:
            dataViewTypeList = [.totalTime, .totalCalorie, .activityTime, .activityCalorie, .restTime, .restCalorie]
        case .heartrate:
            dataViewTypeList = [.averageBloodPressure, .maxBloodPressure, .averageHeartrate, .restHeartrate, .maxHeartrate]
        case .sleep:
            dataViewTypeList = [.heartrate, .sleepState, .deepSleep, .quiteSleep, .lightSleep, .wakeTime, .sleepTime, .wakeCount]
        case .mindBody:
            dataViewTypeList = [.resetStateDuration, .lowStateDuration, .middleStateDuration, .highStateDuration]
        }
        
        if isDetail{        //当前选择日
            
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
            tableViewY = CGFloat(lroundf(Float(dataViewTypeList.count) / 2)) * view_size.width * 0.2 + detailCenterHeight
            tableViewHeight = 44 * CGFloat(1 + weekday + 1 + lastWeek.count)
            let tableViewFrame = CGRect(x: 0, y: tableViewY, width: bounds.width, height: tableViewHeight)
            tableView = UITableView(frame: tableViewFrame, style: .grouped)
            tableView?.isScrollEnabled = false
            tableView?.separatorColor = .white
            tableView?.delegate = self
            tableView?.dataSource = self
            addSubview(tableView!)
        }
    }
}

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
                
                let format = DateFormatter()
                format.dateFormat = "M月d日"
                let startStr = format.string(from: startDate)
                let endStr = format.string(from: endDate)
                
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
                let weekday = calendar.component(.weekday, from: date)
                cell.textLabel?.text = weekStrList[weekday - 1]
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
