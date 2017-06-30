//
//  FinishedCV.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/30.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class FinishedVC: UIViewController {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caloriaLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var heartrateLabel: UILabel!
    
    //持续时间
    var duration: Int16? {
        didSet{
            let value = duration ?? 0
            
            let hour = value / (60 * 60)
            let minute = value % (60 * 60) / 60
            let hourStr = hour > 0 ? "\(hour)" : ""
            let minuteStr = "\(minute)"
            let hourUnit = hour > 0 ? "小时" : ""
            let minuteUnit = "分钟"
            
            let text = hourStr + hourUnit + minuteStr + minuteUnit
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontHuge, NSForegroundColorAttributeName: wordColor])
            attributedString.addAttributes([NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(hourStr.characters.count, hourUnit.characters.count))
            attributedString.addAttributes([NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(text.characters.count - minuteUnit.characters.count, minuteUnit.characters.count))
            durationLabel.attributedText = attributedString
        }
    }
    
    //距离
    var distance: Double? {
        didSet{
            let value = distance ?? 0
            
            let unit = "km   "
            let text = String(format: "%.2f", value / 1000) + unit
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontBig, NSForegroundColorAttributeName: wordColor])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(text.characters.count - unit.characters.count, unit.characters.count))
            
            //添加图片混排
            let length = fontBig.pointSize
            let imageSize = CGSize(width: length, height: length)
            let imageBounds = CGRect(x: 0, y: (length - caloriaLabel.frame.height) / 2, width: length, height: length)
            let startAttach = NSTextAttachment()
            startAttach.image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: imageSize)
            startAttach.bounds = imageBounds
            let startAttributed = NSAttributedString(attachment: startAttach)
            attributedString.insert(startAttributed, at: 0)
        
            distanceLabel.attributedText = attributedString
        }
    }
    
    //卡路里
    var caloria: Int16? {
        didSet{
            let value = caloria ?? 0
            
            let unit = "kcal"
            let text = "   \(value)" + unit
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontBig, NSForegroundColorAttributeName: wordColor])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(text.characters.count - unit.characters.count, unit.characters.count))
            
            //添加图片混排
            let length = fontBig.pointSize
            let imageSize = CGSize(width: length, height: length)
            let imageBounds = CGRect(x: 0, y: (length - caloriaLabel.frame.height) / 2, width: length, height: length)
            let startAttach = NSTextAttachment()
            startAttach.image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: imageSize)
            startAttach.bounds = imageBounds
            let startAttributed = NSAttributedString(attachment: startAttach)
            attributedString.insert(startAttributed, at: 3)
            
            caloriaLabel.attributedText = attributedString
        }
    }
    
    //次数
    var count: Int16? {
        didSet{
            let value = count ?? 0
            
            let unit = "活动次数"
            let text = "\(value)\n" + unit
            countLabel.text = text
        }
    }
    
    //配速
    var pace: Double? {
        didSet{
            let value = Int(pace ??  0)
            
            let unit = "平均配速"
            
            let minute = value / 60
            let second = value % 60
            let minuteStr = "\(minute)\'"
            let secondStr = "\(second)\""
            
            let text = minuteStr + secondStr + "\n" + unit
            paceLabel.text = text
        }
    }
    
    //心率
    var heartrate: Int16? {
        didSet{
            let value = heartrate ?? 0
            
            let unit = "心率"
            let text = "\(value)\n" + unit
            heartrateLabel.text = text
        }
    }
}
