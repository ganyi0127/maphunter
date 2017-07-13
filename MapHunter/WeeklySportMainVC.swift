//
//  WeeklySportMain.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/10.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class WeeklySportMainVC: WeeklyMainVC {
    
    //MARK:-主项*******************************************************************************************
    fileprivate var backgroundImageView: UIImageView?
    fileprivate var achievementBg: UIImageView?
    fileprivate var achievementFg: UIImageView?
    private var headImageView: UIImageView?
    private var nameLabel: UILabel?
    
    var userInfo = 0{
        didSet{
            let text = "ganyi"
            let nsText = NSString(string: text)
            var labelFrame = nsText.boundingRect(with: view_size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontSmall], context: nil)
            
            let headWidth: CGFloat = 20
            let y = topHeight + edgeWidth + mainSeparatorY - headWidth - edgeWidth
            let headFrame = CGRect(x: (view_size.width - labelFrame.width - edgeWidth - headWidth) / 2, y: y, width: headWidth, height: headWidth)
            labelFrame.origin = CGPoint(x: headFrame.origin.x + headWidth + edgeWidth, y: y)
            
            let shadowOffset = CGSize(width: 0, height: 1)
            
            //头像
            let headImg = UIImage(named: "resource/me/me_head_boy")
            let headImageView = UIImageView(frame: headFrame)
            headImageView.image = headImg
            headImageView.layer.cornerRadius = headWidth / 2
            headImageView.clipsToBounds = true
            view.addSubview(headImageView)
            
            //文字
            let label = UILabel(frame: labelFrame)
            label.font = fontSmall
            label.textColor = subWordColor
            label.text = text
            view.addSubview(label)
        }
    }
    
    //MARK:-五角星选项*******************************************************************************************
    private var centerPoint = CGPoint.zero
    private var pointList = [CGPoint]()
    var rank: Int? {
        didSet{
            guard let r = rank else {
                return
            }
            drawStarValue()
            rankLabel?.text = "\(r)\n好友排名"
        }
    }
    var likeCount: Int? {
        didSet{
            guard let l = likeCount else {
                return
            }
            drawStarValue()
            likeLabel?.text = "\(l)\n获赞次数"
        }
    }
    var signCount: Int? {
        didSet{
            guard let s = signCount else {
                return
            }
            drawStarValue()
            signLabel?.text = "\(s)\n打卡天数"
        }
    }
    var averageStep: Int? {
        didSet{
            guard let a = averageStep else {
                return
            }
            drawStarValue()
            averageLabel?.text = "\(a)\n平均步数"
        }
    }
    var runningDistance: Int? {
        didSet{
            guard let r = runningDistance else {
                return
            }
            drawStarValue()
            runningLabel?.text = "\(r)km\n跑步距离"
        }
    }
    private var rankLabel: UILabel?
    private var likeLabel: UILabel?
    private var signLabel: UILabel?
    private var averageLabel: UILabel?
    private var runningLabel: UILabel?
    
    var mainValue: (curValue: Int, lastValue: Int)? {
        didSet{
            guard let tuple = mainValue else {
                return
            }
            
            let delta = tuple.curValue - tuple.lastValue
            
            let curWeekStr = "本周\n"
            let curStr = "\(tuple.curValue)步"
            let deltaStr = "\(delta)步"
            
            let text = curWeekStr + curStr + "\n比上周" + deltaStr
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontTiny, NSForegroundColorAttributeName: subWordColor])
            var attributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: defaut_color]
            attributedString.addAttributes(attributes, range: NSMakeRange(curWeekStr.characters.count, curStr.characters.count))
            if delta >= 0 {
                attributes[NSForegroundColorAttributeName] = UIColor.green.withAlphaComponent(0.5)
            }else{
                attributes[NSForegroundColorAttributeName] = UIColor.red.withAlphaComponent(0.5)
            }
            attributedString.addAttributes(attributes, range: NSMakeRange(text.characters.count - deltaStr.characters.count, deltaStr.characters.count))
            mainLabel?.attributedText = attributedString
            
            view.bringSubview(toFront: mainLabel!)
        }
    }
    private var mainLabel: UILabel?
    
    //MARK:-子项*******************************************************************************************
    private var labelList = [UILabel]()
    var totalCalorie: Int = 0{
        didSet{
            let unit = "大卡"
            let text = "\(totalCalorie)" + unit
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: subWordColor])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor], range: NSMakeRange(text.characters.count - unit.characters.count, unit.characters.count))
            if labelList.count >= 3{
                labelList[0].attributedText = attributedString
            }
        }
    }
    var totalDistance: Int = 0{
        didSet{
            let unit = "公里"
            let text = "\(totalDistance)" + unit
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: subWordColor])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor], range: NSMakeRange(text.characters.count - unit.characters.count, unit.characters.count))
            if labelList.count >= 3{
                labelList[1].attributedText = attributedString
            }
        }
    }
    var totalDuration: Int = 0{
        didSet{
            let hour = totalDuration / 60
            let minute = totalDuration % 60
            let hourStr = hour > 0 ? "\(hour)" : ""
            let minuteStr = "\(minute)"
            let hourUnit = hour > 0 ? "小时" : ""
            let minuteUnit = "分钟"
            let text = hourStr + hourUnit + minuteStr + minuteUnit
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: subWordColor])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor], range: NSMakeRange(hourStr.characters.count, hourUnit.characters.count))
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor], range: NSMakeRange(text.characters.count - minuteUnit.characters.count, minuteUnit.characters.count))
            if labelList.count >= 3{
                labelList[2].attributedText = attributedString
            }
        }
    }
    
    //MARK:-init*******************************************************************************************
    override func config(){
        super.config()
        
    }
    
    override func createContents(){
        super.createContents()
        
        //常量
        let imageWidth = (subViewHeight - edgeWidth * 3) / 2
        let labelWidth = (view_size.width - edgeWidth * 2) / 3
        let originY = view_size.height - edgeWidth - subViewHeight      //子页初始高度
        
        //添加背景
        if let image = UIImage(named: "resource/discover/weekly/background"){
            let width = (view_size.width - edgeWidth * 2) * 0.7
            let height = width * image.size.height / image.size.width
            let frame = CGRect(x: (view_size.width - width) / 2, y: topHeight + edgeWidth, width: width, height: height)
            backgroundImageView = UIImageView(frame: frame)
            backgroundImageView?.image = image
            view.addSubview(backgroundImageView!)
        }
        
        //添加奖章
        if let image = UIImage(named: "resource/discover/weekly/achievement_0"){
            let height = mainSeparatorY * 0.7
            let width = height * image.size.width / image.size.height
            let frame = CGRect(x: (view_size.width - width) / 2, y: topHeight + edgeWidth, width: width, height: height)
            achievementBg = UIImageView(frame: frame)
            achievementBg?.image = image
            view.addSubview(achievementBg!)
        }
        
        //添加成就
        if let image = UIImage(named: "resource/discover/weekly/title_0"){
            let height = mainSeparatorY * 0.7 * 0.2
            let width = height * image.size.width / image.size.height
            let frame = CGRect(x: (view_size.width - width) / 2, y: topHeight + edgeWidth + mainSeparatorY * 0.7 * 0.7, width: width, height: height)
            achievementFg = UIImageView(frame: frame)
            achievementFg?.image = image
            view.addSubview(achievementFg!)
        }
        
        //初始化数据标签
        let labelHeight: CGFloat = 40
        
        let rankFrame = CGRect(x: 0, y: topHeight + edgeWidth + mainSeparatorY, width: view_size.width, height: labelHeight)
        rankLabel = UILabel(frame: rankFrame)
        rankLabel?.numberOfLines = 0
        rankLabel?.textAlignment = .center
        rankLabel?.font = fontSmall
        rankLabel?.textColor = subWordColor
        view.addSubview(rankLabel!)
        
        let valueLabelWidth: CGFloat = 80
        let centerY = topHeight + edgeWidth + mainSeparatorY + (mainViewHeight - mainSeparatorY) / 2
        let middleLabelY = centerY - labelHeight - edgeWidth
        
        let likeFrame = CGRect(x: view_size.width - edgeWidth - valueLabelWidth, y: middleLabelY, width: valueLabelWidth, height: labelHeight)
        likeLabel = UILabel(frame: likeFrame)
        likeLabel?.numberOfLines = 0
        likeLabel?.textAlignment = .center
        likeLabel?.font = fontSmall
        likeLabel?.textColor = subWordColor
        view.addSubview(likeLabel!)
        
        let bottomY = topHeight + edgeWidth + mainViewHeight - labelHeight - edgeWidth
        
        let signFrame = CGRect(x: view_size.width / 2 + 50, y: bottomY, width: valueLabelWidth, height: labelHeight)
        signLabel = UILabel(frame: signFrame)
        signLabel?.numberOfLines = 0
        signLabel?.textAlignment = .center
        signLabel?.font = fontSmall
        signLabel?.textColor = subWordColor
        view.addSubview(signLabel!)
        
        let averFrame = CGRect(x: view_size.width / 2 - 50 - valueLabelWidth, y: bottomY, width: valueLabelWidth, height: labelHeight)
        averageLabel = UILabel(frame: averFrame)
        averageLabel?.numberOfLines = 0
        averageLabel?.textAlignment = .center
        averageLabel?.font = fontSmall
        averageLabel?.textColor = subWordColor
        view.addSubview(averageLabel!)
        
        let runningFrame = CGRect(x: edgeWidth, y: middleLabelY, width: valueLabelWidth, height: labelHeight)
        runningLabel = UILabel(frame: runningFrame)
        runningLabel?.numberOfLines = 0
        runningLabel?.textAlignment = .center
        runningLabel?.font = fontSmall
        runningLabel?.textColor = subWordColor
        view.addSubview(runningLabel!)
        
        //初始化主数据标签
        let mainWidth: CGFloat = 160
        let mainFrame = CGRect(x: (view_size.width - mainWidth) / 2, y: centerY - mainWidth / 2, width: mainWidth, height: mainWidth)
        mainLabel = UILabel(frame: mainFrame)
        mainLabel?.numberOfLines = 0
        mainLabel?.textAlignment = .center
        view.addSubview(mainLabel!)
        
        //添加子数据image项,添加子数据label项
        if labelList.isEmpty{
            //子数据项
            let imageNames = ["calorie", "distance", "duration"]
            
            for (index, imageName) in imageNames.enumerated(){
                let imageViewFrame = CGRect(x: edgeWidth + labelWidth * CGFloat(index) + (labelWidth - imageWidth) / 2, y: originY + edgeWidth, width: imageWidth, height: imageWidth)
                let imageView = UIImageView(frame: imageViewFrame)
                imageView.image = UIImage(named: "resource/discover/weekly/" + imageName)
                view.addSubview(imageView)
                
                let labelFrame = CGRect(x: edgeWidth + labelWidth * CGFloat(index), y: originY + edgeWidth * 2 + imageWidth, width: labelWidth, height: imageWidth)
                let label = UILabel(frame: labelFrame)
                label.textAlignment = .center
                view.addSubview(label)
                labelList.append(label)
            }
        }
    }
    
    //MARK:-绘制数据
    private func drawStarValue(){
        guard rank != nil, likeCount != nil, signCount != nil, averageStep != nil, runningDistance != nil else {
            return
        }
        
        //五角星中心点位置
        centerPoint = CGPoint(x: view_size.width / 2, y: topHeight + edgeWidth + mainSeparatorY + (mainViewHeight - mainSeparatorY) / 2)
        
        //最外圈五角星半径
        let starMaxRadius = (mainViewHeight - mainSeparatorY) / 2 - 40
        
        //小圈半径
        let circleRadius: CGFloat = 5
        let offsetRadius = circleRadius * 2 + 4
        let starMinRadius = starMaxRadius - offsetRadius * 2
        
        //存储用于绘制覆盖物的点组
        var maskPoints = [CGPoint]()
        
        //绘制步数统计
        for i in 0..<3{
            let radius = starMaxRadius - offsetRadius * CGFloat(i)
            let points = getPoints(withCenterPoint: centerPoint, withRadius: radius, withCircleIndex: i, withOffsetRadius: i == 2 ? offsetRadius : 0)
            
            //绘制五角星
            let bezier = UIBezierPath()
            for (index, (isMask, point)) in points.enumerated(){
                if index == 0 {
                    bezier.move(to: point)
                }else{
                    bezier.addLine(to: point)
                }
                if i == 2{  //内小圆圈
                    bezier.addArc(withCenter: point, radius: circleRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                    bezier.addLine(to: point)
                }else{
                    
                    //绘制小圆圈
                    let circleBezier = UIBezierPath(ovalIn: CGRect(x: point.x - circleRadius, y: point.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
                    let circleShape = CAShapeLayer()
                    circleShape.path = circleBezier.cgPath
                    circleShape.fillColor = nil
                    circleShape.lineWidth = 1
                    circleShape.strokeColor = defaut_color.cgColor
                    view.layer.addSublayer(circleShape)
                    
                    //绘制小圆圈渐变
                    let circleGradient = CAGradientLayer()
                    circleGradient.frame = view.bounds
                    circleGradient.locations = [0, 1]
                    circleGradient.startPoint = CGPoint(x: 0, y: 0)
                    circleGradient.endPoint = CGPoint(x: 1, y: 0)
                    circleGradient.colors = [defaut_color.cgColor, UIColor.white.cgColor]
                    circleGradient.mask = circleShape
                    view.layer.addSublayer(circleGradient)
                    
                    if isMask {
                        maskPoints.append(point)
                    }
                }
            }
            bezier.close()
            
            //根据路径绘制遮罩
            let shape = CAShapeLayer()
            shape.path = bezier.cgPath
            view.layer.addSublayer(shape)
            
            //设置遮罩属性
            if i == 2{  //绘制内圈
                shape.lineWidth = 0
                shape.fillColor = defaut_color.cgColor
            }else {     //绘制外圈
                shape.fillColor = nil
                shape.strokeColor = UIColor.orange.cgColor
                shape.lineWidth = 1
            }
            
            //绘制渐变
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.locations = [0, 1]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.colors = [defaut_color.cgColor, UIColor.white.cgColor]
            gradient.mask = shape
            view.layer.addSublayer(gradient)
            
            //绘制白色小圆圈覆盖
            for point in maskPoints{
                let subCircleBezier = UIBezierPath(ovalIn: CGRect(x: point.x - circleRadius + 0.5, y: point.y - circleRadius + 0.5, width: circleRadius * 2 - 1, height: circleRadius * 2 - 1))
                let subCircleShape = CAShapeLayer()
                subCircleShape.path = subCircleBezier.cgPath
                subCircleShape.fillColor = UIColor.white.cgColor
                subCircleShape.lineWidth = 0
                view.layer.addSublayer(subCircleShape)
            }
            
            //绘制中心大圆圈覆盖
            for i in 0..<2{
                let widthRadius = starMinRadius - edgeWidth * CGFloat(i + 2)
                let frame = CGRect(x: centerPoint.x - widthRadius, y: centerPoint.y - widthRadius, width: widthRadius * 2, height: widthRadius * 2)
                let bezier = UIBezierPath(ovalIn: frame)
                let shape = CAShapeLayer()
                shape.path = bezier.cgPath
                if i == 0{
                    shape.strokeColor = UIColor.white.cgColor
                    shape.fillColor = nil
                    shape.lineWidth = 1
                }else{
                    shape.lineWidth = 0
                    shape.fillColor = UIColor.white.cgColor
                }
                view.layer.addSublayer(shape)                                
            }
        }
    }
    
    //MARK:-根据中心点位置与半径获取五角星点组 offset: 0 1 2
    private func getPoints(withCenterPoint centerPoint: CGPoint, withRadius radius: CGFloat, withCircleIndex index: Int, withOffsetRadius offsetRadius: CGFloat) -> [(Bool, CGPoint)]{
        guard let r = rank, let l = likeCount, let s = signCount, let a = averageStep, let d = runningDistance else {
            return []
        }
        
        var result = [(Bool, CGPoint)]()
        for i in 0..<5{
            var offset = 0
            switch i {
            case 0:
                if r < 10{
                    offset = 2
                }else if r < 100{
                    offset = 1
                }
            case 1:
                if l == 0{
                    offset = 0
                }else if l < 10{
                    offset = 1
                }else{
                    offset = 2
                }
            case 2:
                if s == 7{
                    offset = 2
                }else if s > 3{
                    offset = 1
                }
            case 3:
                if a > 8000{
                    offset = 2
                }else if a > 6000{
                    offset = 1
                }
            default:
                if d > 10{
                    offset = 2
                }else if d > 5{
                    offset = 1
                }
            }
            let degree: CGFloat = -.pi / 2 + .pi * 2 / 5 * CGFloat(i)
            let x = cos(degree) * (radius + CGFloat(offset) * offsetRadius)
            let y = sin(degree) * (radius + CGFloat(offset) * offsetRadius)
            let p = CGPoint(x: x + centerPoint.x, y: y + centerPoint.y)
            result.append((offset < (2 - index), p))
        }
        return result
    }
}
