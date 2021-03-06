//
//  InterfaceListHander.swift
//  AngelFit
//
//  Created by aiju_huangjing1 on 2016/11/16.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

import Foundation
import CoreData
import CoreBluetooth

public final class AngelManager: NSObject {
    
    private var peripheral: CBPeripheral?       //当前设备
    public var macAddress: String?              //当前设备macAddress
    public var type: Int16?                     //设备类型
    public var deviceId: String?               //工厂id
    
    public var accessoryId: String?             //设备id
    
    //MARK:- 获取数据库句柄
    private lazy var coredataHandler = {
        return CoreDataHandler.share()
    }()
    
    //MARK:- init +++++++++++++++++++
    private static var __once: () = {
        guard let peripheral = PeripheralManager.share().currentPeripheral else{
            return
        }
        singleton.instance = AngelManager(currentPeripheral: peripheral)
    }()
    struct singleton{
        static var instance:AngelManager? = nil
    }
    public class func share() -> AngelManager?{
        _ = AngelManager.__once
        if singleton.instance == nil {
            if let peripheral = PeripheralManager.share().currentPeripheral {
                singleton.instance = AngelManager(currentPeripheral: peripheral)
            }
        }
        return singleton.instance
    }
    
    convenience init(currentPeripheral existPeripheral: CBPeripheral) {
        self.init()
        
        peripheral = existPeripheral
    }
    
    override init(){
        super.init()
        
        _ = CBridgingManager.share()
        
        //初始化获取macAddress
        getMacAddressFromBand{
            errorCode, data in
            if errorCode == ErrorCode.success{
                self.macAddress = data
                
                //初始化获取deviceId&type
                self.getDeviceInfoFromBand{
                    errorCode, data in
                    if errorCode == ErrorCode.success{
                        
                    }
                }
                
                DispatchQueue.main.async {
                    //发送连接成功消息
                    NotificationCenter.default.post(name: connected_notiy, object: nil, userInfo: nil)
                }
            }
        }
        
        
        //象征性初始化
        swiftSynchronizationConfig = { data in
            
        }
    }
    
    //MARK:- 从数据库获取数据-用户信息
    public func getUserinfo(closure: (User?)->()){
        
        let userId = UserManager.share().userId
        closure(coredataHandler.selectUser(withUserId: userId))
    }
    
    //MARK:- 从数据库获取数据-设备信息
    public func getDevice(_ accessoryId: String? = nil, closure: @escaping (Device?) -> ()){
        //为空直接返回失败
        var realAccessoryId: String!
        if let accId = accessoryId{
            realAccessoryId = accId
        }else if let md = self.accessoryId{
            realAccessoryId = md
        }else{
            closure(nil)
            return
        }
        
        let userId = UserManager.share().userId
        getDeviceInfoFromBand(){
            errorCode, value in
        }
        
        guard let device = coredataHandler.selectDevice(withAccessoryId: realAccessoryId, byUserId: userId) else {
            return
        }
        closure(device)
    }
    
    //获取设备信息
    private func getDeviceInfoFromBand(closure : @escaping (_ errorCode:Int16 ,_ value: Any?)->()){
        getLiveDataFromBring(withActionType: .deviceInfo, closure: closure)
    }
    
    //获取mac地址
    public func getMacAddressFromBand(closure: @escaping (_ errorCode:Int16 ,_ value: String)->()){
        
        getLiveDataFromBring(withActionType: .macAddress){
            errorCode, aValue in
            closure(errorCode, aValue as! String)
            
            if errorCode == ErrorCode.success{
                DispatchQueue.main.async {
                    //发送连接成功消息
                    NotificationCenter.default.post(name: connected_notiy, object: nil, userInfo: nil)
                }
            }
        }
    }
    
    //获取功能列表
    private func getFuncTableFromBand(_ accessoryId: String? = nil, closure : @escaping (_ errorCode:Int16 ,_ value: Any?)->()){
        getLiveDataFromBring(withActionType: .funcTable, accessoryId: accessoryId, closure: closure)
    }
    
    //从数据库获取功能列表
    public func getFuncTable(_ accessoryId: String? = nil, closure: @escaping (DeviceFunction?) -> ()){
        //为空直接返回失败
        var realAccessoryId: String!
        if let accId = accessoryId{
            realAccessoryId = accId
        }else if let accId = self.accessoryId{
            realAccessoryId = accId
        }else{
            closure(nil)
            return
        }
        
        getFuncTableFromBand(realAccessoryId){
            errorCode, value in
            debug("funcTable errorCode: \(errorCode) value: \(String(describing: value))")
            if errorCode == ErrorCode.success{
                closure(self.coredataHandler.selectDevice(withAccessoryId: realAccessoryId, byUserId: UserManager.share().userId)?.deviceFunction)
            }else{
                closure(nil)
            }
        }
        return
    }
    
    //获取实时数据
    public func getLiveDataFromBand(closure : @escaping (_ errorCode:Int16 ,_ value: Any?)->()){
        getLiveDataFromBring(withActionType: .liveData, closure: closure)
    }
    
