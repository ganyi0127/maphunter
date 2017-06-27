//
//  MindbodyDetailTop.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/1.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class MindbodyDetailTop: DetailTopBase {
    
    fileprivate var deltaMinute = 0
    fileprivate var headCount = 0
    fileprivate var dataList = [Int]()
    
    init() {
        super.init(detailType: .mindBody)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func config() {
        super.config()
    }
    
    override func createContents() {
        super.createContents()
        
        //获取数据
        delegate?.mindbodyData{
            result in
            
            var tmpResult = result
            
            //获取常量
            let cornerRadius: CGFloat = 1                                               //圆角半径
            
            //获取最大数值
            guard var maxData = tmpResult.max(), maxData > 0 else {
                return
            }
            
            //隐藏empty label
            self.emptyLabel.isHidden = true
            
            //移除开始与结束为0的数据
            var headCount = 0, tailCount = 0
            while tmpResult.first! <= 0 {
                tmpResult.removeFirst()
                headCount += 1
            }
            while tmpResult.last! <= 0 {
                tmpResult.removeLast()
                tailCount += 1
            }
            
            //获取最小数值
            guard var minData = tmpResult.min() else {
                return
            }
            
            self.dataList = tmpResult                                                   //存储有效数据
            self.headCount = headCount                                                  //存储有效head offset
            
            let dataListCount = tmpResult.count                                         //数据数量
            let rectWidth = (self.bounds.size.width - detailRadius * 2) / CGFloat(dataListCount)        //柱状图宽度
            
            //数据起始结束文字
            var beginText = ""
            var endText = ""
            
            
            self.deltaMinute = 15
            
            //默认最大值
            if maxData < 100{
                maxData = 100
            }
            
            let rectHeight = self.frame.height * 0.6    //柱状图高度
            //绘制柱状图
            tmpResult.enumerated().forEach(){
                index, data in
                
                let rate = CGFloat(data) / CGFloat(maxData)
                let bezier = UIBezierPath(roundedRect: CGRect(x: CGFloat(index) * rectWidth + detailRadius + rectWidth * 0.1,
                                                              y: self.frame.height - rectHeight + cornerRadius + rectHeight * (1 - rate),
                                                              width: rectWidth * 0.8,
                                                              height: rectHeight * rate),
                                          cornerRadius: cornerRadius)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                var color: CGColor
                if data < 30{
                    color = UIColor.blue.withAlphaComponent(0.5).cgColor
                }else if data < 70{
                    color = UIColor.yellow.withAlphaComponent(0.5).cgColor
                }else if data < 80{
                    color = UIColor.orange.withAlphaComponent(0.5).cgColor
                }else{
                    color = UIColor.red.withAlphaComponent(0.5).cgColor
                }
                shapeLayer.fillColor = color
                shapeLayer.lineWidth = 0
                shapeLayer.anchorPoint = CGPoint(x: 0.5, y: rectHeight)
                self.layer.insertSublayer(shapeLayer, at: 0)
                
                //动画
                let anim = CABasicAnimation(keyPath: "transform.scale.y")
                anim.fromValue = 0
                anim.toValue = 1 //data / maxData
                anim.duration = 0.15
                let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                anim.beginTime = time + TimeInterval(index) * 0.005
                anim.fillMode = kCAFillModeBoth
                anim.isRemovedOnCompletion = false
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                shapeLayer.add(anim, forKey: nil)
            }
            
            //起始文字
            let countPerMinute: Int = 60 / self.deltaMinute
            let minute = headCount % countPerMinute * self.deltaMinute
            let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
            beginText = "\(headCount / (60 / self.deltaMinute)):" + minuteStr
            endText = "\(23 - tailCount / (60 / self.deltaMinute)):\(59 - tailCount % (60 / self.deltaMinute) * self.deltaMinute)"
            
            //获取 detail center
            let detailCenter = (self.superview as! DetailSV).detailCenter
            
            //添加数据
            if let value = self.delegate?.detailTotalValue(){
                detailCenter?.value = value
            }
            if let leftValue = self.delegate?.detailLeftValue(){
                detailCenter?.leftValue = leftValue
            }
            if let rightValue = self.delegate?.detailRightValue(){
                detailCenter?.rightValue = rightValue
            }
            
            //绘制起始文字
            let startLabel = UILabel()
            startLabel.frame = CGRect(x: detailRadius, y: 8, width: self.bounds.size.width / 2, height: 12)
            startLabel.textColor = .white
            startLabel.font = fontSmall
            startLabel.textAlignment = .left
            startLabel.text = beginText
            detailCenter?.addSubview(startLabel)
            
            //绘制结束文字
            let endLabel = UILabel()
            endLabel.frame = CGRect(x: self.bounds.size.width / 2 - detailRadius, y: 8, width: self.bounds.size.width / 2, height: 12)
            endLabel.textColor = .white
            endLabel.font = fontSmall
            endLabel.textAlignment = .right
            endLabel.text = endText
            detailCenter?.addSubview(endLabel)
            
            //添加选择view
            self.addSubview(self.selectedView)
        }
    }
}

