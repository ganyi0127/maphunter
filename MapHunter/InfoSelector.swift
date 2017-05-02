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
    
    
    private let targetFrame = CGRect(x: 0, y: view_size.height - height, width: view_size.width, height: height)
    private let initFrame = CGRect(x: 0, y: view_size.height, width: view_size.width, height: height)
    private let pickerFrame = CGRect(x: 0, y: 44, width: view_size.width, height: height - 44)
    
    fileprivate var infotype: InfoType?
    fileprivate var value1: Any?
    fileprivate var value2: Any?
    var closure: ((Bool, InfoType, Any?, Any?)->())?
    
    private var pickerView: UIPickerView?
    private var datePickerView: UIDatePicker?
    
    fileprivate var valueList1 = [Int](){
        didSet{
            pickerView?.reloadAllComponents()
        }
    }
    fileprivate var valueList2 = [String](){
        didSet{
            pickerView?.reloadAllComponents()
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
        refuseButton.addTarget(self, action: #selector(refuse(sender:)), for: .touchUpInside)
        addSubview(refuseButton)
        
        let acceptImageSize = CGSize(width: 20, height: 20)
        let acceptButtonFrame = CGRect(x: view_size.width - 64, y: 0, width: 64, height: 44)
        let acceptButton = UIButton(frame: acceptButtonFrame)
        if let img = UIImage(named: "resource/target/target_accept")?.transfromImage(size: acceptImageSize){
            acceptButton.setImage(img, for: .normal)
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
            value2 = valueList2[defaultInt]
            pickerView?.selectRow(defaultInt, inComponent: 0, animated: true)
        case .height:
            var list = [Int]()
            (30...255).forEach{
                i in
                list.append(i)
            }
            valueList1 = list
            valueList2 = ["厘米", "英寸"]
            
            let defaultInt = 173 - 30
            value1 = valueList1[defaultInt]
            pickerView?.selectRow(defaultInt, inComponent: 0, animated: true)
        case .weight:
            var list = [Int]()
            (25...255).forEach{
                i in
                list.append(i)
            }
            valueList1 = list
            valueList2 = ["公斤", "磅"]
            
            let defaultInt = 65 - 25
            value1 = valueList1[defaultInt]
            pickerView?.selectRow(defaultInt, inComponent: 0, animated: true)
        case .birthday:
            let defaultDate = Date(timeIntervalSinceNow: -25 * 60 * 60 * 24 * 360)
            datePickerView?.setDate(defaultDate, animated: true)
            datePickerView?.date = defaultDate
            value1 = defaultDate
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
        return valueList2.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if infotype == .gender{
            return view_size.width
        }
        
        if component == 0{
            return view_size.width * 2 / 3
        }
        return view_size.width / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if infotype == .gender {
                if row < valueList2.count{
                    return valueList2[row]
                }
            }else{
                if row < valueList1.count{
                    return "\(valueList1[row])"
                }
            }
            return ""
        }
        if row < valueList2.count{
            return valueList2[row]
        }
        
        return ""
    }
    
    //选择内容
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            if infotype == .gender{
                if row < valueList2.count{
                    value2 = valueList2[row]
                }
                return
            }
            if row < valueList1.count {
                value1 = valueList1[row]
            }
        }else{
            if row < valueList2.count{
                value2 = valueList2[row]
            }
        }
    }
}

//MARK:- date picker delegate
extension InfoSelector{}
