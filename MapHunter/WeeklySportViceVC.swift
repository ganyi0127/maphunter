//
//  WeeklySportVice.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/10.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class WeeklySportViceVC: WeeklyViceVC {
    
    private var title0Label: UILabel?
    private var title1Label: UILabel?
    private var subTitle0Label: UILabel?
    private var subTitle1Label: UILabel?
    
    private var startY: CGFloat = 32 + 8
    private var endY = edgeWidth + 20
    private var startX = edgeWidth + 40
    private var endX = edgeWidth
    
    //小圆圈半径
    private let circleRadius: CGFloat = 3
    
    //MARK:-周数据
    var thisWeekSteps: Int? {
        didSet{
            guard thisWeekSteps != nil else {
                return
            }
            drawTopGraphic()
        }
    }
    var lastWeekSteps: Int? {
        didSet{
            guard let weekSteps = lastWeekSteps else {
                return
            }
            //更新文字
            if let curWeekSteps = thisWeekSteps{
                let delta = curWeekSteps - weekSteps
                let rate = Int(ceil(fabs(Double(delta)) / Double(weekSteps) * 100))
                if delta > 0 {
                    title0Label?.text = "本周运动量提升了\(rate)%"
                }else{
                    title0Label?.text = "本周有所放松，运动量下降\(rate)%"
                }
                subTitle0Label?.text = "坚持是维多利亚的秘密"
            }
            drawTopGraphic()
        }
    }
    var lastTwoWeekSteps: Int? {
        didSet{
            guard lastTwoWeekSteps != nil else {
                return
            }
            drawTopGraphic()
        }
    }
    var lastThreeWeekSteps: Int? {
        didSet{
            guard lastThreeWeekSteps != nil else {
                return
            }
            drawTopGraphic()
        }
    }
    
    //MARK:-图标2周数据
    var weekAverageTuple: (thisWeekAverageSteps: [Int], lastWeekAverageSteps: [Int])? {
        didSet{
            guard let tuple = weekAverageTuple else {
                return
            }
            if !tuple.thisWeekAverageSteps.isEmpty && !tuple.lastWeekAverageSteps.isEmpty {
                title1Label?.text = "本周步数波动较大"
                let goalList = tuple.thisWeekAverageSteps.filter{$0 > 8000}
                subTitle1Label?.text = "达标了\(goalList.count)天,每日都要保持适量运动哟"
                
                drawBottomGraphic()
            }
        }
    }
    
    //MARK:-init********************************************************************************************************
    override func config() {
        super.config()
        
        let backgroundColor = weeklyScrollColorList[0]
        view0.backgroundColor = backgroundColor
        view1.backgroundColor = backgroundColor
    }
    
    override func createContents() {
        super.createContents()
        
        //添加标题
        let titleFrame = CGRect(x: 0, y: 0, width: view0.frame.width, height: 20)
        let subTitleFrame = CGRect(x: 0, y: titleFrame.height, width: view0.frame.width, height: 12)
        
        title0Label = UILabel(frame: titleFrame)
        title0Label?.textColor = .white
        title0Label?.textAlignment = .center
        title0Label?.font = fontMiddle
        view0.addSubview(title0Label!)
        
        subTitle0Label = UILabel(frame: subTitleFrame)
        subTitle0Label?.textColor = UIColor.white.withAlphaComponent(0.5)
        subTitle0Label?.textAlignment = .center
        subTitle0Label?.font = fontSmall
        view0.addSubview(subTitle0Label!)
        
        title1Label = UILabel(frame: titleFrame)
        title1Label?.textColor = .white
        title1Label?.textAlignment = .center
        title1Label?.font = fontMiddle
        view1.addSubview(title1Label!)
        
        subTitle1Label = UILabel(frame: subTitleFrame)
        subTitle1Label?.textColor = UIColor.white.withAlphaComponent(0.5)
        subTitle1Label?.textAlignment = .center
        subTitle1Label?.font = fontSmall
        view1.addSubview(subTitle1Label!)
    }
    
    //MARK:-绘制曲线0(总步数/7*2为显示的数据)
    private func drawTopGraphic(){
        guard let value0 = lastThreeWeekSteps, let value1 = lastTwoWeekSteps, let value2 = lastWeekSteps, let value3 = thisWeekSteps else {
            return
        }
        
        let dataList = [value0, value1, value2, value3]
        let dataNameList = ["前三周", "前两周", "上周", "本周"]
        guard let maxWeekSteps = dataList.max() else {
            return
        }
        
        //绘制刻度线
        let maxLine = (CGFloat(maxWeekSteps) / 7) * 2
        let lineList = [0, CGFloat(value0) / 7, (CGFloat(value0) / 7) * 2]
        for (index, line) in lineList.enumerated(){
            let bezier = UIBezierPath()
            let y = (subViewHeight - startY - endY) * (1 - line / maxLine) + startY
            bezier.move(to: CGPoint(x: edgeWidth, y: y))
            bezier.addLine(to: CGPoint(x: subViewWidth - endX, y: y))
            bezier.close()
            
            let separator = CAShapeLayer()
            separator.path = bezier.cgPath
            separator.fillColor = nil
            separator.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
            if index == 0{
                separator.lineWidth = 0.5
            }else{
                separator.lineWidth = 1
                separator.lineDashPattern = [3, 5]
                
                let labelHeight: CGFloat = 9
                let labelFrame = CGRect(x: edgeWidth, y: y - labelHeight - 1, width: startX, height: labelHeight)
                let label = UILabel(frame: labelFrame)
                label.font = fontTiny
                label.textColor = UIColor.white.withAlphaComponent(0.5)
                var text: String
                if index == 1{
                    text = "日均步数"
                }else{
                    text = "总步数"
                }
                label.text = text
                label.textAlignment = .left
                view0.addSubview(label)
            }
            view0.layer.addSublayer(separator)
        }
        
        //颜色
        let weeklyColor = UIColor.yellow
        let averageColor = UIColor.white
        
        //绘制数据线
        let weeklyBezier = UIBezierPath()
        let averageBezier = UIBezierPath()
        var preWeeklyPoint = CGPoint.zero
        var preAveragePoint = CGPoint.zero
        for (index, data) in dataList.enumerated() {
            let x = startX + (subViewWidth - startX - endX) / 3 * CGFloat(index)
            let weeklyY = startY + (subViewHeight - startY - endY) * (1 - (CGFloat(data) / 7) * 2 / CGFloat(maxLine))
            let averageY = startY + (subViewHeight - startY - endY) * (1 - (CGFloat(data) / 7) / CGFloat(maxLine))
            let weeklyPoint = CGPoint(x: x, y: weeklyY)
            let averagePoint = CGPoint(x: x, y: averageY)
            
            if index == 0 {
                weeklyBezier.move(to: weeklyPoint)
                averageBezier.move(to: averagePoint)
            }else{
                let weeklyControlPoint1 = CGPoint(x: preWeeklyPoint.x + 20, y: preWeeklyPoint.y)
                let weeklyControlPoint2 = CGPoint(x: weeklyPoint.x - 20, y: weeklyPoint.y)
                let averageControlPoint1 = CGPoint(x: preAveragePoint.x + 20, y: preAveragePoint.y)
                let averageControlPoint2 = CGPoint(x: averagePoint.x - 20, y: averagePoint.y)
                weeklyBezier.addCurve(to: weeklyPoint, controlPoint1: weeklyControlPoint1, controlPoint2: weeklyControlPoint2)
                averageBezier.addCurve(to: averagePoint, controlPoint1: averageControlPoint1, controlPoint2: averageControlPoint2)
            }
            preWeeklyPoint = weeklyPoint
            preAveragePoint = averagePoint
            
            //绘制纵线
            let lineBezier = UIBezierPath()
            lineBezier.move(to: CGPoint(x: x, y: subViewHeight - endY))
            lineBezier.addLine(to: CGPoint(x: x, y: weeklyY))
            let line = CAShapeLayer()
            line.path = lineBezier.cgPath
            line.fillColor = nil
            line.lineWidth = 1
            line.strokeColor = UIColor.white.cgColor
            line.lineDashPattern = [3, 5]
            view0.layer.addSublayer(line)
            
            //添加文字
            let labelFrame = CGRect(x: x - 20, y: subViewHeight - endY, width: 40, height: 20)
            let label = UILabel(frame: labelFrame)
            label.text = dataNameList[index]
            label.font = fontTiny
            label.textAlignment = .center
            label.textColor = UIColor.white
            view0.addSubview(label)
            
            //添加小圆圈
            let weeklyCircleBezier = UIBezierPath(ovalIn: CGRect(x: x - circleRadius, y: weeklyY - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
            let weeklyCircelShape = CAShapeLayer()
            weeklyCircelShape.path = weeklyCircleBezier.cgPath
            weeklyCircelShape.lineWidth = 0
            weeklyCircelShape.fillColor = weeklyColor.cgColor
            view0.layer.addSublayer(weeklyCircelShape)
            
            let averageCircleBezier = UIBezierPath(ovalIn: CGRect(x: x - circleRadius, y: averageY - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
            let averageCircleShape = CAShapeLayer()
            averageCircleShape.path = averageCircleBezier.cgPath
            averageCircleShape.lineWidth = 0
            averageCircleShape.fillColor = averageColor.cgColor
            view0.layer.addSublayer(averageCircleShape)
            
            //添加数值
            let labelWidth: CGFloat = 40
            let labelHeight: CGFloat = 12
            
            let weeklyFrame = CGRect(x: x - labelWidth / 2, y: weeklyY - labelHeight, width: labelWidth, height: labelHeight)
            let weeklyLabel = UILabel(frame: weeklyFrame)
            weeklyLabel.text = "\(data)"
            weeklyLabel.textColor = weeklyColor
            weeklyLabel.font = fontTiny
            weeklyLabel.textAlignment = .center
            view0.addSubview(weeklyLabel)
            
            let averageFrame = CGRect(x: x - labelWidth / 2, y: averageY - labelHeight, width: labelWidth, height: labelHeight)
            let averageLabel = UILabel(frame: averageFrame)
            averageLabel.text = "\(data / 7)"
            averageLabel.textColor = averageColor
            averageLabel.font = fontTiny
            averageLabel.textAlignment = .center
            view0.addSubview(averageLabel)
        }
        
        //添加数据曲线
        let weeklyShape = CAShapeLayer()
        weeklyShape.path = weeklyBezier.cgPath
        weeklyShape.fillColor = nil
        weeklyShape.strokeColor = weeklyColor.cgColor
        weeklyShape.lineWidth = 3
        view0.layer.addSublayer(weeklyShape)
        
        let averageShape = CAShapeLayer()
        averageShape.path = averageBezier.cgPath
        averageShape.fillColor = nil
        averageShape.strokeColor = averageColor.cgColor
        averageShape.lineWidth = 3
        view0.layer.addSublayer(averageShape)
    }
    
    //MARK:-绘制曲线1
    private func drawBottomGraphic(){
        guard let tuple = weekAverageTuple else {
            return
        }
        
        guard let maxThisSteps = tuple.thisWeekAverageSteps.max(), let maxLastSteps = tuple.lastWeekAverageSteps.max() else {
            return
        }
        
        let maxSteps = max(maxThisSteps, maxLastSteps)
        
        //绘制刻度线
        let maxLine = CGFloat(maxSteps)
        let lineList: [CGFloat] = [0, 8000]
        for (index, line) in lineList.enumerated(){
            let bezier = UIBezierPath()
            let y = (subViewHeight - startY - endY) * (1 - line / maxLine) + startY
            bezier.move(to: CGPoint(x: edgeWidth, y: y))
            bezier.addLine(to: CGPoint(x: subViewWidth - endX, y: y))
            bezier.close()
            
            let separator = CAShapeLayer()
            separator.path = bezier.cgPath
            separator.fillColor = nil
            separator.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
            if index == 0{
                separator.lineWidth = 0.5
            }else{
                separator.lineWidth = 1
                separator.lineDashPattern = [3, 5]
                
                //8000步
                let labelHeight: CGFloat = 9
                let label1Frame = CGRect(x: edgeWidth, y: y - labelHeight - 1, width: startX, height: labelHeight)
                let label1 = UILabel(frame: label1Frame)
                label1.font = fontTiny
                label1.textColor = UIColor.white.withAlphaComponent(0.5)
                label1.text = "8000"
                label1.textAlignment = .left
                view1.addSubview(label1)
                
                //达标线
                let label2Frame = CGRect(x: view_size.width - edgeWidth - startX, y: y - labelHeight - 1, width: startX, height: labelHeight)
                let label2 = UILabel(frame: label2Frame)
                label2.font = fontTiny
                label2.textColor = UIColor.white.withAlphaComponent(0.5)
                label2.text = "达标线"
                label2.textAlignment = .right
                view1.addSubview(label2)
            }
            view1.layer.addSublayer(separator)
        }
        
        //颜色
        let thisColor = UIColor.yellow
        let lastColor = UIColor.white
        
        startX = edgeWidth
        
        //绘制数据线
        let weeklyBezier = UIBezierPath()
        let averageBezier = UIBezierPath()
        var preWeeklyPoint = CGPoint.zero
        var preAveragePoint = CGPoint.zero
        for index in 0..<7 {
            let thisData = tuple.thisWeekAverageSteps[index]
            let lastData = tuple.lastWeekAverageSteps[index]
            
            let x = startX + (subViewWidth - startX - endX) / 6 * CGFloat(index)
            let thisY = startY + (subViewHeight - startY - endY) * (1 - CGFloat(thisData) / CGFloat(maxLine))
            let lastY = startY + (subViewHeight - startY - endY) * (1 - CGFloat(lastData) / CGFloat(maxLine))
            let weeklyPoint = CGPoint(x: x, y: thisY)
            let averagePoint = CGPoint(x: x, y: lastY)
            
            if index == 0 {
                weeklyBezier.move(to: weeklyPoint)
                averageBezier.move(to: averagePoint)
            }else{
                let weeklyControlPoint1 = CGPoint(x: preWeeklyPoint.x + 20, y: preWeeklyPoint.y)
                let weeklyControlPoint2 = CGPoint(x: weeklyPoint.x - 20, y: weeklyPoint.y)
                let averageControlPoint1 = CGPoint(x: preAveragePoint.x + 20, y: preAveragePoint.y)
                let averageControlPoint2 = CGPoint(x: averagePoint.x - 20, y: averagePoint.y)
                weeklyBezier.addCurve(to: weeklyPoint, controlPoint1: weeklyControlPoint1, controlPoint2: weeklyControlPoint2)
                averageBezier.addCurve(to: averagePoint, controlPoint1: averageControlPoint1, controlPoint2: averageControlPoint2)
            }
            preWeeklyPoint = weeklyPoint
            preAveragePoint = averagePoint
            
            //绘制纵线
            let lineBezier = UIBezierPath()
            lineBezier.move(to: CGPoint(x: x, y: subViewHeight - endY))
            lineBezier.addLine(to: CGPoint(x: x, y: max(thisY, lastY)))
            let line = CAShapeLayer()
            line.path = lineBezier.cgPath
            line.fillColor = nil
            line.lineWidth = 1
            line.strokeColor = UIColor.white.cgColor
            line.lineDashPattern = [3, 5]
            view1.layer.addSublayer(line)
            
            //添加文字
            let labelFrame = CGRect(x: x - 20, y: subViewHeight - endY, width: 40, height: 20)
            let label = UILabel(frame: labelFrame)
            label.text = weekStrList[index]
            label.font = fontTiny
            label.textAlignment = .center
            label.textColor = UIColor.white
            view1.addSubview(label)
            
            //添加小圆圈
            let weeklyCircleBezier = UIBezierPath(ovalIn: CGRect(x: x - circleRadius, y: thisY - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
            let weeklyCircelShape = CAShapeLayer()
            weeklyCircelShape.path = weeklyCircleBezier.cgPath
            weeklyCircelShape.lineWidth = 0
            weeklyCircelShape.fillColor = thisColor.cgColor
            view1.layer.addSublayer(weeklyCircelShape)
            
            let averageCircleBezier = UIBezierPath(ovalIn: CGRect(x: x - circleRadius, y: lastY - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
            let averageCircleShape = CAShapeLayer()
            averageCircleShape.path = averageCircleBezier.cgPath
            averageCircleShape.lineWidth = 0
            averageCircleShape.fillColor = lastColor.cgColor
            view1.layer.addSublayer(averageCircleShape)
            
            //添加数值
            let labelWidth: CGFloat = 40
            let labelHeight: CGFloat = 12
            
            let weeklyFrame = CGRect(x: x - labelWidth / 2, y: thisY - labelHeight, width: labelWidth, height: labelHeight)
            let weeklyLabel = UILabel(frame: weeklyFrame)
            weeklyLabel.text = "\(thisData)"
            weeklyLabel.textColor = thisColor
            weeklyLabel.font = fontTiny
            weeklyLabel.textAlignment = .center
            view1.addSubview(weeklyLabel)
            
            let averageFrame = CGRect(x: x - labelWidth / 2, y: lastY - labelHeight, width: labelWidth, height: labelHeight)
            let averageLabel = UILabel(frame: averageFrame)
            averageLabel.text = "\(lastData)"
            averageLabel.textColor = lastColor
            averageLabel.font = fontTiny
            averageLabel.textAlignment = .center
            view1.addSubview(averageLabel)
        }
        
        //添加数据曲线
        let weeklyShape = CAShapeLayer()
        weeklyShape.path = weeklyBezier.cgPath
        weeklyShape.fillColor = nil
        weeklyShape.strokeColor = thisColor.cgColor
        weeklyShape.lineWidth = 3
        view1.layer.addSublayer(weeklyShape)
        
        let averageShape = CAShapeLayer()
        averageShape.path = averageBezier.cgPath
        averageShape.fillColor = nil
        averageShape.strokeColor = lastColor.cgColor
        averageShape.lineWidth = 3
        view1.layer.addSublayer(averageShape)
    }
}
