//
//  PathRemindSettingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathRemindSettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate let titleLists = [["1KM", "3KM", "5KM"], ["5Min", "10Min", "15Min"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.hidesBackButton = true

        navigationItem.title = "提示频率"
    }
}

extension PathRemindSettingVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "按距离"
        }else{
            return "按时间"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let identifier = "\(row)"
        var reusableCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if reusableCell == nil {
            reusableCell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        let cell = reusableCell!
        cell.textLabel?.text = titleLists[section][row]
        cell.textLabel?.font = fontSmall
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = navigationController?.popViewController(animated: true)
    }
}
