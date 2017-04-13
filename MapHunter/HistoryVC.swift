//
//  HistoryVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/2/9.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class HistoryVC: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var trackList = [Track](){
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        navigationItem.title = "历史轨迹"
        
        let coredataHandler = CoreDataHandler.share()
        let userId = UserManager.share().userId
        if let macaddress = AngelManager.share()?.macAddress{
            let tracks = coredataHandler.selectTrack(userId: userId, withMacAddress: macaddress, withDate: selectDate, withDayRange: 0).sorted{
                track1, track2 -> Bool in
                let earlyDate = track1.date?.earlierDate(track2.date! as Date)
                if earlyDate == track1.date as Date?{
                    return false
                }
                return true
            }
            trackList = tracks
        }
    }
    
    private func createContents(){
        
    }
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

//MARK:- tableview
extension HistoryVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "\(indexPath.section)_\(row)"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        cell?.accessoryType = .disclosureIndicator
        let track = trackList[row]
        
        //获取类型
        let type = track.type
        
        //获取时间
        let date = track.date as? Date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date!)
        let hourStr = "\(components.hour!)"
        let minuteStr = components.minute! < 10 ? "0\(components.minute!)" : "\(components.minute!)"
        cell?.textLabel?.text = hourStr + ":" + minuteStr + "____\(type)"
        cell?.detailTextLabel?.text = track.trackItems?.count == 0 ? "无路径" : "坐标数:\(track.trackItems!.count) 心率数:\(track.trackHeartrateItems!.count)"
        return cell!
    }
    
    //点击进入路径详情
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let track = trackList[row]
        
        let mapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map") as! MapVC
        mapVC.historyTrack = track        
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
