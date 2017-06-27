//
//  SubSportVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/20.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SubSport0VC: UIViewController {
    
    fileprivate let startX: CGFloat = 38
    fileprivate let endX: CGFloat = 16
    fileprivate let labelHeight: CGFloat = 24
    
    private var date: Date!
    var subTableView: SubTableView?
    
    
    
    
    //说明文字
    fileprivate lazy var tipLabel: UILabel = {
        
        let tipLabelFrame = CGRect(x: 0, y: 8 + navigation_height! + 20, width: self.view.frame.width, height: 17)
        let tipLabel: UILabel = UILabel(frame: tipLabelFrame)
        tipLabel.font = fontSmall
        tipLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        tipLabel.textAlignment = .center
        tipLabel.backgroundColor = .clear
        
        //添加图片混排
        let text = "其他 脂肪燃烧 心肺锻炼 峰值锻炼"
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
        let length = fontSmall.pointSize * 1
        let imageSize = CGSize(width: length, height: length)
        let imageBounds = CGRect(x: 0, y: length / 2 - tipLabelFrame.height / 2, width: length, height: length)
        var endIndex: Int = 0       //插入位置
        (0..<4).forEach{
            i in
            let startAttach = NSTextAttachment()
            startAttach.bounds = imageBounds
            
            if i == 0{
                endIndex = 0
                startAttach.image = self.getImage(0)
            }else if i == 1{
                endIndex = 3 + i
                startAttach.image = self.getImage(1)
            }else if i == 2{
                endIndex = 8 + i
                startAttach.image = self.getImage(2)
            }else if i == 3{
                endIndex = 13 + i
                startAttach.image = self.getImage(3)
            }
            
            let startAttributed = NSAttributedString(attachment: startAttach)
            attributedString.insert(startAttributed, at: endIndex)
        }
        tipLabel.attributedText = attributedString
        
        return tipLabel
    }()
    
    private func getImage(_ minuteType: Int) -> UIImage{
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        v.layer.cornerRadius = v.frame.height / 2
        v.backgroundColor = self.sportColors[minuteType]
        
        UIGraphicsBeginImageContextWithOptions(v.frame.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        v.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //类型颜色
    private let sportColors = [UIColor.lightGray,
                               UIColor.yellow,
                               UIColor.orange,
                               UIColor.red]
    
    //MARK:-init******************************************************************************************************************
    init(withDate date: Date){
        super.init(nibName: nil, bundle: nil)
        
        self.date = date
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white]
        navigationController?.setNavigation(hidden: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .clear
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.locations = [-0.6, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let startColor = modelStartColors[.sport]!
        gradient.colors = [startColor.cgColor, timeColor.cgColor]
        gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
        
        view.addSubview(tipLabel)
    }
    
    private func createContents(){
        
        //模拟数据
        var dataList = [(date: Date, other: Int, burnFat: Int, cardiopulmonaryExercise: Int, peakExercise: Int)]()
        for i in 0..<7 {
            let date = Date(timeInterval: -TimeInterval(6 - i) * 60 * 60 * 24, since: Date())
            let other = Int(arc4random_uniform(30))
            let burnFat = Int(arc4random_uniform(100))
            let cardiopulmonaryExercise = Int(arc4random_uniform(50))
            let peakExercise = Int(arc4random_uniform(20))
            dataList.append((date, other, burnFat, cardiopulmonaryExercise, peakExercise))
        }
        
        //获取最大值
        let totalList = dataList.map({$0.other + $0.burnFat + $0.cardiopulmonaryExercise + $0.peakExercise})
        let maxValue = totalList.max()!
        
        let topViewHeight = detailTopHeight + navigation_height! + 20   //整个上半部分高度
        let rectHeight = detailTopHeight * 0.6                          //仅图形高度
        
        //定义数据线
        let lineList = [0, maxValue / 2, maxValue]
        
        //绘制数据线
        for lineValue in lineList{
            let bezier = UIBezierPath()
            
            let y = (1 - CGFloat(lineValue - 0) / CGFloat(maxValue - 0)) * rectHeight + (topViewHeight - rectHeight) - labelHeight
            bezier.move(to: CGPoint(x: startX, y: y))
            bezier.addLine(to: CGPoint(x: view.bounds.width - self.endX, y: y))
            let upLineLayer = CAShapeLayer()
            upLineLayer.path = bezier.cgPath
            upLineLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
            upLineLayer.lineWidth = 1
            upLineLayer.lineCap = kCALineCapRound
            view.layer.addSublayer(upLineLayer)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y:  y - 17 / 2, width: self.startX, height: 17)
            label.text = "\(lineValue)"
            label.font = fontSmall
            label.textColor = .white
            label.textAlignment = .center
            //upLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
            view.addSubview(label)
        }
        
        
        //绘制数据
        let dataWidth: CGFloat = 20
        for (index, element) in dataList.enumerated(){
            let totalValue = element.other + element.burnFat + element.cardiopulmonaryExercise + element.peakExercise
            
            let gradient = CAGradientLayer()
            let rate0 = NSNumber(value: Float(element.other) / Float(totalValue))
            let rate1 = NSNumber(value: Float(element.other + element.burnFat) / Float(totalValue))
            let rate2 = NSNumber(value: Float(element.other + element.burnFat + element.cardiopulmonaryExercise) / Float(totalValue))

            gradient.locations = [0, rate0, rate0, rate1, rate1, rate2, rate2, 1]
            let color0 = sportColors[0].cgColor
            let color1 = sportColors[1].cgColor
            let color2 = sportColors[2].cgColor
            let color3 = sportColors[3].cgColor
            gradient.colors = [color0, color0, color1, color1, color2, color2, color3, color3]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)
            
            gradient.shadowColor = UIColor.white.cgColor
            gradient.shadowOffset = .zero
            gradient.shadowOpacity = 1
            gradient.shadowRadius = 2
            
            let cencleX = CGFloat(index) * (view.bounds.width - startX - endX - dataWidth - dataWidth) / (7 - 1) + dataWidth + startX
            let x = cencleX - dataWidth / 2
            let width = rectHeight * CGFloat(totalValue) / CGFloat(maxValue)
            let y = (rectHeight - width) + (topViewHeight - rectHeight) - labelHeight
            gradient.frame = CGRect(x: x, y: y, width: dataWidth, height: width)
            view.layer.addSublayer(gradient)
            
            //绘制日期
            let label = UILabel()
            label.frame = CGRect(x: cencleX - 44 / 2, y: topViewHeight - labelHeight, width: 44, height: labelHeight)
            label.text = element.date.weekdayString()
            label.font = fontSmall
            label.textColor = .white
            label.textAlignment = .center
            view.addSubview(label)
        }
        
        //Bottom
        addDateList()
    }
    
    //MARK:-添加日期列表
    private func addDateList(){
        //绘制列表
        subTableView = SubTableView(withType: .sport)
        view.addSubview(subTableView!)
    }
}
