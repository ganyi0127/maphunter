//
//  NotifyCallVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
import CoreBluetooth
class NotifyCallVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate let godManager = GodManager.share()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        godManager.delegate = self
        godManager.isAutoReconnect = true
        
        nextButton.setTitleColor(defaut_color, for: .normal)
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextButton.isEnabled = false
        nextButton.setTitleColor(defaut_color, for: .normal)
        nextButton.setTitleColor(.lightGray, for: .disabled)
//        _ = delay(1){
//            self.nextButton.isEnabled = true
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let angelManager = AngelManager.share()
        guard let macaddress = angelManager?.macAddress else{
            endLoading()
            nextButton.isEnabled = true
            
            let alert = UIAlertController(title: "无法请求来电提醒", message: "手环未连接", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.setBlackTextColor()
            present(alert, animated: true, completion: nil)
            return
        }

        debugPrint("MacAddress: \(String(describing: macaddress))")
        
        beginLoading(byTitle: "正在请求来电提醒权限")
        angelManager?.setCallRemind(true, delay: 1){
            success in
            debugPrint("<call remind> 打开来电提醒: \(success)")
            DispatchQueue.main.async {
                self.endLoading()                
                self.nextButton.isEnabled = true
            }
        }
    }
        
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到主页
    @IBAction func next(_ sender: UIButton) {
        //登陆主页
        let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
        present(rootTBC, animated: true, completion: nil)
    }
}

extension NotifyCallVC: GodManagerDelegate{
    //获取已连接设备
    func godManager(currentConnectPeripheral peripheral: CBPeripheral, peripheralName name: String) {
    }
    
    func godManager(didDiscoverPeripheral peripheral: CBPeripheral, withRSSI RSSI: NSNumber, peripheralName name: String){
   
    }
    func godManager(didUpdateCentralState state: GodManagerState) {
        print("连接状态: \(state)")
    }
    func godManager(didUpdateConnectState state: GodManagerConnectState, withPeripheral peripheral: CBPeripheral, withError error: Error?) {
        print(state)
        if state == .connect{
            
        }else if state == .failed{
        }
    }
    
    func godManager(didConnectedPeripheral peripheral: CBPeripheral, connectState isSuccess: Bool) {
        print("connect \(String(describing: peripheral.name))--\(isSuccess ? "成功" : "失败")")
    }
    
    func godManager(bindingPeripheralsUUID UUIDList: [String]) {
        print("已绑定的设备列表: \(UUIDList)")
    }
}
