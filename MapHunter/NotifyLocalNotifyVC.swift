//
//  NotifyLocalNotifyVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class NotifyLocalNotifyVC: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.setTitleColor(defaut_color, for: .normal)
        
        navigationController?.isNavigationBarHidden = true
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
        
        let types = UIApplication.shared.currentUserNotificationSettings?.types
        debugPrint("<Notify> types: \(String(describing: types))")
        if types?.rawValue == 0{
            //注册push notification
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }else{
            nextButton.isEnabled = false
            
            next(nextButton)
        }
        userDefaults.set(true, forKey: "notification")
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        if let locationVC = UIStoryboard(name: "Notify", bundle: Bundle.main).instantiateViewController(withIdentifier: "location") as? NotifyLocationVC{
            navigationController?.pushViewController(locationVC, animated: true)
        }
    }
}
