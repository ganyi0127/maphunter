//
//  CustomSheet.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/21.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class CustomSheet: UIVisualEffectView {
    
    let height = view_size.height * 0.4                 //sheet高度
    
    //结束frame大小
    private lazy var finalFrame: CGRect = {
        return CGRect(x: 0, y: view_size.height - self.height, width: view_size.width, height: self.height)
    }()
    
    //初始化frame大小
    private lazy var initFrame: CGRect = {
        return CGRect(x: 0, y: view_size.height, width: view_size.width, height: self.height)
    }()
    
    //按钮

    
    //MARK:- init
    init() {
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        super.init(effect: blur)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    private func config(){
        
        frame = initFrame
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.frame = self.finalFrame
        }, completion: {
            _ in
            self.createContents()
        })
    }
    
    private func createContents(){
        
    }
}
