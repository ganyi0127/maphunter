//
//  ThirdCell.swift
//  MapHunter
//
//  Created by ganyi on 16/9/28.
//  Copyright © 2016年 ganyi. All rights reserved.
//
/*
Type:运动类型(0x00:无， 0x01:走路， 0x02:跑步， 0x03:骑行，0x04:徒步， 0x05: 游泳， 0x06:爬山， 0x07:羽毛球， 0x08:其他， 0x09:健身， 0x0A:动感单车， 0x0B:椭圆机， 0x0C:跑步机， 0x0D:仰卧起坐， 0x0E:俯卧撑， 0x0F:哑铃， 0x10:举重， 0x11:健身操， 0x12:瑜伽， 0x13:跳绳， 0x14:乒乓球， 0x15:篮球， 0x16:足球 ， 0x17:排球， 0x18:网球， 0x19:高尔夫球， 0x1A:棒球， 0x1B:滑雪， 0x1C:轮滑，0x1D:跳舞) + (0x1E:划船, 0x1F:睡眠, 0x20:体重, 0x21:血压, 0x22:卡路里, 0x23:测量心率, 0x24:静息心率, 0x25:心情状态)
*/
import UIKit
import AngelFit
enum SportType: Int16{
    case none = 0x00
    case walking
    case running
    case riding
    case hiking
    case swimming
    case climbing
    case badminton
    case other
    case physical
    case bicycle
    case ellipsoidBall
    case treadmill
    case situp
    case pushup
    case dumbbell
    case lifting
    case gymnastics
    case yoga
    case skipping
    case pingpong
    case basketball
    case football
    case vollyball
    case tennis
    case golf
    case baseball
    case skiing
    case skating
    case dancing
    case boating
    
    case sleep
    case weight
    case bloodPressure
    case calorie
    case testHeartrate
    case restingHeartrate
    case emotion
}

let sportTypeNameMap: [SportType: String] = [
    .none: "",
    
    .walking: "walking",
    .running: "running",
    .riding: "riding",
    .hiking: "hiking",
    .swimming: "swimming",
    .climbing: "climbing",
    .badminton: "badminton",
    .physical: "physical",
    .bicycle: "bicycle",
    .ellipsoidBall: "ellipsoidBall",
    .treadmill: "treadmill",
    .boating: "boating",
    .situp: "situp",
    .pushup: "pushup",
    .dumbbell: "dumbbell",
    .lifting: "lifting",
    .gymnastics: "gymnastics",
    .yoga: "yoga",
    .skipping: "skipping",
    .pingpong: "pingpong",
    .basketball: "basketball",
    .football: "football",
    .vollyball: "vollyball",
    .tennis: "tennis",
    .golf: "golf",
    .baseball: "baseball",
    .skiing: "skiing",
    .skating: "skating",
    .dancing: "dancing",
    .other: "other",
    
    .sleep: "sleep",
    .weight: "weight",
    .bloodPressure: "bloodPressure",
    .calorie: "calorie",
    .testHeartrate: "testHeartrate",
    .restingHeartrate: "restingHeartrate",
    .emotion: "emotion"
]

//数据结构
struct StoryData {
    var type:SportType = SportType.other
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
    
    //类型
    private var type: SportType = .other
    
    //地图或步数高度
    var trackViewHeight: CGFloat = 0
    
