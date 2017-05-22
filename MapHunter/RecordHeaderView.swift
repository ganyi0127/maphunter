//
//  RecordHeaderView.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordHeaderView: UIView {
    
    private var type: RecordType!
    
    //MARK:- sport
    private lazy var sportImageView: UIImageView? = {
        let length: CGFloat = min(self.bounds.width, self.bounds.height) * 0.8
        let imageFrame = CGRect(x: (self.bounds.width - length) / 2, y: (self.bounds.height - length) / 2, width: length, height: length)
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = UIImage(named: "resource/sporticons/bigicon/none")?.transfromImage(size: imageFrame.size)
        return imageView
    }()
    var sportType: SportType?{
        didSet{
            guard let t = sportType else {
                return
            }
            
            if let name = sportTypeNameMap[t]{
                let image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: sportImageView!.bounds.size)
                sportImageView?.image = image
            }else{
                sportImageView?.image = nil
            }
        }
    }
    
    //MARK:- sleep
    private lazy var sleepTimeLabel: UILabel? = {
        let labelFrame = CGRect(x: 0, y: self.frame.height * 0.2, width: self.frame.width, height: 20)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    var sleepMinute: Int?{
        didSet{
            guard let totalMinute = sleepMinute else {
                return
            }

            //修改生日文字
            sleepTimeLabel?.textColor = .white
            
            let hour = totalMinute / 60
            let minute = totalMinute - hour * 60
            let hourStr = hour > 0 ? "\(hour)小时" : ""
            var minuteStr = ""
            if minute > 0 {
                if minute > 10{
                    minuteStr = "\(minute)分钟"
                }else{
                    minuteStr = "0\(minute)分钟"
                }
            }
            let text = hourStr + minuteStr
            let attributeString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle])
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))   //minute
            if hourStr != "" {
                attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2 - 4, 2))   //hour
            }
            sleepTimeLabel?.attributedText = attributeString
        }
    }
    
    
    //MARK:- init *********************************************************************************
    init(withRecordType type: RecordType, top: CGFloat, bottom: CGFloat) {
        let frame = CGRect(x: 0, y: top - 8, width: view_size.width, height: bottom - (top - 8) - 22)
        super.init(frame: frame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .clear
    }
    
    private func createContents(){
        switch type as RecordType {
        case .sport:
            addSubview(sportImageView!)
        case .sleep:
            (0..<10).forEach{
                i in
                let subViewFrame = CGRect(x: (frame.width - 20 * 2) / 10 * CGFloat(i) + 20, y: frame.height * 0.7, width: (frame.width - 20 * 2) / 10 - 2, height: frame.height * 0.3)
                let subView = UIView(frame: subViewFrame)
                subView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                addSubview(subView)
            }
        default:
            break
        }
    }
}
