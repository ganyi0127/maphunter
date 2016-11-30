//
//  SecondCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
//交互数据
struct CellData{
    var value1:CGFloat = 0
    var value2:CGFloat = 0
    var value3:CGFloat = 0
    var value4:CGFloat = 0
    var value5:CGFloat = 0
    var value6 = [CGFloat]()
}
class SecondCell: UITableViewCell {
    
    private var cellRow:Int!
    
    
    private var subCellType1:SubCellType?{
        didSet{
            subCell1 = SubCell(subCellType1!)
            subCell1?.frame.origin = CGPoint.zero
            addSubview(subCell1!)
        }
    }
    private var subCellType2:SubCellType?{
        didSet{
            subCell2 = SubCell(subCellType2!)
            subCell2?.frame.origin = CGPoint(x: view_size.width / 2, y: 0)
            addSubview(subCell2!)
        }
    }
    
    //-------------------------------------
    
    private var subCell1:SubCell?
    private var subCell2:SubCell?
    
    //数据接口
    var cellData1:CellData?{
        didSet{
            guard let date = cellData1 else {
                return
            }
            subCell1?.value1 = date.value1
            subCell1?.value2 = date.value2
            subCell1?.value3 = date.value3
            subCell1?.value4 = date.value4
            subCell1?.value5 = date.value5
            subCell1?.value6 = date.value6
        }
    }
    var cellData2:CellData?{
        didSet{
            guard let date = cellData2 else {
                return
            }
            subCell2?.value1 = date.value1
            subCell2?.value2 = date.value2
            subCell2?.value3 = date.value3
            subCell2?.value4 = date.value4
            subCell2?.value5 = date.value5
            subCell2?.value6 = date.value6
        }
    }
    
    //MARK:- init
    init(_ row: Int, reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        //row: 1, 2, 3
        cellRow = row
        config()
        createContents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        
    }
    
    private func config(){
        
    }
    
    private func createContents(){
       
        switch cellRow {
        case 1:
            subCellType1 = SubCellType.cell1
            subCellType2 = SubCellType.cell2
        case 2:
            subCellType1 = SubCellType.cell3
            subCellType2 = SubCellType.cell4
        default:
            subCellType1 = SubCellType.cell5
            subCellType2 = SubCellType.cell6
        }
    }
}
