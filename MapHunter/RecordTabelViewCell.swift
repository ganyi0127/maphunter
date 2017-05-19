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
    
    var value: Any?{
        didSet{
            
            //日期格式
            let format = DateFormatter()
            format.dateFormat = "yyy-M-d h:mm"
            
            //判断是否为不可选数据
            var eligible = true
            
            //文字
            var detailText = ""
            switch cellType as RecordSubType{
            case .sportActivityType:
                if let sportType = value as? SportType{
                    if let typeName = sportTypeNameMap[sportType]{
                        detailText = typeName
                    }else{
                        detailText = "-"
                    }
                }else{
                    detailText = "-"
                }
            case .sportLevel:
                if let level = value as? Int{
                    switch level {
                    case 0:
                        detailText = "Easy"
                    case 1:
                        detailText = "Moderate"
                    case 2:
                        detailText = "In the zone"
                    case 3:
                        detailText = "Difficult"
                    default:
                        detailText = "Cut buster"
                    }
                }else{
                    detailText = "-"
                }
            case .sportStartDate:
                if let date = value as? Date{
                    detailText = format.string(from: date)
                }else{
                    let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                    detailText = format.string(from: defaultDate)
                }
            case .sportDuration:
                if let duration = value as? TimeInterval{
                    let hour = Int(duration) / (60 * 60)
                    let minute = (Int(duration) - hour * 60 * 60) / 60
                    detailText = "\(hour)小时\(minute)分钟"
                }else{
                    detailText = "-"
                }
            case .sleepDate:
                if let date = value as? Date{
                    detailText = format.string(from: date)
                }else{
                    let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                    detailText = format.string(from: defaultDate)
                }
            case .wakeDate:
                if let date = value as? Date{
                    detailText = format.string(from: date)
                }else{
                    let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                    detailText = format.string(from: defaultDate)
                }
            case .weightValue:
                if let weight = value as? CGFloat{
                    detailText = "\(weight)kg"
                }else{
                    detailText = "-kg"
                }
            case .weightFat:
                if let fat = value as? CGFloat{
                    detailText = "\(fat)"
                }else{
                    detailText = "-"
                }
            case .weightDate:
                if let date = value as? Date{
                    detailText = format.string(from: date)
                }else{
                    let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                    detailText = format.string(from: defaultDate)
                }
            case .diastolicPressure:
                if let pressure = value as? Int{
                    detailText = "\(pressure)mmHg"
                }else{
                    detailText = "-mmHg"
                }
            case .systolicPressure:
                if let pressure = value as? Int{
                    detailText = "\(pressure)mmHg"
                }else{
                    detailText = "-mmHg"
                }
            case .pressureDate:
                if let date = value as? Date{
                    detailText = format.string(from: date)
                }else{
                    let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                    detailText = format.string(from: defaultDate)
                }
            case .heartrateActivityType:
                if let sportType = value as? Int16{
                    detailText = "\(sportType)"
                }else{
                    detailText = "未知"
                }
            case .heartrateValue:
                if let heartrate = value as? Int{
                    detailText = "\(heartrate)次/分钟"
                }else{
                    detailText = "0次/分钟"
                }
            case .heartrateDate:
                if let date = value as? Date{
                    detailText = format.string(from: date)
                }else{
                    let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                    detailText = format.string(from: defaultDate)
                }
            default:
                detailText = ""
            }
            detailLabel?.text = detailText
            
            selectedClosure?(cellType, value, eligible)
        }
    }
    
    //回调
    var clickClosure: ((_ type: RecordSubType)->())?
    var selectedClosure: ((_ type: RecordSubType, _ value: Any?, _ eligible: Bool)->())?    //当数据为非法eligible == false
    
    //显示cell类型
    private lazy var titleLabel: UILabel? = {
        let labelFrame = CGRect(x: 4, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .left
        label.textColor = subWordColor
        label.font = fontMiddle
        self.addSubview(label)
        return label
    }()
    
    //显示下拉按钮
    fileprivate lazy var arrowButton: UIButton? = {
        let buttonFrame = CGRect(x: self.frame.width - self.frame.height, y: 0, width: self.frame.height, height: self.frame.height)
        let button: UIButton = UIButton(frame: buttonFrame)
        let img = UIImage(named: "resource/record/arrow")?.transfromImage(size: CGSize(width: self.frame.height / 3, height: self.frame.height / 3))
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(self.click(sender:)), for: .touchUpInside)
        return button
    }()
    
    //显示内容
    private lazy var detailLabel: UILabel? = {
        let labelFrame = CGRect(x: self.frame.width - self.frame.size.width / 2 - self.arrowButton!.frame.width, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .right
        label.textColor = subWordColor
        label.font = fontMiddle
        label.text = "its detail label"
        return label
    }()
    
    //MARK:- 内容视图
    private var contentView: UIView?
    
    //MARK:- 选择器
    private var recordSelector: RecordSelector?
    
    //MARK:- 展开或收起
    var isOpen = false{
        didSet{
            //移除之前动画
            if isOpen {
                
                //按钮旋转
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = 0
                animation.toValue = Double.pi
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                arrowButton?.layer.add(animation, forKey: nil)
                
                //展开内容
                showContent(true)
                
            }else{
                
                //按钮旋转
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = Double.pi
                animation.toValue = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                arrowButton?.layer.add(animation, forKey: nil)
                
                //关闭内容
                showContent(false)
            }
        }
    }
    
    
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
        
        backgroundColor = .white
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
            titleText = "体内脂肪%"
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
        
        value = nil
    }
    
    private func createContents(){
        
        //手动添加分割线
        let separatorFrame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        let separatorLine = UIView(frame: separatorFrame)
        separatorLine.backgroundColor = separatorColor
        addSubview(separatorLine)
        
        //添加箭头
        addSubview(arrowButton!)
        addSubview(detailLabel!)
    }
    
    //MARK:- 点击按钮响应
    @objc fileprivate func click(sender: UIButton){
        
        clickClosure?(cellType)
    }
    
    //MARK:- 是否展开内容视图
    private var contentHeight: CGFloat = 0
    private func showContent(_ flag: Bool){
        if flag{
            
            guard let parent = superview else {
                return
            }
            let otherCellCount = parent.subviews.count - 2
            guard otherCellCount > 0 else {
                return
            }
            contentHeight = parent.frame.height - CGFloat(otherCellCount) * frame.height
            
            let contentFrame = CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight)
            contentView = UIView(frame: contentFrame)
            contentView?.backgroundColor = .white
            contentView?.isUserInteractionEnabled = true
            contentView?.alpha = 0
            addSubview(contentView!)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView?.alpha = 1
            }, completion: nil)
            
            //显示选择器
            if let selector = recordSelector {
                selector.removeFromSuperview()
            }
            recordSelector = RecordSelector(type: cellType, frame: contentView!.bounds)
            recordSelector?.alpha = 0
            contentView?.addSubview(recordSelector!)
            recordSelector?.closure = {
                selType, selValue in
                self.value = selValue
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                self.recordSelector?.alpha = 1
            }, completion: {
                complete in
            })
        }else{
            
            contentHeight = 0
           
            self.recordSelector?.alpha = 0
            self.recordSelector?.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView?.alpha = 0
                self.contentView?.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
                
            }, completion: {
                complete in
                self.recordSelector?.removeFromSuperview()
                self.recordSelector = nil
                self.contentView?.removeFromSuperview()
                self.contentView = nil
            })
        }
    }
    
    //MARK:- 重写uiview点击范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isOpen{
            if point.x >= 0 && point.x <= frame.width && point.y >= 0 && point.y <= frame.height + contentHeight{
                return true
            }
            return false
        }else{
            if point.x >= 0 && point.x <= frame.width && point.y >= 0 && point.y <= 0 + frame.height{
                return true
            }
            return false
        }
    }
}

//MARK:- 点击事件
extension RecordTabelViewCell{
    
    //点击结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        click(sender: arrowButton!)
    }
}
