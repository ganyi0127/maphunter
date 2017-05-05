//
//  SynProgress.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/3.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SynProgress: UIView {
    
    private var curProgress: CGFloat = 0
    
    //MARK:- init
    init(){
        let frame = CGRect(x: 0, y: 64, width: 1, height: 2)
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = defaut_color
        
        //初始为0
        setProgress(progress: 0)
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 设置进度 0~100
    func setProgress(progress: CGFloat){
        
        if progress > 100{
            curProgress = 100
        }else if progress < 0{
            curProgress = 0
        }else{
            curProgress = progress
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            let newFrame = CGRect(x: 0, y: 64, width: view_size.width * self.curProgress / 100, height: 2)
            self.frame = newFrame
        }, completion: nil)
        
    }
}