    //MARK:- 从手环端获取数据
    private func getLiveDataFromBring(withActionType actionType:ActionType, accessoryId: String? = nil, closure: @escaping (_ errorCode:Int16 ,_ value: Any?) ->()){
        
        switch actionType {
        case .macAddress:
            
            swiftMacAddress = { data  in
                
                let macStruct:protocol_device_mac = data.assumingMemoryBound(to: protocol_device_mac.self).pointee
                let macCList = macStruct.mac_addr
                let macList = [macCList.0, macCList.1, macCList.2, macCList.3, macCList.4, macCList.5]
                let tempMacAddress = macList.map(){String($0,radix:16)}.reduce(""){$0+$1}.uppercased()
                
                //保存macAddress
                self.macAddress = tempMacAddress
                if let deviceId = self.deviceId {
                    
                    let tempAccessoryId = "1" + tempMacAddress + deviceId
                    self.accessoryId = tempAccessoryId
                    _ = self.coredataHandler.insertDevice(withAccessoryId: tempAccessoryId, byUserId: UserManager.share().userId)
                    _ = self.coredataHandler.commit()
                }
                
                //保存macAddress到实例
                print("1....", Unmanaged.passUnretained(self).toOpaque())
                DispatchQueue.main.async {
                    self.accessoryId = tempMacAddress
                }
                //返回
                closure(ErrorCode.success,tempMacAddress)
            }
            var ret_code:UInt32 = 0
            vbus_tx_evt(VBUS_EVT_BASE_APP_GET, VBUS_EVT_APP_APP_GET_MAC, &ret_code);

        case .deviceInfo:
            swiftDeviceInfo = { data in
                let deviceInfo = data.assumingMemoryBound(to: protocol_device_info.self).pointee
                
                let deviceId = "\(deviceInfo.device_id)"
                self.deviceId = deviceId
                
                //当设备物理地址存在时，插入设备项
                if let macAddress = self.macAddress {
                    let accessoryId = "1" + macAddress + deviceId
                    self.accessoryId = accessoryId
                    
                    let device = self.coredataHandler.insertDevice(withAccessoryId: accessoryId, byUserId: UserManager.share().userId)
                    device?.batteryStatus = Int16(deviceInfo.batt_status)
                    device?.batteryLevel = Int16(deviceInfo.batt_level)
                    device?.version = Int16(deviceInfo.version)
                    device?.isPaired = deviceInfo.pair_flag == 0x01 ? true : false
                    device?.isRebooted = deviceInfo.reboot_flag == 0x01 ? true : false
                    device?.runMode = Int16(deviceInfo.mode)
                    device?.accessoryId = accessoryId
                    //象征性初始化
                    swiftSynchronizationConfig = { data in
                        
                    }
                    if deviceInfo.reboot_flag == 0x01 {
                        //如果有重启标志==1,同步设备信息
                        self.setSynchronizationConfig(){
                            complete in
                        }
                    }
                    
                    
                    guard self.coredataHandler.commit() else{
                        closure(ErrorCode.failure, "commit fail")
                        return
                    }
                }
                closure(ErrorCode.success, deviceInfo)
            }
            
            var ret_code:UInt32 = 0
            vbus_tx_evt(VBUS_EVT_BASE_APP_GET, VBUS_EVT_APP_GET_DEVICE_INFO, &ret_code)
            
        case .funcTable:
            
            //为空直接返回失败
            var realAccessoryId: String!
            if let ai = accessoryId{
                realAccessoryId = ai
            }else if let ai = self.accessoryId{
                realAccessoryId = ai
            }else{
                closure(ErrorCode.failure, nil)
                break
            }
            
            swiftFuncTable = { data in
                
                debug("--------------\n已经获取funcTable")
                
                let funcTableModel = data.assumingMemoryBound(to: protocol_func_table.self).pointee
                print("--------------\nprint:funcTable\n\(funcTableModel)")
                let device = self.coredataHandler.selectDevice(withAccessoryId: realAccessoryId, byUserId: UserManager.share().userId)
                let deviceFunction = device?.deviceFunction
//                let deviceFunctionAlarm = device?.deviceFunctionAlarm
//                let deviceFunctionMsgItem = device?.deviceFunctionMsgItem
//                let deviceFunctionSportItem = device?.deviceFunctionSportItem
//                let deviceFunctionSwitchSetting = device?.deviceFunctionSwitchSetting

                deviceFunction?.haveAlarm = funcTableModel.alarm_count > 0
                deviceFunction?.haveAllMsgNotification = funcTableModel.ohter2.allAppNotice
                deviceFunction?.haveAncs = funcTableModel.main.Ancs
                deviceFunction?.haveAntiLost = funcTableModel.ohter2.bilateralAntiLost
                deviceFunction?.haveCallNumber = funcTableModel.call.callingNum
                deviceFunction?.haveCallContact = funcTableModel.call.callingContact
                deviceFunction?.haveCallNotification = funcTableModel.call.calling
                deviceFunction?.haveCameraControl = funcTableModel.control.takePhoto
                deviceFunction?.haveFindPhone = funcTableModel.other.findPhone
                deviceFunction?.haveHeartRateMonitor = funcTableModel.ohter2.heartRateMonitor
                deviceFunction?.haveHeartRateMonitorControl = true
                deviceFunction?.haveLogin = funcTableModel.main1.logIn
                deviceFunction?.haveLongSit = true
                deviceFunction?.haveMsgContent = funcTableModel.sms.tipInfoContact
                deviceFunction?.haveMultiSport = true
                deviceFunction?.haveNotDisturbMode = funcTableModel.ohter2.doNotDisturb
                deviceFunction?.haveOta = true
                deviceFunction?.havePedometer = true
                deviceFunction?.havePlayMusicControl = funcTableModel.control.music
                deviceFunction?.haveRealData = funcTableModel.main.realtimeData
                deviceFunction?.haveScreenDisplay180Rotate = true
                deviceFunction?.haveScreenDisplayMode = funcTableModel.ohter2.displayMode
                deviceFunction?.haveShortcutCall = funcTableModel.other.onetouchCalling
                deviceFunction?.haveShortcutReset = true
                deviceFunction?.haveSleepMonitor = funcTableModel.main.sleepMonitor
                deviceFunction?.haveTimeline = funcTableModel.main.timeLine
                deviceFunction?.haveTraininTracking = true
                deviceFunction?.haveWakeScreenOnWristRaise = true
                deviceFunction?.haveWeatherForecast = funcTableModel.other.weather
                deviceFunction?.isHeartRateMonitorSilent = funcTableModel.ohter2.staticHR
                
                /*
                deviceFunction?.alarmCount = Int16(funcTableModel.alarm_count)
                
                deviceFunction?.main2_logIn = funcTableModel.main1.logIn
                
                deviceFunction?.main_ancs = funcTableModel.main.Ancs
                deviceFunction?.main_timeLine = funcTableModel.main.timeLine
                deviceFunction?.main_heartRate = funcTableModel.main.heartRate
                deviceFunction?.main_singleSport = funcTableModel.main.singleSport
                deviceFunction?.main_deviceUpdate = funcTableModel.main.deviceUpdate
                deviceFunction?.main_realtimeData = funcTableModel.main.realtimeData
                deviceFunction?.main_sleepMonitor = funcTableModel.main.sleepMonitor
                deviceFunction?.main_stepCalculation = funcTableModel.main.stepCalculation
                
                deviceFunction?.alarmType_custom = funcTableModel.type.custom
                deviceFunction?.alarmType_party = funcTableModel.type.party
                deviceFunction?.alarmType_sleep = funcTableModel.type.sleep
                deviceFunction?.alarmType_sport = funcTableModel.type.sport
                deviceFunction?.alarmType_dating = funcTableModel.type.dating
                deviceFunction?.alarmType_wakeUp = funcTableModel.type.wakeUp
                deviceFunction?.alarmType_metting = funcTableModel.type.metting
                deviceFunction?.alarmType_medicine = funcTableModel.type.medicine
                
                deviceFunction?.call_calling = funcTableModel.call.calling
                deviceFunction?.call_callingNum = funcTableModel.call.callingNum
                deviceFunction?.call_callingContact = funcTableModel.call.callingContact
                
                deviceFunction?.sport_run = funcTableModel.sport_type0.run
                deviceFunction?.sport_bike = funcTableModel.sport_type0.by_bike
                deviceFunction?.sport_foot = funcTableModel.sport_type0.on_foot
                deviceFunction?.sport_swim = funcTableModel.sport_type0.swim
                deviceFunction?.sport_walk = funcTableModel.sport_type0.walk
                deviceFunction?.sport_other = funcTableModel.sport_type0.other
                deviceFunction?.sport_climbing = funcTableModel.sport_type0.mountain_climbing
                deviceFunction?.sport_badminton = funcTableModel.sport_type0.badminton
                
                deviceFunction?.sport2_sitUp = funcTableModel.sport_type1.sit_up
                deviceFunction?.sport2_fitness = funcTableModel.sport_type1.fitness
                deviceFunction?.sport2_dumbbell = funcTableModel.sport_type1.dumbbell
                deviceFunction?.sport2_spinning = funcTableModel.sport_type1.spinning
                deviceFunction?.sport2_ellipsoid = funcTableModel.sport_type1.ellipsoid
                deviceFunction?.sport2_treadmill = funcTableModel.sport_type1.treadmill
                deviceFunction?.sport2_weightLifting = funcTableModel.sport_type1.weightlifting
                deviceFunction?.sport_pushUp = funcTableModel.sport_type1.push_up
                
                deviceFunction?.sport3_yoga = funcTableModel.sport_type2.yoga
                deviceFunction?.sport3_tennis = funcTableModel.sport_type2.tennis
                deviceFunction?.sport3_football = funcTableModel.sport_type2.footballl
                deviceFunction?.sport3_pingpang = funcTableModel.sport_type2.table_tennis
                deviceFunction?.sport3_basketball = funcTableModel.sport_type2.basketball
                deviceFunction?.sport3_volleyball = funcTableModel.sport_type2.volleyball
                deviceFunction?.sport3_ropeSkipping = funcTableModel.sport_type2.rope_skipping
                deviceFunction?.sport3_bodybuildingExercise = funcTableModel.sport_type2.bodybuilding_exercise
                
                deviceFunction?.sport4_golf = funcTableModel.sport_type3.golf
                deviceFunction?.sport4_dance = funcTableModel.sport_type3.dance
                deviceFunction?.sport4_skiing = funcTableModel.sport_type3.skiing
                deviceFunction?.sport4_baseball = funcTableModel.sport_type3.baseball
                deviceFunction?.sport4_rollerSkating = funcTableModel.sport_type3.roller_skating
                
                deviceFunction?.sms_tipInfoNum = funcTableModel.sms.tipInfoNum
                deviceFunction?.sms_tipInfoContact = funcTableModel.sms.tipInfoContact
                deviceFunction?.sms_tipInfoContent = funcTableModel.sms.tipInfoContent
                
                deviceFunction?.other_weather = funcTableModel.other.weather
                deviceFunction?.other_antilost = funcTableModel.other.antilost
                deviceFunction?.other_findPhone = funcTableModel.other.findPhone
                deviceFunction?.other_findDevice = funcTableModel.other.findDevice
                deviceFunction?.other_configDefault = funcTableModel.other.configDefault
                deviceFunction?.other_sedentariness = funcTableModel.other.sedentariness
                deviceFunction?.other_upHandGesture = funcTableModel.other.upHandGesture
                deviceFunction?.other_oneTouchCalling = funcTableModel.other.onetouchCalling
                
                deviceFunction?.other2_staticHR = funcTableModel.ohter2.staticHR
                deviceFunction?.other2_flipScreen = funcTableModel.ohter2.flipScreen
                deviceFunction?.other2_displayMode = funcTableModel.ohter2.displayMode
                deviceFunction?.other2_allAppNotice = funcTableModel.ohter2.allAppNotice
                deviceFunction?.other2_doNotDisturb = funcTableModel.ohter2.doNotDisturb
                deviceFunction?.other2_heartRateMonitor = funcTableModel.ohter2.heartRateMonitor
                deviceFunction?.other2_bilateralAntiLost = funcTableModel.ohter2.bilateralAntiLost
                
                deviceFunction?.control_music = funcTableModel.control.music
                deviceFunction?.control_takePhoto = funcTableModel.control.takePhoto
                
                deviceFunction?.notify_qq = funcTableModel.notify.qq
                deviceFunction?.notify_email = funcTableModel.notify.email
                deviceFunction?.notify_weixin = funcTableModel.notify.weixin
                deviceFunction?.notify_message = funcTableModel.notify.message
                deviceFunction?.notify_twitter = funcTableModel.notify.twitter
                deviceFunction?.notify_facebook = funcTableModel.notify.facebook
                deviceFunction?.notify_sinaWeibo = funcTableModel.notify.sinaWeibo
                
                deviceFunction?.notify2_skype = funcTableModel.ontify2.skype
                deviceFunction?.notify2_message = funcTableModel.ontify2.messengre
                deviceFunction?.notify2_calendar = funcTableModel.ontify2.calendar
                deviceFunction?.notify2_linkedIn = funcTableModel.ontify2.linked_in
                deviceFunction?.notify2_whatsapp = funcTableModel.ontify2.whatsapp
                deviceFunction?.notify2_instagram = funcTableModel.ontify2.instagram
                deviceFunction?.notify2_alarmClock = funcTableModel.ontify2.alarmClock
                */
                
                debug("coreData functable: \(String(describing: deviceFunction))")
                guard self.coredataHandler.commit() else {
                    closure(ErrorCode.failure, nil)
                    return
                }
                closure(ErrorCode.success, deviceFunction)
            }
            debug("--------------\n开始获取funcTable")
            var ret_code:UInt32 = 0

            vbus_tx_evt(VBUS_EVT_BASE_APP_GET, VBUS_EVT_APP_GET_FUNC_TABLE, &ret_code)
            print("获取功能列表 \(ret_code)")
        case .liveData:
            //实时数据
            swiftLiveData = { data in
                
                let liveDataStruct:protocol_start_live_data = data.assumingMemoryBound(to: protocol_start_live_data.self).pointee
                
                let liveData = liveDataStruct
                closure(ErrorCode.success, liveData)
            }
            var ret_code:UInt32 = 0
            vbus_tx_evt(VBUS_EVT_BASE_APP_GET, VBUS_EVT_APP_GET_LIVE_DATA, &ret_code)
     
        }
    }
    
