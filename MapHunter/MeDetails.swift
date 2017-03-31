//
//  MeDetails.swift
//  MapHunter
//
//  Created by YiGan on 20/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
import HealthKit
enum MeCell3Type: Int{
    case device = 0
    case target
    case applehealth
}

//目前该类仅适用于 苹果健康
class MeDetails: UIViewController {
    
    private var type: MeCell3Type!                  //页面类型
    
    private let healthStore = HKHealthStore()       //苹果健康
    
    //点击事件
    private var tap: UITapGestureRecognizer?
    
    
    
    //MARK:- init
    init(type: MeCell3Type){
        super.init(nibName: nil, bundle: nil)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let t = tap{
            view.removeGestureRecognizer(t)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "苹果健康"
    }
    
    private func config(){
        view.backgroundColor = timeColor
        
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap!)
    }
    
    private func createContents(){
        switch type as MeCell3Type {
        case .device:
            break
        case .target:
            break
        case .applehealth:
            //判断当前设备是否支持HeathKit
            if HKHealthStore.isHealthDataAvailable() {
                // 1. Set the types you want to read from HK Store
                let healthKitTypesToRead: Set<HKObjectType> = [
                    HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                    HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
                    HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                    HKObjectType.workoutType()
                ]
                
                // 2. Set the types you want to write to HK Store
                let healthKitTypesToWrite: Set<HKObjectType> = [
                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                    HKQuantityType.workoutType()
                ]
                
                //请求
                healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToWrite) {
                    success, error in
                    guard success else{
                        if let err = error {
                            debugPrint("error: \(err)")
                        }
                        return
                    }
                    
                    debugPrint("同意获取write数据")
                }
            }else{
                debugPrint("设备不支持HealthKit")
            }
            
            //添加苹果健康图
            if let image = UIImage(named: "resource/me/me_health"){
                let imageFrame = CGRect(x: 0, y: 64, width: view_size.width, height: view_size.width * image.size.height / image.size.width)
                let imageView = UIImageView(frame: imageFrame)
                imageView.image = image
                view.addSubview(imageView)
            }
            
        }
    }
    
    //MARK:- 点击事件
    @objc private func click(recognizer: UIGestureRecognizer?){
//        let profile = self.readProfile()
//        debugPrint("profile: \(profile)")
    }
    
    //MARK:- 读取苹果健康数据
    private func readProfile() -> ( age: Int, biologicalsex: HKBiologicalSexObject, bloodtype: HKBloodTypeObject)? {

        do{
            // 1. Request birthday and calculate age
            let birthday = try healthStore.dateOfBirth()
            let today = Date()
            let duringComponents = Calendar.current.dateComponents([.year], from: birthday, to: today)
            let age = duringComponents.year
            
            // 2. Read biological sex
            let biologicalSex = try healthStore.biologicalSex()
            
            // 3. Read blood type
            let bloodtype = try healthStore.bloodType()
            
            // 4. Return the information read in a tuple
            return (age ?? 0, biologicalSex, bloodtype)
        }catch let error{
            debugPrint("read health data error: \(error)")
            let alertController = UIAlertController(title: "Error", message: "需要在Health应用中设置出生日期", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "返回到上级页面", style: .cancel){
                action in
                _ = self.navigationController?.popViewController(animated: true)
            }
            let health = UIAlertAction(title: "跳转到苹果健康", style: .default){
                _ in
                
                let urlStr = "Prefs:root=HEALTH"
                if let url = URL(string: urlStr){
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }else{
                        debugPrint("无效的url: \(url)")
                    }
                }else{
                    debugPrint("创建" + urlStr + "失效")
                }
            }
            alertController.addAction(cancel)
            alertController.addAction(health)
            self.present(alertController, animated: true, completion: nil)
        }
        
        return nil
    }
}
