//
//  FunctableCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/3/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
/*
 @NSManaged public var main_stepCalculation: Bool
 @NSManaged public var main_sleepMonitor: Bool
 @NSManaged public var main_singleSport: Bool
 @NSManaged public var main_realtimeData: Bool
 @NSManaged public var main_deviceUpdate: Bool
 @NSManaged public var main_heartRate: Bool
 @NSManaged public var main_ancs: Bool
 @NSManaged public var main_timeLine: Bool
 @NSManaged public var alarmCount: Int16
 @NSManaged public var alarmType_wakeUp: Bool
 @NSManaged public var alarmType_sleep: Bool
 @NSManaged public var alarmType_sport: Bool
 @NSManaged public var alarmType_medicine: Bool
 @NSManaged public var alarmType_dating: Bool
 @NSManaged public var alarmType_party: Bool
 @NSManaged public var alarmType_metting: Bool
 @NSManaged public var alarmType_custom: Bool
 @NSManaged public var control_takePhoto: Bool
 @NSManaged public var control_music: Bool
 @NSManaged public var call_calling: Bool
 @NSManaged public var call_callingContact: Bool
 @NSManaged public var call_callingNum: Bool
 @NSManaged public var notify_message: Bool
 @NSManaged public var notify_email: Bool
 @NSManaged public var notify_qq: Bool
 @NSManaged public var notify_weixin: Bool
 @NSManaged public var notify_sinaWeibo: Bool
 @NSManaged public var notify_facebook: Bool
 @NSManaged public var notify_twitter: Bool
 @NSManaged public var notify2_whatsapp: Bool
 @NSManaged public var notify2_message: Bool
 @NSManaged public var notify2_instagram: Bool
 @NSManaged public var notify2_linkedIn: Bool
 @NSManaged public var notify2_calendar: Bool
 @NSManaged public var notify2_skype: Bool
 @NSManaged public var notify2_alarmClock: Bool
 @NSManaged public var other_sedentariness: Bool
 @NSManaged public var other_antilost: Bool
 @NSManaged public var other_oneTouchCalling: Bool
 @NSManaged public var other_findPhone: Bool
 @NSManaged public var other_findDevice: Bool
 @NSManaged public var other_configDefault: Bool
 @NSManaged public var other_upHandGesture: Bool
 @NSManaged public var other_weather: Bool
 @NSManaged public var sms_tipInfoContact: Bool
 @NSManaged public var sms_tipInfoNum: Bool
 @NSManaged public var sms_tipInfoContent: Bool
 @NSManaged public var other2_staticHR: Bool
 @NSManaged public var other2_doNotDisturb: Bool
 @NSManaged public var other2_displayMode: Bool
 @NSManaged public var other2_heartRateMonitor: Bool
 @NSManaged public var other2_bilateralAntiLost: Bool
 @NSManaged public var other2_allAppNotice: Bool
 @NSManaged public var other2_flipScreen: Bool
 @NSManaged public var sport_walk: Bool
 @NSManaged public var sport_run: Bool
 @NSManaged public var sport_bike: Bool
 @NSManaged public var sport_foot: Bool
 @NSManaged public var sport_swim: Bool
 @NSManaged public var sport_climbing: Bool
 @NSManaged public var sport_badminton: Bool
 @NSManaged public var sport_other: Bool
 @NSManaged public var sport2_fitness: Bool
 @NSManaged public var sport2_spinning: Bool
 @NSManaged public var sport2_ellipsoid: Bool
 @NSManaged public var sport2_treadmill: Bool
 @NSManaged public var sport2_sitUp: Bool
 @NSManaged public var sport_pushUp: Bool
 @NSManaged public var sport2_dumbbell: Bool
 @NSManaged public var sport2_weightLifting: Bool
 @NSManaged public var sport3_bodybuildingExercise: Bool
 @NSManaged public var sport3_yoga: Bool
 @NSManaged public var sport3_ropeSkipping: Bool
 @NSManaged public var sport3_pingpang: Bool
 @NSManaged public var sport3_basketball: Bool
 @NSManaged public var sport3_football: Bool
 @NSManaged public var sport3_volleyball: Bool
 @NSManaged public var sport3_tennis: Bool
 @NSManaged public var sport4_golf: Bool
 @NSManaged public var sport4_baseball: Bool
 @NSManaged public var sport4_skiing: Bool
 @NSManaged public var sport4_rollerSkating: Bool
 @NSManaged public var sport4_dance: Bool
 @NSManaged public var main2_logIn: Bool
 */
enum FunctableType: String {
    case callRemind = "来电提醒"
    case smartRemind = "智能提醒"
    case longsitRemind = "走动提醒"
    case alarm = "手环闹钟"
    case silent = "勿扰模式"
    case music = "音乐控制"
    case camera = "遥控拍照"
    case watchBG = "表盘设置"
    case heartrate = "心率检测"
    case activeMode = "活动模式"
    case update = "固件升级"
    case more = "更多"
}

class FunctableCell: UITableViewCell {
 
    var type: FunctableType?{
        didSet{
            guard let t = type else {
                return
            }
            
            var imageName: String
            switch t {
            case .callRemind:
                imageName = "callremind"
            case .smartRemind:
                imageName = "smartremind"
            case .longsitRemind:
                imageName = "longsit"
            case .alarm:
                imageName = "alarm"
            case .silent:
                imageName = "silent"
            case .music:
                imageName = "music"
            case .camera:
                imageName = "camera"
            case .watchBG:
                imageName = "watchbg"
            case .heartrate:
                imageName = "heartrate"
            case .activeMode:
                imageName = "activemode"
            case .update:
                imageName = "update-0"
            case .more:
                imageName = "more"
            default:
                imageName = ""
            }
            
            //设置图片
            let image = UIImage(named: "resource/me/functable/" + imageName)
            iconImageView.image = image
            
            //设置标题
            let text = t.rawValue
            titleLabel.font = fontMiddle
            titleLabel.textColor = subWordColor
            titleLabel.text = text
            
            //设置副标题
            detailLabel.font = fontSmall
            detailLabel.textColor = lightWordColor
            detailLabel.text = "未开启"
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
 
    override func didMoveToSuperview() {
        
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
}
