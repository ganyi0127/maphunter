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
    
    //上拉下拉
    fileprivate var newY: CGFloat = 0
    fileprivate var oldY: CGFloat = 0
    
    //转场代理
    fileprivate var customAnimationController: CustomAnimationController?
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        createContents()
    }
    
    //MARK:- 转场
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //...
        if segue.identifier == "DetailViewController" {
            let toVC = segue.destination
            toVC.transitioningDelegate = self
        }
    }
    
    private func config(){
        
        //初始化当前选择的日期
        selectDate = Date()
        
        //清除顶部空白区域
        automaticallyAdjustsScrollViewInsets = false
        
        //设置背景
        view.backgroundColor = defaultColor
        tableView.backgroundColor = defaultColor
        
        //转场
        customAnimationController = CustomAnimationController()
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
            ctrl.backgroundColor = .clear
            
//            let cusView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            cusView.backgroundColor = .red
//            ctrl.addSubview(cusView)
            
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
        headerView.backgroundColor = timeColor
        
        let imageViewFrame = CGRect(x: view_size.width * 0.1, y: 15, width: 20, height: 20)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "resource/mystory")?.transfromImage(size: CGSize(width: 20, height: 20))
        headerView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: imageView.frame.origin.x + imageView.frame.width * 1.5,
                                          y: 25 - 9,
                                          width: view_size.width,
                                          height: 18))
        label.textColor = wordColor
        label.font = UIFont(name: font_name, size: 18)
        label.text = "我的一天"
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
                return view_size.width
            case 1:
                return view_size.height * 0.1
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
                    //四模块
                    cell = FirstCell(style: .default, reuseIdentifier: identifier)
                    (cell as! FirstCell).closure = {
                        dataCubeType in
                        
                        //进入详情页面
                        let detaiViewController = DetailViewController(detailType: dataCubeType)
                        self.navigationController?.show(detaiViewController, sender: cell)
                    }
                    
                case 1:
//                    cell = DetailCell(reuseIdentifier: identifier)
//                    (cell as! DetailCell).closure = {
//                        detailType in
//                        //选中回调
//                        print("selected: \(detailType)")
//                        let detaiViewController = DetailViewController(detailType: detailType)
//                        self.navigationController?.show(detaiViewController, sender: cell)
//                    }
                    cell = CalendarCell(reuseIdentifier: identifier)
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
            case 1:
                (cell as! CalendarCell).date = selectDate

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
    
    //上拉下拉
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }
        
        newY = scrollView.contentOffset.y
        
        if #available(iOS 10.0, *) {
            if let refreshControl = tableView.refreshControl{
                if refreshControl.isRefreshing {
                    oldY = 0
                    return
                }
            }
        } else {
            let refreshControls = tableView.subviews.filter(){$0.isKind(of: UIRefreshControl.self)}
            if !refreshControls.isEmpty{
                oldY = 0
                return
            }
        }
        
        guard fabs(newY - oldY) > 100 else {
            return
        }

        if newY > oldY {
            navigationController?.setTabbar(hidden: true)
        }else{
            navigationController?.setTabbar(hidden: false)
        }
        
        oldY = newY
    }

}

//MARK:- 转场实现
extension StateVC: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationController
    }
}
