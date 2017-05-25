//
//  NotifyApplehealthVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import HealthKit
class NotifyApplehealthVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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
        
        //判断当前设备是否支持HeathKit
        if HKHealthStore.isHealthDataAvailable() {
            let isAlreadyRequest = userDefaults.bool(forKey: "applehealth")
            guard !isAlreadyRequest else {
                debugPrint("以获得过applehealth权限")
                nextButton.isEnabled = false
                
                next(nextButton)
                return
            }
            
            // 1. Set the types you want to read from HK Store
            let healthKitTypesToRead: Set<HKObjectType> = [
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                HKObjectType.workoutType()
            ]
            
            // 2. Set the types you want to write to HK Store
            let healthKitTypesToShare: Set<HKCategoryType> = [
                HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
            ]
            
            let healthStore = HKHealthStore()
            
            //请求
            healthStore.requestAuthorization(toShare: healthKitTypesToShare, read: healthKitTypesToRead) {
                success, error in
                guard success else{
                    if let err = error {
                        debugPrint("error: \(err)")
                    }
                    return
                }
                userDefaults.set(true, forKey: "applehealth")
                debugPrint("同意获取write数据")
            }
        }else{
            debugPrint("设备不支持HealthKit")
            nextButton.isEnabled = false
            userDefaults.set(true, forKey: "applehealth")
            next(nextButton)
        }
    }
    
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton) {
        if let callVC = storyboard?.instantiateViewController(withIdentifier: "call") as? NotifyCallVC{
            navigationController?.pushViewController(callVC, animated: true)
        }
    }
}
