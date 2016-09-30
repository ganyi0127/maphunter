//
//  TopScrollView.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class TopScrollView: UIScrollView {
    
    var cycleType:CycleType?{
        didSet{
            setCycle(cycleType!)
        }
    }
    
    var closure: ((_ date: Date) -> ())?                //回调
    
    fileprivate let singleWidth = view_size.width / 7   //单元格宽度
    fileprivate let calendar = Calendar.current             //日历
    fileprivate var isOpen = false                      //是否展开日历
    override var frame: CGRect{
        didSet{
            setNeedsDisplay()
        }
    }
    
    //保存当前选择的月份
    fileprivate var dateProgressOfThisMonth = [DateProgress]()
    fileprivate var dateProgressOfLastMonth = [DateProgress]()
    fileprivate var dateProgressOfNextMonth = [DateProgress]()
    fileprivate var dateProgressOfCurrentMonth = [DateProgress]()
    
    //判断page滚动参数
    fileprivate var startContentOffsetX:CGFloat?
    fileprivate var willEndContentOffsetX:CGFloat?
    fileprivate var monthOffset = 0
    
    //MARK:- init
    init(_ frame: CGRect) {
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        isUserInteractionEnabled = true
        
        //禁用滑条
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        isPagingEnabled = true
        delegate = self
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 重新排列——全屏——滑动
    func edit(_ open: Bool){
       
        isOpen = open
        
        //当前月第一天星期数_月天数
        let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: selectDate)
        let numberOfDaysInMonth:Int = Int(range!.count)
        var components = calendar.dateComponents([.year, .month], from: selectDate)
        components.day = 1
        if isOpen {
            let digure = digureMonth(components.month!, curYear: components.year!, monthOffset: monthOffset)
            components.month = digure.month
            components.year = digure.year
        }
        let weekday = calendar.component(.weekday, from: calendar.date(from: components)!)
        
        var duration:TimeInterval?
        if isOpen{
            
            contentSize = CGSize(width: view_size.width * 3, height: view_size.height)
            contentOffset = CGPoint(x: view_size.width, y: 0)
            duration = 0.8
            
            if dateProgressOfThisMonth.isEmpty{
                monthOffset = 0
                dateProgressOfThisMonth = dateProgressOfCurrentMonth
            }
            
            //排列
            dateProgressOfThisMonth.enumerated().forEach(){
                index, dateProgress in
                
                let dayIndex = index + 1
                
                let posX = CGFloat((dayIndex + weekday - 2) % 7) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2 + view_size.width
                let posY = CGFloat((dayIndex + weekday - 2) / 7) * singleWidth * 1.0 + view_size.height * 0.3
                let origin = CGPoint(x: posX, y: posY)
                
                //移动
                dateProgress.frame.origin = origin
            }
            
            //创建或销毁其他月份
            setLastAndNextMonth(true)
            
        }else{
            //content范围
            contentSize = CGSize(width: view_size.width * CGFloat((numberOfDaysInMonth + weekday) / 7 + ((numberOfDaysInMonth + weekday) % 7 == 0 ? 0 : 1)),
                                 height: frame.height)
            
            duration = 0.2
            
            //移除其他元素_其他月份dateProgress
            subviews.forEach(){
                view in
                if let dateProgress:DateProgress = view as? DateProgress{
                    if !dateProgressOfCurrentMonth.contains(dateProgress){
                        view.removeFromSuperview()
                    }
                }
            }
            dateProgressOfNextMonth.removeAll()
            dateProgressOfLastMonth.removeAll()
            dateProgressOfThisMonth.removeAll()
            
            monthOffset = 0
            
            //排列
            dateProgressOfCurrentMonth.enumerated().forEach(){
                index, dateProgress in
                
                let dayIndex = index + 1
                
                let posX = CGFloat(dayIndex - 1) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2 + CGFloat(weekday - 1) * singleWidth
                let posY = frame.size.height / 2 - dateProgress.frame.height / 2
                let origin = CGPoint(x: posX, y: posY)
                
                //点击回调_先
                dateProgress.closure = {
                    date, needDisplayDate in
                    
                    //自动滑动到当前日期
                    if needDisplayDate{
                        let offset = CGPoint(x: view_size.width * CGFloat((dayIndex + weekday - 2) / 7 ), y: 0)
                        self.setContentOffset(offset, animated: true)
                    }
                    
                    //回调
                    self.closure?(date)
                }
                
                //设置日期_后
                components.day = dayIndex
                dateProgress.date = calendar.date(from: components)
                //移动
                UIView.animate(withDuration: duration!, animations: {
                    dateProgress.frame.origin = origin
                }){
                    complete in
                    
                }
            }
        }
    }
    
    //MARK:计算偏移后的月份 curMonth = month - 1
    fileprivate func digureMonth(_ curMonth: Int, curYear: Int, monthOffset offset:Int) -> (month: Int, year: Int){

        var month = curMonth + offset
        var yearOffset = 0
        
        while month <= 0  {
            month += 12
            yearOffset -= 1
        }
        
        while month > 12 {
            month -= 12
            yearOffset += 1
        }
        
        return (month: month, year: curYear + yearOffset)
    }
    
    //MARK:- 创建或清除上个月与下个月dateProgress
    private func setLastAndNextMonth(_ open: Bool){
     
        if open{
            
            //重置offset
            
            
            var components:DateComponents
            var range: Range<Int>?
            
            //获取上个月
            components = calendar.dateComponents([.year, .month, .day], from: selectDate)
            components.day = 1
            var digure = digureMonth(components.month! - 1, curYear: components.year!, monthOffset: monthOffset)
            components.month = digure.month
            components.year = digure.year
            
            let lastDate = calendar.date(from: components)
            
            range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: lastDate!)
            let numberOfDaysInLastMonth:Int = Int(range!.count)
            let lastWeekday = calendar.component(.weekday, from: calendar.date(from: components)!)
            
            //判断上个月是否为空
            if dateProgressOfLastMonth.isEmpty {
                

                (1...numberOfDaysInLastMonth).forEach(){
                    dayIndex in
                    
                    let dateProgress = DateProgress("\(dayIndex)")
                    
                    dateProgress.curProgress = 40
                    addSubview(dateProgress)
                    
                    //保存为上一月
                    dateProgressOfLastMonth.append(dateProgress)
                    
                    let posX = CGFloat((dayIndex + lastWeekday - 2) % 7) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2
                    let posY = CGFloat((dayIndex + lastWeekday - 2) / 7) * singleWidth * 1.0 + view_size.height * 0.3
                    dateProgress.frame.origin = CGPoint(x: posX, y: posY)
                    
                    //设置日期_后
                    components.day = dayIndex
                    dateProgress.date = calendar.date(from: components)
                    
                    //点击回调
                    dateProgress.closure = {
                        date, needDisplayDate in
                        
                        //自动滑动到当前日期
                        if needDisplayDate{
                            let offset = CGPoint(x: view_size.width * CGFloat((dayIndex + lastWeekday - 2) / 7),
                                                 y: 0)
                            self.setContentOffset(offset, animated: true)
                        }
                        
                        self.dateProgressOfCurrentMonth.removeAll()
                        self.dateProgressOfCurrentMonth = self.dateProgressOfThisMonth
                        
                        self.closure?(date)
                    }
                }
            }else{
                //排列
                dateProgressOfLastMonth.enumerated().forEach(){
                    index, dateProgress in
                    
                    let dayIndex = index + 1
                    
                    let posX = CGFloat((dayIndex + lastWeekday - 2) % 7) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2 // + view_size.width
                    let posY = CGFloat((dayIndex + lastWeekday - 2) / 7) * singleWidth * 1.0 + view_size.height * 0.3
                    dateProgress.frame.origin = CGPoint(x: posX, y: posY)
                    
                    //点击回调
                    dateProgress.closure = {
                        date, needDisplayDate in
                        
                        //自动滑动到当前日期
                        if needDisplayDate{
                            let offset = CGPoint(x: view_size.width * CGFloat((dayIndex + lastWeekday - 2) / 7),
                                                 y: 0)
                            self.setContentOffset(offset, animated: true)
                        }
                        
                        self.dateProgressOfCurrentMonth.removeAll()
                        self.dateProgressOfCurrentMonth = self.dateProgressOfThisMonth
                        
                        self.closure?(date)
                    }
                }
            }
            
            //获取下个月
            components = calendar.dateComponents([.year, .month, .day], from: selectDate)
            components.day = 1
            digure = digureMonth(components.month! + 1, curYear: components.year!, monthOffset: monthOffset)
            components.month = digure.month
            components.year = digure.year
            
            let nextDate = calendar.date(from: components)
            
            range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: nextDate!)
            let numberOfDaysInNextMonth:Int = Int(range!.count)
            let nextWeekday = calendar.component(.weekday, from: calendar.date(from: components)!)
            
            //判断下个月是否为空
            if dateProgressOfNextMonth.isEmpty{
                
                (1...numberOfDaysInNextMonth).forEach(){
                    dayIndex in
                    
                    let dateProgress = DateProgress("\(dayIndex)")
                    
                    dateProgress.curProgress = 40
                    addSubview(dateProgress)
                    
                    //保存为下一月
                    dateProgressOfNextMonth.append(dateProgress)
                    
                    let posX = CGFloat((dayIndex + nextWeekday - 2) % 7) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2 + view_size.width * 2
                    let posY = CGFloat((dayIndex + nextWeekday - 2) / 7) * singleWidth * 1.0 + view_size.height * 0.3
                    dateProgress.frame.origin = CGPoint(x: posX, y: posY)
                    
                    //设置日期_后
                    components.day = dayIndex
                    dateProgress.date = calendar.date(from: components)
                    
                    //点击回调
                    dateProgress.closure = {
                        date, needDisplayDate in
                        
                        //自动滑动到当前日期
                        if needDisplayDate{
                            let offset = CGPoint(x: view_size.width * CGFloat((dayIndex + nextWeekday - 2) / 7),
                                                 y: 0)
                            self.setContentOffset(offset, animated: true)
                        }
                        
                        self.dateProgressOfCurrentMonth.removeAll()
                        self.dateProgressOfCurrentMonth = self.dateProgressOfThisMonth
                        
                        self.closure?(date)
                    }
                }
            }else{
                //排列
                dateProgressOfNextMonth.enumerated().forEach(){
                    index, dateProgress in
                    
                    let dayIndex = index + 1
                    
                    let posX = CGFloat((dayIndex + nextWeekday - 2) % 7) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2 + view_size.width * 2
                    let posY = CGFloat((dayIndex + nextWeekday - 2) / 7) * singleWidth * 1.0 + view_size.height * 0.3
                    dateProgress.frame.origin = CGPoint(x: posX, y: posY)
                    
                    //点击回调
                    dateProgress.closure = {
                        date, needDisplayDate in
                        
                        //自动滑动到当前日期
                        if needDisplayDate{
                            let offset = CGPoint(x: view_size.width * CGFloat((dayIndex + lastWeekday - 2) / 7),
                                                 y: 0)
                            self.setContentOffset(offset, animated: true)
                        }
                        
                        self.dateProgressOfCurrentMonth.removeAll()
                        self.dateProgressOfCurrentMonth = self.dateProgressOfThisMonth
                        
                        self.closure?(date)
                    }
                }
            }
            
        }else{
            
            //移除其他两月内容
        }
    }
    
    //MARK:- 设置显示轮转类型
    private func setCycle(_ type:CycleType){
        
        subviews.forEach(){
            view in
            view.removeFromSuperview()
        }
        
        let ratio: CGFloat = 1.1 //间隔与宽度比
        
        switch type {
        case .week:
            
            //content范围
            contentSize = CGSize(width: view_size.width, height: frame.height)
            
            let textList = ["日", "一", "二", "三", "四", "五", "六"]
            let singleWidth = view_size.width / CGFloat(textList.count)
            
            textList.enumerated().forEach(){
                index, text in
                
                let dateProgress = DateProgress(text)
                
                let origin = CGPoint(x: CGFloat(index) * singleWidth + singleWidth / 2 - dateProgress.frame.width / 2,
                                     y: frame.size.height / 2 - dateProgress.frame.height / 2)
                dateProgress.frame.origin = origin
                dateProgress.curProgress = 80
                addSubview(dateProgress)
            }
        case .month:
            
            //获取当月天数
            let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: Date())
            let numberOfDaysInMonth:Int = Int(range!.count)
            
            (1...numberOfDaysInMonth).forEach(){
                dayIndex in
                
                let dateProgress = DateProgress("\(dayIndex)")
                //初始化数据进度
                dateProgress.curProgress = 40
                addSubview(dateProgress)

                dateProgressOfThisMonth.append(dateProgress)
            }
            
            dateProgressOfCurrentMonth = dateProgressOfThisMonth
            
            edit(false)
            
        case .year:
            
            let textList = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
            
            var dateProgressWidth: CGFloat?
            
            textList.enumerated().forEach(){
                index, text in
                
                let dateProgress = DateProgress(text)
                
                let posX = CGFloat(index) * dateProgress.frame.width * ratio + dateProgress.frame.width * (ratio - 1) / 2
                let posY = frame.size.height / 2 - dateProgress.frame.height / 2
                let origin = CGPoint(x: posX, y: posY)
                dateProgress.frame.origin = origin
                dateProgress.curProgress = 50
                addSubview(dateProgress)
                
                if dateProgressWidth == nil{
                    dateProgressWidth = dateProgress.frame.width
                }
            }
            
            //content范围
            contentSize = CGSize(width: dateProgressWidth! * CGFloat(textList.count) * ratio,
                                 height: frame.height)
        }
    }
}

