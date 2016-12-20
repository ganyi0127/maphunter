//
//  TopView.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
//周期
enum CycleType:Int {
    case week = 0
    case month
    case year
    mutating func next(){
        let currentRawValue = self.rawValue
        var nextRawValue = currentRawValue + 1
        if nextRawValue > 2{
            nextRawValue = 0
        }
        self = CycleType(rawValue: nextRawValue)!
    }
}
@IBDesignable
class TopView: UIView {

    //回调
    var closure: ((_ date:Date) -> ())?
    
    //日期显示
//    private let label:UILabel! = {
//        let label = UILabel()
//        label.backgroundColor = UIColor.clear
//        label.text = "..."
//        label.textColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1)
//        label.font = UIFont(name: font_name, size: 17)
//        label.textAlignment = .center
//        return label
//    }()
    
    //切换今天按钮
//    private lazy var todayButton: UIButton = { ()->UIButton in
//        let buttonWidth = self.bounds.size.height * 0.4
//        let buttonOrigin = CGPoint(x: buttonWidth * 0.2, y: self.bounds.height * 0.55)
//        let buttonFrame = CGRect(origin: buttonOrigin, size: CGSize(width: buttonWidth, height: buttonWidth))
//        let todayButton = UIButton(frame: buttonFrame)
//        todayButton.tag = 0
//        todayButton.setImage(UIImage(named: "resource/icon_today"), for: .normal)
//        todayButton.addTarget(self, action: #selector(TopView.clickButton), for: .touchUpInside)
//        return todayButton
//    }()
    
    //日期显示
    private var topScrollView: TopScrollView?
    //轮转类型：week month year
    private var cycleType:CycleType?{
        didSet{
            //切换进度显示
            topScrollView?.cycleType = cycleType
            
            switch cycleType! {
            case .week:
                break
            case .month:
                break
            case .year:
                break
            }
        }
    }
    
    fileprivate var isCalendarOpened: Bool = false
    fileprivate var originViewFrame: CGRect!
    
    //MARK:- init
    override func didMoveToSuperview() {
        config()
        createContents()
    }
    
    deinit {
        notiy.removeObserver(self, name: switch_notiy, object: nil)
        notiy.removeObserver(self, name: calendar_notiy, object: nil)
    }
    
    override func draw(_ rect: CGRect) {

//        createContents()
    }
    
    private func config(){
        backgroundColor = .clear
        
        notiy.addObserver(self, selector: #selector(switchDate(notification:)), name: switch_notiy, object: nil)
        notiy.addObserver(self, selector: #selector(clickCalendar), name: calendar_notiy, object: nil)
    }
    
    //MARK:左右快捷切换日期
    @objc private func switchDate(notification: NSNotification){
        if notification.object as! Int == 0{
            selectDate = Date(timeInterval: -60 * 60 * 24, since: selectDate)
        }else{            
            selectDate = Date(timeInterval: 60 * 60 * 24, since: selectDate)
        }
        
        topScrollView?.edit(false)
    }
    
    private func createContents(){
        
        //初始化天数栏
        if topScrollView == nil{
            
            let topScrollFrame = CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height / 2)
            topScrollView = TopScrollView(topScrollFrame)
            topScrollView?.topDelegate = self
            addSubview(topScrollView!)
        }
        
        
        //label
//        let selfSize = bounds.size
        originViewFrame = bounds
//        let labelFrame = CGRect(x: 0, y: selfSize.height / 2, width: view_size.width, height: selfSize.height / 2)
//        label.frame = labelFrame
//        addSubview(label)
        
        //button
//        addSubview(todayButton)
        
        //初始化轮转周期
        cycleType = .month
    }
    
    //MARK:- 更新显示当前日期
    fileprivate func updateDateInLabel(date: Date){
        
//        //点击日期事件回调
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyy-MM-dd"
//        let dateStr = formatter.string(from: date)
//        let todayStr = formatter.string(from: Date())
//        
//        //星期数量
//        let calendar = Calendar.current
//        let weekday = calendar.component(.weekday, from: date)
//        let weekList = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
//        //显示今天
//        if dateStr == todayStr{
//            self.label.text = "今天 " + weekList[weekday - 1]
//            todayButton.isHidden = true
//        }else{
//            self.label.text = dateStr + " " + weekList[weekday - 1]
//            todayButton.isHidden = false
//        }
    }
    
    @objc fileprivate func clickCalendar(){
        //展开日历
        isCalendarOpened = !isCalendarOpened
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.topScrollView?.edit(self.isCalendarOpened)
            if self.isCalendarOpened{
                let bigFrame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
                self.topScrollView?.frame = bigFrame
                self.frame.size = bigFrame.size
                
                //隐藏tabbar
                self.viewController().navigationController?.setTabbar(hidden: true)
            }else{
                let smallFrame = CGRect(x: 0, y: -1, width: view_size.width, height: self.originViewFrame.size.height / 2)
                self.topScrollView?.frame = smallFrame
                self.frame.size = self.originViewFrame.size
                
                //显示tabbar
                self.viewController().navigationController?.setTabbar(hidden: false)
            }
        }, completion: nil)
    }
    //MARK:- 按钮点击
    @objc fileprivate func clickButton(sender: UIButton){
        
        switch sender.tag {
        case 0:
            //返回到今天日期
            selectDate = Date()
            topScrollView?.edit(false)
        default:
            break
        }
    }
}

extension TopView : TopScrollDelegate{
    func topScrollData(withDay day: Int, withMonth month: Int, withYear year: Int) -> (curValues: [CGFloat], maxValues: [CGFloat]) {
        return ([12, 89, 2],[50, 100, 3])
    }
    
    func topScrollDidSelected(withData date: Date) {
        
        self.updateDateInLabel(date: date)
        
        //收起日历
        if isCalendarOpened{
            clickCalendar()
        }else{
            closure?(date)
        }
    }
}
