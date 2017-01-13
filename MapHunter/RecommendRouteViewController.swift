//
//  RecommentRouteViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecommendRouteViewController: FunOriginViewController {

    override func config(){
        super.config()
        
        customTitle = "推荐路线"
    }
    
    override func createContents() {
        //添加背景图片
        let backgroundImage = UIImage(named: "resource/map/background/recommendroute")?.transfromImage(size: view_size)
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRect(origin: .zero, size: view_size)
        backgroundImageView.layer.cornerRadius = 20
        view.addSubview(backgroundImageView)
        
        super.createContents()
    }
}
