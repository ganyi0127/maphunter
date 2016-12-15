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
struct StoryData {
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
    
    var value:StoryData?{
        didSet{
            
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
        
        let startColor = UIColor(red: 255 / 255, green: 156 / 255, blue: 0, alpha: 1)
        let endColor = UIColor(red: 255 / 255, green: 140 / 255, blue: 5 / 255, alpha: 1)
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: view_size.width * 0.03,
                                y: view_size.width * 0.03,
                                width: view_size.width * 0.94,
                                height: view_size.width * 0.94 * 200 / 718)
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.cornerRadius =  view_size.width * 0.02
        gradient.shadowColor = UIColor.black.cgColor
        layer.addSublayer(gradient)
        
        //添加美术图片
        let iconSize = CGSize(width: gradient.frame.height / 3, height: gradient.frame.height / 3)
        let icon = UIImage(named: "resource/icon_walk")?.transfromImage(size: iconSize)
        let imageSize = CGSize(width: gradient.frame.height, height: gradient.frame.height)
        let image = UIImage(named: "resource/walk")?.transfromImage(size: imageSize)
        
        let iconView = UIImageView(frame: CGRect(x: view_size.width * 0.05,
                                                 y: view_size.width * 0.05,
                                                 width: iconSize.width,
                                                 height: iconSize.height))
        iconView.image = icon
        addSubview(iconView)
        
        let imageView = UIImageView(frame: CGRect(x: view_size.width - imageSize.width * 1.5,
                                                  y: view_size.width * 0.03,
                                                  width: imageSize.width,
                                                  height: imageSize.height))
        imageView.image = image
        addSubview(imageView)
    }
}

extension ThirdCell{
    override func draw(_ rect: CGRect) {
        
        let ctx:CGContext? = UIGraphicsGetCurrentContext()
        
        ctx?.clear(rect)
        //填充背景
        let backColor = timeColor.cgColor
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
