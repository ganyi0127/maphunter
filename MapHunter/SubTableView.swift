//
//  SubTableView.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/20.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
class SubTableView: UITableView {
    
    
    var startDate = Date()      //开始日期
    fileprivate var dataList = [(date: Date, value: Any)](){
        didSet{
            reloadData()
        }
    }
    
    
    //MARK:-init********************************************************************************************************
    init(withType: DataCubeType) {
        let frame = CGRect(x: edgeWidth, y: detailTopHeight, width: view_size.width - edgeWidth * 2, height: view_size.height - detailTopHeight - edgeWidth)
        super.init(frame: frame, style: .grouped)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        layer.cornerRadius = detailRadius
        
        register(SubTableViewCell.self, forCellReuseIdentifier: "cell")
        delegate = self
        dataSource = self
    }
    
    private func createContents(){
        
    }
    
    //MARK:-加载新数据
    func loadNewData(){
        var newDateList = [Date]()
        for i in 0..<7 {
            let date = startDate.offset(with: i + 1 + dataList.count)
            newDateList.append(date)
        }
        
        //根据日期从数据库加载数据...
        
        for date in newDateList{
            let tuple = (date: date, value: "text" as Any)
            dataList.append(tuple)
        }
    }
}

extension SubTableView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count / 7 + (dataList.count % 7 == 0 ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let identifier = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = SubTableViewCell(with: identifier)
        }
        
        let subTableViewCell = cell as! SubTableViewCell
        let data = dataList[section * 7 + row]
        let date = data.date
        let value = data.value
        
        
        
        subTableViewCell.textLabel?.text = date.weekdayString()
        subTableViewCell.detailTextLabel?.text = "\(value)"
        return subTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
