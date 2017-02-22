//
//  ScanVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/2/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
import CoreBluetooth
class ScanVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    //god manager
    fileprivate let godManager = GodManager.share()
    
    //存储所有设备
    fileprivate var peripheralList = [(name: String, RSSI: NSNumber, peripheral: CBPeripheral)](){
        didSet{
            
            tableview.reloadData()
        }
    }
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        automaticallyAdjustsScrollViewInsets = false
        
        godManager.isAutoReconnect = false
        godManager.delegate = self
    }
    
    private func createContents(){
        
        //开始扫描
        godManager.startScan()
    }
}

//MARK:- angelfit
extension ScanVC: GodManagerDelegate{
    //获取已连接设备
    func godManager(currentConnectPeripheral peripheral: CBPeripheral, peripheralName name: String) {
        //判断UUID重复，避免重复存储
        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
        guard sameList.isEmpty else{
            return
        }
        peripheralList.append((name, 0, peripheral))
        peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
    }
    //发现设备
    func godManager(didDiscoverPeripheral peripheral: CBPeripheral, withRSSI RSSI: NSNumber, peripheralName name: String) {
        
        //判断UUID重复，避免重复存储
        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
        guard sameList.isEmpty else{
            return
        }
        
        peripheralList.append((name, RSSI, peripheral))
        peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
    }
    
    func godManager(didConnectedPeripheral peripheral: CBPeripheral, connectState isSuccess: Bool) {
        
        guard isSuccess else {
            return
        }
        
        AngelManager.share()?.setBind(true){_ in }
    }
    
    func godManager(bindingPeripheralsUUID UUIDList: [String]) {
        
    }
    
    //蓝牙中心状态
    func godManager(didUpdateCentralState state: GodManagerState) {
        debugPrint("蓝牙中心状态", state)
    }
    
    //蓝牙连接状态
    func godManager(didUpdateConnectState state: GodManagerConnectState, withPeripheral peripheral: CBPeripheral, withError error: Error?) {
        debugPrint("蓝牙连接状态", state)
        switch state {
        case .connect:
            _ = navigationController?.popViewController(animated: true)
        case .disConnect:
            break
        case .failed:
            break
        }
    }
}

//MARK:- tableview
extension ScanVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let peripheralModel = peripheralList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.textLabel?.font = fontSmall
        cell.detailTextLabel?.font = fontSmall
        cell.textLabel?.text = peripheralModel.name
        cell.detailTextLabel?.text = peripheralModel.RSSI == 0 ? "已连接" : "\(peripheralModel.RSSI)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheralModel = peripheralList[indexPath.row]
        
        godManager.connect(peripheralModel.peripheral)
    }
}