//MARK:- scroll_delegate
extension TopScrollView: UIScrollViewDelegate{
    
    override func draw(_ rect: CGRect) {
      
        let ctx:CGContext? = UIGraphicsGetCurrentContext()
        
        ctx?.clear(rect)
        
        //填充背景
        var backColor:CGColor?
        if isOpen{
            backColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        }else{
            backColor = UIColor.white.cgColor
        }
        ctx?.setFillColor(backColor!)
        ctx?.fill(rect)
        
        if isOpen{
            
            ctx?.setAllowsAntialiasing(true) //抗锯齿
            
            //文字：配置
            let paragraphStyle:NSParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSParagraphStyle
            var attributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: UIColor.white,
                NSParagraphStyleAttributeName: paragraphStyle]
            
            //绘制文字： 星期
            let textList = ["日", "一", "二", "三", "四", "五", "六"]
            textList.enumerated().forEach(){
                index, text in
                
                let dataTitle = NSString(string: text)
                var dataTitleRect = dataTitle.boundingRect(with: frame.size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                dataTitleRect.origin = CGPoint(x: CGFloat(index) * singleWidth + view_size.width + singleWidth / 2 - 6,
                                               y: view_size.height * 0.25)
                dataTitle.draw(in: dataTitleRect, withAttributes: attributes)
             
            }
            
            //绘制年月: 
            attributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 24),
                NSForegroundColorAttributeName: UIColor.white,
                NSParagraphStyleAttributeName: paragraphStyle]
            
