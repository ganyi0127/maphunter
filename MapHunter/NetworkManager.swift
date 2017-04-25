//
//  NetworkManager.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/19.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
//MARK:- 监测网络是否可用
func isNetworkEnable() -> Bool{
    guard let reachability = Reachability() else{
        debugPrint("<Reachability> 生成网络监测失败")
        return false
    }
    
    //判断连接类型
    if reachability.isReachableViaWiFi {
        debugPrint("<reachability> type: WiFi")
    }else if reachability.isReachableViaWWAN {
        debugPrint("<reachability> type: 移动网络")
    }else {
        debugPrint("<reachability> type: 没有网络连接")
    }
    
    //判断连接状态
    if reachability.isReachable{
        debugPrint("<reachability> state: 网络可用")
        return true
    }else{
        debugPrint("<reachability> state: 网络不可用")
        return false
    }
    
}
