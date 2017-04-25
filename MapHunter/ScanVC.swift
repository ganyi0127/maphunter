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
    let godManager = GodManager.share()
    
    //存储所有设备
    var peripheralList = [(name: String, RSSI: NSNumber, peripheral: CBPeripheral)]()
//    {
//        didSet{
//            
//            tableview.reloadData()
//        }
//    }
    
    //重新扫描按钮
    var showRescanButton = true
    var rescanButton: UIButton = {
        let buttonLength = view_size.width *  0.25
        let buttonFrame = CGRect(x: view_size.width / 2 - buttonLength / 2,
                                 y: view_size.height,
                                 width: buttonLength,
                                 height: buttonLength)
        let button = UIButton(frame: buttonFrame)
        if let image = UIImage(named: "resource/scan/rescan")?.transfromImage(size: CGSize(width: buttonLength, height: buttonLength)){
            button.setImage(image, for: .normal)
        }
        button.alpha = 0
        button.addTarget(self, action: #selector(rescan(sender:)), for: .touchUpInside)
        return button
    }()
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if let currentPeripheral = PeripheralManager.share().currentPeripheral {
//            godManager.disconnect(currentPeripheral, closure: {_ in})
//        }
        peripheralList.removeAll()
        godManager.delegate = nil
    }
    
    private func config(){
        
        automaticallyAdjustsScrollViewInsets = false
        
        godManager.isAutoReconnect = false
        godManager.delegate = self
        
        //tableview参数
        let customIdentifier = "custom"
        tableview.register(ScanCell.self, forCellReuseIdentifier: customIdentifier)
        tableview.separatorStyle = .none
        tableview.backgroundColor = timeColor
    }
    
    private func createContents(){
        
        //添加重新扫描按钮
        if showRescanButton{
            view.addSubview(rescanButton)
        }
        rescan(sender: rescanButton)
    }
    
    @objc func rescan(sender: UIButton){
        beginLoading(byTitle: "正在查找您的手环")
        
        peripheralList.removeAll()
        
        if showRescanButton{
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
                self.rescanButton.alpha = 0
                self.rescanButton.frame.origin.y = view_size.height
            }, completion: nil)
        }
        
        //开始扫描
        godManager.startScan{
            if self.showRescanButton{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.rescanButton.alpha = 1
                    let buttonLength = self.rescanButton.frame.width
                    self.rescanButton.frame.origin.y = view_size.height - buttonLength * 1.2
                }, completion: {
                    _ in
                    self.endLoading()
                })
            }else{
                self.endLoading()
            }
        }
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
        tableview.reloadData()
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
        tableview.reloadData()
    }
    
    func godManager(didConnectedPeripheral peripheral: CBPeripheral, connectState isSuccess: Bool) {
        
        guard isSuccess else {
            return
        }
        
        AngelManager.share()?.setBind(true){_ in}
    }
    
    func godManager(bindingPeripheralsUUID UUIDList: [String]) {
        
    }
    
    //蓝牙中心状态
    func godManager(didUpdateCentralState state: GodManagerState) {
        debugPrint("蓝牙中心状态", state)
        switch state {
        case .resetting:
            debugPrint(" 蓝牙设置中")
        case .unauthorized:
            debugPrint(" 蓝牙未授权")
        case .unknown:
            debugPrint(" 蓝牙未知")
        case .unsupported:
            debugPrint(" 该手机设备不支持蓝牙")
        case .poweredOff:
            //蓝牙关闭
            debugPrint(" 蓝牙已关闭")
            
            //跳转到蓝牙提示页面
            let bootBluetooth = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootbluetooth") as! BootBluetooth
            navigationController?.show(bootBluetooth, sender: nil)
        case .poweredOn:
            //蓝牙开启
            debugPrint(" 蓝牙已开启")
            
            //开始扫描
            if !godManager.isScaning{
                rescan(sender: rescanButton)
            }
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88   //view_size.width / 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let peripheralModel = peripheralList[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = ScanCell(identifier: identifier)
        }
        
        let scanCell = cell as! ScanCell
        let standardName = peripheralModel.name.lowercased().replacingOccurrences(of: " ", with: "")
        scanCell.bandName = standardName
        if tableview.indexPathForSelectedRow == indexPath {
            scanCell.setSelected(true, animated: true)
        }
        scanCell.bandRSSI = peripheralModel.RSSI.intValue
        return scanCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        guard indexPath.row < peripheralList.count else {
            return
        }
        let peripheralModel = peripheralList[indexPath.row]
        
        
        if peripheralModel.RSSI != 0 {
            beginLoading()
            godManager.connect(peripheralModel.peripheral)
        }else{
            let alertController = UIAlertController(title: "提示", message: "该设备已连接", preferredStyle: .alert)
            alertController.setBlackTextColor()
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
