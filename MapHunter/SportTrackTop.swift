//
//  SportTrackTop.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
class SportTrackTop: TrackTopBase {
    
    private var track: EachTrainningData!
    
    fileprivate var deltaMinute = 0
    fileprivate var headCount = 0
    fileprivate var dataList = [CGFloat]()
    
    
    //MARK:-init*******************************************************************************************
    override init(with track: EachTrainningData) {
        super.init(with: track)
        
        self.track = track
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func config() {
        super.config()
    }
    
    override func createContents() {
        
        guard let del = delegate else {
            return
        }
        
        //1.判断是否有轨迹 2.判断是否有步数 3...
        return
        //获取数据
        del.sportData{
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
                
                let rate = data / maxData
                let bezier = UIBezierPath(roundedRect: CGRect(x: CGFloat(index) * rectWidth + detailRadius + rectWidth * 0.1,
                                                              y: self.frame.height - rectHeight + cornerRadius + rectHeight * (1 - rate),
                                                              width: rectWidth * 0.8,
                                                              height: rectHeight * rate),
                                          cornerRadius: cornerRadius)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = bezier.cgPath
                shapeLayer.fillColor = UIColor.white.cgColor
                shapeLayer.lineWidth = 0
                shapeLayer.anchorPoint = CGPoint(x: 0.5, y: rectHeight)
                self.layer.insertSublayer(shapeLayer, at: 0)
                
                //动画
                let anim = CABasicAnimation(keyPath: "transform.scale.y")
                anim.fromValue = 0
                anim.toValue = 1 //data / maxData
                anim.duration = 0.2
                let time = self.layer.convertTime(CACurrentMediaTime(), from: nil)       //马赫时间
                anim.beginTime = time + TimeInterval(index) * 0.01
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

extension SportTrackTop{
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
        
        //修改具体项
        let unit = "步"
        
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
        
        //设置显示值 selected view
        let data = dataList[dataIndex]
        let hour = "\((headCount + dataIndex) / (60 / deltaMinute))"
        let minute: String = (headCount + dataIndex) % (60 / deltaMinute) == 0 ? "00" : "\((headCount + dataIndex) % (60 / deltaMinute) * deltaMinute)"
        let time = hour + ":" + minute
        selectedLabel.text = "\(Int16(data))" + unit + "\n\(time)"
    }
    
    override func currentTouchesEnded(_ touches: Set<UITouch>) {
        selectedView.isHidden = true
    }
}
