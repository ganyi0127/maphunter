//
//  MeSetting.swift
//  MapHunter
//
//  Created by YiGan on 21/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class MeSetting: UITableViewController {
    
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
}

//MARK:- tableview
extension MeSetting{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.font = fontSmall
        cell.detailTextLabel?.font = fontSmall
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //个人信息页面
            guard let infoViewController = storyboard?.instantiateViewController(withIdentifier: "meinfo") else{
                return
            }
            navigationController?.pushViewController(infoViewController, animated: true)
        case 1:
            //单位设置页面
            let unitViewController = MeUnit()
            navigationController?.pushViewController(unitViewController, animated: true)
        case 2:
            //星期开始日页面
            let weekbeginViewController = MeWeekbegin()
            navigationController?.pushViewController(weekbeginViewController, animated: true)
        case 3:
            //版本
            let versionViewController = MeVersion()
            navigationController?.pushViewController(versionViewController, animated: true)
        default:
            break
        }
    }
}
