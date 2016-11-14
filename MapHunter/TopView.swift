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
    private let label:UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        label.text = "..."
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    //切换轮转按钮
    private var dateButton: UIButton?
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
    }
    
    deinit {
        notiy.removeObserver(self, name: switch_notiy, object: nil)
    }
    
    override func draw(_ rect: CGRect) {
        
        createContents()
    }
    
    private func config(){
        backgroundColor = .clear
        
        notiy.addObserver(self, selector: #selector(switchDate(notification:)), name: switch_notiy, object: nil)
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
            
            let topScrollFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2)
            topScrollView = TopScrollView(topScrollFrame)
//            topScrollView?.closure = {
//                date in
//                
//                self.updateDateInLabel(date: date)
//                
//                //收起日历
//                if self.isCalendarOpened{
//                    self.clickButton()
//                }else{
//                    self.closure?(date)
//                }
//                
//            }
            topScrollView?.topDelegate = self
            addSubview(topScrollView!)
        }
        
        
        //label
        let selfSize = bounds.size
        originViewFrame = bounds
        let labelFrame = CGRect(x: 0, y: selfSize.height / 2, width: view_size.width, height: selfSize.height / 2)
        label.frame = labelFrame
        addSubview(label)
        
        //button
        if dateButton == nil{
            
            let buttonWidth = selfSize.height * 0.4
            let buttonOrigin = CGPoint(x: view_size.width - buttonWidth * 1.2, y: selfSize.height * 0.55)
            let buttonFrame = CGRect(origin: buttonOrigin, size: CGSize(width: buttonWidth, height: buttonWidth))
            dateButton = UIButton(frame: buttonFrame)
            dateButton?.setImage(UIImage(named: "icon_calender"), for: .normal)
            dateButton?.addTarget(self, action: #selector(TopView.clickButton), for: .touchUpInside)
            addSubview(dateButton!)
        }
        
        //初始化轮转周期
        cycleType = .month
    }
    
    //MARK:- 更新显示当前日期
    fileprivate func updateDateInLabel(date: Date){
        
        //点击日期事件回调
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        let dateStr = formatter.string(from: date)
        let todayStr = formatter.string(from: Date())
        
        //显示今天
        if dateStr == todayStr{
            self.label.text = "今天"
        }else{
            self.label.text = dateStr
        }
    }
    
    //打开日历
    @objc fileprivate func clickButton(){
       
        isCalendarOpened = !isCalendarOpened
        
        UIView.animate(withDuration: 0.3, animations: {
            
            if self.isCalendarOpened{
                let bigFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: view_size.height)
                self.topScrollView?.frame = bigFrame
                self.frame.size = bigFrame.size
            }else{
                let smallFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.originViewFrame.size.height / 2)
                self.topScrollView?.frame = smallFrame
                self.frame.size = self.originViewFrame.size
            }
            self.topScrollView?.edit(self.isCalendarOpened)
        }){
            complete in
            
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
            clickButton()
        }else{
            closure?(date)
        }
    }
}
