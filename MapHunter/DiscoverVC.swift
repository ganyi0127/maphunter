//
//  DiscoverVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/30.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class DiscoverVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "发现"
        navigationController?.setNavigationOpacity(opacity: true)
    }
}

extension DiscoverVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let discoverCell = cell as! DiscoverCell
        
        switch section {
        case 0:
            discoverCell.name = "运动圈"
        case 1:
            discoverCell.name = "最美路线"
        case 2:
            if row == 0{
                discoverCell.name = "健康周报"
            }else{
                discoverCell.name = "排行榜"
            }
        default:
            discoverCell.name = "商城"
        }
        return discoverCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        switch section {
        case 0:
            break
        case 1:
            break
        case 2:
            if row == 0{
                if let weeklyVC = storyboard?.instantiateViewController(withIdentifier: "weekly"){
                    navigationController?.pushViewController(weeklyVC, animated: true)
                }
            }else{
                
            }
        case 3:
            break
        default:
            break
        }
    }
}
