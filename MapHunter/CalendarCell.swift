//
//  CalendarCell.swift
//  MapHunter
//
//  Created by YiGan on 12/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class CalendarCell: UITableViewCell {
    
    //日期显示
    private let label:UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = "..."
        label.textColor = wordColor
        label.font = UIFont(name: font_name, size: 17)
        label.textAlignment = .center
        return label
    }()
    
    //设置日期
    var date: Date!{
        didSet{
            updateDateInLabel(date: date)
        }
    }

    //左按钮
    private lazy var leftButton: UIButton = { ()->UIButton in
        let buttonWidth = self.bounds.size.height * 0.6
        let buttonOrigin = CGPoint(x: buttonWidth * 0.8, y: self.bounds.height / 2 - buttonWidth / 2)
        let buttonFrame = CGRect(origin: buttonOrigin, size: CGSize(width: buttonWidth, height: buttonWidth))
        let button = UIButton(frame: buttonFrame)
        button.tag = 0
        button.setImage(UIImage(named: "resource/button_left")?.transfromImage(size: CGSize(width: buttonWidth / 2, height: buttonWidth / 2)), for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }()
    
    //右按钮
    private lazy var rightButton: UIButton = { ()->UIButton in
        let buttonWidth = self.contentView.bounds.size.height * 0.6
        let buttonOrigin = CGPoint(x: view_size.width - buttonWidth * 1.8, y: self.contentView.bounds.height / 2 - buttonWidth / 2)
        let buttonFrame = CGRect(origin: buttonOrigin, size: CGSize(width: buttonWidth, height: buttonWidth))
        let button = UIButton(frame: buttonFrame)
        button.tag = 1
        button.setImage(UIImage(named: "resource/button_right")?.transfromImage(size: CGSize(width: buttonWidth / 2, height: buttonWidth / 2)), for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }()
    
    //MARK:- init
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        let selfSize = bounds.size
        
        //日期显示按钮
        let labelFrame = CGRect(x: 0, y: selfSize.height / 2 - selfSize.height / 4, width: view_size.width, height: selfSize.height / 2)
        label.frame = labelFrame
        contentView.addSubview(label)
        
        //左右按钮
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        
    }
    
    //MARK:- 更新显示当前日期
    fileprivate func updateDateInLabel(date: Date){
        
        //点击日期事件回调
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        let dateStr = formatter.string(from: date)
        let todayStr = formatter.string(from: Date())
        
        //星期数量
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekList = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        //显示今天
        if dateStr == todayStr{
            self.label.text = "今天 " + weekList[weekday - 1]
        }else{
            self.label.text = dateStr + " " + weekList[weekday - 1]
        }
    }
    
    @objc private func clickButton(sender: UIButton){
        
        //发送切换日期消息
        notiy.post(name: switch_notiy, object: sender.tag, userInfo: nil)
    }
}