    //MARK:- 设置手环端命令
    //设置手环模式
    private func setBringMode(_ bandMode:BandMode, completed: Bool = true, closure: @escaping (_ success:Bool) ->()){
        
        guard completed else {
            closure(false)
            return
        }
        
        var ret_code: UInt32 = 0
        switch bandMode {
        case .unbind:
            closure(protocol_set_mode(PROTOCOL_MODE_UNBIND) == 0)
            //解绑当前设备uuid
            if let uuid = PeripheralManager.share().UUID{
                _ = PeripheralManager.share().delete(UUIDString: uuid)
                PeripheralManager.share().UUID = nil
            }
        case .bind:
            closure(protocol_set_mode(PROTOCOL_MODE_BIND) == 0)
            //保存绑定当前设备uuid
            if let uuid = PeripheralManager.share().UUID{
                _ = PeripheralManager.share().add(newUUIDString: uuid)
            }
        case .levelup:
            vbus_tx_evt(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_OTA_START, &ret_code)
            
            if ret_code == 0 {
                protocol_set_mode(PROTOCOL_MODE_OTA)
                closure(true)
                
            }else{
                closure(false)
            }
        }
    }
    
    //MARK:- 升级
    public func setUpdate(closure: @escaping (_ success: Bool) -> ()){
        setBringMode(.levelup, closure: closure)
    }
    
    //MARK:- 绑定
    public func setBind(_ bind: Bool, closure: @escaping (_ success: Bool) -> ()){
        var ret_code:UInt32 = 0
        var evt_type:VBUS_EVT_TYPE
    
        if bind{
            evt_type = VBUS_EVT_APP_BIND_START
        } else {
            evt_type = VBUS_EVT_APP_BIND_REMOVE
        }
        vbus_tx_evt(VBUS_EVT_BASE_APP_SET, evt_type, &ret_code);
        
        let bandMode = bind ? BandMode.bind : BandMode.unbind
        if ret_code == 0 {
            setBringMode(bandMode, completed: true, closure: closure)
        }else{
            setBringMode(bandMode, completed: false, closure: closure)
        }
    }
    
    //MARK:- 设置手环日期
    public func setDate(date: Date = Date(), closure:(_ success:Bool) ->()){
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: date)
        var time = protocol_set_time()
        time.year = UInt16(components.year!)
        time.month =  UInt8(components.month!)
        time.day = UInt8(components.day!)
        time.hour = UInt8(components.hour!)
        time.minute = UInt8(components.minute!)
        time.second = UInt8(components.second!)
        var weekday = UInt8(components.weekday!)
        //修正: component.weekday 1~7(从星期天开始) time.week 0~6(从星期一开始)
        if weekday == 1{
            weekday = 6
        }else{
            weekday -= 2
        }
        time.week = weekday
        let length = UInt32(MemoryLayout<UInt16>.size+MemoryLayout<UInt8>.size * 8)
        
