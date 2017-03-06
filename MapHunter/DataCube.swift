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
    
    //显示curLable
    private lazy var mainLabel: UILabel = {
        let frame = CGRect(x: self.frame.width * 0.05, y: self.frame.height * 0.1, width: self.frame.width, height: self.frame.height * 0.25)
        let curLabel: UILabel = UILabel(frame: frame)
        curLabel.textAlignment = .left
        curLabel.textColor = .white
        curLabel.font = UIFont(name: font_name, size: self.frame.height * 0.2)
        return curLabel
    }()
    
    //显示subLable
    private lazy var subLabel: UILabel = {
        let frame = CGRect(x: self.mainLabel.frame.origin.x, y: self.mainLabel.frame.origin.y + self.mainLabel.frame.height, width: self.frame.width, height: self.frame.height * 0.2)
        let targetLabel = UILabel(frame: frame)
        targetLabel.textAlignment = .left
        targetLabel.textColor = .white
        targetLabel.font = UIFont(name: font_name, size: self.frame.height * 0.1)
        return targetLabel
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
                var text = "\(Int16(data.value1))步"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontHuge])
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 1, 1))
                mainLabel.attributedText = mainAttributedString
                
                text = "还有\(Int16(data.value2))步完成"
                let subAttributedString = NSAttributedString(string: text,
                                                             attributes: [NSFontAttributeName: fontSmall])
                subLabel.attributedText = subAttributedString
            case .heartrate:
                
                var text = "\(Int16(data.value1))Bmp"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontHuge])
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 3, 3))
                mainLabel.attributedText = mainAttributedString
                
                text = "\(Int16(data.value2))分钟"
                heartrateLabel1.text = text
                
                text = "\(Int16(data.value3))分钟"
                heartrateLabel2.text = text
                
                text = "\(Int16(data.value4))分钟"
                heartrateLabel3.text = text
            case .sleep:
                
                let hourStr = "\(Int16(data.value1) / 60)"
                let minuteStr = Int16(data.value2) % 60 < 10 ? "0\(Int16(data.value2) % 60)" : "\(Int16(data.value2) % 60)"
                let text = hourStr + "小时" + minuteStr + "分钟"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontHuge])
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 6, 2))
                mainLabel.attributedText = mainAttributedString
            case .weight:
                
                var text = String(format: "%.1f", data.value1) + "Kg"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontHuge])
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))
                mainLabel.attributedText = mainAttributedString
                
                text = "目标体重" + String(format: "%.1f", data.value2) + "Kg"
                let subAttributedString = NSAttributedString(string: text,
                                                             attributes: [NSFontAttributeName: fontSmall])
                subLabel.attributedText = subAttributedString
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
        
        let length = view_size.width * (1 - 0.09) / 2
        let initFrame = CGRect(x: 0, y: 0, width: length, height: length * 547 / 580)
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
            
            addSubview(heartrateIcon1)
            addSubview(heartrateIcon2)
            addSubview(heartrateIcon3)
            addSubview(heartrateLabel1)
            addSubview(heartrateLabel2)
            addSubview(heartrateLabel3)
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
        addSubview(mainLabel)
        addSubview(subLabel)
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
