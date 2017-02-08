//
//  ThirdCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/28.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
enum SportType: String{
    case walking = "walking"
    case running = "running"
    case riding = "riding"
    case hiking = "hiking"
    case swimming = "swimming"
    case climbing = "climbing"
    case badminton = "badminton"
    case physical = "physical"
    case bicycle = "bicycle"
    case ellipsoidBall = "ellipsoidBall"
    case treadmill = "treadmill"
    case boating = "boating"
    case situp = "situp"
    case pushup = "pushup"
    case dumbbell = "dumbbell"
    case lifting = "lifting"
    case gymnastics = "gymnastics"
    case yoga = "yoga"
    case skipping = "skipping"
    case pingpong = "pingpong"
    case basketball = "basketball"
    case football = "football"
    case vollyball = "vollyball"
    case tennis = "tennis"
    case golf = "golf"
    case baseball = "baseball"
    case skiing = "skiing"
    case skating = "skating"
    case dancing = "dancing"
    case other = "other"
    case sleep = "sleep"
    case weight = "weight"
    case calorie = "calorie"
}

private let nameMap: [SportType: String] = [
    .walking: "走路",
    .running: "跑步",
    .riding: "骑行",
    .hiking: "徒步",
    .swimming: "游泳",
    .climbing: "爬山",
    .badminton: "羽毛球",
    .physical: "健身",
    .bicycle: "动感单车",
    .ellipsoidBall: "椭圆球",
    .treadmill: "跑步机",
    .boating: "划船机",
    .situp: "仰卧起坐",
    .pushup: "俯卧撑",
    .dumbbell: "哑铃",
    .lifting: "举重",
    .gymnastics: "健身操",
    .yoga: "瑜伽",
    .skipping: "跳绳",
    .pingpong: "乒乓球",
    .basketball: "篮球",
    .football: "足球",
    .vollyball: "排球",
    .tennis: "网球",
    .golf: "高尔夫",
    .baseball: "棒球",
    .skiing: "滑雪",
    .skating: "轮滑",
    .dancing: "舞蹈",
    .other: "其他",
    .sleep: "睡眠",
    .weight: "体重",
    .calorie: "卡路里"
]

//数据结构
struct StoryData {
    var type:SportType = SportType.running
    var date: Date = Date()
    var calorie: CGFloat = 0
    var heartRate: CGFloat = 0
    var hour: Int16 = 0
    var minute: Int16 = 0
    var fat: CGFloat = 0
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
    
    
    private var type: SportType = .other        //类型
    
    //值
    var value:StoryData?{
        didSet{
            guard let val = value else {
                return
            }
            
            self.type = val.type
            createContents()
            
            let type = val.type
            let imageName = type.rawValue
            
            //添加背景图片
            let imageSize = CGSize(width: gradient.frame.width, height: gradient.frame.height)
            let image = UIImage(named: "resource/sporticons/background/\(imageName)")?.transfromImage(size: imageSize)
            let iconSize = CGSize(width: gradient.frame.height / 3, height: gradient.frame.height / 3)
            let icon = UIImage(named: "resource/sporticons/icon/\(imageName)")?.transfromImage(size: iconSize)
            
            //添加底图
            let imageView = UIImageView(frame: CGRect(x: 0,
                                                      y: gradient.frame.origin.y,
                                                      width: imageSize.width,
                                                      height: imageSize.height))
            imageView.image = image
            imageView.alpha = 0.3
            addSubview(imageView)
            
            //添加icon
            let iconView = UIImageView(frame: CGRect(x: view_size.width * 0.05,
                                                     y: view_size.width * 0.05,
                                                     width: iconSize.width,
                                                     height: iconSize.height))
            iconView.layer.contents = icon?.cgImage
            addSubview(iconView)
            
            //显示值
            switch val.type {
            case .walking:
                label.text = "走路\(val.hour)小时\(val.minute)分钟"
            case .running:
                label.text = "跑步\(val.hour)小时\(val.minute)分钟"
            case .riding:
                label.text = "骑行\(val.hour)小时\(val.minute)分钟"
            case .hiking:
                label.text = "徒步\(val.hour)小时\(val.minute)分钟"
            case .swimming:
                label.text = "游泳\(val.hour)小时\(val.minute)分钟"
            case .sleep:
                label.text = "睡眠\(val.hour)小时\(val.minute)分钟"
            case .calorie:
                label.text = "消耗\(val.calorie)卡路里"
            case .weight:
                label.text = "体重\(val.fat)公斤"
            case .basketball:
                label.text = "打篮球\(val.hour)小时\(val.minute)分钟"
            case .badminton:
                label.text = "打羽毛球\(val.hour)小时\(val.minute)分钟"
            case .climbing:
                label.text = "登山\(val.hour)小时\(val.minute)分钟"
            default:
                label.text = ""
            }
            
            //显示时间
            let calender = Calendar.current
            let components = calender.dateComponents([.hour, .minute], from: val.date)
            deltaTimeLabel.text = "\(components.hour!):\(components.minute!)"
        }
    }
    
