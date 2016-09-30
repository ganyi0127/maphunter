//
//  StateVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class StateVC: UIViewController {
    
    @IBOutlet weak var topView: TopView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        //初始化当前选择的日期
        selectDate = Date()
        
        //清除顶部空白区域
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func createContents(){
        
        topView.closure = {
            date in
            
            print("date: \(date)")
            self.tableView.reloadData()
        }
    }
}

//MARK:- tableView
extension StateVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return view_size.width * 2 / 3
        case 1, 2, 3:
            return view_size.width / 2
        default:
            return view_size.width / 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "row\(indexPath.row)"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil{
            switch indexPath.row {
            case 0:
                cell = FirstCell(style: .default, reuseIdentifier: identifier)
            case 1, 2, 3:
                cell = SecondCell(indexPath.row, reuseIdentifier: identifier)
                cell?.contentView.backgroundColor = tableView.backgroundColor
            default:
                cell = ThirdCell(style: .default, reuseIdentifier: identifier)
            }
        }
        
        //添加数据
        switch indexPath.row {
        case 0:
            (cell as! FirstCell).step = 1367
            (cell as! FirstCell).calorie = 144
            (cell as! FirstCell).distance = 5
            (cell as! FirstCell).time = 123
        case 1, 2, 3:
            
            let cellDate = CellData(value1: 123, value2: 456, value3: 789, value4: 101, value5: 102, value6: [12,34,56])
            (cell as! SecondCell).cellData1 = cellDate
            (cell as! SecondCell).cellData2 = cellDate
            
        default:
            break
        }
        
        return cell!
    }
}
