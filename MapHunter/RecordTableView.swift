//
//  RecordTableView.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
let recordAttributeMap: [RecordType: [RecordSubType]] = [
    .sport: [.sportActivityType, .sportLevel, .sportStartDate, .sportDuration],
    .sleep: [.sleepDate, .wakeDate],
    .weight: [.weightValue, .weightFat, .weightDate],
    .mood: [],
    .bloodPressure: [.diastolicPressure, .systolicPressure, .pressureDate],
    .heartrate: [.heartrateActivityType, .heartrateValue, .heartrateDate]
]

class RecordTableView: UIView {
    
    let openOriginY: CGFloat = 64 + 8                   //展开Y轴位置
    let closeOriginY = view_size.height * 0.5           //收起Y轴位置
    
    //MARK:- 类型
    private var type: RecordType!
    
    //MARK:- 存储需显示的数据名称列表
    private var attributeList: [RecordSubType]?
    private var subCells = [RecordTabelViewCell]()
    
    //MARK:- footer
    private var header: RecordHeader?
    private var footer: RecordFooter?
    
    //是否展开
    var openClosure: ((_ type: RecordType, _ isOpen: Bool)->())?
    var isOpen = false {
        didSet{
            openClosure?(type, isOpen)
            //动画
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                //self移动到顶部
                self.frame.origin.y = self.isOpen ? self.openOriginY : self.closeOriginY
                
                //隐藏头部
                self.header?.alpha = self.isOpen ? 0 : 1
                
                //重新排列cell位置
                var signIndex: Int?
                self.subCells.enumerated().forEach{
                    index, cell in
                    
                    if signIndex == nil{
                        
                        //判断是否有已点击的cell，标记之后，以下cell从底部开始排列
                        if let selType = self.selectedSubType{
                            if selType == cell.cellType{
                                signIndex = index
                                cell.isOpen = true
                            }else{
                                cell.isOpen = false
                            }
                        }else{
                            cell.isOpen = false
                        }
                        
                        //正序
                        cell.frame.origin.y = cell.frame.height * CGFloat(index)
                    }else{
                        //反序
                        cell.isOpen = false
                        cell.frame.origin.y = self.frame.height - cell.frame.height * CGFloat(self.subCells.count - index)
                    }
                }
                
                //footer移动到底部
                let lastCell = self.subCells.last!
                self.footer?.frame.origin.y = lastCell.frame.origin.y + lastCell.frame.height - 1
                
            }, completion: {
                complete in
                
                
            })
        }
    }
    
    //存储当前选择的subType
    private var selectedSubType: RecordSubType?
    
    //需存储的数据
    static var sportType: SportType?
    static var sportLevel: Int?
    static var sleepDate: Date?
    static var wakeDate: Date?
    
    //MARK:- init ************************************************************************************
    init(withRecordType type: RecordType) {
        
        let frame = CGRect(x: 8, y: closeOriginY, width: view_size.width - 8 * 2, height: view_size.height - openOriginY - 16)
        super.init(frame: frame)
        
        //存储类型
        self.type = type
        
        config()
        createContents()
    }
    
    override func didMoveToSuperview() {
        isOpen = false
    }
    
    deinit {
        cancel(task)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
        isUserInteractionEnabled = true        
    }
    
    private var task: Task?     //记录展开的定时器
    private func createContents(){
        
        guard let t = type else {
            return
        }
        
        //添加属性
        guard let attributeList = recordAttributeMap[t] else{
            return
        }
        
        //添加cell
        attributeList.enumerated().forEach{
            index, attribute in
            
            let recordTableViewCell = RecordTabelViewCell(withRecordTableCellType: attribute)
            recordTableViewCell.frame.origin.y = recordTableViewCell.frame.height * CGFloat(index)
            subCells.append(recordTableViewCell)
            addSubview(recordTableViewCell)
            
            //设置点击回调
            recordTableViewCell.clickClosure = {
                recordSubType in
                
                if let selSubType = self.selectedSubType{   //当前已展开
                    
                    self.selectedSubType = nil
                    
                    if selSubType == recordSubType{
                        self.isOpen = false
                    }else{
                        self.isOpen = false
                        
                        //再次展开
                        cancel(self.task)
                        self.task = delay(0.3){
                            self.selectedSubType = recordSubType
                            self.isOpen = true
                        }
                    }
                }else{                                      //当前未展开
                    self.selectedSubType = recordSubType
                    self.isOpen = true
                }
            }
            
            //设置选择回调
            recordTableViewCell.selectedClosure = {
                cellType, value, eligible in                
             
                switch cellType as RecordSubType{
                case .sportActivityType:
                    if let sportType = value as? SportType{
                        RecordTableView.sportType = sportType
                    }
                case .sportLevel:
                    if let level = value as? Int{
                        RecordTableView.sportLevel = level
                    }
                case .sportStartDate:
                    if let date = value as? Date{
                        self.header?.leftDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.leftDate = defaultDate
                    }
                case .sportDuration:
                    if let duration = value as? TimeInterval, let header = self.header{
                        self.header?.rightDate = Date(timeInterval: duration, since: header.leftDate)
                    }
                case .sleepDate:
                    if let date = value as? Date{
                        self.header?.leftDate = date
                        RecordTableView.sleepDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.leftDate = defaultDate
                        RecordTableView.sleepDate = defaultDate
                    }
                case .wakeDate:
                    if let date = value as? Date{
                        self.header?.rightDate = date
                        RecordTableView.wakeDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.rightDate = defaultDate
                        RecordTableView.wakeDate = defaultDate
                    }
                case .weightValue:
                    if let weight = value as? CGFloat{
                    }
                case .weightFat:
                    if let fat = value as? CGFloat{
                    }
                case .weightDate:
                    if let date = value as? Date{
                        self.header?.leftDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.leftDate = defaultDate
                    }
                case .diastolicPressure:
                    if let pressure = value as? Int{
                    }
                case .systolicPressure:
                    if let pressure = value as? Int{
                    }
                case .pressureDate:
                    if let date = value as? Date{
                    }
                case .heartrateActivityType:
                    if let sportType = value as? Int16{
                    }
                case .heartrateValue:
                    if let heartrate = value as? Int{
                    }
                case .heartrateDate:
                    if let date = value as? Date{
                        self.header?.leftDate = date
                    }else{
                        let defaultDate = Date(timeInterval: -30 * 60, since: Date())
                        self.header?.leftDate = defaultDate
                    }
                default:
                    break
                }
            }
        }
        
        
        //添加头部
        header = RecordHeader(type: type!)
        addSubview(header!)
        
        //添加尾部
        footer = RecordFooter(originY: CGFloat(attributeList.count) * 44 - 1)
        addSubview(footer!)
    }
}