    //文字
    private lazy var label: UILabel = {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: self.gradient.frame.height / 3 + view_size.width * 0.1,
                             y: view_size.width * 0.05,
                             width: self.gradient.frame.width,
                             height: self.gradient.frame.height / 3)
        label.textColor = .white
        label.font = fontMiddle
        label.textAlignment = .left
        return label
    }()
    private lazy var deltaTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0,
                             y: self.gradient.frame.height,
                             width: self.gradient.frame.width,
                             height: self.gradient.frame.height / 3)
        label.textColor = subWordColor
        label.font = fontSmall
        label.textAlignment = .right
        return label
    }()
    
    //底图渐变
    let gradient = CAGradientLayer()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        var startColor: CGColor?
        var endColor: CGColor?
        
        //绘制渐变
        gradient.frame = CGRect(x: view_size.width * 0.03,
                                y: view_size.width * 0.03,
                                width: view_size.width * 0.94,
                                height: view_size.width * 0.94 * 200 / 718)
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        switch type {
        case .weight:
            startColor = modelStartColors[.weight]?.cgColor
            endColor = modelEndColors[.weight]?.cgColor
        case .calorie:
            startColor = UIColor(red: 238 / 255, green: 183 / 255, blue: 15 / 255, alpha: 1).cgColor
            endColor = UIColor(red: 236 / 255, green: 156 / 255, blue: 0 / 255, alpha: 1).cgColor
        case .sleep:
            startColor = modelStartColors[.sleep]?.cgColor
            endColor = modelEndColors[.sleep]?.cgColor
        case .badminton, .skipping:
            startColor = UIColor(red: 255 / 255, green: 138 / 255, blue: 0 / 255, alpha: 1).cgColor
            endColor = UIColor(red: 255 / 255, green: 123 / 255, blue: 5 / 255, alpha: 1).cgColor
        default:
            startColor = modelStartColors[.sport]?.cgColor
            endColor = modelEndColors[.sport]?.cgColor
        }
        gradient.colors = [startColor ?? UIColor.lightGray.cgColor, endColor ?? UIColor.gray.cgColor]
        gradient.cornerRadius =  view_size.width * 0.02
        gradient.shadowColor = UIColor.black.cgColor
        layer.addSublayer(gradient)
        
        //添加标签
        addSubview(label)
        addSubview(deltaTimeLabel)
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
        ctx?.move(to: CGPoint(x: frame.width * 0.08, y: 0))
        ctx?.addLine(to: CGPoint(x: frame.width * 0.08, y: frame.height))
        
        //设置
        ctx?.setLineWidth(1)
        ctx?.setLineCap(CGLineCap.round)
        ctx?.setLineJoin(CGLineJoin.round)
        ctx?.setStrokeColor(lightWordColor.cgColor)
        
        ctx?.drawPath(using: .stroke)
    }
}
