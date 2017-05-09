//
//  NotifyLocationVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import CoreLocation
class NotifyLocationVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.setTitleColor(defaut_color, for: .normal)
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextButton.isEnabled = false
        nextButton.setTitleColor(defaut_color, for: .normal)
        nextButton.setTitleColor(.lightGray, for: .disabled)
        _ = delay(1){
            self.nextButton.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard CLLocationManager.locationServicesEnabled() else {
            nextButton.isEnabled = false
            performSegue(withIdentifier: "next", sender: nil)
            return
        }
        
        //当用户已同意 则忽略
        let status = CLLocationManager.authorizationStatus()
        debugPrint("<Notify> status: \(status)")
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            nextButton.isEnabled = false
            performSegue(withIdentifier: "next", sender: nil)
        }else{
            debugPrint("请求后台定位访问")
            locationManager.requestAlwaysAuthorization()  //请求允许访问
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton) {
        if let applehealthVC = storyboard?.instantiateViewController(withIdentifier: "applehealth") as? NotifyApplehealthVC{
            navigationController?.show(applehealthVC, sender: nil)
        }
    }
}
