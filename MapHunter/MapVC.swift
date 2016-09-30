//
//  ViewController.swift
//  MapHunter
//
//  Created by ganyi on 16/9/21.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AudioToolbox

class MapVC: UIViewController {

    //位置管理器
    lazy private var locationManager = { () -> CLLocationManager in
        
        let locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   //精确度
        locationManager.distanceFilter = 5                          //位置更新距离限制

        //开启定位
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined &&
            locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)){
            
            locationManager.requestAlwaysAuthorization()  //请求允许访问
        }
        
        return locationManager
    }()
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    
    //移动总距离
    fileprivate var totalDistance:Double?{
        didSet{
            guard let distance = self.totalDistance else {
                totalDistanceLabel.text = "..."
                return
            }
            totalDistanceLabel.text = "移动距离:\(distance)"
        }
    }
    
    //保存最新添加的overlay,用于修正删除
    fileprivate var newOverlay:MKOverlay?
    
    //反编码
    lazy fileprivate var geocoder = {
        return CLGeocoder()
    }()
    
    //地图视图
    @IBInspectable
    @IBOutlet weak var mapView: MKMapView!
    
    //默认按钮尺寸
    let button_rect = CGRect(x: view_size.width - view_size.width / 3,
                             y: 0,
                             width: view_size.width / 3,
                             height: view_size.height / 16)
    
    //编辑按钮
    private var isEdit = false
    private var editButtons = [UIButton]()
    private let buttonTitles = ["开始记录", "分享1", "分享2", "分享3"]
    
    //重定位按钮
    @IBOutlet weak var relocationButton: UIButton!
    
    //MARK:导航
    //当前选择的大头针
    fileprivate var selectAnnotationView:MKAnnotationView?
    
    //MARK:保存实时位置
    fileprivate var locationList = [(latitude: Double, longitude: Double)]()
    
    //是否开始录制路径
    fileprivate var isRecording = false{
        didSet{
            
            let recordButton = editButtons[0]
            recordButton.setTitle(isRecording ? "停止记录" : "开始记录", for: .normal)
            recordButton.backgroundColor = isRecording ? .green : .red
            
            if isRecording{                
                //清空记录数据
                totalDistance = 0
                locationList.removeAll()
                mapView.removeOverlays(mapView.overlays)
                
            }else{
                
                //重置记录数据
                
                //分享路线
            }
        }
    }
    
    //MARK:存储sprite
    fileprivate var spriteDataList = [SpriteData]()
    
    //MARK:- init -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func config(){
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            print("无法开启定位")
        }
        
        locationManager.delegate = self
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading    //当前地图跟踪模式
        mapView.mapType = MKMapType.standard //普通地图
        mapView.showsUserLocation = true
        
        //添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapVC.addAnnotation(tap:)))
        mapView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(MapVC.addAnnotation(tap:)))
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)
        
        //初始化编辑按钮
        buttonTitles.enumerated().forEach(){
            index, title in
            
            let button = UIButton(type: .system)
            button.frame = button_rect
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
            button.layer.cornerRadius = button.frame.height / 4
            button.layer.opacity = 0
            button.tag = index
            
            button.addTarget(self, action: #selector(MapVC.onEdit(sender:)), for: .touchUpInside)
            
            editButtons.append(button)
            view.addSubview(button)
        }
        
        relocationButton.layer.cornerRadius = button_rect.height / 4
        relocationButton.backgroundColor = .red
        relocationButton.setTitleColor(.white, for: .normal)
    }
    
    private func createContents(){
        
        
    }
    
    //MARK:测试添加大头针
    @objc private func addAnnotation(tap: UITapGestureRecognizer){
        
        if tap.numberOfTapsRequired == 1{
            //单次点击
            let touchPoint = tap.location(in: tap.view)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: tap.view)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            //监控区域
            let region = CLCircularRegion(center: coordinate, radius: 50, identifier: "sprite")
            locationManager.startMonitoring(for: region)

            //反地理编码
            geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) {
                placemarks, error in
                
                guard error == nil else{
                    print("创建大头针 geocoder回调错误:\n\(error)")
                    return
                }
                
                guard let placemark = placemarks?.last else{
                    return
                }
                
                annotation.title = placemark.name
                annotation.subtitle = "\(placemark.location!)"
            }
        }else{
            //双击
        }
    }
    
    //MARK:重置位置
    @IBAction func relocation(_ sender: UIButton) {
        
        let center = mapView.userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:编辑按钮
    @IBAction func edit(_ sender: UIBarButtonItem) {
        
        isEdit = !isEdit

        editButtons.enumerated().forEach(){
            index, button in
            
            let sortAnim = CABasicAnimation(keyPath: "position.y")
            sortAnim.fromValue = isEdit ? 0 : navigation_height! * 2 + CGFloat(index) * button.frame.height + UIApplication.shared.statusBarFrame.height
            sortAnim.toValue = isEdit ? navigation_height! * 2 + CGFloat(index) * button.frame.height * 1.1 + UIApplication.shared.statusBarFrame.height : 0
            
            let fadeAnim = CABasicAnimation(keyPath: "opacity")
            fadeAnim.fromValue = isEdit ? 0 : 1
            fadeAnim.toValue = isEdit ? 1 : 0
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.5
            groupAnim.isRemovedOnCompletion = true
            groupAnim.fillMode = kCAFillModeBoth
            groupAnim.animations = [sortAnim, fadeAnim]
            
            button.layer.add(groupAnim, forKey: nil)
            
            button.frame.origin.y = isEdit ? navigation_height! * 2 + CGFloat(index) * button.frame.height * 1.1 : 0
            button.layer.opacity = isEdit ? 1 : 0
        }
    }
    
    @objc private func onEdit(sender: UIButton){
        
        switch sender.tag {
        case 0:
            
            isRecording = !isRecording
            
        default:
            break
        }
    }
}

