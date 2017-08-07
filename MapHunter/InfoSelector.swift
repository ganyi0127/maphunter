//
//  InfoSelector.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
fileprivate let height: CGFloat = 256
class InfoSelector: UIView {
    
    fileprivate let heightRange: (min: Int, max: Int) = (30, 255)
    fileprivate let weightRange: (min: Int, max: Int) = (25, 255)
    
    private let targetFrame = CGRect(x: 0, y: view_size.height - height, width: view_size.width, height: height)
    private let initFrame = CGRect(x: 0, y: view_size.height, width: view_size.width, height: height)
    private let pickerFrame = CGRect(x: 0, y: 44, width: view_size.width, height: height - 44)
    
    private let calender = Calendar.current
    
    fileprivate var infotype: InfoType?
    fileprivate var value1: Any?
    fileprivate var value2: Any?
    var closure: ((Bool, InfoType, Any?, Any?)->())?
    
    private var pickerView: UIPickerView?
    private var datePickerView: UIDatePicker?
    
    fileprivate var valueList1 = [Int](){
        didSet{
            //pickerView?.reloadAllComponents()
        }
    }
    fileprivate var valueList2 = [String](){
        didSet{
            //pickerView?.reloadAllComponents()
        }
    }
    
    //体重小数点
    fileprivate var valueDotList: [Int]! {
        get{
            var list = [Int]()
            (0...9).forEach{
                i in
                list.append(i)
            }
            return list
        }
    }
    
