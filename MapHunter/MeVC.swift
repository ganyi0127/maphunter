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
                return view_size.width / 2
            }else{
                return 44
            }
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 18
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    cell = MeCell1(reuseIdentifier: identifier)
                }else{
                    cell = MeCell2(reuseIdentifier: identifier)
                }
            }else{
                cell = MeCell3(type: MeCell3Type(rawValue: indexPath.row)!, reuseIdentifier: identifier)
            }
        }
        
        return cell!
    }
}