//MARK:navigation_buttons
extension MapVC{

}

//MARK:- Map代理
extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    //MARK:更新位置时调用
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        guard let location = userLocation.location else {
            return
        }
        
        userLocation.title = "curLocation"
        userLocation.subtitle = "gan"
        
        //反编码
        geocoder.reverseGeocodeLocation(location){
            placemarks, error in
            
            guard let placemark = placemarks?.last else{
                return
            }

            userLocation.title = "local" + (placemark.name ?? "")
            userLocation.subtitle = "\(placemark.location!)"
        }
        
        
//        //绘制运动路径
//        guard isRecording else {
//            return
//        }
//        
//        
//        if locationList.isEmpty{
//            
//            //放置起始点
//            locationList.append((latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
//            
//        }else{
//            
//            //获取最新位置数据
//            guard let startCoordinateTuple = locationList.last else{
//                print("获取最新位置数据错误")
//                return
//            }
//            
//            let startCoordinate = CLLocationCoordinate2D(latitude: startCoordinateTuple.latitude, longitude: startCoordinateTuple.longitude)
//            
//            //获取当前位置数据
//            let endCoordinate = location.coordinate
//            
//            //计算距离
//            var distance = calculateDistance(start: startCoordinate, end: endCoordinate)
//            print("移动距离:\(distance)米")
//            
//            
//            if distance >= 10 {
//                
//                var currentLocationList = [startCoordinate, endCoordinate]
//                
//                //获取倒数第二个点位置_筛选坐标_判断移动位置是否真实
//                if locationList.count >= 2{
//                    let preCoordinateTuple = locationList[locationList.count - 2]
//                    let preCoordinate = CLLocationCoordinate2D(latitude: preCoordinateTuple.latitude, longitude: preCoordinateTuple.longitude)
//                    let distanceBetweenPreCoordinateToStart = calculateDistance(start: preCoordinate, end: startCoordinate)
//                    
//                    let distanceBetweenPreCoordinateToEnd = calculateDistance(start: preCoordinate, end: endCoordinate)
//                    
//                    //如果当前移动的距离与之前的距离比小于正三角，则修正
//                    if distanceBetweenPreCoordinateToEnd < distance || distanceBetweenPreCoordinateToEnd < distanceBetweenPreCoordinateToStart{
//                        
//                        //移除之前定位的坐标点
//                        locationList.removeLast()
//                        //移除最新添加的overlay
//                        if let overlay:MKOverlay = newOverlay{
//                            
//                            mapView.remove(overlay)
//                            newOverlay = nil
//                        }
//                        //修正需绘制的路径
//                        currentLocationList = [preCoordinate, endCoordinate]
//                        //修改之前添加的距离
//                        if let currentDistance = totalDistance{
//                            totalDistance = currentDistance - distanceBetweenPreCoordinateToStart
//                        }
//                        
//                        //修正distance值为倒数第二个位置与当前位置距离
//                        distance = distanceBetweenPreCoordinateToEnd
//                        
//                        print("坐标修正:\(locationList.count)")
//                    }
//                }
//                
//                locationList.append((latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
//                
//                //绘制路径
//                newOverlay = MKPolyline(coordinates: currentLocationList, count: 2)
//                mapView.add(newOverlay!)
//                
//                //记录总距离
//                if let currentDistance = totalDistance{
//                    totalDistance = currentDistance + distance
//                }
//            }
//        }
        
        //判断精灵是否可捕获
        
    }
    
    //MARK:距离计算
    fileprivate func calculateDistance(start:CLLocationCoordinate2D, end:CLLocationCoordinate2D) -> Double{

        let startLongitude = start.longitude
        let startLatitude = start.latitude
        let endLongitude = end.longitude
        let endLatitude = end.latitude
        
        let radLatitude1 = startLatitude * M_PI / 180
        let radLatitude2 = endLatitude * M_PI / 180
        let a = fabs(radLatitude1 - radLatitude2)
        let b = fabs(startLongitude * M_PI / 180 - endLongitude * M_PI / 180)
        
        let s = 22 * asin(sqrt(pow(sin(a / 2), 2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b / 2), 2))) * 6378137
        return round(s * 10000) / Double(10000)
    }
    
    //MARK:更新显示区域时调用will
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    //MARK:更新显示区域时调用did
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    
    //MARK:添加大头针时调用(添加大头针动画)
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {

        let visibleRect = mapView.annotationVisibleRect
        views.forEach(){
            annotationView in
            
            //忽略蓝色小标
            if annotationView.annotation!.isKind(of: MKPointAnnotation.classForCoder()){
                
                let endPosY = annotationView.layer.position.y
                let startPosY = endPosY - visibleRect.size.height
                
                //添加掉落动画
                let dropAnim = CABasicAnimation(keyPath: "position.y")
                dropAnim.fromValue = startPosY
                dropAnim.toValue = endPosY
                dropAnim.duration = 1
                dropAnim.fillMode = kCAFillModeBoth
                dropAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                
                annotationView.layer.add(dropAnim, forKey: nil)
            }
        }
    }
    
    //MARK:选中大头针
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        selectAnnotationView = view
    }
    
    //MARK:取消选中大头针
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        selectAnnotationView = nil
    }
    
    //MARK:返回自定义大头针 nil 返回自定义大头针
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        //忽略蓝色小标
        guard annotation.isKind(of: MKPointAnnotation.classForCoder()) else {
            return nil
        }
        
        let identify = "sprite"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identify)
        if annotationView == nil {
            
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identify)
            (annotationView?.leftCalloutAccessoryView as! UIButton).addTarget(self, action: #selector(MapVC.onAnnotationClick(sender:)), for: .touchUpInside)
            (annotationView?.rightCalloutAccessoryView as! UIButton).addTarget(self, action: #selector(MapVC.onAnnotationClick(sender:)), for: .touchUpInside)
        }
        
        return annotationView
    }
    
    //MARK:annotation点击
    @objc private func onAnnotationClick(sender: UIButton){
        
        guard let currentAnnotationView = selectAnnotationView else {
            return
        }
        
        if sender.tag == 0{
            //左信息
            currentAnnotationView.removeFromSuperview()
            selectAnnotationView = nil
            
        }else{
            //右信息
            guard let annotation = currentAnnotationView.annotation else {
                return
            }
            
            let message = "target coordinate:\n\(annotation.coordinate.latitude)\n\(annotation.coordinate.longitude)"
            let alertController = UIAlertController(title: annotation.title!,
                                                    message: message, preferredStyle: .actionSheet)
            let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancleAction)
            
            let setAction = UIAlertAction(title: "设置为目标", style: .default){
                action in
                
                //移除之前的所有导航
                self.mapView.removeOverlays(self.mapView.overlays)
                
                //导航
                let req = MKDirectionsRequest()
                req.transportType = MKDirectionsTransportType.walking
                
                let localPlace = MKMapItem(placemark: MKPlacemark(coordinate: self.mapView.userLocation.coordinate,
                                                                  addressDictionary: ["name": "local"]))
                req.source = localPlace
                
                let targetPlace = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate,
                                                                   addressDictionary: ["name": "target"]))
                req.destination = targetPlace
                
                
                let direction = MKDirections(request: req)
                direction.calculate(){
                    res, error in
                    if let polyline = res?.routes.first?.polyline{
                        self.mapView.add(polyline, level: MKOverlayLevel.aboveLabels)
                    }
                }
                
                //距离计算
                let localPlaceLocation = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude,
                                                    longitude: self.mapView.userLocation.coordinate.longitude)
                let targetPlaceLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let distance = localPlaceLocation.distance(from: targetPlaceLocation)
                print("距离:\(distance)米")
                
                let coordinateRegin = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate,
                                                                         2 * distance, 2 * distance)
                self.mapView.setRegion(coordinateRegin, animated: true)
                
            }
            alertController.addAction(setAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:获取位置失败时调用
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("loadingMapFailed!")
    }
    
    //MARK:线路绘制
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        print("overlay")
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 2
        renderer.strokeColor = .orange
        return renderer
    }
}

