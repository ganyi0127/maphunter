//
//  BootScanVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootScanVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    
    fileprivate let nameList = ["ID107", "ID107Plus", "ID127Plus"]
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigation(hidden: true)
    }
    
    private func config(){
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 获取其他设备
    @IBAction func getOtherButton(_ sender: UIButton) {
        
        //跳转到搜索页 无过滤
    }
    
    //MARK:- 通过筛选进行搜索
    fileprivate func scan(byName name: String){
        
    }
}

extension BootScanVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view_size.width / 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let name = nameList[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = BootScanCell(identifier: identifier)
        }
        
        let scanCell = cell as! BootScanCell
        scanCell.bandName = name
        return scanCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        let name = nameList[indexPath.row]
        
        //通过筛选进行搜索
        scan(byName: name)
    }
}
