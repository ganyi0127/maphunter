//
//  PathMaptypeSettingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathMaptypeSettingVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate let maptypeList = ["标准地图", "卫星地图", "混合地图"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.hidesBackButton = true
        navigationItem.title = "地图类型"
    }
}

extension PathMaptypeSettingVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "\(row)"
        var reusableCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if reusableCell == nil {
            reusableCell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        let cell = reusableCell!
        cell.textLabel?.text = maptypeList[row]
        cell.textLabel?.font = fontSmall
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = navigationController?.popViewController(animated: true)
    }
}
