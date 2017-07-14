//
//  MeVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
import CoreBluetooth
class MeVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        //清除顶部空白区域
        automaticallyAdjustsScrollViewInsets = false
        
        navigationController?.navigationBar.topItem?.title = "GanYi"
        
        //接收消息
        notiy.addObserver(self, selector: #selector(receiveConnectedMessage(notify:)), name: connected_notiy, object: nil)
    }
    
    //MARK:- 接收连接状态
    @objc func receiveConnectedMessage(notify: Notification?){
        tableview.reloadData()
    }
    
    private func createContents(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationOpacity(opacity: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableview.reloadData()
        
        //个人视图        
        let editImage = UIImage(named: "resource/me/me_edit")?.transfromImage(size: CGSize(width: 24, height: 24))?.withRenderingMode(.alwaysTemplate)
        let editButton = UIBarButtonItem(image: editImage, style: .done, target: self, action: #selector(clickSetting(sender:)))
        editButton.tintColor = .white
        navigationItem.rightBarButtonItem = editButton
    }
    
    //MARK:- 点击设置
    func clickSetting(sender: UIBarButtonItem){
        guard let settingViewController = storyboard?.instantiateViewController(withIdentifier: "mesetting") else {
            return
        }
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @IBAction func clickImageView(_ sender: UITapGestureRecognizer) {
        
        guard let infoViewController = storyboard?.instantiateViewController(withIdentifier: "meinfo") else{
            return
        }
        navigationController?.pushViewController(infoViewController, animated: true)
    }
}

extension MeVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            if PeripheralManager.share().selectUUIDStringList().isEmpty {
                return 1
            }else{
                return 2
            }
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {

            return 244
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }else if section == 1 {
            return 44
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 49
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "我的设备"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        var cell: UITableViewCell?
        if section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let meCell1 = cell as! MeCell1
            //test
            meCell1.averageSteps = 0
            meCell1.actionCount = 0
            meCell1.targetCount = 0
            
            //获取运动信息_日期为当前选择日
            if let angelManager = AngelManager.share() {
                if let macaddress = angelManager.macAddress {
                    let userId = UserManager.share().userId
                    let tracks = CoreDataHandler.share().selectTrack(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
                    if !tracks.isEmpty {
                        //默认获取当天数据，tracks个数>=0
                        meCell1.averageSteps = tracks.reduce(0){$0 + $1.calories}       //日均步数
                        meCell1.actionCount = Int16(tracks.count)                       //活动次数
                        meCell1.targetCount = tracks.reduce(0){$0 + Int16($1.distance)} //达标次数
                    }
                }
            }
            return meCell1
        }
        
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            if section == 1 {
                //判断是否有连接设备
                if PeripheralManager.share().selectUUIDStringList().isEmpty {
                    cell = MeCell3(type: .additional, reuseIdentifier: identifier)
                }else{
                    if row == 0{    //设备
                        cell = MeDeviceCell(reuseIdentifier: identifier)
                        (cell as! MeDeviceCell).name = PeripheralManager.share().currentPeripheral?.name
                    }else{          //添加设备
                        cell = MeAdditionalCell(reuseIdentifier: identifier)
                    }
                }
            }else{
                cell = MeCell3(type: MeCell3Type(rawValue: indexPath.row)!, reuseIdentifier: identifier)
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        if section == 1 {
            if PeripheralManager.share().selectUUIDStringList().isEmpty {
                if row == 0{
                    //添加设备
                    let scanVC = storyboard?.instantiateViewController(withIdentifier: "scan") as! ScanVC
                    navigationController?.pushViewController(scanVC, animated: true)
                }
            }else{
                if row == 0{
                    //查看设备
                    let scanVC = storyboard?.instantiateViewController(withIdentifier: "scan") as! ScanVC
                    navigationController?.pushViewController(scanVC, animated: true)
                }else{
                    //添加设备
                    let scanVC = storyboard?.instantiateViewController(withIdentifier: "scan") as! ScanVC
                    navigationController?.pushViewController(scanVC, animated: true)
                }
            }
        }else{
            //进入详情页面
            guard let cell3: MeCell3 = cell as? MeCell3 else{
                return
            }
            guard let type = cell3.type else{
                return
            }
            
            switch type {
            case .target:
                let targetSettingVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "targetsetting")
                present(targetSettingVC, animated: true, completion: nil)                
            case .setting:
                //设置
                guard let settingViewController = storyboard?.instantiateViewController(withIdentifier: "mesetting") else {
                    return
                }
                navigationController?.pushViewController(settingViewController, animated: true)
            default:
                let detailViewController = MeDetails(type: type)
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}
