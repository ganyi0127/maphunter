//
//  RecordTabelViewCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
enum RecordSubType{
    //运动
    case sportActivityType
    case sportLevel
    case sportStartDate
    case sportDuration
    
    //睡眠
    case sleepDate
    case wakeDate
    
    //体重
    case weightValue
    case weightFat
    case weightDate
    
    //血压
    case diastolicPressure
    case systolicPressure
    case pressureDate
    
    //心率
    case heartrateActivityType
    case heartrateValue
    case heartrateDate
}
class RecordTabelViewCell: UIView {
    
    //类型
    var cellType: RecordSubType!
    
    var value: Any?
    
    //回调
    var closure: ((_ type: RecordSubType, _ s: Bool)->())?
    
    private lazy var titleLabel: UILabel? = {
        let labelFrame = CGRect(x: 4, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .left
        label.textColor = wordColor
        label.font = fontMiddle
        self.addSubview(label)
        return label
    }()
    
    private lazy var button: UIButton? = {
        return nil
    }()
    
    private lazy var detailLabel: UILabel? = {
        let labelFrame = CGRect(x: self.frame.width - self.frame.size.width / 2 - self.button!.frame.width, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .right
        label.textColor = wordColor
        label.font = fontMiddle
        self.addSubview(label)
        return label
    }()
    
    
    //MARK:- init
    init(withRecordTableCellType cellType: RecordSubType){
        let frame = CGRect(x: 0, y: 0, width: view_size.width - 8 * 2, height: 44)
        super.init(frame: frame)
        
        self.cellType = cellType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .green
        isUserInteractionEnabled = true
        
        //主文字
        var titleText: String
        switch cellType! {
        case .sportActivityType:
            titleText = "活动类型"
        case .sportLevel:
            titleText = "难度级别"
        case .sportStartDate:
            titleText = "开始时间"
        case .sportDuration:
            titleText = "时长"
        case .sleepDate:
            titleText = "入睡"
        case .wakeDate:
            titleText = "醒来"
        case .weightValue:
            titleText = "体重"
        case .weightFat:
            titleText = "体内脂肪"
        case .weightDate:
            titleText = "时间"
        case .diastolicPressure:
            titleText = "舒张压"
        case .systolicPressure:
            titleText = "收缩压"
        case .pressureDate:
            titleText = "时间"
        case .heartrateActivityType:
            titleText = "类型"
        case .heartrateValue:
            titleText = "心率值"
        case .heartrateDate:
            titleText = "时间"
        default:
            titleText = ""
        }
        titleLabel?.text = titleText
    }
    
    private func createContents(){
        
        
    }
}

//MARK:- 点击事件
extension RecordTabelViewCell{
    
    //点击结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        closure?(cellType, true)        
    }
}
