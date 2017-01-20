//
//  PathTargetSettingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathTargetSettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let typeLists = [["1KM", "3KM", "5KM", "10KM", "半程马拉松21.098KM", "马拉松42.195KM"],
                             ["10分钟", "20分钟", "30分钟", "1小时", "1小时30分钟", "2小时"],
                             ["150大卡", "200大卡", "250大卡", "300大卡", "350大卡", "400大卡"]]
    fileprivate var selectedTypeList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedTypeList = typeLists[0]
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "目标设置"
    }
    
    //MARK:- 选择目标类型
    @IBAction func selectTargetType(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        selectedTypeList = typeLists[index]
        
        tableView.reloadData()
    }
}

extension PathTargetSettingVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = selectedTypeList else {
            return 0
        }
        return list.count
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
        cell.textLabel?.text = selectedTypeList?[row]
        cell.textLabel?.font = fontSmall
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = navigationController?.popViewController(animated: true)
    }
}