extension MindbodyDetailTop{
    override func currentTouchesBegan(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        guard !dataList.isEmpty else{
            return
        }
        
        let location = touch.location(in: self)
        let dataWidth = (bounds.size.width - detailRadius * 2) / CGFloat(dataList.count)
        let dataIndex = Int((location.x - detailRadius) / dataWidth)
        guard dataIndex < dataList.count, dataIndex >= 0 else{
            return
        }
        
        selectedView.frame.origin.x = detailRadius + CGFloat(dataIndex) * dataWidth
        
        currentTouchesMoved(touches)
    }
    
    override func currentTouchesMoved(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let dataWidth = (bounds.size.width - detailRadius * 2) / CGFloat(dataList.count)
        let dataIndex = Int((location.x - detailRadius) / dataWidth)
        guard dataIndex < dataList.count, dataIndex >= 0 else{
            return
        }
        
        
        //改变显示view x轴位置
        UIView.animate(withDuration: 0.3){
            self.selectedView.isHidden = false
            let x = detailRadius + CGFloat(dataIndex) * dataWidth
            let newFrame = CGRect(x: x, y: self.selectedView.frame.origin.y, width: dataWidth, height: self.selectedView.frame.height)
            self.selectedView.frame = newFrame
            
            //改变小三角x位置
            self.triangleView.frame.origin.x = dataWidth / 2 - self.triangleView.frame.width / 2
            
            
            //改变layer宽度
            if let oldLayers = self.selectedView.layer.sublayers?.filter({$0.name == "layer"}){
                if let last = oldLayers.last{
                    last.frame = self.selectedView.bounds
                }
            }
            
            //改变selected label 位置
            let width = self.selectedView.frame.width
            var posX = (width - self.selectedLabel.frame.width) / 2
            let convertX = self.convert(CGPoint(x: posX, y: 0), from: self.selectedView).x
            if convertX < 0{
                posX = self.convert(.zero, to: self.selectedView).x
            }else if convertX + self.selectedLabel.frame.width > self.bounds.width{
                posX = self.convert(CGPoint(x: self.bounds.width - self.selectedLabel.frame.width, y: 0), to: self.selectedView).x
            }
            self.selectedLabel.frame.origin.x = posX
        }
        
        //改变label位置
        let labels = selectedView.subviews.filter(){$0.isKind(of: UILabel.self)}
        labels.forEach(){
            label in
            UIView.animate(withDuration: 0.3){
                
                if label.tag == 0{
                    
                    var posX: CGFloat = (self.selectedView.bounds.width - label.bounds.width) / 2
                    let convertX = self.convert(CGPoint(x: posX, y: 0), from: self.selectedView).x
                    if convertX < 0{
                        posX = self.convert(.zero, to: self.selectedView).x
                    }else if convertX + label.frame.width > self.bounds.width{
                        posX = self.convert(CGPoint(x: self.bounds.width - label.frame.width, y: 0), to: self.selectedView).x
                    }
                    label.frame.origin.x = posX
                }
            }
        }
        
        //修改具体项
        var unit = ""
        
        //设置显示值 selected view
        let data = dataList[dataIndex]
        if data < 30{
            unit = "休息"
        }else if data < 70{
            unit = "低压"
        }else if data < 80{
            unit = "中压"
        }else{
            unit = "高压"
        }
        let hour = "\((headCount + dataIndex) / (60 / deltaMinute))"
        let minute: String = (headCount + dataIndex) % (60 / deltaMinute) == 0 ? "00" : "\((headCount + dataIndex) % (60 / deltaMinute) * deltaMinute)"
        let time = hour + ":" + minute
        selectedLabel.text =  "\(time)" + "\n\(Int16(data))" + unit
    }
    
    override func currentTouchesEnded(_ touches: Set<UITouch>) {
        selectedView.isHidden = true
    }
}
