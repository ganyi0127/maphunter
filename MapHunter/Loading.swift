//
//  Loading.swift
//  MapHunter
//
//  Created by ganyi on 2017/3/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class Loading: UIView {
    
    private let cornerRadius: CGFloat = 5
    private let length: CGFloat = 56 //view_size.width * 0.2      //view边长
    private lazy var boxLength: CGFloat = {         //box边长
        return self.length * 0.4
    }()
    
    private var offsetTitleLenght: CGFloat = 0
    
    private var label: UILabel?
    
    var title: String?
    
    init(byTitle title: String? = nil) {
        
        //获取title长度
        var tLenght: CGFloat = 0
        if let t = title{
            let paragraphStyle: NSParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSParagraphStyle
            let minTitle =  NSString(string: t)
            let tRect = minTitle.boundingRect(with: CGSize(width: view_size.width, height: length),
                                                  options: .usesLineFragmentOrigin,
                                                  attributes: [NSFontAttributeName: fontSmall, NSParagraphStyleAttributeName: paragraphStyle],
                                                  context: nil)
            if tRect.size.width > length - 16 {
                tLenght = tRect.size.width - length + 16
            }
        }
        offsetTitleLenght = tLenght
        
        //尺寸
        let frame = CGRect(x: view_size.width / 2 - length / 2 - offsetTitleLenght / 2,
                           y: view_size.height / 2 - length / 2,
                           width: length + offsetTitleLenght,
                           height: length + (title == nil ? 0 : 24))
        super.init(frame: frame)
        
        self.title = title
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        layer.cornerRadius = cornerRadius
        
        //背景
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        
        //标签
        if label == nil {
            let labelFrame = CGRect(x: -view_size.width / 2 + length / 2 + offsetTitleLenght / 2,
                                    y: length,
                                    width: view_size.width,
                                    height: 24)
            label = UILabel(frame: labelFrame)
            label?.textAlignment = .center
            label?.font = fontSmall
            label?.textColor = .white
            addSubview(label!)
        }
        
        if let t = title{
            label?.text = t
        }
    }
    
    private func createContents(){
        
        let rectOrigin = CGRect(x: -boxLength / 2, y: -boxLength / 2, width: boxLength, height: boxLength)
        let pathOrigin = UIBezierPath(roundedRect: rectOrigin, cornerRadius: cornerRadius)
        
        let pos0 = CGPoint(x: boxLength / 2 + offsetTitleLenght / 2, y: boxLength / 2)
        let pos1 = CGPoint(x: length - boxLength / 2 + offsetTitleLenght / 2, y: boxLength / 2)
        let pos2 = CGPoint(x: length - boxLength / 2 + offsetTitleLenght / 2, y: length - boxLength / 2)
        let pos3 = CGPoint(x: boxLength / 2 + offsetTitleLenght / 2, y: length - boxLength / 2)
        
        var poss = [pos0, pos1, pos2, pos3]
        
        let rect0 = CGRect(x: offsetTitleLenght / 2, y: 0, width: boxLength, height: boxLength)
        let path0 = UIBezierPath(roundedRect: rect0, cornerRadius: cornerRadius)
        
        let rect1 = CGRect(x: length - boxLength + offsetTitleLenght / 2, y: 0, width: boxLength, height: boxLength)
        let path1 = UIBezierPath(roundedRect: rect1, cornerRadius: cornerRadius)

        let rect2 = CGRect(x: length - boxLength + offsetTitleLenght / 2, y: length - boxLength, width: boxLength, height: boxLength)
        let path2 = UIBezierPath(roundedRect: rect2, cornerRadius: cornerRadius)
        
        let rect3 = CGRect(x: offsetTitleLenght / 2, y: length - boxLength, width: boxLength, height: boxLength)
        let path3 = UIBezierPath(roundedRect: rect3, cornerRadius: cornerRadius)
        
        var paths = [path0, path1, path2, path3]
        var colors = [modelEndColors[.sport], modelEndColors[.heartrate], modelEndColors[.sleep], modelEndColors[.mindBody]]
        
        var shapeLayers = [CAShapeLayer]()
        (0..<4).forEach{
            i in
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = pathOrigin.cgPath//paths[i].cgPath
            shapeLayer.position = poss[i]
            
            shapeLayer.fillColor = colors[i]?.cgColor
//            shapeLayer.strokeColor = UIColor.white.cgColor
//            shapeLayer.lineWidth = 2
            
            shapeLayers.append(shapeLayer)
            layer.addSublayer(shapeLayer)
        }
        
        //animation
        shapeLayers.enumerated().forEach{
            index, sublayer in
            
            let positionAnim = CAKeyframeAnimation(keyPath: "position")
            positionAnim.keyTimes = [0, 0.33, 0.66, 1]
            positionAnim.values = poss
            
            poss.insert(poss.removeLast(), at: 0)
            
            let pathAnim = CAKeyframeAnimation(keyPath: "path")
            pathAnim.keyTimes = [0, 0.33, 0.66, 1]//[0, 0.25, 0.5, 0.75, 1]
            pathAnim.values = paths.map{$0.cgPath}
            
            paths.insert(paths.removeLast(), at: 0)
            
            let colorAnim = CAKeyframeAnimation(keyPath: "fillColor")
            colorAnim.keyTimes = [0, 0.33, 0.66, 1]//[0, 0.25, 0.5, 0.75, 1]
            colorAnim.values = colors.map{$0?.cgColor ?? UIColor.white.cgColor}
            
            colors.insert(colors.removeLast(), at: 0)
            
            let rotaAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            rotaAnim.keyTimes = [0, 0.33, 0.66, 1]
            rotaAnim.values = [0, Double.pi * 2 / 3, .pi * 4 / 3, .pi * 2]
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 2
            groupAnim.repeatCount = HUGE
            groupAnim.isRemovedOnCompletion = false
            groupAnim.fillMode = kCAFillModeBoth
            groupAnim.animations = [positionAnim, colorAnim, rotaAnim]
            
            sublayer.add(groupAnim, forKey: nil)

        }
    }
}