            var components = calendar.dateComponents([.year, .month], from: selectDate)
            let digure = digureMonth(components.month!, curYear: components.year!, monthOffset: monthOffset)
            
            let dataTitle = NSString(string: "\(digure.year)年 \(digure.month)月")
            var dataTitleRect = dataTitle.boundingRect(with: frame.size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            dataTitleRect.origin = CGPoint(x: singleWidth + view_size.width + singleWidth / 2,
                                           y: view_size.height * 0.15)
            dataTitle.draw(in: dataTitleRect, withAttributes: attributes)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if isOpen{
            
            if contentOffset.x == view_size.width * 2{
                //左滑 nextMonth to thisMonth
                dateProgressOfLastMonth.forEach(){
                    dateProgress in
                    if !dateProgressOfCurrentMonth.contains(dateProgress){
                        dateProgress.removeFromSuperview()
                    }
                }

                dateProgressOfLastMonth = dateProgressOfThisMonth
                dateProgressOfThisMonth = dateProgressOfNextMonth
                dateProgressOfNextMonth.removeAll()
                
                monthOffset += 1
                
            }else if contentOffset.x == 0.0 {
                //右滑 lastMonth to thisMonth
                dateProgressOfNextMonth.forEach(){
                    dateProgress in
                    if !dateProgressOfCurrentMonth.contains(dateProgress){
                        dateProgress.removeFromSuperview()
                    }
                }

                dateProgressOfNextMonth = dateProgressOfThisMonth
                dateProgressOfThisMonth = dateProgressOfLastMonth
                dateProgressOfLastMonth.removeAll()
                
                monthOffset -= 1
            }
            
            edit(true)
            
            setNeedsDisplay()
            
        }else{
            monthOffset = 0
        }
    }
}
