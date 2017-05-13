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
    
    fileprivate let openOriginY: CGFloat = 64 + 8                   //展开Y轴位置
    fileprivate let closeOriginY = view_size.height * 0.4           //收起Y轴位置
    
    //MARK:- 类型
    private var type: RecordType?
    
    //MARK:- 存储需显示的数据名称列表
    private var attributeList: [RecordSubType]?
    private var subCells = [RecordTabelViewCell]()
    
    //是否展开
    var isOpen = false {
        didSet{
            
            //动画
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                //移动到顶部
                self.frame.origin.y = self.isOpen ? self.openOriginY : self.closeOriginY
                

                var signIndex: Int?
                self.subCells.enumerated().forEach{
                    index, cell in
                    
                    if signIndex == nil{
                        
                        //判断是否有已点击的cell，标记之后，以下cell从底部开始排列
                        if let selType = self.selectedSubType{
                            if selType == cell.cellType{
                                signIndex = index
                            }
                        }
                        
                        //正序
                        cell.frame.origin.y = cell.frame.height * CGFloat(index)
                    }else{
                        //反序
                        cell.frame.origin.y = self.frame.height - cell.frame.height * CGFloat(self.subCells.count - index)
                    }
                }
            }, completion: {
                complete in
                
                
            })
        }
    }
    
    //存储当前选择的subType
    private var selectedSubType: RecordSubType?
    
    //MARK:- init ************************************************************************************
    init(withRecordType type: RecordType) {
        
        let frame = CGRect(x: 8, y: closeOriginY, width: view_size.width - 8 * 2, height: view_size.height - openOriginY - 8)
        super.init(frame: frame)
        
        //存储类型
        self.type = type
        
        config()
        createContents()
    }
    
    deinit {
        cancel(task)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
    }
    
    private var task: Task?     //记录展开的定时器
    private func createContents(){
        
        guard let t = type else {
            return
        }
        if let attributeList = recordAttributeMap[t] {
            attributeList.enumerated().forEach{
                index, attribute in
                
                let recordTableViewCell = RecordTabelViewCell(withRecordTableCellType: attribute)
                recordTableViewCell.frame.origin.y = recordTableViewCell.frame.height * CGFloat(index)
                subCells.append(recordTableViewCell)
                addSubview(recordTableViewCell)
                
                //设置回调
                recordTableViewCell.closure = {
                    recordSubType, b in
                    
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
            }
        }
    }
}

