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
                             modelEndColors[.sport]!,
                             modelStartColors[.sleep]!,
                             modelEndColors[.sleep]!,
                             modelStartColors[.heartrate]!,
                             modelEndColors[.heartrate]!]

class WeeklyVC: UIViewController {

    //日期范围
    private var weekStartDate: Date!
    private var weekEndDate: Date!
    
    //滑动视图背景颜色
    fileprivate var selectedPage = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = weekStartDate.formatString(with: "MM/dd") + "-" + weekEndDate.formatString(with: "MM/dd") + "周报"
        navigationController?.setNavigationOpacity(opacity: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        scrollView.setContentOffset(.zero, animated: true)
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
        for (index, id) in storyboardIDList.enumerated(){
            if let vc = storyboard?.instantiateViewController(withIdentifier: id) {
                if vc.isKind(of: WeeklyMainVC.self) {
                    (vc as! WeeklyMainVC).color = weeklyScrollColorList[index]
                }
                let v = vc.view
                v?.frame = CGRect(origin: CGPoint(x: 0, y: view_size.height * CGFloat(index)), size: scrollView.bounds.size)
                scrollView.addSubview(v!)
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
