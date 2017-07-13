//
//  WeeklyMainVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/10.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
let weeklyRadius: CGFloat = 8
class WeeklyMainVC: UIViewController {
    
    let topHeight: CGFloat = 64
    var mainSeparatorY: CGFloat = 0
    var mainViewHeight: CGFloat = 0
    var subViewHeight: CGFloat = 0
    
    //主颜色
    var color = UIColor.clear
    
    //分割线
    private var separator: CAShapeLayer?
    
    private var nameLabel: UILabel?
    private var rankLabel: UILabel?
    private var likeLabel: UILabel?
    
    //MARK:-init************************************************************
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    func config(){
        //根据顶点创建背景路径
        func getPath(withTopLeft corner0: CGPoint, withTopRight corner1: CGPoint, withRight cornerR: CGPoint, withBottomRight corner2: CGPoint, withBottomLeft corner3: CGPoint, withLeft cornerL: CGPoint) -> CGPath{
            
            let corner0Start = CGPoint(x: corner0.x, y: corner0.y + weeklyRadius)
            let corner0Center = CGPoint(x: corner0.x + weeklyRadius, y: corner0.y + weeklyRadius)
            let corner1Start = CGPoint(x: corner1.x - weeklyRadius, y: corner1.y)
            let corner1Center = CGPoint(x: corner1Start.x, y: corner1.y + weeklyRadius)
            let cornerRStart = CGPoint(x: cornerR.x, y: cornerR.y - weeklyRadius)
            let cornerRCenter = cornerR
            let corner2Start = CGPoint(x: corner2.x, y: corner2.y - weeklyRadius)
            let corner2Center = CGPoint(x: corner2.x - weeklyRadius, y: corner2Start.y)
            let corner3Start = CGPoint(x: corner3.x + weeklyRadius, y: corner3.y)
            let corner3Center = CGPoint(x: corner3Start.x, y: corner3.y - weeklyRadius)
            let cornerLStart = CGPoint(x: cornerL.x, y: cornerL.y + weeklyRadius)
            let cornerLCenter = cornerL
            
            let bezier = UIBezierPath()
            bezier.move(to: corner0Start)
            bezier.addArc(withCenter: corner0Center, radius: weeklyRadius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
            bezier.addLine(to: corner1Start)
            bezier.addArc(withCenter: corner1Center, radius: weeklyRadius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
            bezier.addLine(to: cornerRStart)
            bezier.addArc(withCenter: cornerRCenter, radius: weeklyRadius, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: false)
            bezier.addLine(to: corner2Start)
            bezier.addArc(withCenter: corner2Center, radius: weeklyRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            bezier.addLine(to: corner3Start)
            bezier.addArc(withCenter: corner3Center, radius: weeklyRadius, startAngle: .pi / 2, endAngle: -.pi, clockwise: true)
            bezier.addLine(to: cornerLStart)
            bezier.addArc(withCenter: cornerLCenter, radius: weeklyRadius, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: false)
            return bezier.cgPath
        }
        
        
        subViewHeight = view_size.height * 0.125
        mainViewHeight = view_size.height - topHeight - subViewHeight - edgeWidth * 4
        mainSeparatorY = mainViewHeight * 2 / 5
        
        var corner0 = CGPoint(x: edgeWidth, y: topHeight + edgeWidth)
        var corner1 = CGPoint(x: view_size.width - edgeWidth, y: topHeight + edgeWidth)
        var cornerR = CGPoint(x: view_size.width - edgeWidth, y: topHeight + edgeWidth + mainSeparatorY)
        var corner2 = CGPoint(x: view_size.width - edgeWidth, y: topHeight + edgeWidth + mainViewHeight)
        var corner3 = CGPoint(x: edgeWidth, y: topHeight + edgeWidth + mainViewHeight)
        var cornerL = CGPoint(x: edgeWidth, y: topHeight + edgeWidth + mainSeparatorY)
        
        //绘制主背景
        let mainShape = CAShapeLayer()
        mainShape.path = getPath(withTopLeft: corner0, withTopRight: corner1, withRight: cornerR, withBottomRight: corner2, withBottomLeft: corner3, withLeft: cornerL)
        mainShape.fillColor = UIColor.white.cgColor
        mainShape.lineWidth = 0
        view.layer.addSublayer(mainShape)
        
        corner0 = CGPoint(x: edgeWidth, y: view_size.height - edgeWidth - subViewHeight)
        corner1 = CGPoint(x: view_size.width - edgeWidth, y: view_size.height - edgeWidth - subViewHeight)
        cornerR = CGPoint(x: view_size.width - edgeWidth, y: view_size.height - edgeWidth - subViewHeight / 2)
        corner2 = CGPoint(x: view_size.width - edgeWidth, y: view_size.height - edgeWidth)
        corner3 = CGPoint(x: edgeWidth, y: view_size.height - edgeWidth)
        cornerL = CGPoint(x: edgeWidth, y: view_size.height - edgeWidth - subViewHeight / 2)
        
        //绘制副背景
        let subShape = CAShapeLayer()
        subShape.path = getPath(withTopLeft: corner0, withTopRight: corner1, withRight: cornerR, withBottomRight: corner2, withBottomLeft: corner3, withLeft: cornerL)
        subShape.fillColor = UIColor.white.cgColor
        subShape.lineWidth = 0
        view.layer.addSublayer(subShape)
        
        //初始化
        view.backgroundColor = .clear
    }
    
    func createContents(){
        
        let separatorPath = UIBezierPath()
        separatorPath.move(to: CGPoint(x: edgeWidth + weeklyRadius + 5, y: edgeWidth + mainSeparatorY + 64))
        separatorPath.addLine(to: CGPoint(x: view_size.width - edgeWidth - weeklyRadius - 5, y: edgeWidth + mainSeparatorY + 64))
        
        separator = CAShapeLayer()
        separator?.path = separatorPath.cgPath
        separator?.lineDashPattern = [1, 5]
        separator?.lineCap = kCALineCapRound
        separator?.lineWidth = 2
        separator?.strokeColor = lightWordColor.cgColor //color.cgColor
        view.layer.addSublayer(separator!)
    }
}
