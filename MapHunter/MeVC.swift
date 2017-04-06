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
        
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func createContents(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableview.reloadData()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 244 //view_size.width / 2
            }else{
                return 44
            }
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0{
            return 20
        }else{
            return 18
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        if indexPath.section == 0 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let meCell1 = cell as! MeCell1
            //获取运动信息_日期为当前选择日
            if let angelManager = AngelManager.share() {
                if let macaddress = angelManager.macAddress {
                    let userId = UserManager.share().userId
                    let tracks = CoreDataHandler.share().selectTrack(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0)
                    if !tracks.isEmpty {
                        //默认获取当天数据，tracks个数>=0
                        meCell1.calorie = tracks.reduce(0){$0 + $1.calories}
                        meCell1.count = Int16(tracks.count)
                        meCell1.distance = tracks.reduce(0){$0 + Int16($1.distance)}
                        meCell1.minutes = tracks.reduce(0){$0 + $1.aerobicMinutes}
                        meCell1.introduce = "its introduce string from sqlite"
                    }
                }
            }
            return meCell1
        }
        
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            if indexPath.section == 0 {
                cell = MeCell2(reuseIdentifier: identifier)                
            }else{
                cell = MeCell3(type: MeCell3Type(rawValue: indexPath.row)!, reuseIdentifier: identifier)
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 1{
                //个人总成绩
                
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
            case .device:
                if PeripheralManager.share().selectUUIDStringList().isEmpty {
                    
                    let scanVC = storyboard?.instantiateViewController(withIdentifier: "scan") as! ScanVC
                    navigationController?.pushViewController(scanVC, animated: true)
                }else{
                    let bindingVC = storyboard?.instantiateViewController(withIdentifier: "binding") as! BindingVC
                    navigationController?.pushViewController(bindingVC, animated: true)
                }
            case .target:
                //目标设置
                let targetSettingVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "targetsetting")
                present(targetSettingVC, animated: true, completion: nil)
            default:
                //苹果健康
                let detailViewController = MeDetails(type: type)
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}
