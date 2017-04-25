//
//  DataCube.swift
//  MapHunter
//
//  Created by YiGan on 12/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
//跑步 心率 睡眠 体重
enum DataCubeType{
    case sport
    case heartrate
    case sleep
    case weight
}
struct DataCubeData {
    var value1: CGFloat = 0
    var value2: CGFloat = 0
    var value3: CGFloat = 0
    var value4: CGFloat = 0
}

class DataCube: UIView {
    
    fileprivate var type: DataCubeType!          //CUBE类型 运动、心率、睡眠、体重
    
    //显示第一个lable
    private lazy var firstLabel: UILabel = {
        let frame = CGRect(x: 4, y: 8, width: self.frame.width, height: self.frame.height * 0.2)
        let label: UILabel = UILabel(frame: frame)
        label.textAlignment = .left
        label.textColor = .white
        label.font = fontSmall
        return label
    }()
    
    //显示第二个lable
    private lazy var secondLabel: UILabel = {
        let frame = CGRect(x: 4, y: self.firstLabel.frame.origin.y + self.firstLabel.frame.height + 4, width: self.frame.width, height: self.frame.height * 0.2)
        let label = UILabel(frame: frame)
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = fontSmall
        return label
    }()
    
    //显示第三个label
    private lazy var thirdLabel: UILabel = {
        let frame = CGRect(x: 4, y: self.secondLabel.frame.origin.y + self.secondLabel.frame.height + 4, width: self.frame.width, height: self.frame.height * 0.2)
        let label = UILabel(frame: frame)
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = fontSmall
        return label
    }()
    
    //显示第四个label(目前只有sport用到)
    private lazy var fourthLabel: UILabel = {
        let frame = CGRect(x: 4, y: self.frame.height - self.frame.height * 0.2 - 4, width: self.frame.width, height: self.frame.height * 0.2)
        let label = UILabel(frame: frame)
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = fontSmall
        return label
    }()
    
    //点击回调
    var closure: ((DataCubeType)->())?
    
    //颜色
    private var color: UIColor{
        get{
            switch type as DataCubeType {
            case .heartrate:
                return SportColor.running
            case .sport:
                return SportColor.walking
            case .sleep:
                return SportColor.riding
            case .weight:
                return SportColor.riding
            }
        }
    }
    
    //MARK:- 需传入的数据
    var data: DataCubeData!{
        didSet{
            switch type as DataCubeType {
            case .sport:
                var text = "今日运动"
                firstLabel.text = text
                
                text = "\(Int16(data.value1))步"
                let firstMutableAttributed = NSMutableAttributedString(string: text,
                                                                       attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                firstMutableAttributed.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)],
                                                     range: NSMakeRange(text.characters.count - 1, 1))
                secondLabel.attributedText = firstMutableAttributed
                
                if data.value2 == 0.0{
                    text = "完成0%"
                }else{
                    text = "完成\(Int(data.value1 / data.value2 * 100))%"
                }
                thirdLabel.text = text
                
                //显示fourthLabel
                text = "\(Int(data.value3))分钟"
                let fourthMutableAttributed = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
                
                //添加图片混排
                let length = fontSmall.pointSize * 1.2
                let imageSize = CGSize(width: length, height: length)
                let imageBounds = CGRect(x: 0, y: length / 2 - fourthLabel.bounds.height / 2, width: length, height: length)
                
                let attach = NSTextAttachment()
                attach.image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: imageSize)
                attach.bounds = imageBounds
                let attributed = NSAttributedString(attachment: attach)
                fourthMutableAttributed.append(attributed)
                
                fourthLabel.attributedText = fourthMutableAttributed
            case .heartrate:
                var text = "心肺功能"
                firstLabel.text = text
                
                text = "心率 \(Int16(data.value1))次/分钟"
                let secondMutableAttributed = NSMutableAttributedString(string: text,
                                                                        attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                secondMutableAttributed.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)],
                                                      range: NSMakeRange(text.characters.count - 4, 4))
                secondMutableAttributed.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)],
                                                      range: NSMakeRange(0, 2))
                secondLabel.attributedText = secondMutableAttributed

                text = "血压 \(Int16(data.value2))" + "/" + "\(Int16(data.value3))"
                let thirdMutableAttributed = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                thirdMutableAttributed.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)],
                                                     range: NSMakeRange(0, 2))
                thirdLabel.attributedText = thirdMutableAttributed
//                text = "\(Int16(data.value2))分钟"
//                heartrateLabel1.text = text
//                
//                text = "\(Int16(data.value3))分钟"
//                heartrateLabel2.text = text
//                
//                text = "\(Int16(data.value4))分钟"
//                heartrateLabel3.text = text
            case .sleep:
                var text = "昨晚睡眠"
                firstLabel.text = text
                
                let hourStr = "\(Int16(data.value1) / 60)"
                let minuteStr = Int16(data.value2) % 60 < 10 ? "0\(Int16(data.value2) % 60)" : "\(Int16(data.value2) % 60)"
                text = hourStr + "小时" + minuteStr + "分钟"
                let secondMutableAttributed = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
                secondMutableAttributed.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)],
                                                      range: NSMakeRange(text.characters.count - 2, 2))
                secondMutableAttributed.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)],
                                                      range: NSMakeRange(text.characters.count - 6, 2))
                secondLabel.attributedText = secondMutableAttributed
                
                text = "优质睡眠"
                thirdLabel.text = text
            case .weight:
                var text = "身心状态"
                firstLabel.text = text
                
