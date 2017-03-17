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
    private let length = view_size.width * 0.2      //view边长
    private lazy var boxLength: CGFloat = {         //box边长
        return self.length * 0.45
    }()
    
    init() {
        let frame = CGRect(x: view_size.width / 2 - length / 2,
                           y: view_size.height / 2 - length / 2,
                           width: length,
                           height: length)
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
    }
    
    private func createContents(){
        
        
        
        let rect0 = CGRect(x: 0, y: 0, width: boxLength, height: boxLength)
        let path0 = UIBezierPath(roundedRect: rect0, cornerRadius: cornerRadius)
        
        let rect1 = CGRect(x: length - boxLength, y: 0, width: boxLength, height: boxLength)
        let path1 = UIBezierPath(roundedRect: rect1, cornerRadius: cornerRadius)

        let rect2 = CGRect(x: length - boxLength, y: length - boxLength, width: boxLength, height: boxLength)
        let path2 = UIBezierPath(roundedRect: rect2, cornerRadius: cornerRadius)
        
        let rect3 = CGRect(x: 0, y: length - boxLength, width: boxLength, height: boxLength)
        let path3 = UIBezierPath(roundedRect: rect3, cornerRadius: cornerRadius)
        
        var paths = [path0, path1, path2, path3]
        var colors = [modelEndColors[.sport], modelStartColors[.heartrate], modelStartColors[.sleep], modelStartColors[.weight]]
        
        var shapeLayers = [CAShapeLayer]()
        (0..<4).forEach{
            i in
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = paths[i].cgPath
            
            shapeLayer.fillColor = colors[i]?.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 2
            
            shapeLayers.append(shapeLayer)
            layer.addSublayer(shapeLayer)
        }
        
        //animation
        shapeLayers.enumerated().forEach{
            index, sublayer in
            let pathAnim = CAKeyframeAnimation(keyPath: "path")
            pathAnim.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            pathAnim.values = paths.map(){$0.cgPath}
            
            paths.insert(paths.removeLast(), at: 0)
            
            let colorAnim = CAKeyframeAnimation(keyPath: "fillColor")
            pathAnim.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            colorAnim.values = colors.map(){$0?.cgColor ?? UIColor.white.cgColor}
            
            colors.insert(colors.removeLast(), at: 0)
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 2
            groupAnim.repeatCount = HUGE
            groupAnim.isRemovedOnCompletion = false
            groupAnim.fillMode = kCAFillModeBoth
            groupAnim.animations = [pathAnim, colorAnim]
            
            sublayer.add(groupAnim, forKey: nil)

        }
    }
}