    //数据
    var track: Track?{
        didSet{
            guard let trk = track else {
                return
            }
            
//            value.date = track.date as Date? ?? Date()
//            value.hour = track.durations / (60 * 60)
//            value.minute = (track.durations - track.durations / (60 * 60)) / 60
//            value.calorie = CGFloat(track.calories)
//            value.heartRate = CGFloat(track.avgrageHeartrate)
//            value.fat = CGFloat(track.burnFatMinutes)
            self.type = SportType(rawValue: trk.type)!
            createContents()
            
            //添加icon
            if let imageName = sportTypeNameMap[self.type]{
                
                let iconSize = CGSize(width: 46, height: 46)
                let icon = UIImage(named: "resource/sporticons/icon/\(imageName)")?.transfromImage(size: iconSize)
                let iconView = UIImageView(frame: CGRect(x: 16,
                                                         y: 6,
                                                         width: iconSize.width,
                                                         height: iconSize.height))
                iconView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                iconView.layer.cornerRadius = iconSize.width / 2
                iconView.layer.contents = icon?.cgImage
                addSubview(iconView)
            }
            
            //显示值
            let hour = trk.durations / (60 * 60)
            let minute = (trk.durations - hour * 60 * 60) / 60
            switch self.type {
            case .walking:
                titleLabel.text = "走路\(hour)小时\(minute)分钟"
            case .running:
                titleLabel.text = "跑步\(hour)小时\(minute)分钟"
            case .riding:
                titleLabel.text = "骑行\(hour)小时\(minute)分钟"
            case .hiking:
                titleLabel.text = "徒步\(hour)小时\(minute)分钟"
            case .swimming:
                titleLabel.text = "游泳\(hour)小时\(minute)分钟"
            case .sleep:
                titleLabel.text = "睡眠\(hour)小时\(minute)分钟"
            case .calorie:
                titleLabel.text = "消耗\(trk.calories)卡路里"
            case .weight:
                titleLabel.text = "体重\(trk.burnFatMinutes)公斤"
            case .basketball:
                titleLabel.text = "打篮球\(hour)小时\(minute)分钟"
            case .badminton:
                titleLabel.text = "打羽毛球\(hour)小时\(minute)分钟"
            case .climbing:
                titleLabel.text = "登山\(hour)小时\(minute)分钟"
            default:
                titleLabel.text = "类型：\(self.type)"
            }
            
            //显示时间
            let date = trk.date as Date? ?? Date()
            let calender = Calendar.current
            let components = calender.dateComponents([.hour, .minute], from: date)
            let minuteStr = components.minute! < 10 ? "0\(components.minute!)" : "\(components.minute!)"
            deltaTimeLabel.text = "\(components.hour!):" + minuteStr
            
            //显示卡路里
            detailLabel.text = "消耗卡路里\(trk.calories)kcal"
            
            //绘制路径或步数
            guard let items = trk.trackItems, items.count > 1 else{
                //无法绘制轨迹的情况下，绘制步数
                let steps = trk.step
                return
            }
            
            let trackHeartrateItems = trk.trackHeartrateItems?.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as! [TrackHeartrateItem]
            let trackItems = trk.trackItems?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as! [TrackItem]
            
            //轨迹尺寸范围
            let trackX: CGFloat = 8
            let trackY = thirdCellHeight
            let trackWidth = self.gradient.frame.width - trackX * 2
            let trackHeight = trackViewHeight
            
            //边界
            if let minLongtitude = trackItems.min(by: {$0.longtitude > $1.longtitude})?.longtitude,         //最小经度
                let maxLongtitude = trackItems.max(by: {$0.longtitude > $1.longtitude})?.longtitude,        //最大经度
                let minLatitude = trackItems.min(by: {$0.latitude > $1.latitude})?.latitude,                //最小纬度
                let maxLatitude = trackItems.max(by: {$0.latitude > $1.latitude})?.latitude {               //最大纬度
                
                let deltaLongtitude = maxLongtitude - minLongtitude
                let deltaLatitude = maxLatitude - minLatitude

                let bezier = UIBezierPath()                
                trackItems.enumerated().forEach{
                    index, trackItem in
                    
                    let longtitude = trackItem.longtitude
                    let latitude = trackItem.latitude
                    
                    //获取当前坐标位置
                    let posX = trackX + CGFloat(longtitude - minLongtitude) / CGFloat(deltaLongtitude) * trackWidth
                    let posY = trackY + CGFloat(latitude - minLatitude) / CGFloat(deltaLatitude) * trackHeight
                    let pos = CGPoint(x: posX, y: posY)
                    
                    if index == 0{
                        bezier.move(to: pos)
                    }else{
                        bezier.addLine(to: pos)
                    }
                }
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                shapeLayer.fillColor = nil
                shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
                shapeLayer.lineWidth = 2
                shapeLayer.lineCap = kCALineCapRound
                layer.addSublayer(shapeLayer)
            }
        }
    }
    
    //标题文字
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 16 + 46 + 8,
                             y: 8,
                             width: self.gradient.frame.width,
                             height: 24)
        label.textColor = .white
        label.font = fontSmall
        label.textAlignment = .left
        return label
    }()
    
    //详情文字
    private lazy var detailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 16 + 46 + 8,
                             y: 8 + 24,
                             width: self.gradient.frame.width,
                             height: 24)
        label.textColor = .white
        label.font = fontMiddle
        label.textAlignment = .left
        return label
    }()
    
    //发布时间文字
    private lazy var deltaTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: self.frame.width * 0.08,
                             y: self.gradient.frame.origin.y + self.gradient.frame.height,
                             width: 120,
                             height: 26)
        label.textColor = subWordColor
        label.font = fontSmall
        label.textAlignment = .left
        return label
    }()
    
    //点赞按钮
    private lazy var likeButton: UIButton = {
        let buttonFrame = CGRect(x: view_size.width - 8 * 2 - 32 * 2, y: self.gradient.frame.origin.y + self.gradient.frame.height, width: 32, height: 26)
        let button: UIButton = UIButton(frame: buttonFrame)
        if let image = UIImage(named: "resource/time/like_0")?.transfromImage(size: CGSize(width: 18, height: 18)){
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(like(sender:)), for: .touchUpInside)
        return button
    }()
    
    //评论按钮
    private lazy var commentButton: UIButton = {
        let buttonFrame = CGRect(x: view_size.width - 8 - 32, y: self.gradient.frame.origin.y + self.gradient.frame.height, width: 32, height: 26)
        let button: UIButton = UIButton(frame: buttonFrame)
        if let image = UIImage(named: "resource/time/comment_0")?.transfromImage(size: CGSize(width: 18, height: 18)){
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(comment(sender:)), for: .touchUpInside)
        return button
    }()
    
    //底图渐变
    let gradient = CAGradientLayer()
    
    
    
    //MARK:- init ************************************************************
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        var startColor: CGColor?
        var endColor: CGColor?
        
        let margin: CGFloat = 8
        
        //绘制渐变
        gradient.frame = CGRect(x: margin,
                                y: 0,
                                width: view_size.width - margin * 2,
                                height: thirdCellHeight + trackViewHeight - margin - 26)
        gradient.locations = [0.2, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        switch type {
        case .weight:
            startColor = modelStartColors[.mindBody]?.cgColor
            endColor = modelEndColors[.mindBody]?.cgColor
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
        gradient.cornerRadius =  2
        gradient.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true        //光栅化
        layer.addSublayer(gradient)
        
        //添加标签
        addSubview(titleLabel)
        addSubview(deltaTimeLabel)
        addSubview(detailLabel)
        
        //添加按钮
        addSubview(likeButton)
        addSubview(commentButton)
    }
    
    //MARK:- 点赞按钮点击
    @objc private func like(sender: UIButton){
        
    }
    
    //MARK:- 评论按钮点击
    @objc private func comment(sender: UIButton){
        
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
