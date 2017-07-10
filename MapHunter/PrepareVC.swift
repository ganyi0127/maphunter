//
//  PrepareVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/28.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit

private let typeImageLength: CGFloat = 80

@IBDesignable
class PrepareVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var gpsImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var singleTargetButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var finishedContainerView: UIView!
    private weak var finishedVC: FinishedVC?
    
    private var settingButtonItem: UIBarButtonItem? = nil
    
    //@IBInspectable var circleRadius: CGFloat = 1
    
    //判断是否有轨迹图
    var track: Track?{
        didSet{
            print(track == nil ? "无轨迹" : "有轨迹")
            //绘制轨迹线
            /*
            guard let trk = track else {
                return
            }
             */
            tipLabel.isHidden = true
            startButton.isHidden = true
            singleTargetButton.isHidden = true
            scrollView?.isScrollEnabled = false
            finishedContainerView.isHidden = false
            
            //将运动类型图标移到前层
            view.bringSubview(toFront: scrollView!)
            
            //添加结束内容
            finishedVC?.duration = track?.durations
            finishedVC?.distance = track?.distance
            finishedVC?.caloria = track?.calories
            finishedVC?.count = 1
            if let durations = track?.durations, let distance = track?.distance{
                if distance == 0{
                    finishedVC?.pace = 0
                }else{                    
                    finishedVC?.pace = Double(durations) / distance
                }
            }
            finishedVC?.heartrate = track?.avgrageHeartrate
            //绘制轨迹
        }
    }
    
    fileprivate var scrollView: UIScrollView?
    fileprivate var selectedPage = 0{
        didSet{
            switch selectedPage {
            case 0:
                navigationController?.navigationBar.topItem?.title = "步行"
            case 1:
                navigationController?.navigationBar.topItem?.title = "骑行"
            case 2:
                navigationController?.navigationBar.topItem?.title = "徒步"
            default:
                navigationController?.navigationBar.topItem?.title = "跑步"
            }
        }
    }
    private let walkingImg = UIImage(named: "resource/map/type/walking")?.transfromImage(size: CGSize(width: typeImageLength, height: typeImageLength))
    private let hikingImg = UIImage(named: "resource/map/type/hiking")?.transfromImage(size: CGSize(width: typeImageLength, height: typeImageLength))
    private let runningImg = UIImage(named: "resource/map/type/running")?.transfromImage(size: CGSize(width: typeImageLength, height: typeImageLength))
    private let ridingImg = UIImage(named: "resource/map/type/riding")?.transfromImage(size: CGSize(width: typeImageLength, height: typeImageLength))
    private lazy var sportTypeImgMap: [ActiveSportType: UIImage?] = [.walking: self.walkingImg, .hiking: self.hikingImg, .running: self.runningImg, .riding: self.ridingImg]
    
    
    //MARK:-init******************************************************************************************
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if CLLocationManager.locationServicesEnabled(){
            globalLocationManager.startUpdatingLocation()
            
        }else{
            debugPrint("无法开启定位")
        }
        globalLocationManager.delegate = self
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        startButton.layer.cornerRadius = startButton.bounds.height / 2
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.backItem?.title = " "
        
        //初始化运动类型选项
        selectedPage = 0
        scrollView?.setContentOffset(.zero, animated: true)
        
        //添加设置按钮
        if settingButtonItem == nil{
            let img = UIImage(named: "resource/map/setting")

            let settingFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let button = UIButton(type: UIButtonType.roundedRect)
            button.frame = settingFrame
            button.setImage(img, for: .normal)
            button.addTarget(self, action: #selector(setting(_:)), for: .touchUpInside)
            
            settingButtonItem = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = settingButtonItem
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        globalLocationManager.stopUpdatingLocation()    //停止定位
        globalLocationManager.delegate = nil
        
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finished" {
            finishedVC = segue.destination as? FinishedVC
        }
    }
    
    private func config(){
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading    //当前地图跟踪模式
        mapView.mapType = MKMapType.standard //普通地图
        mapView.showsUserLocation = true
    }
    
    private func createContents(){
        
        //添加运动类型滑块
        let scrollFrame = CGRect(x: 0, y: -typeImageLength / 4, width: view_size.width , height: typeImageLength)
        scrollView = UIScrollView(frame: scrollFrame)
        scrollView?.contentSize = CGSize(width: scrollFrame.width * 4, height: scrollFrame.height)
        scrollView?.isPagingEnabled = true
        scrollView?.backgroundColor = .clear
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        backView.addSubview(scrollView!)
        
        //添加运动类型选项
        for (index, element) in sportTypeImgMap.enumerated(){
            let x = CGFloat(index) * scrollFrame.width
            let imageViewFrame = CGRect(x: x, y: 0, width: scrollFrame.width, height: scrollFrame.height)
            let imageView = UIImageView(frame: imageViewFrame)
            imageView.image = element.value
            let progress = (scrollView!.contentOffset.x - x) / scrollFrame.width
            imageView.layer.transform = menuTransformForPercent(progress, index: index)
            scrollView?.addSubview(imageView)
        }
    }
    
    //MARK:-设置
    @objc private func setting(_ sender: Any) {
        pushSetting()
    }
    
    //MARK:-开始
    @IBAction func start(_ sender: Any) {
        pushMap()
    }
    
    //MARK:-设置单次目标
    @IBAction func setTarget(_ sender: Any) {
        pushSingleTarget()
    }
    
    //MARK:-跳转到设置页面
    private func pushSetting(){
        let settingPathVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "settingpath") as! SettingPathVC
        navigationController?.pushViewController(settingPathVC, animated: true)
    }
    
    //MARK:-跳转地图开始
    private func pushMap(){
        let premapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "premap") as! PremapVC
        premapVC.activeType = ActiveSportType(rawValue: selectedPage)
        navigationController?.pushViewController(premapVC, animated: true)
    }
    
    //MARK:-跳转到单次目标设置页面
    private func pushSingleTarget(){
        let settingPathVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "settingpath") as! SettingPathVC
        navigationController?.pushViewController(settingPathVC, animated: true)
    }
    
    //MARK:-更新gps显示
    fileprivate func updateMap(gps status: MapGPSStatus) {
        var imgName: String
        switch status {
        case .high:
            imgName = "resource/map/gps/high"
        case .middle:
            imgName = "resource/map/gps/middle"
        case .low:
            imgName = "resource/map/gps/low"
        case .disConnect:
            imgName = "resource/map/gps/disconnect"
        case .close:
            imgName = "resource/map/gps/disconnect"
        }
        let image = UIImage(named: imgName)
        gpsImageView.image = image
    }
}

