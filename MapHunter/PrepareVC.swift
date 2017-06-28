//
//  PrepareVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/28.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PrepareVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var gpsImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var singleTargetButton: UIButton!
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "跑步"
        navigationController?.navigationBar.backItem?.title = " "
        
        
        startButton.layer.cornerRadius = startButton.bounds.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        globalLocationManager.stopUpdatingLocation()    //停止定位
        globalLocationManager.delegate = nil
        
        super.viewWillDisappear(animated)
    }
    
    private func config(){
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading    //当前地图跟踪模式
        mapView.mapType = MKMapType.standard //普通地图
        mapView.showsUserLocation = true
        
    }
    
    private func createContents(){
        
    }
    
    @IBAction func start(_ sender: Any) {
        pushMap()
    }
    
    //MARK:-跳转地图开始
    private func pushMap(){
        let premapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "premap") as! PremapVC
        premapVC.activeType = ActiveSportType.walking
        navigationController?.pushViewController(premapVC, animated: true)
    }
    
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
