//
//  HealthVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
//背景颜色
let weeklyScrollColorList = [modelStartColors[.sport]!,
                             separatorColor,
                             modelStartColors[.sleep]!,
                             separatorColor,
                             modelStartColors[.heartrate]!,
                             separatorColor]

class WeeklyVC: UIViewController {

    //日期范围
    private var weekStartDate: Date!
    private var weekEndDate: Date!
    
    //滑动视图背景颜色
    fileprivate var selectedPage = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var onceToken = false
    
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.title = weekStartDate.formatString(with: "MM/dd") + "-" + weekEndDate.formatString(with: "MM/dd") + "周报"
        navigationController?.setNavigationOpacity(opacity: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        scrollView.setContentOffset(.zero, animated: true)
        
        let shareImage = UIImage(named: "resource/share")?.transfromImage(size: CGSize(width: 30, height: 30))
        let shareButton = UIBarButtonItem(image: shareImage, style: .done, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func share(){
        debugPrint("shared")
    }
    
    private func config(){
        
        //初始化日期范围
        weekStartDate = selectDate.offset(with: -7 - selectDate.weekday() + 1)
        weekEndDate = weekStartDate.offset(with: 7 - 1)
        
        //初始化滑动视图
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view_size.width, height: view_size.height * 6)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = weeklyScrollColorList.first
        
        //添加子页面
        let storyboardIDList = ["sportmain", "sportvice", "sleepmain", "sleepvice", "heartratemain", "heartratevice"]
        if scrollView.subviews.count < storyboardIDList.count{            
            for (index, id) in storyboardIDList.enumerated(){
                if let vc = storyboard?.instantiateViewController(withIdentifier: id) {
                    
                    let v = vc.view
                    v?.frame = CGRect(origin: CGPoint(x: 0, y: view_size.height * CGFloat(index)), size: scrollView.bounds.size)
                    scrollView.addSubview(v!)
                    
                    if vc.isKind(of: WeeklyMainVC.self) {   //main
                        let weeklyMainVC = vc as! WeeklyMainVC
                        weeklyMainVC.color = weeklyScrollColorList[index]
                        
                        if weeklyMainVC.isKind(of: WeeklySportMainVC.self){          //运动
                            let weeklySportMainVC = weeklyMainVC as! WeeklySportMainVC
                            
                            weeklySportMainVC.userInfo = 0
                            
                            weeklySportMainVC.rank = Int(arc4random_uniform(50)) + 1
                            weeklySportMainVC.likeCount = Int(arc4random_uniform(20))
                            weeklySportMainVC.signCount = Int(arc4random_uniform(7))
                            let averageStep = Int(arc4random_uniform(6000)) + 4000
                            weeklySportMainVC.averageStep = averageStep
                            weeklySportMainVC.runningDistance = Int(arc4random_uniform(20))
                            
                            weeklySportMainVC.totalCalorie = 123
                            weeklySportMainVC.totalDistance = 456
                            weeklySportMainVC.totalDuration = 789
                            
                            let curValue = averageStep * 7
                            let lastValue = Int(arc4random_uniform(36000)) + 20000
                            weeklySportMainVC.mainValue = (curValue: curValue, lastValue: lastValue)
                        }else if weeklyMainVC.isKind(of: WeeklySleepMainVC.self){    //睡眠
                            let weeklySleepMainVC = weeklyMainVC as! WeeklySleepMainVC
                        }else {                                                 //心率
                            let weeklyHeartrateMainVC = weeklyMainVC as! WeeklyHeartrateMainVC
                        }
                    }else{                                  //vice
                        let weeklyViceVC = vc as! WeeklyViceVC
                        
                        if weeklyViceVC.isKind(of: WeeklySportViceVC.self){         //运动子页
                            let weeklySportViceVC = weeklyViceVC as! WeeklySportViceVC
                            
                            weeklySportViceVC.thisWeekSteps = Int(arc4random_uniform(36000)) + 20000
                            weeklySportViceVC.lastWeekSteps = Int(arc4random_uniform(36000)) + 20000
                            weeklySportViceVC.lastTwoWeekSteps = Int(arc4random_uniform(36000)) + 20000
                            weeklySportViceVC.lastThreeWeekSteps = Int(arc4random_uniform(36000)) + 20000
                            
                            var curWeeklySteps = [Int]()
                            var lastWeeklySteps = [Int]()
                            for _ in 0..<7 {
                                curWeeklySteps.append(Int(arc4random_uniform(6000)) + 4000)
                                lastWeeklySteps.append(Int(arc4random_uniform(6000)) + 4000)
                            }
                            weeklySportViceVC.weekAverageTuple = (curWeeklySteps, lastWeeklySteps)
                        }else if weeklyViceVC.isKind(of: WeeklySleepViceVC.self) {
                            let weeklySleepViceVC = weeklyViceVC as! WeeklySleepViceVC
                        }else {
                            let weeklyHeartrateViceVC = weeklyViceVC as! WeeklyHeartrateViceVC
                        }
                    }
                }
            }
        }
    }
    
    private func createContents(){
        
    }
}

extension WeeklyVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    //滑动结束回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.height
        let page = Int(scrollView.contentOffset.y) / Int(pageWidth)
        if page < 6{
            selectedPage = page
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.backgroundColor = weeklyScrollColorList[page]
            }, completion: {
                completed in
            })
        }
    }
}
