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
        label.font = fontMiddle
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
        let buttonWidth = self.bounds.size.height * 1.5
        let buttonHeight = self.bounds.size.height
        let imageLength = self.bounds.size.height * 0.6
        let buttonOrigin = CGPoint(x: 0, y: self.bounds.height / 2 - buttonHeight / 2)
        let buttonFrame = CGRect(origin: buttonOrigin, size: CGSize(width: buttonWidth, height: buttonHeight))
        let button: UIButton = UIButton(frame: buttonFrame)
        button.tag = 0
        button.setImage(UIImage(named: "resource/button_left")?.transfromImage(size: CGSize(width: imageLength / 2, height: imageLength / 2)), for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }()
    
    //右按钮
    private lazy var rightButton: UIButton = { ()->UIButton in
        let buttonWidth = self.bounds.size.height * 1.5
        let buttonHeight = self.bounds.size.height
        let imageLength = self.bounds.size.height * 0.6
        let buttonOrigin = CGPoint(x: view_size.width - buttonWidth, y: self.contentView.bounds.height / 2 - buttonHeight / 2)
        let buttonFrame = CGRect(origin: buttonOrigin, size: CGSize(width: buttonWidth, height: buttonHeight))
        let button = UIButton(frame: buttonFrame)
        button.tag = 1
        button.setImage(UIImage(named: "resource/button_right")?.transfromImage(size: CGSize(width: imageLength / 2, height: imageLength / 2)), for: .normal)
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
        label.isUserInteractionEnabled = true
        contentView.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        label.addGestureRecognizer(tap)
        
        //添加无点击回调的按钮，用于接收当rightButton不可点时穿过的点击事件
        let noneButton = UIButton(frame: rightButton.frame)
        noneButton.backgroundColor = nil
        contentView.addSubview(noneButton)
        
        //左右按钮
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
    }
    
    //MARK:- 点击事件
    @objc private func click(){
        notiy.post(name: calendar_notiy, object: nil)
    }
    
    //MARK:- 更新显示当前日期
    fileprivate func updateDateInLabel(date: Date){
        
        //点击日期事件回调
        let formatter = DateFormatter()
        formatter.dateFormat = " dd MM月" //"yyy-MM-dd"
        let dateStr = formatter.string(from: date)
        let todayStr = formatter.string(from: Date())
        
        //星期数量
//        let calendar = Calendar.current
//        let weekday = calendar.component(.weekday, from: date)
//        let weekList = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        
        //显示
        var text: String
        if dateStr == todayStr{
            text = " Today," + dateStr
            
        }else{
            text = dateStr
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        let attributeDict = [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: wordColor]
        attributedString.addAttributes(attributeDict, range: NSMakeRange(0, attributedString.length))
        
        let imageAttach = NSTextAttachment()
        imageAttach.image = UIImage(named: "resource/icon_calendar")?.transfromImage(size: CGSize(width: 17, height: 17))
        
        let attributeImage = NSAttributedString(attachment: imageAttach)
        
        attributedString.insert(attributeImage, at: 0)
        self.label.attributedText = attributedString
        
        //判断是否为最后可选日期（>今天）
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        var curComponents = calendar.dateComponents([.year, .month, .day], from: date)
        curComponents.year = todayComponents.year
        curComponents.month = todayComponents.month
        curComponents.day = todayComponents.day
        if let today = calendar.date(from: curComponents){
            let comparisonResult = date.compare(today)
            rightButton.isEnabled = comparisonResult == ComparisonResult.orderedAscending
        }
    }
    
    @objc private func clickButton(sender: UIButton){
        
        //发送切换日期消息
        notiy.post(name: switch_notiy, object: sender.tag, userInfo: nil)
    }
}
