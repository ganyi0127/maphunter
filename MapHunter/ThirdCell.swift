//
//  ThirdCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/28.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
enum SportType:String{
    case run = "跑步"
}
struct StroyData {
    var type:SportType = SportType.run
    var date:(time: CGFloat, week: Int) = (0, 0)
    var calorie:CGFloat = 0
    var heartRate:CGFloat = 0
    var sportTime:CGFloat = 0
    var fat:CGFloat = 0
}
let weekStrList = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
class ThirdCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var sportTimeLabel:UILabel!
    @IBOutlet weak var calorieLabel:UILabel!
    @IBOutlet weak var heartRateLabel:UILabel!
    @IBOutlet weak var fatLabel:UILabel!
    
    var value:StroyData?{
        didSet{
            guard  let data = value else {
                return
            }

            //类型
            typeLabel.text = data.type.rawValue
            
            //时间 星期
            let time = data.date.time
            let hour = time / 60
            let min = time % 60
            let hourStr = hour > 10 ? "\(hour)" : "0\(hour)"
            let minStr = min > 10 ? "\(min)" : "0\(min)"
            let week = weekStrList[data.date.week]
            timeLabel.text = week
            
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
}

extension ThirdCell{
    override func draw(_ rect: CGRect) {
        
        let ctx:CGContext? = UIGraphicsGetCurrentContext()
        
        ctx?.clear(rect)
        //填充背景
        let backColor = UIColor.white.cgColor
        ctx?.setFillColor(backColor)
        ctx?.fill(rect)
        
        //绘制虚线
        ctx?.move(to: CGPoint(x: 20, y: 0))
        ctx?.addLine(to: CGPoint(x: 20, y: frame.size.height))
        
        //设置
        ctx?.setLineWidth(2)
        ctx?.setLineCap(CGLineCap.round)
        ctx?.setLineJoin(CGLineJoin.round)
        ctx?.setLineDash(phase: 0, lengths: [4,4])
        ctx?.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.5).cgColor)
        
        ctx?.drawPath(using: .stroke)
    }
}
