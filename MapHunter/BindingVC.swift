//
//  BindingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/2/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class BindingVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    fileprivate var energy: Int16 = 0 {
        didSet{
            let text = "\(energy)%"
            
            let attributedText = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontHuge, NSForegroundColorAttributeName: UIColor.white])
            attributedText.addAttributes([NSFontAttributeName: fontMiddle], range: NSMakeRange(text.characters.count - 1, 1))
            energyLabel.attributedText = attributedText
        }
    }
    
    //MARK:- 功能列表
    fileprivate var funcTable: DeviceFunction?{
        didSet{
            guard let ft = funcTable else {
                return
            }
            debugPrint(ft)
            
            //获取functable成员变量
            var outCount:UInt32 = 0
            let propertyList = class_copyPropertyList(DeviceFunction.self, &outCount)
            
            for i in 0..<Int(outCount) {
                let property = propertyList![i]
                let propertyName = String(cString: property_getName(property))
                let propertyValue = ft.value(forKey: propertyName)
                if let boolValue: Bool = propertyValue as? Bool {
                    debugPrint(propertyName, ":", boolValue)
                    if boolValue {
                        
                    }else{
                        
                    }
                }
            }
        }
    }
    
    //所有
    fileprivate let functableTypeList: [[FunctableType]] = [
        [.callRemind, .smartRemind, .longsitRemind, .alarm, .silent],
        [.music, .camera],
        [.watchBG, .heartrate, .activeMode],
        [.update],
        [.more]
    ]
    
    //MARK:-init***************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationOpacity(opacity: false)
    }
    
    private func config(){
        
        navigationController?.setNavigation(hidden: false)
        
        //背景色
        bgImageView.image = UIImage(named: "resource/me/functable/background")
        view.backgroundColor = timeColor
        
        tableview.backgroundColor = .clear
    }
    
    private func createContents(){
        
        //获取设备名称
        let name = PeripheralManager.share().currentPeripheral?.name
        navigationItem.title = name
        
        beginLoading()
        
        //获取设备信息
        let angelManager = AngelManager.share()
        let accessoryId = angelManager?.accessoryId

        angelManager?.getDevice(accessoryId, closure: {
            device in
            self.endLoading()
            
            guard let existDevice = device else{
                return
            }
            
            DispatchQueue.main.async {
                /*
                var dateStr = "~"
                if let date = existDevice.lastSyncTime{
                    //获取日期格式
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyy-MM-dd hh:mm"
                    dateStr = formatter.string(from: date as Date)
                }
                self.synchroDateLabel.text = "上次同步时间: " + dateStr
                self.versionLabel.text = "固件版本: v\(existDevice.version)"
                self.funcTable = existDevice.deviceFunction
                 */
                self.energy = existDevice.batteryLevel
                print(existDevice.deviceFunction)
            }
        })
        
        //单独获取设备列表
        angelManager?.getFuncTable{
            functable in
            DispatchQueue.main.async {
                self.funcTable = functable
            }
        }
    }
    
    //MARK:- 解除绑定
    func unbinding() {
        
        if let peripheral = PeripheralManager.share().currentPeripheral {
            
            if peripheral.state == .connected{
                GodManager.share().disconnect(peripheral){
                    success in
                    if success{
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                let uuidstr = peripheral.identifier.uuidString
                _ = PeripheralManager.share().delete(UUIDString: uuidstr)
                PeripheralManager.share().UUID = nil
                _ = self.navigationController?.popViewController(animated: true)
            }
        }else{
            let list = PeripheralManager.share().selectUUIDStringList()
            list.forEach{
                uuidStr in
                _ = PeripheralManager.share().delete(UUIDString: uuidStr)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK:-tableview delegate
extension BindingVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return functableTypeList.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == functableTypeList.count {
            return 1
        }
        return functableTypeList[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var identifier: String
        
        if section == functableTypeList.count { //解绑
            identifier = "cell1"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            return cell!
        }else {                                 //功能列表
            identifier = "cell0"
            let functableType = functableTypeList[section][row]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let functableCell = cell as! FunctableCell
            functableCell.type = functableType
            return functableCell
        }
    }
    
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        if section == functableTypeList.count{  //解绑
            unbinding()
        }else{
            let functableType = functableTypeList[section][row]
            /*
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
            //跳转
            switch functableType {
            case .callRemind:
                break
            case .smartRemind:
                break
            case .longsitRemind:
                break
            case .alarm:
                break
            case .silent:
                break
            case .music:
                break
            case .camera:
                break
            case .watchBG:
                break
            case .heartrate:
                break
            case .activeMode:
                break
            case .update:
                break
            default:    //more
                performSegue(withIdentifier: "more", sender: nil)
            }
            */
            performSegue(withIdentifier: "\(functableType)".lowercased(), sender: functableType.rawValue)
        }
    }
    
    //设置功能列表标题
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pushVC = segue.destination
        pushVC.navigationItem.title = sender as! String
        pushVC.view.backgroundColor = .red
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        guard y < 0 else {
            return
        }
        
        let newHeight = topView.frame.height - y
        let newWidth = newHeight * topView.frame.width / topView.frame.height
        let newFrame = CGRect(x: (topView.frame.width - newWidth) / 2, y: 0, width: newWidth, height: newHeight)
        
        UIView.animate(withDuration: 0, animations: {
            self.bgImageView.frame = newFrame
            self.energyLabel.frame = newFrame
        })
    }
}

//MARK:- collectionView delegate
extension BindingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "custom"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        let cell = FunctableCell(functableType: .camera)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (view_size.width - 0) / 3
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view_size.width, height: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
//        
//    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
