//
//  RecordHeader.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/16.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordHeader: UIView {
    
    //数据
    var leftDate = Date(){
        didSet{
            let format = DateFormatter()
            format.dateFormat = "yyy-M-d h:mm"
            leftLabel?.text = format.string(from: self.leftDate)
        }
    }
    var rightDate = Date(){
        didSet{
            let format = DateFormatter()
            format.dateFormat = "yyy-M-d h:mm"
            rightLabel?.text = format.string(from: self.rightDate)
        }
    }
    
    //左标签
    private lazy var leftLabel: UILabel? = {
        let frame = CGRect(x: 8, y: -self.frame.height, width: self.frame.width / 2 - 8, height: self.frame.height)
        let label: UILabel = UILabel(frame: frame)
        label.font = fontTiny
        label.textAlignment = .left
        label.textColor = .white
        let format = DateFormatter()
        format.dateFormat = "yyy-M-d"
        label.text = format.string(from: self.leftDate)
        return label
    }()
    
    //右标签
    private lazy var rightLabel: UILabel? = {
        let frame = CGRect(x: self.frame.width / 2, y: -self.frame.height, width: self.frame.width / 2 - 8, height: self.frame.height)
        let label: UILabel = UILabel(frame: frame)
        label.font = fontTiny
        label.textAlignment = .right
        label.textColor = .white
        let format = DateFormatter()
        format.dateFormat = "yyy-M-d"
        label.text = format.string(from: self.rightDate)
        return label
    }()
    
    private var type: RecordType!
    
    //MARK:- init ***************************************************************************
    init(type: RecordType){
        let frame = CGRect(x: 0, y: 0, width: view_size.width - 8 * 2, height: 22)
        super.init(frame: frame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
        
        //绘制背景
        let radius: CGFloat = 2
        let bezier = UIBezierPath()
        bezier.move(to: .zero)
        bezier.addLine(to: CGPoint(x: 0, y: -frame.height + radius))
        bezier.addQuadCurve(to: CGPoint(x: radius, y: -frame.height), controlPoint: CGPoint(x: 0, y: -frame.height))
        bezier.addLine(to: CGPoint(x: frame.width - radius, y: -frame.height))
        bezier.addQuadCurve(to: CGPoint(x: frame.width, y: -frame.height + radius), controlPoint: CGPoint(x: frame.width, y: -frame.height))
        bezier.addLine(to: CGPoint(x: frame.width, y: 0))
        bezier.addLine(to: .zero)
        bezier.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = recordDarkColors[type]?.cgColor
        shapeLayer.lineWidth = 0
        layer.addSublayer(shapeLayer)
    }
    
    private func createContents(){
        
        addSubview(leftLabel!)
        addSubview(rightLabel!)
    }
}
