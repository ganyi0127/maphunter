//
//  AppointScanVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import CoreBluetooth
import AngelFit
class AppointScanVC: ScanVC {
    
    var filterName: String?
    
    //获取已连接设备
    override func godManager(currentConnectPeripheral peripheral: CBPeripheral, peripheralName name: String) {
        //判断UUID重复，避免重复存储
        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
        guard sameList.isEmpty else{
            return
        }
        
        let standardName = name.lowercased().replacingOccurrences(of: " ", with: "")
        if let fname = filterName{
            if standardName == fname{
                peripheralList.append((name, 0, peripheral))
                peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
            }
        }else{
            peripheralList.append((name, 0, peripheral))
            peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
        }
    }
    //发现设备
    override func godManager(didDiscoverPeripheral peripheral: CBPeripheral, withRSSI RSSI: NSNumber, peripheralName name: String) {
        
        //判断UUID重复，避免重复存储
        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
        guard sameList.isEmpty else{
            return
        }
        
        let standardName = name.lowercased().replacingOccurrences(of: " ", with: "")
        if let fname = filterName{
            if standardName == fname {
                peripheralList.append((name, RSSI, peripheral))
                peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
            }
        }else{
            peripheralList.append((name, RSSI, peripheral))
            peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
        }
    }
    
    //蓝牙连接状态
    override func godManager(didUpdateConnectState state: GodManagerConnectState, withPeripheral peripheral: CBPeripheral, withError error: Error?) {
        debugPrint("蓝牙连接状态", state)
        switch state {
        case .connect:
            //登陆主页
            endLoading()
            let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
            present(rootTBC, animated: true, completion: nil)
        case .disConnect:
            break
        case .failed:
            break
        }
    }
}
