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
    
    var type: DataCubeType!
    var startDate = Date()      //开始日期
    fileprivate var dataList = [(date: Date, value: Any)](){
        didSet{
            reloadData()
        }
    }
    
    
    //MARK:-init********************************************************************************************************
    init(withType type: DataCubeType) {
        let frame = CGRect(x: edgeWidth, y: detailTopHeight + navigation_height! + 20,
                           width: view_size.width - edgeWidth * 2,
                           height: view_size.height - (detailTopHeight + navigation_height! + 20) - edgeWidth)
        super.init(frame: frame, style: .plain)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        //layer.cornerRadius = detailRadius
        
        register(SubTableViewCell.self, forCellReuseIdentifier: "cell")
        backgroundColor = timeColor
       
        delegate = self
        dataSource = self
    }
    
    private func createContents(){
        for _ in 0..<2{
            loadNewData()
        }
    }
    
    //MARK:-加载新数据
    func loadNewData(){
        var newDateList = [Date]()
        for i in 0..<7 {
            let date = startDate.offset(with: -i + dataList.count)
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.contentView.backgroundColor = modelEndColors[type]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let format = "yyy-M-d"
        let startStr = startDate.formatString(with: format)
        let endStr = startDate.offset(with: 7).formatString(with: format)
        return startStr + " ~ " + endStr
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let identifier = "\(section)_\(row)"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = SubTableViewCell(with: identifier)
        }
        cell?.accessoryType = .disclosureIndicator
        
        let subTableViewCell = cell as! SubTableViewCell
        let data = dataList[section * 7 + row]
        let date = data.date
        let value = data.value
        
        
        subTableViewCell.date = date
        subTableViewCell.textLabel?.text = date.weekdayString()
        subTableViewCell.detailTextLabel?.text = "\(value)"
        return subTableViewCell
    }    
    
    //上拉下拉
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var newY = scrollView.contentOffset.y
        
        //禁止下拉
        if newY < 0{
            newY = 0
            scrollView.setContentOffset(CGPoint(x: 0, y: newY), animated: false)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath) as! SubTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        let date = cell.date

        //进入详情页面
        let detailVC = DetailVC(detailType: type, date: date, isDetail: false)
        viewController()?.navigationController?.show(detailVC, sender: nil)
    }
}