//MARK: - location delegate
extension MapVC:CLLocationManagerDelegate{
    
    //开始定位追踪_返回位置信息数组
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location:\(locations)")
        
        guard let location = locations.last else {
            print("location get last error!")
            return
        }

        //绘制运动路径
        guard isRecording else {
            return
        }
        
        
        if locationList.isEmpty{
            
            //放置起始点
            locationList.append((latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            
        }else{
            
            //获取最新位置数据
            guard let startCoordinateTuple = locationList.last else{
                print("获取最新位置数据错误")
                return
            }
            
            let startCoordinate = CLLocationCoordinate2D(latitude: startCoordinateTuple.latitude, longitude: startCoordinateTuple.longitude)
            
            //获取当前位置数据
            let endCoordinate = location.coordinate
            
            //计算距离
            var distance = calculateDistance(start: startCoordinate, end: endCoordinate)
            print("移动距离:\(distance)米")
            
            
            if distance >= 10 {
                
                var currentLocationList = [startCoordinate, endCoordinate]
                
                //获取倒数第二个点位置_筛选坐标_判断移动位置是否真实
                if locationList.count >= 2{
                    let preCoordinateTuple = locationList[locationList.count - 2]
                    let preCoordinate = CLLocationCoordinate2D(latitude: preCoordinateTuple.latitude, longitude: preCoordinateTuple.longitude)
                    let distanceBetweenPreCoordinateToStart = calculateDistance(start: preCoordinate, end: startCoordinate)
                    
                    let distanceBetweenPreCoordinateToEnd = calculateDistance(start: preCoordinate, end: endCoordinate)
                    
                    //如果当前移动的距离与之前的距离比小于正三角，则修正
                    if distanceBetweenPreCoordinateToEnd < distance || distanceBetweenPreCoordinateToEnd < distanceBetweenPreCoordinateToStart{
                        
                        //移除之前定位的坐标点
                        locationList.removeLast()
                        //移除最新添加的overlay
                        if let overlay:MKOverlay = newOverlay{
                            
                            mapView.remove(overlay)
                            newOverlay = nil
                        }
                        //修正需绘制的路径
                        currentLocationList = [preCoordinate, endCoordinate]
                        //修改之前添加的距离
                        if let currentDistance = totalDistance{
                            totalDistance = currentDistance - distanceBetweenPreCoordinateToStart
                        }
                        
                        //修正distance值为倒数第二个位置与当前位置距离
                        distance = distanceBetweenPreCoordinateToEnd
                        
                        print("坐标修正:\(locationList.count)")
                    }
                }
                
                locationList.append((latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                
                //绘制路径
                newOverlay = MKPolyline(coordinates: currentLocationList, count: 2)
                mapView.add(newOverlay!)
                
                //记录总距离
                if let currentDistance = totalDistance{
                    totalDistance = currentDistance + distance
                }
            }
        }
    }
    
    //进入某个区域调用
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let alertController = UIAlertController(title: "进入区域", message: "\(region)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //离开某个区域调用
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("leaveRegion:\(region)")
    }
    
    //MARK:定位状态变化
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            statusLabel.text = "定位未授权"
        case .denied:
            statusLabel.text = "定位禁止"
            if CLLocationManager.locationServicesEnabled(){
                //打开设置页面
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else{
                    break
                }
                
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }else{
                
            }
        case .restricted:
            statusLabel.text = "定位受限"
        case .authorizedAlways:
            statusLabel.text = "已开启定位服务(前台后台)"
        case .authorizedWhenInUse:
            statusLabel.text = "已开启定位服务(前台)"
        }
    }
}

