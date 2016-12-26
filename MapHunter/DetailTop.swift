//
//  DetailTop.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class DetailTop: UIView {
    private var type: DataCubeType!
    
    
    init(detailType: DataCubeType){
        let frame = CGRect(x: 0,
                           y: 0,
                           width: view_size.width - edgeWidth * 2,
                           height: view_size.width * 0.3)
        super.init(frame: frame)
        
        type = detailType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [modelStartColors[type]!.cgColor, modelEndColors[type]!.cgColor]
        gradient.cornerRadius = 10
        layer.addSublayer(gradient)
    }
    
    private func createContents(){
        
        //绘制大圆圈
        
        
        //绘制顶部甘特图
        
    }
}
