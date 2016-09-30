//
//  Cell6Content.swift
//  MapHunter
//
//  Created by ganyi on 16/9/30.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class Cell6Content: UIView {
    
    //value
    var value: (demand: CGFloat, complete: CGFloat) = (0, 0){
        didSet{
            
            draw(value.demand, completeValue: value.complete)
        }
    }
    
    //保存所有cube
    private var cubeList = [CellCube]()
    
    //MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        //创建小方块
        let length:Int = 10
        let cubeSize = CGSize(width: frame.size.width / CGFloat(length), height: frame.size.height / CGFloat(length))
        
        (0..<length).forEach(){
            yIndex in
            (0..<length).forEach(){
                xIndex in
                
                let cubeFrame = CGRect(x: CGFloat(xIndex) * cubeSize.width, y: CGFloat(yIndex) * cubeSize.height, width: cubeSize.width * 0.95, height: cubeSize.height * 0.95)
                let cube = CellCube(frame: cubeFrame)
                addSubview(cube)
                
                cubeList.append(cube)
            }
        }
    }
    
    //MARK:- 动画
    private func draw(_ demandValue: CGFloat, completeValue: CGFloat){
        
        let initAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        var count:Double = 0
        
        cubeList.forEach(){
            cube in
            
            count += 1
            
            initAnim.values = [1, 1.1, 0.95]
            initAnim.keyTimes = [0, 0.3, 1]
            initAnim.duration = 0.3
            initAnim.beginTime = 0.1 * count + 1
            initAnim.isRemovedOnCompletion = false
            initAnim.fillMode = kCAFillModeBoth
            cube.layer.add(initAnim, forKey: nil)
            
            //重置颜色
            cube.colorValue = 0
        }
        
        let colorCount = Int(demandValue)
        
        (0..<colorCount).forEach(){
            _ in
            
            let index = Int(arc4random_uniform(100))
            
            cubeList[index].colorValue += 0.4 * demandValue / completeValue
        }
    }
}
