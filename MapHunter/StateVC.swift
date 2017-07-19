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

//附加数据高度
let thirdCellHeight: CGFloat = 120
let trackItemsHeight: CGFloat = 120

class StateVC: UIViewController {
    
    @IBOutlet weak var topView: TopView!            //日历
    @IBOutlet weak var tableView: UITableView!      //内容
    
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
    
    //选择线(我的活动，好友)
    fileprivate weak var selectedLine: UIView?
    fileprivate var switchTag: Int = 0{          //我的活动：0 好友：1 默认：0
        didSet{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                if self.switchTag == 0{
                    //我的活动
                    self.selectedLine?.frame.origin.x = 0
                }else{
                    //好友
                    self.selectedLine?.frame.origin.x = view_size.width / 2
                }
            }, completion: {
                complete in
                self.tableView.reloadData()
            })
        }
    }
    //获取时间轴数据
    fileprivate var trackList = [EachTrainningData](){
        didSet{
            tableView.reloadData()
        }
    }
    
    //标题
    private var canChangeTitle = true
    private var progressTask: Task?
    fileprivate var navigationTitle: String?{
        didSet{
            guard canChangeTitle else {
                return
            }
            cancel(progressTask)
            navigationController?.navigationBar.topItem?.title = navigationTitle
            progressTask = delay(3){
                if self.canChangeTitle{
                    self.navigationController?.navigationBar.topItem?.title = nil
                }
            }
        }
    }
    
    //进度条
    fileprivate var synProgress: SynProgress? = nil
    
    //MARK:- init ****************************************************************************************************************
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
        
        _ = AngelManager.share()
        
        //设置top title
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor]
        
        //设置返回navigation back
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        canChangeTitle = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationTitle = ""
        canChangeTitle = false
    }
    
    private func config(){
        
        //初始化当前选择的日期
        //selectDate = Date()
        
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
//            ctrl.attributedTitle = NSAttributedString(string: "同步健康数据")
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

        control.endRefreshing()
        guard !initFresh else {
//            self.endSynchronization()
            return
        }
        
        initFresh = true
        
        //判断是否有绑定设备
        let peripheral = PeripheralManager.share().currentPeripheral
        guard peripheral != nil else {
            DispatchQueue.main.async {
                self.navigationTitle = "手环未绑定"
                
                _ = delay(1){
                    self.initFresh = false
                }
            }
            return
        }
        
        guard peripheral?.state == CBPeripheralState.connected  else {
            DispatchQueue.main.async {
                
                self.navigationTitle = "手环未连接"
                _ = delay(1){
                    self.initFresh = false
                    self.endSynchronization()
                }
            }
            return
        }
        
//        control.attributedTitle = NSAttributedString(string: "同步数据")
        
//        beginLoading(byTitle: "同步健康与运动数据")
        
        //添加进度条
        synProgress = SynProgress()
        view.addSubview(synProgress!)
        
        navigationTitle = "同步数据"
        
        guard let angelManager = AngelManager.share() else{
            initFresh = false
            return
        }
        //初始化设置用户信息
        let userInfoModel = UserInfoModel()
        userInfoModel.birthDay = 27
        userInfoModel.birthMonth = 1
        userInfoModel.birthYear = 1988
        userInfoModel.gender = 1
        userInfoModel.height = 172
        userInfoModel.weight = 65
        angelManager.setUserInfo(userInfoModel){_ in}
        
        guard let satanManager = SatanManager.share() else{
            initFresh = false
            return
        }
        
        //同步数据
        satanManager.getSynchronizationActiveCount(angelManager.macAddress){
            count in
            angelManager.setSynchronizationHealthData{
                complete, progress in
                DispatchQueue.main.async {
                    var message: String
                    if complete{
                        message = count > 0 ? "正在同步运动数据..." : "同步完成"
                        debugPrint(message)
//                        control.attributedTitle = NSAttributedString(string: message)
                        self.navigationTitle = message
                        
                        self.tableView.reloadData()
                        
                        //同步时间轴
                        if count > 0{
                            satanManager.setSynchronizationActiveData{
                                complete, progress, timeout in
                                DispatchQueue.main.async {
                                    guard !timeout else{
                                        message = "同步运动数据超时"
//                                        control.attributedTitle = NSAttributedString(string: message)
                                        self.navigationTitle = message
                                        self.initFresh = false
                                        self.endSynchronization()
                                        return
                                    }
                                    
                                    if complete {
                                        
                                        message = "同步运动数据完成"
                                        self.navigationTitle = message
                                        self.endSynchronization()
                                        
                                        self.initFresh = false
                                        self.synProgress?.setProgress(progress: 100)
                                        
                                        //更新时间轴数据
                                        self.receiveConnectedMessage(notify: nil)
                                    }else{
                                        let realProgress = progress / 2 + 50
                                        message = "正在同步运动数据:\(realProgress)%"
                                        self.navigationTitle = message
                                        self.synProgress?.setProgress(progress: CGFloat(realProgress) / 2 + 50)
                                    }
                                }
                            }
                        }else{
                            self.initFresh = false
                            self.endSynchronization()
                        }
                    }else{
                        let realProgress = count > 0 ? progress / 2 : progress
                        message = "正在同步健康数据:\(realProgress)%"
                        debugPrint(message)
                        self.navigationTitle = message
                        self.synProgress?.setProgress(progress: CGFloat(realProgress))
                    }
                }
            }
        }
    }
    
    //MARK:- 结束同步
    private func endSynchronization(){
        _ = delay(1){
            self.synProgress?.removeFromSuperview()
            self.synProgress = nil
        }
    }
    
    //MARK:- 接收连接状态
    @objc func receiveConnectedMessage(notify: Notification?){
        
        initFresh = false
        
        //更新日期 获取calendarCell
        let indexPath = IndexPath(row: 1, section: 0)
        guard let calendarCell = tableView.cellForRow(at: indexPath) as? CalendarCell else{
            return
        }
        calendarCell.date = selectDate
        
        //显示连接成功信息
        //navigationTitle = "连接成功"
        
        //更新数据
        if let angelManager = AngelManager.share() {
            if let macaddress = angelManager.macAddress {
                trackList.removeAll()
                let userId = UserManager.share().userId
                let tracks = CoreDataHandler.share().selectEachTrainningDataList(withAccessoryId: macaddress, byUserId: userId, withDate: selectDate, withCDHRange: CDHRange.day).sorted{
                    track1, track2 -> Bool in
                    let earlyDate = track1.date?.earlierDate(track2.date! as Date)
                    if earlyDate == track1.date as Date?{
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
        
        //设置头
        let defaultCellHeight: CGFloat = 44         //默认cell高度 用于头部
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view_size.width, height: defaultCellHeight))
        headerView.backgroundColor = .clear

        //设置切换按钮
        //[我的活动]
        let myActiveFrame = CGRect(x: 0, y: 0, width: view_size.width / 2, height: 44)
        let myActive = UIButton(frame: myActiveFrame)
        myActive.setTitle("我的活动", for: .normal)
        myActive.setTitleColor(subWordColor, for: .normal)
        myActive.setTitleColor(lightWordColor, for: .disabled)
        myActive.backgroundColor = .white
        myActive.isSelected = true
        myActive.tag = 0
        myActive.addTarget(self, action: #selector(switchFromHeader(byButton:)), for: .touchUpInside)
        headerView.addSubview(myActive)
        
        //[好友]
        let myFriendsFrame = CGRect(x: view_size.width / 2, y: 0, width: view_size.width / 2, height: defaultCellHeight)
        let myFriends = UIButton(frame: myFriendsFrame)
        myFriends.setTitle("好友", for: .normal)
        myFriends.setTitleColor(subWordColor, for: .normal)
        myFriends.setTitleColor(lightWordColor, for: .disabled)
        myFriends.backgroundColor = .white
        myFriends.isSelected = false
        myFriends.tag = 1
        myFriends.addTarget(self, action: #selector(switchFromHeader(byButton:)), for: .touchUpInside)
        headerView.addSubview(myFriends)
        
        //[选择线]
        if selectedLine == nil{
            let selectedHeight: CGFloat = 2
            var selectedLineFrame = CGRect(x: 0, y: defaultCellHeight - selectedHeight, width: view_size.width / 2, height: selectedHeight)
            if switchTag == 0{
                selectedLineFrame.origin.x = 0
            }else{
                selectedLineFrame.origin.x = view_size.width / 2
            }
            let line = UIView(frame: selectedLineFrame)
            line.backgroundColor = subWordColor
            selectedLine = line
            headerView.addSubview(line)
        }
        
        return headerView
    }
    
    //MARK:- 切换按钮点击事件
    @objc private func switchFromHeader(byButton button: UIButton){
        switchTag = button.tag
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        
        return trackList.count + 1   //运动数 + 哈博士
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 49
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let footerFrame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 49)
        let footer = UIView(frame: footerFrame)
        footer.backgroundColor = timeColor
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                return view_size.width / dataCubeAspectRatio    //四个模块整体比例为dataCubeAspectRatio
            case 1:
                return 44                                       //日历切换高度为默认固定cell高度
            default:
                return view_size.width / 3                      //时间轴类型高度 需动态设置
            }
        }
        
        let row = indexPath.row
        if row == 0 {
            return view_size.width / 2                          //哈博士高度
        }
        
        //需根据内容判断时间轴高度(是否包含步数，是否包含路径)
        if let track: EachTrainningData = trackList[row - 1] as? EachTrainningData{
            //Type:运动类型(0x00:无， 0x01:走路， 0x02:跑步， 0x03:骑行，0x04:徒步， 0x05: 游泳， 0x06:爬山， 0x07:羽毛球， 0x08:其他， 0x09:健身， 0x0A:动感单车， 0x0B:椭圆机， 0x0C:跑步机， 0x0D:仰卧起坐， 0x0E:俯卧撑， 0x0F:哑铃， 0x10:举重， 0x11:健身操， 0x12:瑜伽， 0x13:跳绳， 0x14:乒乓球， 0x15:篮球， 0x16:足球 ， 0x17:排球， 0x18:网球， 0x19:高尔夫球， 0x1A:棒球， 0x1B:滑雪， 0x1C:轮滑，0x1D:跳舞)
            var value = StoryData()
            value.type = SportType(rawValue: track.type)!
            value.heartRate = CGFloat(track.averageHeartRate)
            
            if !track.hasGPSLogger{
                return thirdCellHeight                  //时间轴高度
            }
        }
        return thirdCellHeight + trackItemsHeight       //时间轴高度(带图表)
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
                        let detailVC = DetailVC(detailType: dataCubeType, date: nil, isDetail: true)
                        self.navigationController?.show(detailVC, sender: cell)
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
                if let goal = CoreDataHandler.share().currentUser()?.goal{
                    (cell as! FirstCell).goalStep = UInt32(goal.steps)
                }
                
                if let user = CoreDataHandler.share().currentUser(){
                    var data = DataCubeData()
                    data.value1 = CGFloat(CoreDataHandler.share().selectWeightDataList(withUserId: UserManager.share().userId, withDate: Date()).last!.weight10000TimesKG)
                    data.value2 = CGFloat(user.goal!.weight10000TimesKG)
                    (cell as! FirstCell).mindBodyDataCube.data = data
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
        
        let row = indexPath.row
        //section == 1
        if row == 0{
            //哈博士
            cell = tableView.dequeueReusableCell(withIdentifier: "ha")
            if cell == nil {
                cell = HaTip(reuseIdentifier: "ha")
            }
            let haTipCell = cell as! HaTip
            var list = [HaData]()
            (0..<3).forEach{
                i in
                var haData = HaData()
                haData.title = "定下目标"
                haData.text = "its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i) its text \(i)"
                list.append(haData)
            }
            haTipCell.dataList = list
            return cell!
        }

        //时间轴
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let thirdCell = cell as! ThirdCell
        //添加数据 .sleep, .calorie, .weight 混合
        if let track: EachTrainningData = trackList[row - 1] as? EachTrainningData{
            //Type:运动类型(0x00:无， 0x01:走路， 0x02:跑步， 0x03:骑行，0x04:徒步， 0x05: 游泳， 0x06:爬山， 0x07:羽毛球， 0x08:其他， 0x09:健身， 0x0A:动感单车， 0x0B:椭圆机， 0x0C:跑步机， 0x0D:仰卧起坐， 0x0E:俯卧撑， 0x0F:哑铃， 0x10:举重， 0x11:健身操， 0x12:瑜伽， 0x13:跳绳， 0x14:乒乓球， 0x15:篮球， 0x16:足球 ， 0x17:排球， 0x18:网球， 0x19:高尔夫球， 0x1A:棒球， 0x1B:滑雪， 0x1C:轮滑，0x1D:跳舞)
            var value = StoryData()
            value.type = SportType(rawValue: track.type)!
            value.date = track.date as Date? ?? Date()
            value.hour = Int16(track.durationS / (60 * 60))
            value.minute = Int16((track.durationS - track.durationS / Int32(60 * 60)) / Int32(60))
            value.calorie = CGFloat(track.calories)
            value.heartRate = CGFloat(track.averageHeartRate)
            value.fat = CGFloat(track.burnFatMinutes)
            
            thirdCell.track = track                                                             //所有数据
            thirdCell.trackViewHeight = track.hasGPSLogger ? trackItemsHeight : 0               //设置附加高度
            thirdCell.closure = {
                trk in
                let trackVC = TrackVC(with: trk)
                self.navigationController?.show(trackVC, sender: nil)
            }
        }
        
        return cell!
    }
    
    //上拉下拉
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }
        
        //判断+号按钮是否打开
        let rootTBC = self.tabBarController as! RootTBC
        guard !rootTBC.menuButtonFlag else {
            return
        }
        
        newY = scrollView.contentOffset.y
        
        if newY <= 100 || initFresh{
            oldY = 0
            navigationController?.setTabbar(hidden: false)
            
            //禁止上滑回弹
            if newY > scrollView.contentSize.height - scrollView.bounds.height{
                newY = scrollView.contentSize.height - scrollView.bounds.height
                scrollView.setContentOffset(CGPoint(x: 0, y: newY), animated: false)
                oldY = newY
            }
            return
        }
        
        //禁止上滑回弹
        if newY > scrollView.contentSize.height - scrollView.bounds.height{
            newY = scrollView.contentSize.height - scrollView.bounds.height
            scrollView.setContentOffset(CGPoint(x: 0, y: newY), animated: false)
            oldY = newY
            return
        }
        
        guard fabs(newY - oldY) > 150 else {
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
