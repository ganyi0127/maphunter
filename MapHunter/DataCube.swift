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
        let frame = CGRect(x: 0, y: 10, width: self.frame.width, height: self.frame.height * 0.2)
        let curLabel: UILabel = UILabel(frame: frame)
        curLabel.textAlignment = .left
        curLabel.textColor = .white
        curLabel.font = UIFont(name: font_name, size: self.frame.height * 0.2)
        return curLabel
    }()
    
    //显示subLable
    private lazy var subLabel: UILabel = {
        let frame = CGRect(x: 0, y: 10 + self.frame.height * 0.2, width: self.frame.width, height: self.frame.height * 0.2)
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
                let text = "\(Int16(data.value1))步"
                let mainAttributedString = NSMutableAttributedString(string: text,
                    attributes: [NSFontAttributeName:
                    UIFont(name: font_name, size: self.frame.height * 0.2)!])
                mainAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: font_name, size: self.frame.height * 0.07)!, range: NSMakeRange(text.characters.count - 1, 1))
                mainLabel.attributedText = mainAttributedString
                
                let subAttributedString = NSAttributedString(string: "还有\(Int16(data.value2))步完成",
                    attributes: [NSFontAttributeName:
                        UIFont(name: font_name, size: self.frame.height * 0.07)!])
                subLabel.attributedText = subAttributedString
            case .heartrate:
                
                let text = "\(Int16(data.value1))Bmp"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName:
                                                                        UIFont(name: font_name, size: self.frame.height * 0.2)!])
                mainAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: font_name, size: self.frame.height * 0.07)!, range: NSMakeRange(text.characters.count - 3, 3))
                mainLabel.attributedText = mainAttributedString
            case .sleep:
                
                let text = "\(Int16(data.value1))小时\(Int16(data.value2))分钟"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName:
                                                                        UIFont(name: font_name, size: self.frame.height * 0.2)!])
                mainAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: font_name, size: self.frame.height * 0.07)!, range: NSMakeRange(text.characters.count - 2, 2))
                mainAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: font_name, size: self.frame.height * 0.07)!, range: NSMakeRange(text.characters.count - 7, 2))
                mainLabel.attributedText = mainAttributedString
            case .weight:
                
                let text = "\(Int16(data.value1))Kg"
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName:
                                                                        UIFont(name: font_name, size: self.frame.height * 0.2)!])
                mainAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: font_name, size: self.frame.height * 0.07)!, range: NSMakeRange(text.characters.count - 2, 2))
                mainLabel.attributedText = mainAttributedString
                
                let subAttributedString = NSAttributedString(string: "目标体重\(data.value2)Kg",
                    attributes: [NSFontAttributeName:
                        UIFont(name: font_name, size: self.frame.height * 0.07)!])
                subLabel.attributedText = subAttributedString
            }
        }
    }
    
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
        gradient.cornerRadius = frame.size.width * 0.1
        layer.addSublayer(gradient)
        
        
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