        var ret_code:UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_TIME, &time, length, &ret_code);
        closure(ret_code == 0)
    }
    
    //MARK:- 设置用户信息
    public func setUserInfo(_ userInfo:UserInfoModel, closure:(_ success:Bool) ->()){
        
        var userInfoModel = protocol_set_user_info()
        userInfoModel.heigth = userInfo.height
        userInfoModel.weight = userInfo.weight * 100
        userInfoModel.gender = userInfo.gender
        userInfoModel.year = userInfo.birthYear
        userInfoModel.monute = userInfo.birthMonth
        userInfoModel.day = userInfo.birthDay
        
        var ret_code: UInt32 = 0
        let length = UInt32(MemoryLayout<UInt16>.size+MemoryLayout<UInt8>.size * 7)
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_USER_INFO, &userInfoModel, length, &ret_code)
        
        guard ret_code==0 else {
            closure(false)
            return
        }
        //保存到数据库
        let userId = UserManager.share().userId
        let user = coredataHandler.selectUser(withUserId: userId)
        let calender = Calendar.current
        var components = calender.dateComponents([.year, .month, .day], from: Date())
        components.year = Int(userInfo.birthYear)
        components.month = Int(userInfo.birthMonth)
        components.day = Int(userInfo.birthDay)
        let birthDay = calender.date(from: components)
        user?.userInfo?.birthday = birthDay as NSDate?
        user?.userInfo?.gender = Int16(userInfo.gender)
        user?.userInfo?.height100TimesCM = Int16(userInfo.height)
        user?.userInfo?.weight10000TimesKG = Int32(userInfo.weight)
        guard coredataHandler.commit() else{
            closure(false)
            return
        }
        
        closure(true)
    }
    
    //MARK:- 设置久坐提醒
    public func setLongSit(_ sit:LongSitModel, accessoryId: String? = nil, closure:(_ success:Bool) ->()){
        
        var long_sit = protocol_long_sit()
        
        long_sit.start_hour = sit.startHour
        long_sit.start_minute = sit.startMinute
        long_sit.end_hour = sit.endHour
        long_sit.end_minute = sit.endMinute
        long_sit.interval = sit.duringTime
        
        //0,1,2,3,4,5,6 日。。。六
        var val = sit.weekdayList.reduce(0){$0 | ($1 == 0 ? 0x1 : (($1 < 7 && $1 > 0) ? 0x01 << UInt8(7 - $1) : 0x00))}
        val = val | (sit.isOpen ? 0x01 << 7 : 0x00)
        long_sit.repetitions = UInt16(val)
        
        var ret_code:UInt32 = 0
        
        let length = UInt32(MemoryLayout<UInt16>.size + MemoryLayout<UInt8>.size * 7)
        
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_LONG_SIT, &long_sit, length, &ret_code)
        guard ret_code == 0 else{
            closure(false)
            return
        }
        
        //保存数据库
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            closure(false)
            return
        }
        
        let userId = UserManager.share().userId
        let device = coredataHandler.selectDevice(withAccessoryId: realAccessoryId, byUserId: userId)
        let dbLongsit = device?.deviceLongSitSetting

        dbLongsit?.startHour = Int16(sit.startHour)
        dbLongsit?.startMinute = Int16(sit.startMinute)

        dbLongsit?.endHour = Int16(sit.endHour)
        dbLongsit?.endMinute = Int16(sit.endMinute)

        dbLongsit?.intervalMinute = Int32(Int16(sit.duringTime))
        //dbLongsit?.isOpen = sit.isOpen
        
        var repetition: Int16 = 0x00
        for i in sit.weekdayList{
            repetition = repetition & 0x01 << Int16(i)
        }
        dbLongsit?.repetition = repetition
        
        closure(true)
    }
    
    //MARK:- 设置公英制
    /*
    public func setUnit(_ unitsType: Set<UnitType>, macAddress: String? = nil, closure:(_ success:Bool) ->()){
        
        //为空直接返回失败
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        guard !unitsType.isEmpty else {
            closure(false)
            return
        }
        
        //默认赋值
        var setUnit = protocol_set_uint()
        if setUnit.dist_uint == 0x00{
            setUnit.dist_uint = 0x01
        }
        if setUnit.is_12hour_format == 0x00{
            setUnit.is_12hour_format = 0x01
        }
        if setUnit.language == 0x00{
            setUnit.language = 0x01
        }
        if setUnit.stride == 0{
            setUnit.stride = 70
        }
        if setUnit.temp == 0x00{
            setUnit.temp = 0x01
        }
        if setUnit.weight_uint == 0x00{
            setUnit.weight_uint = 0x01
        }
        
        //创建单位模型
        let userId = UserManager.share().userId
        let device = coredataHandler.selectDevice(withAccessoryId: realMacAddress, byUserId: userId)
        let unit = coredataHandler.selectUnit(userId: UserManager.share().userId, withMacAddress: realMacAddress)
        //赋值
        unitsType.forEach(){
            body in
            
            switch body{
            case .distance_KM:
                setUnit.dist_uint = 0x01
                unit?.distance = 0x01
            case .distance_MI:
                setUnit.dist_uint = 0x02
                unit?.distance = 0x02
            case  .langure_EN:
                setUnit.language = 0x02
                unit?.language = 0x02
            case .langure_ZH:
                setUnit.language = 0x01
                unit?.language = 0x01
            case .temp_C:
                setUnit.temp = 0x01
                unit?.temperature = 0x01
            case .temp_F:
                setUnit.temp = 0x02
                unit?.temperature = 0x02
            case .timeFormat_12:
                setUnit.is_12hour_format = 0x02
                unit?.timeFormat = 0x02
            case .timeFormat_24:
                setUnit.is_12hour_format = 0x01
                unit?.timeFormat = 0x01
            case .weight_LB:
                setUnit.weight_uint = 0x02
                unit?.weight = 0x02
            case .weight_KG:
                setUnit.weight_uint = 0x01
                unit?.weight = 0x01
            }
        }
        
        /*
         stride 为步长，根据身高和男女运算，详情见协议 70是默认的
         */
        guard let user = coredataHandler.selectUser(userId: UserManager.share().userId) else{
            closure(false)
            return
        }
        let height = user.height
        let gender = user.gender
        if gender == 1{
            setUnit.stride = UInt8(Double(height) * 0.415)
        }else{
            setUnit.stride = UInt8(Double(height) * 0.413)
        }
        
        let length = UInt32(MemoryLayout<UInt8>.size * 8)
        var ret_code:UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_UINT, &setUnit, length, &ret_code)

        guard ret_code == 0 else{
            //重置数据库修改
            _ = coredataHandler.reset()
            closure(false)
            return
        }
        
        //保存数据库
        guard coredataHandler.commit() else{
            closure(false)
            return
        }
        
        closure(true)
    }
    
    //MARK:- 获取公英制
    public func getUnit(_ macAddress: String? = nil, closure: (Unit?)->()){
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        closure(coredataHandler.selectUnit(userId: UserManager.share().userId, withMacAddress: realMacAddress))
    }
     */
    
    //设置目标
    public func setGoal(_ goal:GoalDataModel , closure: @escaping (_ success:Bool) ->()){
        
        var ret_code:UInt32 = 0
        var setGoal = protocol_set_sport_goal()
        
        setGoal.type = goal.type
        setGoal.data = goal.value
        setGoal.sleep_hour = goal.sleepHour
        setGoal.sleep_minute = goal.sleepMinute
        
        let length: UInt32 = UInt32(MemoryLayout<UInt32>.size+MemoryLayout<UInt8>.size * 5)
        
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_SPORT_GOAL, &setGoal, length, &ret_code)
        
        guard ret_code == 0 else {
            closure(false)
            return
        }

        //保存数据库
        let userId = UserManager.share().userId
        let user = coredataHandler.selectUser(withUserId: userId)
        if goal.type == 0x00 {
            user?.goal?.steps = Int32(goal.value)
        }else if goal.type == 0x01{
//            user?.goalCal = Int16(goal.value)
        }else if goal.type == 0x02{
//            user?.goalDistance = Int16(goal.value)
        }
        guard coredataHandler.commit() else{
            closure(false)
            return
        }
        
        closure(true)
    }
    
    //MARK:- 设置拍照开关
    public func setCamera(_ open:Bool, closure: @escaping (_ success:Bool) ->()){
        swiftGetCameraSignal = { data in
            closure(true)
        }
        
        var ret_code:UInt32 = 0
        var evt_type:VBUS_EVT_TYPE = VBUS_EVT_APP_APP_TO_BLE_PHOTO_STOP
        
        if open == true {
            evt_type = VBUS_EVT_APP_APP_TO_BLE_PHOTO_START
        }else{
            evt_type = VBUS_EVT_APP_APP_TO_BLE_PHOTO_STOP
        }
        vbus_tx_evt(VBUS_EVT_BASE_APP_SET, evt_type, &ret_code);
        
        guard ret_code == 0 else {
            closure(false)
            return
        }
    }
    
    //MARK:-获取设备
    private func getDevice(withAccessoryId accessoryId: String? = nil) -> Device?{
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            return nil
        }
        
        let userId = UserManager.share().userId
        let device = coredataHandler.selectDevice(withAccessoryId: realAccessoryId, byUserId: userId)
        return device
    }
    
    
    //MARK:- 设置寻找手机 timeOut 超时时间
    public func setFindPhone(_ open:Bool, timeOut: UInt8 = 5, accessoryId: String? = nil, closure: (_ success:Bool) ->()){
        
        var ret_code:UInt32 = 0
        var findPhone = protocol_find_phone()
        findPhone.status = open ? 0xAA : 0x55
        findPhone.timeout = timeOut
        
        let length = UInt32(MemoryLayout<UInt8>.size * 4)
        
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_FIND_PHONE, &findPhone,length, &ret_code);
        
        guard ret_code == 0 else {
            closure(false)
            return
        }
        //保存数据库
        let device = getDevice(withAccessoryId: accessoryId)
        device?.deviceFunctionSwitchSetting?.isFindPhonesOn = open
        guard coredataHandler.commit() else{
            closure(false)
            return
        }
        
        closure(true)
    }
    
    //MARK:- 获取是否开启寻找手机
    public func getFindPhone(_ accessoryId: String? = nil, closure: (_ open: Bool?)->()){
        
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            closure(false)
            return
        }
        
        let userId = UserManager.share().userId
        guard let device = coredataHandler.selectDevice(withAccessoryId: realAccessoryId, byUserId: userId) else{
            closure(nil)
            return
        }
        closure(device.deviceFunctionSwitchSetting?.isFindPhonesOn)
    }
    
    //MARK:- 设置一键还原
    public func setGhost(closure: (_ success:Bool)->()){
        
        var ret_code:UInt32 = 0
        vbus_tx_evt(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_DEFAULT_CONFIG, &ret_code)
        
        guard ret_code == 0 else {
            closure(false)
            return
        }
        closure(true)
    }
    
    //MARK:- 设置一键呼叫
    public func setQuickSOS(_ open:Bool, accessoryId: String? = nil, closure:(_ success:Bool) ->()){
        var ret_code:UInt32 = 0
        var oneKey = protocol_set_onekey_sos()
        
        oneKey.on_off = open ? 0xAA : 0x55
        
        let length = UInt32(MemoryLayout<UInt8>.size*3)
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_ONEKEY_SOS, &oneKey, length, &ret_code)
        guard ret_code == 0 else {
            closure(false)
            return
        }
        //保存数据库
        let device = getDevice(withAccessoryId: accessoryId)
        //device?.sos = open
        guard coredataHandler.commit() else{
            closure(false)
            return
        }
        closure(true)
    }
    
    //MARK:- 获取是否开启一键呼叫
    public func getQuickSOSSwitch(_ accessoryId: String? = nil, closure: (_ open: Bool?)->()){
        
        let device = getDevice(withAccessoryId: accessoryId)
        //closure(device.sos)
    }
    
    //MARK:- 重启设备
    public func setRestart(closure:(_ success:Bool) ->()){
        
        var ret_code:UInt32 = 0
        
        vbus_tx_evt(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_REBOOT,&ret_code)
        
        guard ret_code == 0 else {
            closure(false)
            return
        }
        closure(true)
    }
    
    //MARK:- 设置抬腕识别
    public func setWristRecognition(_ open:Bool, lightDuring: UInt8 = 3, closure: (_ success:Bool)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = accessoryId{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var wrist = protocol_set_up_hand_gesture()
        var showDuring = lightDuring
        if showDuring < 2{
            showDuring = 2
        }else if showDuring > 7{
            showDuring = 7
        }
        wrist.show_second = showDuring
        wrist.on_off = open ? 0xAA : 0x55
        
        let length = UInt32(MemoryLayout<UInt8>.size * 4)

        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_UP_HAND_GESTURE, &wrist, length, &ret_code);

        guard ret_code == 0 else {
            closure(false)
            return
        }
        
        //保存数据库
//        let device = getDevice(withAccessoryId: self.accessoryId)
//        let handGresture = coredataHandler.selectHandGesture(userId: UserManager.share().userId, withMacAddress: realMacAddress)
//        handGresture?.isOpen = open
//        handGresture?.displayTime = Int16(lightDuring)
//        guard coredataHandler.commit() else{
//            closure(false)
//            return
//        }
//        closure(true)
    }
    
    /*
    //MARK:- 获取抬腕识别
    public func getWristRecognition(_ macAddress: String? = nil, closure: (HandGesture?)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        
        closure(coredataHandler.selectHandGesture(userId: UserManager.share().userId, withMacAddress: realMacAddress))
    }
     */
    
    /*
    //设置勿扰模式
    public func setSilent(_ silentModel:SilentModel, macAddress: String? = nil, closure:(_ success:Bool)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var disturb = protocol_do_not_disturb()
        disturb.switch_flag = silentModel.isOpen ? 0xAA :0x55
        disturb.start_hour = silentModel.startHour
        disturb.start_minute = silentModel.startMinute
        disturb.end_hour = silentModel.endHour
        disturb.end_minute = silentModel.endMinute
        
        let length = UInt32(MemoryLayout<UInt8>.size*7)
        
        var ret_code:UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_DO_NOT_DISTURB,&disturb,length,&ret_code);

        guard ret_code == 0 else {
            closure(false)
            return
        }
        
        //保存数据库
        let device = getDevice(withAccessoryId: macAddress)
        
        let silent = coredataHandler.selectSilentDistrube(userId: UserManager.share().userId, withMacAddress: realMacAddress)
        silent?.startHour = Int16(silentModel.startHour)
        silent?.startMinute = Int16(silentModel.startMinute)
        silent?.endHour = Int16(silentModel.endHour)
        silent?.endMinute = Int16(silentModel.endMinute)
        silent?.isOpen = silentModel.isOpen
        guard coredataHandler.commit() else {
            closure(false)
            return
        }
        closure(true)
    }
     */
    
    /*
    //MARK:- 设置心率区间
    public func setHeartRateInterval(_ heartIntervalModel:HeartIntervalModel ,closure:(_ success:Bool) -> ()){
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = accessoryId{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var interval = protocol_heart_rate_interval()
        interval.aerobic_threshold = heartIntervalModel.aerobic
        interval.burn_fat_threshold = heartIntervalModel.burnFat
        interval.limit_threshold = heartIntervalModel.limit
        
        
        let length = UInt32(MemoryLayout<UInt8>.size * 5)
        var ret_code:UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_HEART_RATE_INTERVAL,&interval,length,&ret_code);

        guard ret_code == 0 else {
            closure(false)
            return
        }
        
        //保存数据库
        guard let heartInterval = coredataHandler.selectHeartInterval(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(false)
            return
        }
        heartInterval.aerobic = Int16(heartIntervalModel.aerobic)
        heartInterval.burnFat = Int16(heartIntervalModel.burnFat)
        heartInterval.limit = Int16(heartIntervalModel.limit)
        guard coredataHandler.commit() else {
            closure(false)
            return
        }
        closure(true)
    }
     */
    
    /*
    //MARK:- 获取心率区间
    public func getHeartRateInterval(_ macAddress: String? = nil, closure: (HeartInterval?)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        
        closure(coredataHandler.selectHeartInterval(userId: UserManager.share().userId, withMacAddress: realMacAddress))
    }
     */
    
    /*
    //MARK:- 设置左右手穿戴
    /*handtype true为左手*/
    public func setHand(_ leftHand:Bool , closure:(_ success:Bool)->()){

        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = accessoryId{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var handle = protocol_set_handle()
        handle.hand_type = leftHand ? 0x00 : 0x01
        
        let length = UInt32(MemoryLayout<UInt8>.size*3)
        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_HAND, &handle, length, &ret_code)
        
        guard ret_code == 0 else {
            closure(false)
            return
        }
        //保存数据库
        guard let handGesture = coredataHandler.selectHandGesture(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(false)
            return
        }
        handGesture.leftHand = leftHand
        guard coredataHandler.commit() else {
            closure(false)
            return
        }
        closure(true)
    }
     */
    
    /*
    //MARK:- 获取左右手穿戴
    public func getHand(_ macAddress: String? = nil, closure: (_ isLeftHand: Bool?)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        
        guard let handGesture = coredataHandler.selectHandGesture(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(nil)
            return
        }
        
        closure(handGesture.leftHand)
    }
     */
    
    /*
    //MARK:- 设置心率模式
    public func setHeartRateMode(_ heartRateMode: HeartRateMode, macAddress: String? = nil, closure:(_ success:Bool) ->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var mode = protocol_heart_rate_mode()

        switch heartRateMode {
        case .auto:
            mode.mode = 0x88
        case .close:
            mode.mode = 0x55
        case .manual:
            mode.mode = 0xAA
        }
        
        let length = UInt32(MemoryLayout<UInt8>.size * 3)
        var ret_code:UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_HEART_RATE_MODE, &mode, length, &ret_code);

        guard ret_code == 0 else {
            closure(false)
            return
        }
        //保存数据库
        guard let heartInterval = coredataHandler.selectHeartInterval(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(false)
            return
        }
        heartInterval.heartRateMode = Int16(mode.mode)
        guard coredataHandler.commit() else {
            closure(false)
            return
        }
        closure(true)
    }
     */
    
    /*
    //MARK:- 获取心率模式
    public func getHeartRateMode(_ macAddress: String? = nil, closure: (HeartRateMode?)->()){
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        
        guard let heartInterval = coredataHandler.selectHeartInterval(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(nil)
            return
        }
        let result = heartInterval.heartRateMode
        switch result {
        case 0x88:
            closure(HeartRateMode.auto)
        case 0x55:
            closure(HeartRateMode.close)
        case 0xAA:
            closure(HeartRateMode.manual)
        default:
            closure(nil)
        }
    }
     */
    
    /*
    //MARK:- 设置横屏
    public func setLandscape(_ flag: Bool, macAddress: String? = nil, closure:(_ success:Bool) ->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var mode: protocol_display_mode = protocol_display_mode.init()
        
        mode.mode = flag ? 0x01 : 0x02

        let length = UInt32(MemoryLayout<UInt8>.size*3)
        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_DISPLAY_MODE, &mode, length, &ret_code);
 
        guard ret_code == 0 else {
            closure(false)
            return
        }
        //保存数据库
        guard let device = coredataHandler.selectDevice(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(false)
            return
        }
        device.landscape = flag
        guard coredataHandler.commit() else {
            closure(false)
            return
        }
        closure(true)
    }
     */
    
    /*
    //MARK:- 获取横屏消息
    public func getLangscape(_ macAddress: String? = nil, closure: (_ isLangScape: Bool?)->()){
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        
        guard let device = coredataHandler.selectDevice(userId: UserManager.share().userId, withMacAddress: realMacAddress) else {
            closure(nil)
            return
        }
        
        closure(device.landscape)
    }
     */
    
    //MARK:- 同步健康数据
    /*
     *  status 是否同步完成
     *  percent 同步百分比
     */
    public func setSynchronizationHealthData(_ accessoryId: String? = nil, closure:@escaping (_ complete: Bool, _ progress: Int16) -> ()){
        
        //判断mac地址是否存在
        print("2....", Unmanaged.passUnretained(self).toOpaque())
        
        //判断mac地址是否存在
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            debugPrint("<sync healthData> 同步获取accessoryId失败")
            closure(false, 0)
            return
        }
        
        //获取用户id
        let userId = UserManager.share().userId
        
        //同步进度回调
        swiftSynchronizationHealthData = { data in
            if data.0{
                //存储最后同步时间
                if let device = self.getDevice(withAccessoryId: accessoryId){
                    device.lastSyncTime = Date() as NSDate?
                    _ = self.coredataHandler.commit()
                }
            }
            closure(data.0,Int16(data.1))
        }
        
        //获取到运动数据回调
        swiftReadSportData = { data in

            let sportData = data.assumingMemoryBound(to: protocol_health_resolve_sport_data_s.self).pointee
            
            
            //处理sportData
            let year = sportData.head1.date.year
            let month = sportData.head1.date.month
            let day = sportData.head1.date.day
            guard day != 0, month != 0, year != 0 else {
                return
            }
            var component = DateComponents()
            component.day = Int(day)
            component.month = Int(month)
            component.year = Int(year)
            let optionDate = Calendar.current.date(from: component)       //日期
            let id = self.accessoryId
            let itemCount = sportData.items_count
            let minuteDuration = sportData.head1.per_minute
            let minuteOffset = sportData.head1.minute_offset
            let totalActiveTime = sportData.head2.total_active_time
            let totalCal = sportData.head2.total_cal
            let totalDistance = sportData.head2.total_distances
            let totalStep = sportData.head2.total_step
            let perMinute = sportData.head1.per_minute
            let packetCount = sportData.head1.packet_count
            
            guard let realDate = optionDate  else {
                return
            }
            
            
            
            guard let sport = self.coredataHandler.insertSportEverydayData(withAccessoryId: realAccessoryId, UserId: userId, withDate: realDate) else {
                return
            }
            sport.date = realDate as NSDate
            sport.objectId = id
            sport.sportItemCount = Int32(itemCount)
            sport.perMinute = Int32(minuteDuration)
            sport.offset = Int32(minuteOffset)
            sport.totalActiveTimeSeconds = Int32(totalActiveTime)
            sport.totalCalories = Int32(totalCal)
            sport.totalDistances = Int32(totalDistance)
            sport.perMinute = Int32(perMinute)
            //sport.packetCount = Int16(packetCount)
            sport.totalSteps = Int32(totalStep)
            guard self.coredataHandler.commit() else {
                return
            }
            
            
            let items = sportData.items
            //let length = MemoryLayout<ble_sync_sport_item>.size
            (0..<96).forEach(){
                i in
                if let item = items?[i]{
                    print("item 步数 :" , item.sport_count, Thread.isMainThread);
                    
                    if let sportItem = self.coredataHandler.createSportEverydayDataItem(withAccessoryId: realAccessoryId, byUserId: userId, withDate: realDate, withItemId: Int16(i)){
                        //sportItem.activeTime = Int16(item.active_time)
                        sportItem.calories = Int16(item.calories)
                        sportItem.distancesM = Int16(item.distance)
                        sportItem.id = Int16(i)
                        sportItem.mode = Int16(item.mode)
                        sportItem.steps = Int16(item.sport_count)                       
                    }
                }
            }
            DispatchQueue.main.async {
                _ = self.coredataHandler.commit()
            }
        }
        
        //获取睡眠数据回调
        swiftReadSleepData = { data in
            let sleepData = data.assumingMemoryBound(to: protocol_health_resolve_sleep_data_s.self).pointee
            
            //处理sportData
            let year = sleepData.head1.date.year
            let month = sleepData.head1.date.month
            let day = sleepData.head1.date.day
            guard day != 0, month != 0, year != 0 else {
                return
            }
            var component = DateComponents()
            component.day = Int(day)
            component.month = Int(month)
            component.year = Int(year)
            
            let optionDate = Calendar.current.date(from: component)       //日期
            let id = self.accessoryId
            let itemCount = sleepData.itmes_count
            let deepSleepCount = sleepData.head2.deep_sleep_count
            let deepSleepMinute = sleepData.head2.deep_sleep_minute
            let endTimeHour = Int16(sleepData.head1.end_time_hour)
            let endTimeMinute = Int16(sleepData.head1.end_time_minute)
            let lightSleepCount = sleepData.head2.light_sleep_count
            let lightSleepMinute = sleepData.head2.ligth_sleep_minute
            let totalMinute = sleepData.head1.total_minute
            let packetCount = sleepData.head1.packet_count
            let sleepItemCount = sleepData.head1.sleep_item_count
            let wakeCount = sleepData.head2.wake_count
            var deltaHour = Int16(totalMinute / 60)
            var deltaMinute = Int16(totalMinute % 60)
            if deltaMinute > endTimeMinute{
                deltaHour += 1
                deltaMinute -= 60
            }
            var startTimeHour = endTimeHour - deltaHour
            while startTimeHour < 0 {
                startTimeHour += 24
            }
            let startTimeMinute = endTimeMinute - deltaMinute
            
            guard let realDate = optionDate  else {
                return
            }
            
            
            guard let sleep = self.coredataHandler.insertSleepEverydayData(withAccessoryId: realAccessoryId, byUserId: userId, withDate: realDate) else {
                return
            }
            sleep.date = realDate as NSDate
            sleep.objectId = id

            sleep.itemsCount = Int32(itemCount)
            //sleep.packetCount = Int16(packetCount)
            sleep.deepSleepCount = Int32(deepSleepCount)
            sleep.deepSleepMinutes = Int16(deepSleepMinute)
            sleep.endedHour = Int32(endTimeHour)
            sleep.endedMinute = Int32(endTimeMinute)
            sleep.lightSleepCount = Int32(lightSleepCount)
            sleep.lightSleepMinutes = Int16(lightSleepMinute)
            sleep.deepSleepCount = Int32(deepSleepCount)
            sleep.deepSleepMinutes = Int16(deepSleepMinute)
            sleep.totalMinutes = Int16(totalMinute)
            sleep.awakeCount = Int32(wakeCount)
            sleep.endedHour = Int32(startTimeHour)
            sleep.endedMinute = Int32(startTimeMinute)
            
            guard self.coredataHandler.commit() else {
                return
            }
            
            let items = sleepData.itmes
            //let length = MemoryLayout<ble_sync_sleep_item>.size
            (0..<96).forEach(){
                i in
                if let item = items?[i]{
                    
                    if let sleepItem = self.coredataHandler.createSleepEverydayDataItem(withAccessoryId: realAccessoryId, byUserId: userId, withDate: realDate, withItemId: Int16(i)){
                        sleepItem.durationsMinute = Int16(item.durations)
                        sleepItem.id = Int16(i)
                        sleepItem.status = Int16(item.sleep_status)
                    }
                }
            }
            DispatchQueue.main.async {
                _ = self.coredataHandler.commit()
            }
        }
        
        //获取心率数据回调
        swiftReadHeartRateData = { data in
            let heartRateData = data.assumingMemoryBound(to: protocol_health_resolve_heart_rate_data_s.self).pointee
            
            //处理数据
            let year = heartRateData.head1.year
            let month = heartRateData.head1.month
            let day = heartRateData.head1.day
            guard day != 0, month != 0, year != 0 else {
                return
            }
            var component = DateComponents()
            component.day = Int(day)
            component.month = Int(month)
            component.year = Int(year)
            let optionDate = Calendar.current.date(from: component)       //日期
            let id = self.accessoryId
            let itemCount = heartRateData.items_count
            let aerobicMinutes = heartRateData.head2.aerobic_mins
            let aerobicThreshld = heartRateData.head2.aerobic_threshold
            let burnFatMinutes = heartRateData.head2.burn_fat_mins
            let burnFatThreshold = heartRateData.head2.burn_fat_threshold
            let limitMinutes = heartRateData.head2.limit_mins
            let limitThreshold = heartRateData.head2.limit_threshold
            let minuteOffset = heartRateData.head1.minute_offset
            let packetsCount = heartRateData.head1.packets_count
            let silentHeartRate = heartRateData.head1.silent_heart_rate
            
            guard let realDate = optionDate  else {
                return
            }
            
            guard let heartRate = self.coredataHandler.insertHeartRateEverydayData(withAccessoryId: realAccessoryId, byUserId: userId, withDate: realDate) else {
                return
            }
            heartRate.date = realDate as NSDate
            heartRate.objectId = id
            //heartRate.itemCount = Int16(itemCount)
            heartRate.aerobicMinutes = Int16(aerobicMinutes)
            heartRate.aerobicThreshold = Int16(aerobicThreshld)
            heartRate.burnFatMinutes = Int16(burnFatMinutes)
            heartRate.burnFatThreshold = Int16(burnFatThreshold)
            heartRate.limitMinutes = Int16(limitMinutes)
            heartRate.limitThreshold = Int16(limitThreshold)
            heartRate.offset = Int16(minuteOffset)
            //heartRate.packetsCount = Int16(packetsCount)
            heartRate.silentHeartRate = Int16(silentHeartRate)
         
            guard self.coredataHandler.commit() else {
                return
            }
            
            let items = heartRateData.items
            //heartRateData.items_count
            //let length = MemoryLayout<ble_sync_heart_rate_item>.size
            (0..<96).forEach(){
                i in
                if let item = items?[i]{
                    
                    
                    if let heartRateItem = self.coredataHandler.createHeartRateEverydayDataItem(withAccessoryId: realAccessoryId, byUserId: userId, withDate: realDate, withItemId: Int16(i)){
                        heartRateItem.value = Int16(item.data)
                        heartRateItem.id = Int16(i)
                        heartRateItem.toLastMinutes = Int16(item.offset)
                    }
                }
            }
            DispatchQueue.main.async {
                _ = self.coredataHandler.commit()
            }
        }
        
        protocol_health_sync_start();
    }
    
    //MARK:- 获取健康数据
    public func getSportData(_ accessoryId: String? = nil, date: Date = Date(), offset: Int = 0, closure:(_ result: [SportEverydayData]) ->()){

        //判断accessoryId地址是否存在
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            closure([])
            return
        }
        
        let userId = UserManager.share().userId
        let sportEverydayDataList = coredataHandler.selectSportEverydayDataList(withAccessoryId: realAccessoryId, byUserId: userId, withDate: date, withDayOffset: offset)
        closure(sportEverydayDataList)
    }
    
    public func getSleepData(_ accessoryId: String? = nil, date: Date = Date(), offset: Int = 0, closure:(_ result: [SleepEverydayData]) ->()){
        
        //判断accessoryId地址是否存在
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            closure([])
            return
        }
        
        let userId = UserManager.share().userId
        let sleepDataList = coredataHandler.selectSleepEverydayDataList(withAccessoryId: realAccessoryId, byUserId: userId, withDate: date, withDayOffset: offset)
        closure(sleepDataList)
    }
    public func getHeartRateData(_ accessoryId: String? = nil, date: Date = Date(), offset: Int = 0, closure:(_ result: [HeartRateEverydayData]) ->()){
        
        //判断accessoryId地址是否存在
        var realAccessoryId: String!
        if let ai = accessoryId{
            realAccessoryId = ai
        }else if let ai = self.accessoryId{
            realAccessoryId = ai
        }else{
            closure([])
            return
        }
        
        let userId = UserManager.share().userId
        let heartrateDataList = coredataHandler.selectHeartRateEverydayDataList(withAccessoryId: realAccessoryId, byUserId: userId, withDate: date, withDayOffset: offset)
        closure(heartrateDataList)
    }
    
    //MARK:- 同步配置
    public func setSynchronizationConfig(closure:@escaping (_ complete:Bool) -> ()){

        swiftSynchronizationConfig = { data in
            closure(data)
        }
        protocol_sync_config_start()
    }
    
    /*
    //设置闹钟
    public func updateAlarm(_ macAddress: String? = nil, alarmId: Int16, customAlarm: CustomAlarm, closure: (_ success: Bool)->()){
      
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        let alarmList = coredataHandler.selectAlarm(userId: UserManager.share().userId, alarmId: alarmId, withMacAddress: realMacAddress)
        debug("update alarmList:", alarmList)
        guard !alarmList.isEmpty else {
            closure(false)
            return
        }
        
        let alarm = alarmList[0]
        alarm.hour = Int16(customAlarm.hour)
        alarm.minute = Int16(customAlarm.minute)
        alarm.duration = customAlarm.duration
        alarm.repeatList = Int16(customAlarm.repeatList.reduce(0x00){$0 | 0x01 << $1})
        alarm.synchronize = false
        alarm.type = customAlarm.type
        alarm.id = alarmId
        debug("?????????????????????")
        debug(alarm.repeatList)
        debug(customAlarm.repeatList)
        guard coredataHandler.commit() else {
            closure(false)
            return
        }
        closure(true)
    }
    
    //MARK:- 添加闹钟
    public func addAlarm(_ macAddress: String? = nil, customAlarm: CustomAlarm, closure: @escaping (_ success: Bool, _ alarmId: Int16?)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false, nil)
            return
        }
        //数据库操作
        guard let alarm = coredataHandler.insertAlarm(userId: UserManager.share().userId, withMacAddress: realMacAddress) else{
            closure(false, nil)
            return
        }
        
        updateAlarm(realMacAddress, alarmId: alarm.id, customAlarm: customAlarm){
            success in
            closure(true, alarm.id)
        }
        
        
    }
    
    //MARK:- 删除闹钟
    public func deleteAlarm(_ macAddress: String? = nil, alarmId: Int16, closure:(_ complete: Bool)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        //数据库操作
        let alarmList = coredataHandler.selectAlarm(userId: UserManager.share().userId, alarmId: alarmId, withMacAddress: realMacAddress)
        
        guard !alarmList.isEmpty else {
            closure(false)
            return
        }
        
        let coreDataAlarmModel = alarmList[0]
        var alarm = protocol_set_alarm()
        alarm.alarm_id = UInt8(coreDataAlarmModel.id)
        alarm.repeat = 0
        alarm.type = UInt8(coreDataAlarmModel.type)
        alarm.hour = UInt8(coreDataAlarmModel.hour)
        alarm.minute = UInt8(coreDataAlarmModel.minute)
        alarm.tsnooze_duration = UInt8(coreDataAlarmModel.duration)
        alarm.status = 0xAA
        let length = UInt32(MemoryLayout<UInt8>.size * 9)
        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_ALARM, &alarm, length, &ret_code)
        if ret_code == 0 {
            coredataHandler.deleteAlarm(userId: UserManager.share().userId, alarmId: alarmId, withMacAddress: realMacAddress)
            closure(true)
        }
    }
    
    //MARK:- 获取闹钟
    public func getAlarm(_ macAddress: String? = nil, alarmId: Int16, closure: (Alarm?)->()){
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(nil)
            return
        }
        
        closure(coredataHandler.selectAlarm(userId: UserManager.share().userId, alarmId: alarmId, withMacAddress: realMacAddress).first)
    }
    
    //MARK:- 获取所有闹钟
    public func getAllAlarms(closure: ([Alarm])->()){
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = accessoryId{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure([])
            return
        }
        
        closure(coredataHandler.selectAllAlarm(userId: UserManager.share().userId, withMacAddress: realMacAddress))
    }
    
    //同步闹钟数据
    public func setSynchronizationAlarm(_ macAddress: String? = nil, closure:@escaping (_ success:Bool) -> ()){
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
    //1.先清除
        protocol_set_alarm_clean()
    //2.再添加 添加的闹钟是从数据库获取的
        //获取所有闹钟
        let alarmList = coredataHandler.selectAllAlarm(userId: UserManager.share().userId, withMacAddress: realMacAddress)
        print("alarmList: \(alarmList)")
        alarmList.forEach(){
            localAlarm in
            var alarm = protocol_set_alarm()
            alarm.hour = UInt8(localAlarm.hour)
            alarm.minute = UInt8(localAlarm.minute)
            alarm.alarm_id = UInt8(localAlarm.id)
            alarm.tsnooze_duration = UInt8(localAlarm.duration)
            alarm.type = UInt8(localAlarm.type)
            alarm.repeat = 0xFF // UInt8(localAlarm.repeatList)
            alarm.status = UInt8(localAlarm.status)
            protocol_set_alarm_add(alarm)
            
            print("set alarm: \(alarm)")
        }
        
    //3.再同步
        swiftSynchronizationAlarm = { complete in
            
            closure(complete)
            let alarmList = self.coredataHandler.selectAllAlarm(userId: UserManager.share().userId, withMacAddress: realMacAddress)
            alarmList.forEach(){
                localAlarm in
                localAlarm.synchronize = true
            }
            guard self.coredataHandler.commit() else {
                return
            }
        }
        protocol_set_alarm_start_sync()
    }
     */
    
    //获取总开关状态
    public func getNoticeStatus(_ closure:@escaping (_ status:Bool) -> ()){
        
        swiftGetNoticeStatus = { data in
            guard data.0 == 0x55 else {
                closure(false)
                return
            }
            closure(true)
        }
        
        var ret_code:UInt32 = 0
        vbus_tx_evt(VBUS_EVT_BASE_APP_GET,VBUS_EVT_APP_GET_NOTICE_STATUS,&ret_code);
    }
    
    //打开总开关
    private func setOpenNoticeSwitch(closure:(_ status:Bool) ->()){
        var notice = protocol_set_notice()
        notice.notify_switch = 0x55     //0x55 总开关开 0xAA 总开关关 0x88 设置子开关 0x00 无效
        notice.notify_itme1 = 0x00
        notice.notify_itme2 = 0x00
        notice.call_switch = 0x00
        notice.call_delay = 0x00
        
        let length = UInt32(MemoryLayout<UInt8>.size * 7)
        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET, VBUS_EVT_APP_SET_NOTICE, &notice, length, &ret_code)
        guard ret_code == 0 else {
            closure(false)
            return
        }
        closure(true)
    }
    
    /*
    //MARK:- 设置音乐开关
    public func setMusicSwitch(_ open:Bool, macAddress: String? = nil, closure:@escaping (_ success:Bool) -> ()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var musicOn = protocol_music_onoff()
        musicOn.switch_status = open ? 0xAA :0x55
        
        let length = UInt32(MemoryLayout<UInt8>.size * 3)
        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_MUISC_ONOFF, &musicOn, length, &ret_code)
        
        guard ret_code==0 else {
            closure(false)
            return
        }
        
        guard open else {
            closure(false)
            return
        }
        
        setOpenNoticeSwitch(closure: { success in
           
            guard success else{
                return
            }
            //保存音乐开关
            let notice = coredataHandler.selectNotice(userId: UserManager.share().userId, withMacAddress: realMacAddress)
            notice?.musicSwitch = open
            guard coredataHandler.commit() else{
                closure(false)
                return
            }
            loop(5, closure: closure)
        })
    }
    
    //MARK:- 设置来电提醒
    public func setCallRemind(_ open:Bool, delay:UInt8, macAddress: String? = nil, closure:@escaping (_ success:Bool)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        
        var call = protocol_set_notice()
        call.notify_switch = 0x88
        
        let notice = coredataHandler.selectNotice(userId: UserManager.share().userId, withMacAddress: realMacAddress)
        call.call_switch = open ? 0x55 :0xAA
        call.call_delay = delay
        call.notify_itme1 = UInt8(notice?.notifyItem0 ?? 0)
        call.notify_itme2 = UInt8(notice?.notifyItem1 ?? 0)
        
        //从数据库查询出提醒模型赋给call,暂时填为0
        let length = UInt32(MemoryLayout<UInt8>.size * 7)
        
        var ret_code:UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_NOTICE,&call,length,&ret_code)
        
        guard ret_code==0 else {
            closure(false)
            return
        }
        guard open else {
            closure(false)
            return
        }
        
        setOpenNoticeSwitch(closure: { success in
            print("打开总开关 \(success)")
            guard success else{
                return
            }
            
            notice?.callSwitch = open
            notice?.callDelay = Int16(delay)
            guard coredataHandler.commit() else{
                closure(false)
                return
            }
            loop(5, closure: closure)
        })
    }
    
    //MARK:- 循环设置总开关5次
    private func loop(_ count: Int, closure: @escaping (_ success:Bool)->()){
        
        guard count > 0 else {
            return
        }
        
        _ = delay(5, task: {
            //调5次
            self.getNoticeStatus({status in
                print("获取总开关状态 \(status)")
                if status{
                    //保存音乐开关到数据库
                    
                    closure(status)
                }else{
                    guard count > 0 else{
                        return
                    }
                    self.loop(count - 1, closure: closure)
                }
            })
        })
    }
    
    //MARK:- 设置智能提醒
    public func setSmartAlart(smart:SmartAlertPrm, macAddress: String? = nil, closure:@escaping (_ success:Bool)->()){
        
        //判断mac地址是否存在
        var realMacAddress: String!
        if let md = macAddress{
            realMacAddress = md
        }else if let md = self.accessoryId{
            realMacAddress = md
        }else{
            closure(false)
            return
        }
        
        var call = protocol_set_notice()
        
        call.notify_switch = 0x88
        
        //从数据库查询出提醒模型赋给call,暂时填为0
        let notice = coredataHandler.selectNotice(userId: UserManager.share().userId, withMacAddress: realMacAddress)
        call.notify_itme1 = UInt8(notice?.notifyItem0 ?? 0)
        call.notify_itme2 = UInt8(notice?.notifyItem1 ?? 0)
        call.call_switch = (notice?.callSwitch ?? false) ? 0x55 : 0xAA
        call.call_delay = UInt8(notice?.callDelay ?? 0)
        
        let itmes1: UInt8 = getValue(smart.sms, 1) | getValue(smart.weChat,3) | getValue(smart.qq,4) | getValue(smart.faceBook,6) | getValue(smart.twitter,7)
        let itmes2: UInt8 = getValue(smart.whatsapp,0) | getValue(smart.messenger,1) | getValue(smart.instagram,2) | getValue(smart.linkedIn,3)

        call.notify_itme1 = itmes1
        call.notify_itme2 = itmes2
        
        let length = UInt32(MemoryLayout<UInt8>.size * 7)
        var ret_code: UInt32 = 0
        vbus_tx_data(VBUS_EVT_BASE_APP_SET,VBUS_EVT_APP_SET_NOTICE, &call, length, &ret_code)
        
        guard ret_code==0 else {
            closure(false)
            return
        }
        print("打开总开关")
        setOpenNoticeSwitch(closure: { success in
            print("打开总开关 \(success)")
            guard success else{
                return
            }
            
            notice?.notifyItem0 = Int16(itmes1)
            notice?.notifyItem1 = Int16(itmes2)
            guard coredataHandler.commit() else{
                closure(false)
                return
            }
            loop(5, closure: closure)
        })
    }
    */
  
    
    
    private func getValue(_ flag:Bool,_ offset:UInt8) -> UInt8{
        let result = flag ? 0x01 << offset : 0x00
        return result
    }

}


