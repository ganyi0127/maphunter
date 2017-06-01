//
//  DetailCenter.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/1.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class DetailCenter: UIView {
    //main value
    var value: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                unit = "%"
                text = "\(Int16(value / 10000 * 100))" + unit
            case .heartrate:
                unit = "Bmp"
                text = "\(Int16(value))" + unit
            case .sleep:
                unit = "%"
                text = "\(Int16(value / 10000 * 100))" + unit
            case .mindBody:
                unit = "Kg"
                text = "\(Int16(value))" + unit
            }
            
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontHuge])
            let unitLength = unit.characters.count, textLength = text.characters.count
            
            //字体大小
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(textLength - unitLength, unitLength))
            
            valueLabel.attributedText = mainAttributedString
        }
    }
    var leftValue: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                unit = "步"
                text = "\(Int16(leftValue))" + unit
            case .sleep:
                unit = "分钟"
                let hour = Int16(leftValue) / 60
                let minute = Int16(leftValue) % 60
                let minuteStr = "\(minute)"
                text = "\(hour)小时" + minuteStr + "分钟"
                
                let mainAttributedString = NSMutableAttributedString(string: text,
                                                                     attributes: [NSFontAttributeName: fontMiddle])
                let unitLength = unit.characters.count
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
                mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength * 2 - minuteStr.characters.count, unitLength))
                leftLabel.attributedText = mainAttributedString
                return
            default:
                unit = ""
                text = ""
            }
            
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontMiddle])
            let unitLength = unit.characters.count
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            leftLabel.attributedText = mainAttributedString
        }
    }
    var rightValue: CGFloat = 0{
        didSet{
            var unit: String
            var text: String
            switch type as DataCubeType {
            case .sport:
                if rightValue > 1000 {
                    unit = "公里"
                    text = "\(rightValue / 1000)" + unit
                }else{
                    unit = "米"
                    text = "\(rightValue)" + unit
                }
            default:
                unit = ""
                text = ""
            }
            
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontMiddle])
            let unitLength = unit.characters.count
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            rightLabel.attributedText = mainAttributedString
        }
    }
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: (self.bounds.size.width - self.bounds.size.height * 1.5) / 2,
                             y: 0,
                             width: self.bounds.size.height * 1.5,
                             height: self.bounds.size.height)
        label.textAlignment = .center
        label.font = fontSmall
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: self.bounds.size.height,
                             height: self.bounds.size.height)
        label.textAlignment = .center
        label.font = fontMiddle
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: self.bounds.size.width - self.bounds.size.height,
                             y: 0,
                             width: self.bounds.size.height,
                             height: self.bounds.size.height)
        label.textAlignment = .center
        label.font = fontMiddle
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //显示进度
    private lazy var progressLayer: CALayer = {
        let bezierRadius = self.bounds.height - 4 - 4
        let bezierRect = CGRect(x: 0,
                                y: 0,
                                width: bezierRadius,
                                height: bezierRadius)
        let bezier = UIBezierPath(ovalIn: bezierRect)
        
        let shapeLayer = CAShapeLayer()
        
        let transform = CATransform3DIdentity
        let rotateTransform = CATransform3DRotate(transform, -.pi / 2, 0, 0, 1)
        let translateTransform = CATransform3DTranslate(rotateTransform, self.bounds.height / 2 - bezierRadius / 2 - self.bounds.height, self.bounds.width / 2 - bezierRadius / 2, 0)
        shapeLayer.transform = translateTransform
        
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeEnd = self.value / 10000
        return shapeLayer
    }()
    
    //编辑按钮
    fileprivate lazy var weightEditButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.tintColor = .white
        button.backgroundColor = nil
        button.setTitle("编辑", for: .normal)
        button.titleLabel?.font = fontSmall
        button.addTarget(self, action: #selector(edit), for: .touchUpInside)
        button.frame = CGRect(x: self.bounds.width - self.bounds.width * 0.2 * 1.2,
                              y: (self.bounds.height - self.bounds.height * 0.3) / 2,
                              width: self.bounds.width * 0.2,
                              height: self.bounds.height * 0.3)
        let buttonRect = CGRect(origin: .zero, size: button.bounds.size)
        let bezier = UIBezierPath(roundedRect: buttonRect, cornerRadius: 3)
        
        let buttonLayer = CAShapeLayer()
        buttonLayer.path = bezier.cgPath
        buttonLayer.fillColor = nil
        buttonLayer.strokeColor = UIColor.white.cgColor
        buttonLayer.lineWidth = 1
        button.layer.addSublayer(buttonLayer)
        return button
    }()
    
    //点击事件
    private var tap: UITapGestureRecognizer?    
    
    fileprivate var type: DataCubeType!         //类型
    
    var delegate: DetailDelegate?
    var closure: (()->())?          //统一回调
    var editClosure: (()->())?
    
    
    //MARK:- init****************************************************************************************************
    init(detailType: DataCubeType){
        let frame = CGRect(x: edgeWidth,
                           y: detailTopHeight,
                           width: view_size.width - edgeWidth * 2,
                           height: detailCenterHeight)
        super.init(frame: frame)
        
        type = detailType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [modelStartColors[type]!.cgColor, modelEndColors[type]!.cgColor]
        gradient.cornerRadius = detailRadius
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = CGSize(width: 0, height: 1)
        gradient.shadowRadius = 1
        gradient.shadowOpacity = 0.5
        gradient.masksToBounds = false
        layer.addSublayer(gradient)
        
        //添加点击事件
        isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
        
    //MARK:- weight编辑点击按钮
    @objc private func edit(){
        editClosure?()
    }
    
    //MARK:- 点击事件
    @objc private func click(recognizer: UITapGestureRecognizer){
        closure?()
    }
    
    private func createContents(){
        //绘制大圆圈
        let bezierRadius = bounds.size.height - 4
        let bezierRect = CGRect(x: bounds.size.width / 2 - bezierRadius / 2,
                                y: bounds.size.height / 2 - bezierRadius / 2,
                                width: bezierRadius,
                                height: bezierRadius)
        let bezier = UIBezierPath(ovalIn: bezierRect)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        layer.addSublayer(shapeLayer)
        
        //添加圆圈label
        addSubview(valueLabel)
        
        //添加左右标签与进度
        switch type as DataCubeType {
        case .sport:
            
            //左右标签
            addSubview(leftLabel)
            addSubview(rightLabel)
            
            //绘制进度
            layer.addSublayer(progressLayer)
        case .sleep:
            //左右标签
            addSubview(leftLabel)
            
            //添加编辑按钮
            addSubview(weightEditButton)
            
            //绘制进度
            layer.addSublayer(progressLayer)
        default:
            break
        }
    }
}
