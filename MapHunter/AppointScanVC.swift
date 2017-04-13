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
    
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK:- init
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        endLoading()
    }
    
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到下级页面--绑定手环（设置）
    @IBAction func next(_ sender: UIButton) {
        
        //判断是否连接设备
        guard PeripheralManager.share().currentPeripheral != nil else {
            debugPrint("请连接设备")
            return
        }
        
        //跳转到主页
        let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
        present(rootTBC, animated: true, completion: nil)
    }
    
    
    //获取已连接设备
    override func godManager(currentConnectPeripheral peripheral: CBPeripheral, peripheralName name: String) {
        
        //当有已连接手环情况下，设置下一步按钮为可点状态
        nextButton.isEnabled = true
        
        //判断UUID重复，避免重复存储
        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
        guard sameList.isEmpty else{
            return
        }
        
        let standardName = name.lowercased().replacingOccurrences(of: " ", with: "")
        if let fname = filterName{
            if standardName == fname || standardName.contains(fname){
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
            if standardName == fname || standardName.contains(fname) {
                peripheralList.append((name, RSSI, peripheral))
                peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
            }
        }else{
            peripheralList.append((name, RSSI, peripheral))
            peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
        }
    }
    
    //连接状态
    override func godManager(didConnectedPeripheral peripheral: CBPeripheral, connectState isSuccess: Bool) {
        guard isSuccess else {
            //跳转到连接失败页面
            let bootUnconnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootunconnect") as! BootUnconnectVC
            navigationController?.show(bootUnconnectVC, sender: nil)
            return
        }
        
        AngelManager.share()?.setBind(true){
            success in
            guard success else{
                //跳转到连接失败页面
                let bootUnconnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootunconnect") as! BootUnconnectVC
                self.navigationController?.show(bootUnconnectVC, sender: nil)
                return
            }
        }
    }
    
    //蓝牙连接状态
    override func godManager(didUpdateConnectState state: GodManagerConnectState, withPeripheral peripheral: CBPeripheral, withError error: Error?) {
        
        debugPrint("蓝牙连接状态", state)
        endLoading()    //取消loading
        
        switch state {
        case .connect:
            //登陆主页
            debugPrint(" 连接手环成功")
            nextButton.isEnabled = true

            for (index, peripheralElement) in peripheralList.enumerated() {
                if peripheral.identifier.uuidString == peripheralElement.peripheral.identifier.uuidString{
                    peripheralList.remove(at: index)
                    peripheralList.append((peripheralElement.name, 0, peripheralElement.peripheral))
                    peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
                    break
                }
            }
        case .disConnect:
            debugPrint(" 手环断开连接")
            
            let bootUnconnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootunconnect") as! BootUnconnectVC
            navigationController?.show(bootUnconnectVC, sender: nil)
        case .failed:
            //弹出无法连接页面
            debugPrint(" 连接手环失败")
            
            let bootUnconnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootunconnect") as! BootUnconnectVC
            navigationController?.show(bootUnconnectVC, sender: nil)
        }
    }
}