    //MARK:- init ***********************************************************************************************************************
    init(){
        super.init(frame: initFrame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .white
    }
    
    private func createContents(){
        
        //手动添加分割线
        let separatorFrame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        let separatorLine = UIView(frame: separatorFrame)
        separatorLine.backgroundColor = lightWordColor
        addSubview(separatorLine)
        
        //添加确认取消按钮
        let refuseImageSize = CGSize(width: 20, height: 20)
        let refuseButtonFrame = CGRect(x: 0, y: 0, width: 64, height: 44)
        let refuseButton = UIButton(frame: refuseButtonFrame)
        if let img = UIImage(named: "resource/target/target_refuse")?.transfromImage(size: refuseImageSize){
            refuseButton.setImage(img, for: .normal)
        }
        if let img = UIImage(named: "resource/target/target_refuse_highlight")?.transfromImage(size: refuseImageSize){
            refuseButton.setImage(img, for: .highlighted)
        }
        refuseButton.addTarget(self, action: #selector(refuse(sender:)), for: .touchUpInside)
        addSubview(refuseButton)
        
        let acceptImageSize = CGSize(width: 20, height: 20)
        let acceptButtonFrame = CGRect(x: view_size.width - 64, y: 0, width: 64, height: 44)
        let acceptButton = UIButton(frame: acceptButtonFrame)
        if let img = UIImage(named: "resource/target/target_accept")?.transfromImage(size: acceptImageSize){
            acceptButton.setImage(img, for: .normal)
        }
        if let img = UIImage(named: "resource/target/target_accept_highlight")?.transfromImage(size: acceptImageSize){
            acceptButton.setImage(img, for: .highlighted)
        }
        acceptButton.addTarget(self, action: #selector(accept(sender:)), for: .touchUpInside)
        addSubview(acceptButton)        
    }
    
    //MARK:- 取消
    @objc private func refuse(sender: UIButton){
        if let type = infotype{
            closure?(false, type, nil, nil)
        }
        set(hidden: true)
    }
    
    //MARK:- 确认
    @objc private func accept(sender: UIButton){
        if let type = infotype{
            closure?(true, type, value1, value2)
        }
        set(hidden: true)
    }
    
    //MARK:- 切换输入模块
    func switchInput(withType type: InfoType){
        if type == .birthday && (infotype == nil || infotype != .birthday){
            pickerView?.removeFromSuperview()
            pickerView = nil
            datePickerView?.removeFromSuperview()
            
            datePickerView = UIDatePicker(frame: pickerFrame)
            datePickerView?.datePickerMode = .date
            datePickerView?.addTarget(self, action: #selector(selectBirthyDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -250 * 60 * 60 * 24 * 365)
            addSubview(datePickerView!)
        }else if type != .birthday && (infotype == nil || infotype == .birthday){
            datePickerView?.removeFromSuperview()
            datePickerView = nil
            pickerView?.removeFromSuperview()
            
            pickerView = UIPickerView(frame: pickerFrame)
            pickerView?.delegate = self
            pickerView?.dataSource = self
            addSubview(pickerView!)
        }
        
        infotype = type
        set(hidden: false)
        
        
        //选择器类型
        switch type {
        case .gender:
            valueList2 = ["男", "女"]
            
            let defaultInt = 0
            var udGender = userDefaults.integer(forKey: "gender")
            if udGender == 1 {          //男
                udGender = 0
            }else if udGender == 2{     //女
                udGender = 1
            }
            value2 = valueList2[defaultInt]
            pickerView?.reloadAllComponents()
            pickerView?.selectRow(defaultInt, inComponent: 0, animated: true)
        case .height:
            var list = [Int]()
            (heightRange.min...heightRange.max).forEach{
                i in
                list.append(i)
            }
            valueList1 = list
            valueList2 = ["厘米", "英寸"]
            
            //身高
            var defaultHeight = 175
            let udHeight = userDefaults.integer(forKey: "height")
            if udHeight != 0 {
                defaultHeight = udHeight
            }
            let defaultInt = defaultHeight - heightRange.min
            value1 = valueList1[defaultInt]
            
            pickerView?.reloadAllComponents()
            pickerView?.selectRow(defaultInt, inComponent: 0, animated: true)
        case .weight:
            var list = [Int]()
            (weightRange.min...weightRange.max).forEach{
                i in
                list.append(i)
            }
            valueList1 = list
            valueList2 = ["公斤", "磅"]
            
            var defaultWeight = 65
            var defaultWeightDot = 0
            let udWeight = userDefaults.integer(forKey: "weight")
            if udWeight != 0{
                defaultWeight = Int(udWeight / 1000)
                defaultWeightDot = lroundf(Float(udWeight % 1000) / 100)
            }
            
            let defaultInt = defaultWeight - weightRange.min
            value1 = valueList1[defaultInt] * 1000 + valueDotList[defaultWeightDot] * 100
            
            pickerView?.reloadAllComponents()
            pickerView?.selectRow(defaultInt, inComponent: 0, animated: true)
            pickerView?.selectRow(defaultWeightDot, inComponent: 1, animated: true)
        case .birthday:
            var components = calender.dateComponents([.year, .month, .day], from: Date())
            components.year = components.year! - 25
            components.month = 6
            components.day = 18
            if let defaultDate = calender.date(from: components){
                
                let udBirthday = userDefaults.double(forKey: "offsetdays")
                if udBirthday != 0{
                    //计算生日
                    let today = Date()
                    let defaultDate = Date(timeInterval: -udBirthday * 60 * 60 * 24, since: today)
                    datePickerView?.setDate(defaultDate, animated: true)
                    datePickerView?.date = defaultDate
                    value1 = defaultDate
                }else{
                    datePickerView?.setDate(defaultDate, animated: true)
                    datePickerView?.date = defaultDate
                    value1 = defaultDate
                }
            }
            break
        }
    }
    
    @objc private func selectBirthyDate(sender: UIDatePicker){
        value1 = sender.date
    }
    
    //MARK:- 隐藏
    func set(hidden flag: Bool){
        if flag {
            infotype = nil
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.frame = flag ? self.initFrame : self.targetFrame
        }, completion: nil)
    }
}

//MARK:- picker delegate
extension InfoSelector: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if infotype == .gender {
            return 1
        } else if infotype == .weight{
            return 3
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            if infotype == .gender{
                return valueList2.count
            }
            return valueList1.count
        }
        
        if component == 1 {
            if infotype == .weight{
                return valueDotList.count
            }
            return valueList2.count
        }
        return valueList2.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        //性别
        if infotype == .gender{
            return view_size.width
        }
        
        //身高
        
        if infotype == .height{
            if component == 0{
                return view_size.width * 2 / 3
            }else{
                return view_size.width / 3
            }
        }
        
        //体重
        return view_size.width / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //第一列
        if component == 0 {
            if infotype == .gender {        //性别
                if row < valueList2.count{
                    return valueList2[row]
                }
            }else if infotype == .height{   //身高
                if pickerView.selectedRow(inComponent: 1) == 0{
                    //公制
                    if row < valueList1.count{
                        return "\(valueList1[row])"
                    }
                }else{
                    //英制
                    if row < valueList1.count{
                        let value = valueList1[row]
                        let foot = value / 12
                        let inch = value % 12
                        return "\(foot)\'\(inch)\""
                    }
                }
            }else{                          //体重
                if pickerView.selectedRow(inComponent: 1) == 0{
                    //公制
                    if row < valueList1.count{
                        return "\(valueList1[row])"
                    }
                }else{
                    //英制
                    if row < valueList1.count{
                        return "\(valueList1[row])"
                    }
                }
            }
            return ""
        }
        
        //第二列 身高单位、体重.dot
        if component == 1{
            if infotype == .height{
                if row < valueList2.count{
                    return valueList2[row]
                }
            }else if infotype == .weight{
                if row < valueDotList.count{
                    if row == 0{
                        return "-"
                    }
                    return ".\(valueDotList[row])"
                }
            }
        }
        
        //第三列 体重单位
        if component == 2{
            if row < valueList2.count{
                return valueList2[row]
            }
        }
        
        return ""
    }
    
    //选择内容
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{  //选择数值
            if infotype == .gender{         //性别
                if row < valueList2.count{
                    value2 = valueList2[row]
                }
                return
            }else if infotype == .height{
                if row < valueList1.count {
                    let originValue = valueList1[row]
                    let unitIndex = pickerView.selectedRow(inComponent: 1)      //获取公英制
                    let value = unitIndex == 0 ? originValue : lroundf(Float(originValue) * 2.54)
                    value1 = value
                }
            }else if infotype == .weight{
                if row < valueList1.count{
                    let unitIndex = pickerView.selectedRow(inComponent: 2)      //获取公英制
                    let dotValue = pickerView.selectedRow(inComponent: 1)       //获取小数位
                    let originValue = Int((Float(valueList1[row]) + Float(dotValue) / 10) * 1000)
                    let value = unitIndex == 0 ? originValue : lroundf(Float(originValue) / 2.2046)
                    value1 = value
                }
            }
        }else if component == 1{    //选择身高单位  或 体重dot
            //切换单位后更新数据
            if infotype == .height{         //身高
                /*
                 1英尺=12英寸=304.8mm；foot
                 1英寸=25.4mm；inch
                 */
                
                //获取之前的row
                let valueIndex = pickerView.selectedRow(inComponent: 0)
                
                var newIndex: Int = 0
                
                //转换为当前数值
                if row == 0{    //如果当前为公制，之前则为英制
                    
                    var newValue = lroundf(Float(valueList1[valueIndex]) * 2.54)
                    
                    if newValue < heightRange.min{
                        newValue = heightRange.min
                    }else if newValue > heightRange.max {
                        newValue = heightRange.max
                    }
                    
                    newIndex = newValue - heightRange.min
                }else{          //如果当前为英制，之前则为公制
                    
                    var newValue = lroundf(Float(valueList1[valueIndex]) / 2.54)
                    
                    if newValue < lroundf(Float(heightRange.min) / 2.54){
                        newValue = lroundf(Float(heightRange.min) / 2.54)
                    }else if newValue > lroundf(Float(heightRange.max) / 2.54){
                        newValue = lroundf(Float(heightRange.max) / 2.54)
                    }
                    
                    newIndex = newValue - lroundf(Float(heightRange.min) / 2.54)
                }
                
                //清空数据
                valueList1.removeAll()
                
                let minHeight = row == 0 ? heightRange.min : lroundf(Float(heightRange.min) / 2.54)
                let maxHeight = row == 0 ? heightRange.max : lroundf(Float(heightRange.max) / 2.54)
                (minHeight...maxHeight).forEach{
                    height in
                    valueList1.append(height)
                }
                
                //刷新
                pickerView.reloadAllComponents()
                pickerView.selectRow(newIndex, inComponent: 0, animated: true)
                
                //存储单位
                if row < valueList2.count{
                    value2 = valueList2[row]
                }
            }else{      //体重小数位
                if row < valueDotList.count{
                    let unitIndex = pickerView.selectedRow(inComponent: 2)      //获取公英制
                    let intValue = pickerView.selectedRow(inComponent: 0)       //获取整数位
                    let originValue = Int((Float(valueList1[intValue]) + Float(valueDotList[row]) / 10) * 10000)
                    let value = unitIndex == 0 ? originValue : lroundf(Float(originValue) / 2.2046)
                    value1 = value
                }
            }
        }else{
            if infotype == .weight{   //体重
                /*
                 1公斤=2.2046磅
                 valueListSwitchCopy = valueList1.map{Int(CGFloat($0) * 2.2046)}
                 */
                
                //获取之前的row
                let valueIndex = pickerView.selectedRow(inComponent: 0)
                let dotIndex = pickerView.selectedRow(inComponent: 1)
                
                var newIndex: Int = 0
                var newDotIndex: Int = 0
                
                //转换为当前数值
                if row == 0{    //如果当前为公制，之前则为英制
                    var newValue = lroundf((Float(valueList1[valueIndex]) + Float(valueDotList[dotIndex]) / 10) / 2.2046 * 1000)
                    
                    if newValue < weightRange.min * 1000{
                        newValue = weightRange.min * 1000
                    }else if newValue > weightRange.max * 1000{
                        newValue = weightRange.max * 1000
                    }
                    
                    newIndex = newValue / 1000 - weightRange.min
                    newDotIndex = (newValue % 1000) / 100
                }else{          //如果当前为英制，之前则为公制
                    
                    var newValue = lroundf((Float(valueList1[valueIndex]) + Float(valueDotList[dotIndex]) / 10) * 2.2046 * 10000)
                    
                    if newValue < lroundf(Float(weightRange.min) * 2.2046) * 1000{
                        newValue = lroundf(Float(weightRange.min) * 2.2046) * 1000
                    }else if newValue > lroundf(Float(weightRange.max) * 2.2046) * 1000{
                        newValue = lroundf(Float(weightRange.max) * 2.2046) * 1000
                    }
                    
                    newIndex = newValue / 1000 - lroundf(Float(weightRange.min) * 2.2046)
                    newDotIndex = (newValue % 1000) / 100
                }
                
                
                //清空数据
                valueList1.removeAll()
                
                let minWeight = row == 0 ? weightRange.min : lroundf(Float(weightRange.min) * 2.2046)
                let maxWeight = row == 0 ? weightRange.max : lroundf(Float(weightRange.max) * 2.2046)
                (minWeight...maxWeight).forEach{
                    weight in
                    valueList1.append(weight)
                }
                
                //刷新控件
                pickerView.reloadAllComponents()
                pickerView.selectRow(newIndex, inComponent: 0, animated: true)
                pickerView.selectRow(newDotIndex, inComponent: 1, animated: true)
            }
        }
    }
}

//MARK:- date picker delegate
extension InfoSelector{}
