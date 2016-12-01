//
//  StateVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class StateVC: UIViewController {
    
    @IBOutlet weak var topView: TopView!            //日历
    @IBOutlet weak var tableView: UITableView!      //内容
    
    
    
    //MARK:- init
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
        
        //设置背景
        view.backgroundColor = defaultColor
        tableView.backgroundColor = defaultColor
    }
    
    private func createContents(){
        
        topView.closure = {
            date in
            
            print("date: \(date)")
            self.tableView.reloadData()
        }
        
        setupRefresh()
    }
    
    //MARK:- 下拉刷新
    private func setupRefresh(){
        //添加刷新控件
        let control = { () -> UIRefreshControl in
            let ctrl = UIRefreshControl()
            ctrl.tintColor = UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
            ctrl.attributedTitle = NSAttributedString(string: "同步健康数据")
            ctrl.addTarget(self, action: #selector(refreshStateChange(_:)), for: .valueChanged)
            return ctrl
        }()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = control
        } else {
            tableView.addSubview(control)
        }
        
        //进入刷新状态
        control.beginRefreshing()
        //加载数据
        refreshStateChange(control)
    }
    
    @objc private func refreshStateChange(_ control: UIRefreshControl){
        
        _ = delay(1){
            
            control.endRefreshing()
        }
    }
}

//MARK:- tableView
extension StateVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        if section == 0{
            return nil
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view_size.width, height: 50))
        headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        let imageView = UIImageView(image: UIImage(named: "icon_menu"))
        imageView.frame = CGRect(x: imageView.frame.width * 0.3,
                                 y: imageView.frame.height * 0.3,
                                 width: imageView.frame.width,
                                 height: imageView.frame.height)
        headerView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: imageView.frame.origin.x + imageView.frame.width * 1.5,
                                          y: imageView.frame.origin.y,
                                          width: view_size.width,
                                          height: 18))
        label.textColor = .white
        label.font = UIFont(name: font_name, size: 18)
        label.text = "今日故事"
        label.textAlignment = .left
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                return view_size.width * 2 / 3
//            case 1, 2, 3:
//                return view_size.width / 2
            default:
                return view_size.width / 3
            }
        }
        
        return view_size.width / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0{
            
            let identifier = "\(indexPath.section)_\(indexPath.row)"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            if cell == nil{
                switch indexPath.row {
                case 0:
                    cell = FirstCell(style: .default, reuseIdentifier: identifier)
                case 1:
                    cell = DetailCell(reuseIdentifier: identifier)
                    (cell as! DetailCell).closure = {
                        detailType in
                        //选中回调
                        print("selected: \(detailType)")
                        let detaiViewController = DetailViewController(detailType: detailType)
                        self.navigationController?.show(detaiViewController, sender: cell)
                    }
                default:
                    cell = SecondCell(indexPath.row, reuseIdentifier: identifier)
                    cell?.contentView.backgroundColor = tableView.backgroundColor
                }
            }
            
            //添加数据
            switch indexPath.row {
            case 0:
//                (cell as! FirstCell).step = 1367
//                (cell as! FirstCell).calorie = 144
//                (cell as! FirstCell).distance = 5
//                (cell as! FirstCell).time = 123
                break
//            case 1, 2, 3:
//                
//                let cellDate = CellData(value1: 123, value2: 456, value3: 789, value4: 101, value5: 102, value6: [12,34,56])
//                (cell as! SecondCell).cellData1 = cellDate
//                (cell as! SecondCell).cellData2 = cellDate
            default:
                break
            }
            
            return cell!
        }
        
        //今日故事 cell3
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        var value = StoryData()
        value.type = SportType.run
        value.date = (456, 1)
        value.sportTime = 789
        value.calorie = 123
        value.heartRate = 101
        value.fat = 202
        
        (cell as! ThirdCell).value = value
        
        return cell!
    }
}
