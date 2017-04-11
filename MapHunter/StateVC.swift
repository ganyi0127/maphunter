//
//  StateVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
import CoreBluetooth
class StateVC: UIViewController {
    
    @IBOutlet weak var topView: TopView!            //日历
    @IBOutlet weak var tableView: UITableView!      //内容
    
    //毛玻璃 打开日历后蒙版
//    private lazy var effectView = { () -> UIVisualEffectView in
//        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
//        effectView.isUserInteractionEnabled = false
//        effectView.frame = CGRect(x: 0, y: view_size.height * 0, width: view_size.width, height: view_size.height * 1)
//        return effectView
//    }()
    //取消点击事件
    private lazy var tap: UITapGestureRecognizer = {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(recognizer:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        return tap
    }()
    
    //上拉下拉
    fileprivate var newY: CGFloat = 0
    fileprivate var oldY: CGFloat = 0

    //获取时间轴数据
    fileprivate var trackList = [Track](){
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func awakeFromNib() {
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexpath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexpath], with: UITableViewRowAnimation.fade)
        
    }
    
    private func config(){
        
        //初始化当前选择的日期
        selectDate = Date()
        
        //清除顶部空白区域
        automaticallyAdjustsScrollViewInsets = false
        
        //设置背景
        view.backgroundColor = defaultColor
        tableView.backgroundColor = defaultColor

        //接收消息
        notiy.addObserver(self, selector: #selector(receiveConnectedMessage(notify:)), name: connected_notiy, object: nil)
    }
    
    private func createContents(){
        
        if topView.closure == nil {
            topView.closure = {
                date in
                
                print("date: \(date)")
                self.receiveConnectedMessage(notify: nil)
            }
        }
        setupRefresh()
    }
    
    //MARK:- 添加或移除蒙版
    func setBlur(hidden: Bool){
       
        if hidden {
            tableView.removeGestureRecognizer(tap)
            tableView.alpha = 1
        }else{
            tableView.addGestureRecognizer(tap)
            tableView.alpha = 0.2
        }
    }
    
    //MARK:- 点击关闭按钮
    @objc private func tap(recognizer: UITapGestureRecognizer){
        setBlur(hidden: true)
        topView.clickCalendar()
    }
    
    //MARK:- 下拉刷新
    private func setupRefresh(){
        //添加刷新控件
        let control = { () -> UIRefreshControl in
            let ctrl = UIRefreshControl()
            let f = CGRect(x: 0, y: 0, width: view_size.width, height: 58)
            let v = UIView(frame: f)
            v.backgroundColor = defaultColor
            ctrl.addSubview(v)
            ctrl.backgroundColor = nil
            ctrl.layer.zPosition = -0.1
            ctrl.tintColor = UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
            ctrl.attributedTitle = NSAttributedString(string: "同步健康数据")
            ctrl.addTarget(self, action: #selector(refreshStateChange(_:)), for: .valueChanged)
            return ctrl
        }()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = control
        } else {
            tableView.addSubview(control)
        }
        
        //进入刷新状态
//        control.beginRefreshing()
        //加载数据
        refreshStateChange(control)
    }
    
    //MARK:- 刷新调用
    var initFresh = false
    @objc private func refreshStateChange(_ control: UIRefreshControl){

        guard !initFresh else {
            initFresh = false
            control.endRefreshing()
            return
        }
        
        initFresh = true
        
        //判断是否有绑定设备
        let peripheral = PeripheralManager.share().currentPeripheral
        guard peripheral != nil else {
            DispatchQueue.main.async {
                control.attributedTitle = NSAttributedString(string: "手环未绑定")
                _ = delay(1){
                    control.endRefreshing()
                }
            }
            return
        }
        
        guard peripheral?.state == CBPeripheralState.connected  else {
            DispatchQueue.main.async {
                control.attributedTitle = NSAttributedString(string: "手环未连接")
                _ = delay(1){
                    control.endRefreshing()
                }
            }
            return
        }
        
        control.attributedTitle = NSAttributedString(string: "同步数据")
        
        beginLoading()
        
        let angelManager = AngelManager.share()
        //初始化设置用户信息
        let userInfoModel = UserInfoModel()
        userInfoModel.birthDay = 27
        userInfoModel.birthMonth = 1
        userInfoModel.birthYear = 1988
        userInfoModel.gender = 1
        userInfoModel.height = 172
        userInfoModel.weight = 65
        angelManager?.setUserInfo(userInfoModel){_ in}
        
        let satanManager = SatanManager.share()
        
        //同步数据
        satanManager?.getSynchronizationActiveCount(angelManager?.macAddress){
            count in
            angelManager?.setSynchronizationHealthData{
                complete, progress in
                DispatchQueue.main.async {
                    var message: String
                    if complete{
                        message = count > 0 ? "正在同步运动数据..." : "同步完成"
                        debugPrint(message)
                        control.attributedTitle = NSAttributedString(string: message)
                        
                        self.tableView.reloadData()
                        
                        //同步时间轴
                        if count > 0{
                            satanManager?.setSynchronizationActiveData{
                                complete, progress, timeout in
                                DispatchQueue.main.async {
                                    guard !timeout else{
                                        message = "同步运动数据超时"
                                        control.attributedTitle = NSAttributedString(string: message)
                                        
                                        self.initFresh = false
                                        
                                        //弹窗
                                        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                        let cancel = UIAlertAction(title: "返回", style: .cancel){
                                            action in
                                            control.endRefreshing()
                                        }
                                        alertController.addAction(cancel)
                                        self.present(alertController, animated: true, completion: nil)
                                        return
                                    }
                                    
                                    if complete {
                                        self.endLoading()
                                        
                                        message = "同步运动数据完成"
                                        control.attributedTitle = NSAttributedString(string: message)
                                        control.endRefreshing()
                                        
                                        self.initFresh = false
                                        
                                        //更新时间轴数据
                                        self.receiveConnectedMessage(notify: nil)
                                    }else{
                                        message = "正在同步运动数据:\(progress / 2 + 50)%"
                                        control.attributedTitle = NSAttributedString(string: message)
                                    }
                                }
                            }
                        }else{
                            self.initFresh = false
                            self.endLoading()
                            control.endRefreshing()
                        }
                    }else{
                        message = "正在同步健康数据:\(count > 0 ? progress / 2 : progress)%"
                        debugPrint(message)
                        control.attributedTitle = NSAttributedString(string: message)
                    }
                }
            }
        }
        
    }
    
    //MARK:- 接收连接状态
    @objc func receiveConnectedMessage(notify: Notification?){
        
        //更新日期 获取calendarCell
        let indexPath = IndexPath(row: 1, section: 0)
        guard let calendarCell = tableView.cellForRow(at: indexPath) as? CalendarCell else{
            return
        }
        calendarCell.date = selectDate
        
        
        //更新数据
        if let angelManager = AngelManager.share() {
            if let macaddress = angelManager.macAddress {
                trackList.removeAll()
                let userId = UserManager.share().userId
                let tracks = CoreDataHandler.share().selectTrack(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0).sorted{
                    track1, track2 -> Bool in
                    let earlyDate = track1.date?.earlierDate(track2.date as! Date)
                    if earlyDate == track1.date as? Date{
                        return false
                    }
                    return true
                }
                trackList.append(contentsOf: tracks)
            }
        }
    }
}

//MARK:- tableView
extension StateVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        if section == 0{
            return nil
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view_size.width, height: 50))
        headerView.backgroundColor = timeColor
        
        //icon
        let imageViewFrame = CGRect(x: view_size.width * 0.1, y: 15, width: 20, height: 20)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "resource/mystory")?.transfromImage(size: CGSize(width: 20, height: 20))
        headerView.addSubview(imageView)
        
        //我的一天
        let label = UILabel(frame: CGRect(x: imageView.frame.origin.x + imageView.frame.width * 1.5,
                                          y: 25 - 9,
                                          width: view_size.width,
                                          height: 18))
        label.textColor = wordColor
        label.font = UIFont(name: font_name, size: 18)
        label.text = "我的一天"
        label.textColor = subWordColor
        label.textAlignment = .left
        headerView.addSubview(label)
        
        //分割线
        let view = UIView(frame: CGRect(x: 0, y: 50 - 1, width: view_size.width, height: 1))
        view.backgroundColor = lightWordColor
        headerView.addSubview(view)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                return view_size.width
            case 1:
                return view_size.height * 0.1
            default:
                return view_size.width / 3
            }
        }
        
        return view_size.width / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0{
            
            let identifier = "\(indexPath.section)_\(indexPath.row)"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            if cell == nil{
                switch indexPath.row {
                case 0:
                    //四模块
                    cell = FirstCell(style: .default, reuseIdentifier: identifier)
                    (cell as! FirstCell).closure = {
                        dataCubeType in
                        
                        //进入详情页面
                        let detaiViewController = DetailViewController(detailType: dataCubeType, date: selectDate)
                        self.navigationController?.show(detaiViewController, sender: cell)
                    }
                case 1:
                    cell = CalendarCell(reuseIdentifier: identifier)
                default:
                    cell = SecondCell(indexPath.row, reuseIdentifier: identifier)
                    cell?.contentView.backgroundColor = tableView.backgroundColor
                }
            }
            
            //添加数据
            switch indexPath.row {
            case 0:
                //获取目标设定
                if let user = CoreDataHandler.share().selectUser(userId: UserManager.share().userId){
                    (cell as! FirstCell).goalStep = UInt32(user.goalStep)
                }
                
                if let user = CoreDataHandler.share().selectUser(userId: UserManager.share().userId){
                    var data = DataCubeData()
                    data.value1 = CGFloat(user.currentWeight)
                    data.value2 = CGFloat(user.goalWeight)
                    (cell as! FirstCell).weightDataCube.data = data
                }
                
                //定时器刷新
                (cell as! FirstCell).startTimer()
            case 1:
                (cell as! CalendarCell).date = selectDate

            default:
                break
            }
            
            return cell!
        }
        
        //今日故事 cell3
        let row = indexPath.row

        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //添加数据 .sleep, .calorie, .weight 混合
        if let track: Track = trackList[row]{
            //Type:运动类型(0x00:无， 0x01:走路， 0x02:跑步， 0x03:骑行，0x04:徒步， 0x05: 游泳， 0x06:爬山， 0x07:羽毛球， 0x08:其他， 0x09:健身， 0x0A:动感单车， 0x0B:椭圆机， 0x0C:跑步机， 0x0D:仰卧起坐， 0x0E:俯卧撑， 0x0F:哑铃， 0x10:举重， 0x11:健身操， 0x12:瑜伽， 0x13:跳绳， 0x14:乒乓球， 0x15:篮球， 0x16:足球 ， 0x17:排球， 0x18:网球， 0x19:高尔夫球， 0x1A:棒球， 0x1B:滑雪， 0x1C:轮滑，0x1D:跳舞)
            var type: SportType
            switch track.type {
            case 0x01:
                type = .walking
            case 0x02:
                type = .running
            case 0x03:
                type = .riding
            case 0x04:
                type = .hiking
            case 0x05:
                type = .swimming
            case 0x06:
                type = .climbing
            case 0x07:
                type = .badminton
            case 0x08:
                type = .other
            case 0x09:
                type = .physical
            case 0x0A:
                type = .bicycle
            case 0x0B:
                type = .ellipsoidBall
            case 0x0C:
                type = .treadmill
            case 0x0D:
                type = .situp
            case 0x0E:
                type = .pushup
            case 0x0F:
                type = .dumbbell
            case 0x10:
                type = .lifting
            case 0x11:
                type = .gymnastics
            case 0x12:
                type = .yoga
            case 0x13:
                type = .skipping
            case 0x14:
                type = .pingpong
            case 0x15:
                type = .basketball
            case 0x16:
                type = .football
            case 0x17:
                type = .vollyball
            case 0x18:
                type = .tennis
            case 0x19:
                type = .golf
            case 0x1A:
                type = .baseball
            case 0x1B:
                type = .skiing
            case 0x1C:
                type = .skating
            case 0x1D:
                type = .dancing
            default:
                type = .other
            }
            
            var value = StoryData()
            value.type = type
            value.date = track.date as? Date ?? Date()
            value.hour = track.durations / (60 * 60)
            value.minute = (track.durations - track.durations / (60 * 60)) / 60
            value.calorie = CGFloat(track.calories)
            value.heartRate = CGFloat(track.avgrageHeartrate)
            value.fat = CGFloat(track.burnFatMinutes)
            
            (cell as! ThirdCell).value = value
        }
        
        return cell!
    }
    
    //上拉下拉
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }
        
        newY = scrollView.contentOffset.y
        
        if #available(iOS 10.0, *) {
            if let refreshControl = tableView.refreshControl{
                if refreshControl.isRefreshing {
                    oldY = 0
                    return
                }
            }
        } else {
            let refreshControls = tableView.subviews.filter(){$0.isKind(of: UIRefreshControl.self)}
            if !refreshControls.isEmpty{
                oldY = 0
                return
            }
        }
        
        guard fabs(newY - oldY) > 100 else {
            return
        }

        if newY > oldY {
            navigationController?.setTabbar(hidden: true)
        }else{
            navigationController?.setTabbar(hidden: false)
        }
        
        oldY = newY
    }
}

//MARK:- 手势事件
extension StateVC: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard let v = touch.view, v.isKind(of: UIVisualEffectView.self) else {
            return false
        }
        
        let location = touch.location(in: view)
        if topView.topScrollView!.frame.contains(location) {
           return false
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return false
    }
}
