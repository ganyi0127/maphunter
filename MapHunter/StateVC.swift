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

    //sdk
//    private lazy var angelManager: AngelManager? = {
//        return AngelManager.share()
//    }()
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        createContents()
    }
    
    private func config(){
        
        //初始化当前选择的日期
        selectDate = Date()
        
        //清除顶部空白区域
        automaticallyAdjustsScrollViewInsets = false
        
        //设置背景
        view.backgroundColor = defaultColor
        tableView.backgroundColor = defaultColor

    }
    
    private func createContents(){
        
        topView.closure = {
            date in
            
            print("date: \(date)")
            self.tableView.reloadData()
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
            ctrl.backgroundColor = nil
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
        control.beginRefreshing()
        //加载数据
        refreshStateChange(control)
    }
    
    //MARK:- 刷新调用
    private var initFresh = true
    @objc private func refreshStateChange(_ control: UIRefreshControl){

        guard !initFresh else {
            initFresh = false
            control.endRefreshing()
            return
        }
        
        //判断是否有绑定设备
        let peripheral = PeripheralManager.share().currentPeripheral
        guard peripheral != nil else {
            DispatchQueue.main.async {
                control.attributedTitle = NSAttributedString(string: "未绑定")
                _ = delay(1){
                    control.endRefreshing()
                }
            }
            return
        }
        
        guard peripheral?.state == CBPeripheralState.connected  else {
            DispatchQueue.main.async {
                control.attributedTitle = NSAttributedString(string: "未连接")
                _ = delay(1){
                    control.endRefreshing()
                }
            }
            return
        }
        
        control.attributedTitle = NSAttributedString(string: "同步健康数据")
        
        
        
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
        
        //同步数据
        angelManager?.setSynchronizationHealthData{
            complete, progress in
            if complete{
                DispatchQueue.main.async {
                    debugPrint("同步完成")
                    control.attributedTitle = NSAttributedString(string: "同步完成")
                    control.endRefreshing()
                }
            }else{
                DispatchQueue.main.async {
                    debugPrint("正在同步:\(progress)")
                    control.attributedTitle = NSAttributedString(string: "已同步\(progress)%")
                }
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
        
        return 34
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
//                    cell = DetailCell(reuseIdentifier: identifier)
//                    (cell as! DetailCell).closure = {
//                        detailType in
//                        //选中回调
//                        print("selected: \(detailType)")
//                        let detaiViewController = DetailViewController(detailType: detailType)
//                        self.navigationController?.show(detaiViewController, sender: cell)
//                    }
                    cell = CalendarCell(reuseIdentifier: identifier)
                default:
                    cell = SecondCell(indexPath.row, reuseIdentifier: identifier)
                    cell?.contentView.backgroundColor = tableView.backgroundColor
                }
            }
            
            //添加数据
            switch indexPath.row {
            case 0:
//                (cell as! FirstCell).step = 1367
//                (cell as! FirstCell).calorie = 144
//                (cell as! FirstCell).distance = 5
//                (cell as! FirstCell).time = 123
                break
            case 1:
                (cell as! CalendarCell).date = selectDate

            default:
                break
            }
            
            return cell!
        }
        
        //今日故事 cell3
        let row = indexPath.row
        let testList: [SportType] = [.walking, .running, .badminton, .basketball, .riding, .swimming, .climbing, .badminton, .physical, .bicycle, .ellipsoidBall, .treadmill, .boating, .situp, .pushup, .dumbbell, .lifting, .gymnastics, .yoga, .sleep, .calorie, .weight]

        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        guard row < testList.count else{
            var value = StoryData()
            value.type = .other
            value.date = Date()
            value.hour = 7
            value.minute = 9
            value.calorie = 123
            value.heartRate = 101
            value.fat = 202
            
            (cell as! ThirdCell).value = value
            return cell!
        }
        var value = StoryData()
        value.type = testList[row]
        value.date = Date()
        value.hour = 7
        value.minute = 9
        value.calorie = 123
        value.heartRate = 101
        value.fat = 202
        
        (cell as! ThirdCell).value = value
        
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
