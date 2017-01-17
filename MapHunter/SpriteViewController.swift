//
//  SpriteViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SpriteViewController: FunOriginViewController {
    
    override func config() {
        super.config()
        
        customTitle = "找精灵"
    }
    
    override func createContents() {
        //添加背景图片
        let backgroundImage = UIImage(named: "resource/map/background/sprite")?.transfromImage(size: view_size)
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRect(origin: .zero, size: view_size)
        backgroundImageView.layer.cornerRadius = 20
        view.addSubview(backgroundImageView)
        
        super.createContents()
    }
}
