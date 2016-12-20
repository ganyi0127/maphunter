//
//  MeVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
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
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 点击设置
    func clickSetting(sender: UIBarButtonItem){
        debugPrint("setting")
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
            return cell!
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
        
        if indexPath.section == 0 {
            
        }else{
            let cell: MeCell3 = tableView.cellForRow(at: indexPath) as! MeCell3
            let type = cell.type
            let detailViewController = MeDetails(type: type!)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
