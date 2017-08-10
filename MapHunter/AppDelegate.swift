//
//  AppDelegate.swift
//  MapHunter
//
//  Created by ganyi on 16/9/21.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import CoreData
import AngelFit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //后台参数
        application.setMinimumBackgroundFetchInterval(5)
        
        //初始化窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //进入
        if let password = userDefaults.string(forKey: "password"), !password.characters.isEmpty{
            
            //登录到通知与提醒页面 判断
            //let notificationSettingTypes = UIApplication.shared.currentUserNotificationSettings?.types
            let isNotification = userDefaults.bool(forKey: "notification")
            let locationStatus = CLLocationManager.authorizationStatus()
            let isAlreadyRequestAppleHealth = userDefaults.bool(forKey: "applehealth")
            guard isNotification && isAlreadyRequestAppleHealth && !(locationStatus == .notDetermined)  else{
                if let notifyNavigationController = UIStoryboard(name: "Notify", bundle: Bundle.main).instantiateViewController(withIdentifier: "notifyroot") as? UINavigationController{
                    window?.rootViewController = notifyNavigationController
                    window?.makeKeyAndVisible()
                }
                return true
            }
            
            //直接登陆
            let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
            window?.rootViewController = rootTBC
        }else{
            //引导页
            let navigation = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateInitialViewController()
            window?.rootViewController = navigation
        }
        window?.makeKeyAndVisible()                
        
        //当点击通知启动应用后如何获取通知
        if let options = launchOptions{
            if let localNotification = options[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
                if let dict = localNotification.userInfo {
                    // 获取通知上绑定的信息后作相应处理...
                    debugPrint("<nocal notification> dict: \(dict)")
                }
            }
        }                
        
        //崩溃处理
        //NSSetUncaughtExceptionHandler(customUncaughtExceptionHandler())
        
        //蒲公英sdk初始化
        let PgyAppId = "f16920655e1cec805b62f4fad7b7774e"
        PgyManager.shared().start(withAppId: PgyAppId)
        PgyUpdateManager.sharedPgy().start(withAppId: PgyAppId)
        PgyUpdateManager.sharedPgy().checkUpdate()  //检查更新
        PgyManager.shared().isFeedbackEnabled = false
        
        //友盟统计 591a5512677baa21560006e2
        UMAnalyticsConfig.sharedInstance().appKey = "591a5512677baa21560006e2"
        UMAnalyticsConfig.sharedInstance().channelId = "pgy"
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        
        return true
    }
    
    //MARK:- 崩溃回调
    func customUncaughtExceptionHandler() -> @convention(c) (NSException) -> Void{
        return {
            (exception) -> Void in
            let arr = exception.callStackSymbols    //得到当前调用栈信息
            let reason = exception.reason           //得到崩溃原因
            let name = exception.name               //异常类型
            
            let data = "<exception> type: \(name), reason: \(String(describing: reason)), stackInfo: \(arr)"
            debugPrint(data)
            writeData(data: "<exception> [type]: \(name)\n [reason]: \(String(describing: reason))")
            
            //手动上报到蒲公英
            PgyManager.shared().report(exception)
        }
    }
    
    //MARK:- 通知 注册推送成功后调用
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("<remote notification> deviceToken: \(deviceToken)")
    }
    
    //MARK:- 通知 推送失败调用
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("<remote notification> failure: \(error)")
    }
    
    //MARK:- 通知 接收到推送时调用
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        debugPrint("<remote notification> did receive remote notification with userinfo: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        debugPrint("<local notification> did receive remote notification with userinfo: \(userInfo)")
        
        //后台处理...
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //切换状态
        print("__will resign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //进入后台
        print("__did enter background")
        
        //修改时间为当前日期
        selectDate = Date()
        notiy.post(name: connected_notiy, object: nil)
//        globalLocationManager.startUpdatingLocation()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //进入前台
        debugPrint("__will enter foreground")
        
        
        //判断跨天问题
        if !preToday.isToday() {
            preToday = Date()
            selectDate = Date()
            application.reloadInputViews()
            
            //查找并上传8000步数
            let coredataHandler = CoreDataHandler.share()
            if let accessoryId = AngelManager.share()?.accessoryId {
                let userId = coredataHandler.mainUserId()
                let sportEveryData = coredataHandler.selectSportEverydayData(withAccessoryId: accessoryId, byUserId: userId, withDate: preToday)
                if let uid = userId{
                    if let step = sportEveryData?.totalSteps {
                        NetworkHandler.share().updateSteps(withUserId: uid, steps: Int(step), date: preToday, closure: {
                            resultCode, message, data in
                            print("<8000steps> resultCode: \(resultCode), message: \(message), data: \(data)")
                        })
                    }
                }
            }
        }
        
        application.applicationIconBadgeNumber = 0          //设置提示图标数量为0
        LocalNotification.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    //MARK:- 后台回调 unused
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("perform fetch with completion")
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MapHunter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

