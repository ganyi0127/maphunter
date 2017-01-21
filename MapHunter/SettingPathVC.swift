//
//  SettingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation

class SettingPathVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //默认数据
    fileprivate let titleList = ["提示频率", "地图设置", "目标设置", "屏幕常亮"]
    fileprivate let iconImageNameList = ["maptype", "remindrate", "target", "lightdisplay"]
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    //MARK:- 保存
    @objc private func save(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 开启提示音
    @IBAction func swithRemind(_ sender: UISwitch) {
        
    }
    
    //MARK:- 室内室外选择
    @IBAction func selectPlace(_ sender: UISegmentedControl) {
    }
}

extension SettingPathVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell: UITableViewCell
        switch row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "remind") as! PathCell0
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PathCell1
            let pathCell1: PathCell1 = cell as! PathCell1
            pathCell1.titleLabel.text = titleList[row - 1]
            pathCell1.valueLabel.text = ""
            
            //修改icon
            let imageName = "resource/map/setting/" + iconImageNameList[row - 1]
            let image = UIImage(named: imageName)
            pathCell1.iconImageView.image = image
            
            //设置屏幕常亮类型
            if row == 4 {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        let row = indexPath.row
        
        switch row {
        case 0:
            break
        case 1:
            let pathRemindVC = storyboard?.instantiateViewController(withIdentifier: "pathremindsetting") as! PathRemindSettingVC
            navigationController?.pushViewController(pathRemindVC, animated: true)
        case 2:
            let pathMaptypeVC = storyboard?.instantiateViewController(withIdentifier: "pathmaptypesetting") as! PathMaptypeSettingVC
            navigationController?.pushViewController(pathMaptypeVC, animated: true)
        case 3:
            let pathTargetVC = storyboard?.instantiateViewController(withIdentifier: "pathtargetsetting") as! PathTargetSettingVC
            navigationController?.pushViewController(pathTargetVC, animated: true)
        case 4:
            break
        default:
            break
        }
    }
}