//MARK:-scroll delegate(选择运动类型)
extension PrepareVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let subviews = scrollView.subviews
        subviews.enumerated().forEach(){
            index, subView in
            
            subView.layer.transform = CATransform3DIdentity
            let progress = (scrollView.contentOffset.x - subView.frame.origin.x) / scrollView.frame.width
            subView.layer.transform = menuTransformForPercent(progress, index: index)
        }
    }
    
    //滑动结束回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let subviews = scrollView.subviews
        let pageWidth = scrollView.bounds.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        if page < subviews.count{
            selectedPage = page
        }
    }
    
    //矩阵变换
    func menuTransformForPercent(_ percent: CGFloat, index: Int) -> CATransform3D {

        var remainingPercent = 1 - fabs(percent)
        if remainingPercent < 0.5{
            remainingPercent = 0.5
        }
        
        let tx = scrollView!.bounds.width * -percent * 0.15 + (scrollView!.contentOffset.x / scrollView!.bounds.width - CGFloat(index)) * scrollView!.bounds.width - typeImageLength / 2 * 0
        
        let identity = CATransform3DIdentity
        let translationTransform = CATransform3DTranslate(identity, tx, 0, 0)
        let scaleTransform = CATransform3DScale(translationTransform, scrollView!.frame.height / scrollView!.frame.width * remainingPercent, remainingPercent, 1)
        return scaleTransform
    }
}

//MARK:-location delegate(更新gps信息)
extension PrepareVC: CLLocationManagerDelegate{
    //开始定位追踪_返回位置信息数组
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        
        //获取最后记录点
        guard let location = locations.last else {
            print("location get last error!")
            return
        }
        
        //展示信号强度
        if fabs(location.horizontalAccuracy) <= 5 {
            updateMap(gps: .high)
        }else if fabs(location.horizontalAccuracy) <= 15{
            updateMap(gps: .middle)
        }else{
            updateMap(gps: .low)
        }
    }
}
