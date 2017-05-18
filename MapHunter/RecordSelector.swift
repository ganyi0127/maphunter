//
//  RecordSeletor.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordSelector: UIView {
    
    fileprivate var type: RecordSubType!
    
    private var datePickerView: UIDatePicker?
    private var pickerView: UIPickerView?
    
    var closure: ((_ type: RecordSubType, _ value: Any?)->())?     //返回是否合法
    
    
    //MARK:- init **********************************************************************
    init(type: RecordSubType, frame: CGRect){
        super.init(frame: frame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        isUserInteractionEnabled = true
    }
    
    private func createContents(){
        switch type as RecordSubType {
        case .weightValue, .weightFat, .diastolicPressure, .systolicPressure, .heartrateActivityType, .heartrateValue:
            pickerView = UIPickerView(frame: frame)
            pickerView?.delegate = self
            pickerView?.dataSource = self
            addSubview(pickerView!)
        case .sportActivityType:
            //自定义选择器
            break
        case .sportLevel:
            //自定义选择器
            break
        case .sportStartDate:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .dateAndTime
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -2 * 60 * 60 * 24)     //两天前
            addSubview(datePickerView!)
        case .sleepDate, .wakeDate, .weightDate, .pressureDate, .heartrateDate:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .dateAndTime
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24)     //1天前
            addSubview(datePickerView!)
        case .sportDuration:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .countDownTimer
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24)     //24小时
            addSubview(datePickerView!)
        default:
            break
        }
    }
    
    @objc private func selectDate(sender: UIDatePicker){
        switch type as RecordSubType {
        case .sportDuration:
            closure?(type, sender.countDownDuration)
        default:
            closure?(type, sender.date)
        }
    }
}

extension RecordSelector: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type as RecordSubType {
        case .weightFat, .diastolicPressure, .systolicPressure, .heartrateActivityType, .heartrateValue:
            return 1
        case .weightValue:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type as RecordSubType {
        case .weightFat:
            return 100
        case .diastolicPressure:
            return 40
        case .systolicPressure:
            return 40
        case .heartrateActivityType:
            return 2
        case .heartrateValue:
            return 250
        case .weightValue:
            return 255 - 30
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        switch type as RecordSubType {
        case .weightFat, .diastolicPressure, .systolicPressure, .heartrateActivityType, .heartrateValue:
            return frame.width
        case .weightValue:
            return frame.width / 3
        default:
            return frame.width
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type as RecordSubType {
        case .weightFat:
            return "\(row)"
        case .diastolicPressure:
            return "\(row)"
        case .systolicPressure:
            return "\(row)"
        case .heartrateActivityType:
            return "\(row)"
        case .heartrateValue:
            return "\(row)"
        case .sportDuration:
            return "\(row)"
        case .weightValue:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedValue: Any?
        switch type as RecordSubType {
        case .weightFat:
            selectedValue = 44
        case .diastolicPressure:
            selectedValue = 44
        case .systolicPressure:
            selectedValue = 44
        case .heartrateActivityType:
            selectedValue = 44
        case .heartrateValue:
            selectedValue = 44
        case .sportDuration:
            selectedValue = 44
        case .weightValue:
            selectedValue = 44
        default:
            selectedValue = nil
        }
        closure?(type, selectedValue)
    }
}
