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
    
    //MARK:- 名称
    private var connectName: String?
    var filterName: String?{
        didSet{
            guard let name = filterName else{
                return
            }
            
            if name == "id107plus" || name == "id107plushr"{
                bandIdType = .id107plus
            }else if name == "id119"{
                bandIdType = .id119
            }else if name == "id127"{
                bandIdType = .id127
            }else if name == "id129"{
                bandIdType = .id129
            }else{
                bandIdType = .undefined
            }
        }
    }
    
    //MARK:- id型号
    private var bandIdType: BandIdType?{
        didSet{
            
            guard let type = bandIdType else {
                return
            }
            
            var imageName: String
            switch type {
            case .id107plus:
                imageName = "resource/scan/id107plus"
            case .id119:
                imageName = "resource/scan/id119"
            case .id127:
                imageName = "resource/scan/id127"
            case .id129:
                imageName = "resource/scan/id129"
            default:
                imageName = "resource/scan/undefined"
            }
            bandImageName = imageName
        }
    }
    
    //MARK:- 图片名
    private var bandImageName: String?
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var bandImage: UIImage?
    
    //MARK:- tip弹窗视图
    private lazy var tipView: UIView? = {
        let tipFrame = CGRect(x: 0, y: self.tableview.frame.origin.y, width: view_size.width, height: view_size.height - self.tableview.frame.origin.y - 49)
        let tipView: UIView = UIView(frame: tipFrame)
            let labelFrame = CGRect(x: 0, y: 0, width: tipView.frame.width, height: 24)
            let label = UILabel(frame: labelFrame)
            label.font = fontSmall
            label.numberOfLines = 3
            label.textAlignment = .center
            label.text = "请把手环戴在手腕上"
            tipView.addSubview(label)
            
            let imageFrame = CGRect(x: 0, y: 24, width: tipView.frame.width, height: tipView.frame.width)
            let imageView = UIImageView(frame: imageFrame)
            if let image = self.bandImage{
                imageView.image = image
            }else{
                if let imageName = self.bandImageName{
                    if let image = UIImage(named: imageName){
                        self.bandImage = image
                        imageView.image = image
                    }
                }
            }
            tipView.addSubview(imageView)
        tipView.backgroundColor = .clear
        return tipView
    }()
    
    //MARK:- 失败视图
    private lazy var failureView: UIView? = {
        let failureFrame = CGRect(x: 0, y: self.tableview.frame.origin.y, width: view_size.width, height: view_size.height - self.tableview.frame.origin.y - 49)
        let failureView: UIView = UIView(frame: failureFrame)
            let labelFrame = CGRect(x: 20, y: 0, width: failureView.frame.width - 20 * 2, height: 24)
            let label = UILabel(frame: labelFrame)
            label.font = fontSmall
            label.numberOfLines = 0
            label.textAlignment = .center
            let bandName = self.filterName == nil ? "手环" : self.filterName!.uppercased()
            label.text = "请在手机系统将蓝牙连接设备，进行忽略确保" + bandName + "位于你的设备附近，然后重试"
            label.sizeToFit()
            failureView.addSubview(label)
            
            let imageFrame = CGRect(x: 0, y: 24, width: failureView.frame.width, height: failureView.frame.width)
            let imageView = UIImageView(frame: imageFrame)
            if let image = self.bandImage{
                imageView.layer.contents = image.cgImage
            }else{
                if let imageName = self.bandImageName{
                    if let image = UIImage(named: imageName){
                        self.bandImage = image
                        imageView.layer.contents = image.cgImage
                    }
                }
            }
            failureView.addSubview(imageView)
        
            //惊叹号
            let warningFrame = CGRect(x: failureView.frame.width / 2,
                                      y: imageFrame.origin.y + imageFrame.height - failureView.frame.width / 4,
                                      width: failureView.frame.width / 4,
                                      height: failureView.frame.width / 4)
            let warningImageView = UIImageView(frame: warningFrame)
            if let warningImage = UIImage(named: "resource/scan/warning"){
                warningImageView.image = warningImage
            }
            failureView.addSubview(warningImageView)
        failureView.backgroundColor = .clear
        return failureView
    }()
    
    
    
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showRescanButton = false    //隐藏重新扫描按钮
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //修改firstLabel文字
        if let name = filterName{
            firstLabel.text = "正在查找您的" + name.uppercased()
        }else{
            firstLabel.text = "正在查找您的设备"
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        godManager.stopScan()
        
        super.viewWillDisappear(animated)
        endLoading()
        
        MapHunter.cancel(rescanTask)
    }
    
    private func config(){
        
        view.backgroundColor = timeColor
        
        //设置下一步颜色
        nextButton.setTitleColor(defaut_color, for: .normal)
        nextButton.setTitleColor(.lightGray, for: .disabled)
        nextButton.isEnabled = false
        
        //设置取消颜色
        cancelButton.setTitleColor(defaut_color, for: .normal)
        
        //设置返回图片
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
        
        //显示搜索视图
        if let tView = tipView{
            view.addSubview(tView)
        }
        
        //显示失败视图
        if let fView = self.failureView{
            fView.isHidden = true
            self.view.addSubview(fView)
        }
    }
    
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到下级页面--绑定手环（设置）
    fileprivate var isConnecting = false
    @IBAction func next(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "下一步"{
            
            //判断是否已选择设备
            guard let indexPath = tableview.indexPathForSelectedRow else{
                debugPrint("请选择设备")
                return
            }
            
            guard !isConnecting && !isScaning else{
                return
            }
            isConnecting = true
            
            let peripheralModel = peripheralList[indexPath.row]
            connectName = peripheralModel.name
            beginLoading(byTitle: "正在设置您的\(connectName!)")
            godManager.connect(peripheralModel.peripheral)
        }else{
            //重新载入
            failureView?.isHidden = true
            
            if let tView = tipView {
                tView.isHidden = false
                cancelButton.isHidden = false
                backButton.isHidden = true
                nextButton.isHidden = true
                nextButton.setTitle("重新搜索", for: .normal)
                view.addSubview(tView)
            }
            rescan(sender: rescanButton)
        }
    }
    
    //MARK:- 返回上级页面
    @IBAction func cancel(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 搜索到第一个设备时调用
    private func beginScan(){
        
        var name = "设备"
        if let fName = filterName{
            name = fName
        }
        beginLoading(byTitle: "正在查找您的" + name)
        
        //firstLabel.text = "选择要绑定的设备"
        
        //设置按钮隐藏与显示
        cancelButton.isHidden = true
        backButton.isHidden = false
        nextButton.isHidden = false
        
        //移除tip视图
        failureView?.isHidden = true
        tipView?.isHidden = true
        
        //修改按钮文字
        cancelButton.isHidden = false
        backButton.isHidden = true
        nextButton.isHidden = true
        nextButton.setTitle("重新搜索", for: .normal)
    }
    
    //MARK:- 5S搜索失败后调用
    private var rescanTask: Task?
    private func failureScan(){
        endLoading()
        
        isScaning = false
        
        tipView?.isHidden = true
        
        nextButton.isEnabled = true     //成功或失败都设置为可点状态
        
        //当搜索解释未获取到设备时，添加失败视图
        if self.peripheralList.isEmpty{
            self.firstLabel.text = "搜索失败"
            nextButton.setTitle("再试一次", for: .normal)
            nextButton.isHidden = false
            backButton.isHidden = false
            cancelButton.isHidden = true
            failureView?.isHidden = false
        }else{
            firstLabel.text = "选择要绑定的设备"
            if showRescanButton{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.rescanButton.alpha = 1
                    let buttonLength = self.rescanButton.frame.width
                    self.rescanButton.frame.origin.y = view_size.height - buttonLength * 1.2
                }, completion: {
                    _ in
                })
            }
        }
        
        //再过5s重新扫描
        rescanTask = delay(5){
            self.rescan(sender: self.rescanButton)
        }
    }
    
    //MARK:- 重写搜索
    private var isScaning = false
    override func rescan(sender: UIButton) {
        
        //修改firstLabel文字
        if let name = filterName{
            firstLabel.text = "正在查找您的" + name.uppercased()
        }else{
            firstLabel.text = "正在查找您的设备"
        }

//        if !isScaning{
//            peripheralList.removeAll()
//        }
        
        if showRescanButton{
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
                self.rescanButton.alpha = 0
                self.rescanButton.frame.origin.y = view_size.height
            }, completion: nil)
        }
        
        //开始扫描
        isScaning = true
        godManager.startScan{
            self.failureScan()
        }
    }
    
    //MARK:- 判断peripheralList是否包含某peripheral
    private func getIndexFromPeripheralList(_ peripheral: CBPeripheral) -> Int?{
        var index: Int?
        peripheralList.enumerated().forEach{
            i, element in
            if element.peripheral.identifier.uuidString == peripheral.identifier.uuidString{
                index = i
            }
        }
        return index
    }
    
    //获取已连接设备
    override func godManager(currentConnectPeripheral peripheral: CBPeripheral, peripheralName name: String) {
        
        //第一次存储设备之前调用
        if peripheralList.isEmpty {
            beginScan()
        }
        
        //判断UUID重复，避免重复存储
//        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
//        guard sameList.isEmpty else{
//            return
//        }
        
        let standardName = name.lowercased().replacingOccurrences(of: " ", with: "")
        if let fname = filterName{
            if standardName == fname || standardName.contains(fname){
                
                if getIndexFromPeripheralList(peripheral) != nil {
                    
                }else{
                    peripheralList.append((name, 0, peripheral))
                    peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
                }
            }
        }else{
            if getIndexFromPeripheralList(peripheral) != nil {
                
            }else{
                peripheralList.append((name, 0, peripheral))
                peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
            }
        }
        tableview.reloadData()
    }
    //发现设备
    override func godManager(didDiscoverPeripheral peripheral: CBPeripheral, withRSSI RSSI: NSNumber, peripheralName name: String) {
        
        //第一次存储设备之前调用
        if peripheralList.isEmpty {
            beginScan()
        }
        
        //判断UUID重复，避免重复存储
//        let sameList = peripheralList.filter(){$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}
//        guard sameList.isEmpty else{
//            return
//        }
        
        let standardName = name.lowercased().replacingOccurrences(of: " ", with: "")
        if let fname = filterName{
            if standardName == fname || standardName.contains(fname) {
                if let index = getIndexFromPeripheralList(peripheral) {
                    peripheralList[index].RSSI = RSSI
                }else{
                    peripheralList.append((name, RSSI, peripheral))
                }
                peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
            }
        }else{
            if let index = getIndexFromPeripheralList(peripheral) {
                peripheralList[index].RSSI = RSSI
            }else{
                peripheralList.append((name, RSSI, peripheral))
            }
            peripheralList = peripheralList.sorted{fabs($0.RSSI.floatValue) < fabs($1.RSSI.floatValue)}
        }
        tableview.reloadData()
    }
    
    //连接状态
    override func godManager(didConnectedPeripheral peripheral: CBPeripheral, connectState isSuccess: Bool) {
        guard isSuccess else {
            isConnecting = false
            //跳转到连接失败页面
            let bootConnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootconnected") as! BootConnectedVC
            navigationController?.show(bootConnectVC, sender: nil)
            return
        }
        
        //延迟3.5秒后设置绑定
        beginLoading(byTitle: "正在设置你的" + (connectName ?? "手环"))
        
        //判断设备是否已绑定
        if PeripheralManager.share().select(UUIDString: peripheral.identifier.uuidString) {
            //跳转到绑定成功或失败页面
            let bootConnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootconnected") as! BootConnectedVC
            bootConnectVC.isSuccess = true
            bootConnectVC.bandName = self.connectName
            self.navigationController?.show(bootConnectVC, sender: true)
        }else{
            _ = delay(3.5){
                //+30s判断
                let bandTask = delay(30){
                    self.endLoading()
                    self.isConnecting = false
                    
                    //跳转到绑定失败页面
                    let bootConnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootconnected") as! BootConnectedVC
                    bootConnectVC.isSuccess = false
                    bootConnectVC.bandName = self.connectName
                    self.navigationController?.show(bootConnectVC, sender: true)
                }
                
                let angelManager = AngelManager.share()
                angelManager?.setBind(true){
                    success in
                    DispatchQueue.main.async {
                        
                        MapHunter.cancel(bandTask)
                        
                        self.endLoading()
                        self.isConnecting = false
                        
                        //跳转到绑定成功或失败页面
                        let bootConnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootconnected") as! BootConnectedVC
                        bootConnectVC.isSuccess = success
                        bootConnectVC.bandName = self.connectName
                        self.navigationController?.show(bootConnectVC, sender: true)
                    }
                }
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
        case .disConnect:
            debugPrint(" 手环断开连接")
            break
            
            //跳转到绑定成功页面
            let bootConnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootconnected") as! BootConnectedVC
            bootConnectVC.bandName = self.connectName
            self.navigationController?.show(bootConnectVC, sender: true)
        case .failed:
            //弹出无法连接页面
            debugPrint(" 连接手环失败")
            
            //跳转到绑定成功页面
            let bootConnectVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootconnected") as! BootConnectedVC
            bootConnectVC.bandName = self.connectName
            self.navigationController?.show(bootConnectVC, sender: true)
        }
    }
    
    //MARK:- 选择设备
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if tableview.indexPathForSelectedRow != nil{
//            nextButton.isEnabled = true
//        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? ScanCell
        
        let allCells = tableview.visibleCells
        allCells.forEach{
            cell in
            let bandCell = cell as? ScanCell
            bandCell?.bandRSSI = bandCell?.bandRSSI
        }
        cell?.bandRSSI = peripheralList[indexPath.row].RSSI.intValue
        
//        //判断是否已选择设备 直接连接绑定登录
//        guard let indexPath = tableview.indexPathForSelectedRow else{
//            debugPrint("请选择设备")
//            return
//        }
        
        guard !isConnecting && !isScaning else{
            return
        }
        isConnecting = true
        
        let peripheralModel = peripheralList[indexPath.row]
        connectName = peripheralModel.name
        beginLoading(byTitle: "正在设置您的\(connectName!)")
        godManager.connect(peripheralModel.peripheral)
    }
}