//                text = String(format: "%.1f", data.value1) + "Kg"
//                let mainAttributedString = NSMutableAttributedString(string: text,
//                                                                     attributes: [NSFontAttributeName: fontHuge])
//                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))
//                firstLabel.attributedText = mainAttributedString
//                
//                text = "目标体重" + String(format: "%.1f", data.value2) + "Kg"
//                let subAttributedString = NSAttributedString(string: text,
//                                                             attributes: [NSFontAttributeName: fontSmall])
//                secondLabel.attributedText = subAttributedString
                
                text = "轻度疲劳"
                let secondMutableAttributed = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
                
                //添加图片混排
                let length = fontSmall.pointSize * 1.2
                let imageSize = CGSize(width: length, height: length)
                let imageBounds = CGRect(x: 0, y: length / 2 - fourthLabel.bounds.height / 2, width: length, height: length)
                
                let attach = NSTextAttachment()
                attach.image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: imageSize)
                attach.bounds = imageBounds
                let attributed = NSAttributedString(attachment: attach)
                secondMutableAttributed.insert(attributed, at: 0)
                
                secondLabel.attributedText = secondMutableAttributed
                
                text = "和平"
                let thirdMutableAttributed = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
                
                attach.image = UIImage(named: "resource/target/target_sleep_begin")?.transfromImage(size: imageSize)
                attach.bounds = imageBounds
                let thirdAttributed = NSAttributedString(attachment: attach)
                thirdMutableAttributed.insert(thirdAttributed, at: 0)
                
                thirdLabel.attributedText = thirdMutableAttributed
            }
        }
    }
    
    //心率子icon
    private lazy var heartrateIcon1: UIView = {
        let radius = self.frame.width * 0.08
        let frame = CGRect(x: radius, y: self.frame.height - self.frame.height * 0.4, width: radius , height: radius)
        let icon: UIView = UIView(frame: frame)
        icon.backgroundColor = UIColor(red: 239 / 255, green: 77 / 255, blue: 44 / 255, alpha: 1)
        icon.layer.cornerRadius = radius / 2
        return icon
    }()
    private lazy var heartrateIcon2: UIView = {
        let radius = self.frame.width * 0.08
        let frame = CGRect(x: radius, y: self.heartrateIcon1.frame.origin.y + self.heartrateIcon1.frame.height * 1.6, width: radius , height: radius)
        let icon: UIView = UIView(frame: frame)
        icon.backgroundColor = UIColor(red: 248 / 255, green: 139 / 255, blue: 24 / 255, alpha: 1)
        icon.layer.cornerRadius = radius / 2
        return icon
    }()
    private lazy var heartrateIcon3: UIView = {
        let radius = self.frame.width * 0.08
        let frame = CGRect(x: radius, y: self.heartrateIcon2.frame.origin.y + self.heartrateIcon2.frame.height * 1.6, width: radius , height: radius)
        let icon: UIView = UIView(frame: frame)
        icon.backgroundColor = UIColor(red: 250 / 255, green: 204 / 255, blue: 25 / 255, alpha: 1)
        icon.layer.cornerRadius = radius / 2
        return icon
    }()
    //心率子视图
    private lazy var heartrateLabel1: UILabel = {
        let frame = CGRect(x: self.heartrateIcon1.frame.origin.x + self.heartrateIcon1.frame.width * 1.2, y: self.heartrateIcon1.frame.origin.y, width: self.frame.width, height: self.heartrateIcon1.frame.height)
        let label: UILabel = UILabel(frame: frame)
        label.font = fontTiny
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    private lazy var heartrateLabel2: UILabel = {
        let frame = CGRect(x: self.heartrateIcon2.frame.origin.x + self.heartrateIcon2.frame.width * 1.2, y: self.heartrateIcon2.frame.origin.y, width: self.frame.width, height: self.heartrateIcon2.frame.height)
        let label: UILabel = UILabel(frame: frame)
        label.font = fontTiny
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    private lazy var heartrateLabel3: UILabel = {
        let frame = CGRect(x: self.heartrateIcon3.frame.origin.x + self.heartrateIcon3.frame.width * 1.2, y: self.heartrateIcon3.frame.origin.y, width: self.frame.width, height: self.heartrateIcon3.frame.height)
        let label: UILabel = UILabel(frame: frame)
        label.font = fontTiny
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    //MARK:- init
    init(dataCubeType type: DataCubeType){
        
        let width = (view_size.width - dataCubeSpacing * 3) / 2
        let height = width / dataCubeAspectRatio
        let initFrame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: initFrame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        layer.backgroundColor = UIColor.clear.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    private func createContents(){
        
        var imageName: String!
        switch type as DataCubeType {
        case .sport:
            imageName = "sport"
        case .heartrate:
            imageName = "heartrate"
            
//            addSubview(heartrateIcon1)
//            addSubview(heartrateIcon2)
//            addSubview(heartrateIcon3)
//            addSubview(heartrateLabel1)
//            addSubview(heartrateLabel2)
//            addSubview(heartrateLabel3)
        case .sleep:
            imageName = "sleep"
        case .weight:
            imageName = "weight"
        }
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [modelStartColors[type]!.cgColor, modelEndColors[type]!.cgColor]
        gradient.cornerRadius = frame.size.width * 0.05
        layer.insertSublayer(gradient, at: 0)
        
        
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "resource/cube/" + imageName)
        addSubview(imageView)
        
        //设置中央文字
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(thirdLabel)
        addSubview(fourthLabel)
    }
    
    @objc private func click(){
        
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.values = [1, 1.15, 0.9, 1]
        anim.keyTimes = [0, 0.4, 0.8, 1]
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let moveAnim = CABasicAnimation(keyPath: "position")
        moveAnim.toValue = layer.position
        moveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [moveAnim, anim]
        groupAnim.duration = 0.3
        layer.add(groupAnim, forKey: nil)
        
        closure?(type)
    }
}

//MARK:- 点击事件
extension DataCube{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
