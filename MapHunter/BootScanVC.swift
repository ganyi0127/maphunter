//
//  BootScanVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
//存储可筛选设备名
let nameList = ["id107plus", "id119", "id127", "id129"]
class BootScanVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        navigationController?.setNavigation(hidden: true)
    }
    
    private func config(){
        
        view.backgroundColor = timeColor
        
        //隐藏navigation
        navigationController?.isNavigationBarHidden = true
        
        automaticallyAdjustsScrollViewInsets = false
        
        //tableview参数
        let customIdentifier = "custom"
        tableview.register(BootScanCell.self, forCellReuseIdentifier: customIdentifier)
        tableview.separatorStyle = .none
        tableview.backgroundColor = timeColor
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到下级页面
    @IBAction func next(_ sender: UIButton) {
        
    }
    
    //MARK:- 获取其他设备
    fileprivate func scanOther() {
        
        //跳转到搜索页 无过滤
        let appointScanVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "scan") as! AppointScanVC
        navigationController?.show(appointScanVC, sender: nil)
    }
    
    //MARK:- 通过筛选进行搜索
    fileprivate func scan(byName name: String){
        
        //跳转到手环页
        let bootPreVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootpre") as! BootPreVC
        bootPreVC.filterName = name
        navigationController?.show(bootPreVC, sender: nil)
    }
}

//MARK:- tableview delegate
extension BootScanVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count + 1   //+1为其他设备选项
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view_size.width / 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        
        if indexPath.row == 4 {
            //其他设备
            let otherCell = BootOtherCell(identifier: identifier)
            return otherCell
        }else{
            //筛选设备
            let name = nameList[indexPath.row]
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if cell == nil {
                cell = BootScanCell(identifier: identifier)
            }
            
            let scanCell = cell as! BootScanCell
            scanCell.bandName = name
            return scanCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        if indexPath.row != 4 {
            let name = nameList[indexPath.row]
            //通过筛选进行搜索
            scan(byName: name)
        }else{
            scanOther()
        }
    }
}
