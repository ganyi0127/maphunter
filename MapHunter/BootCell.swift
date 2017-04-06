//
//  BootCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class BootCell: UICollectionViewCell {
    
    var index: Int?{
        didSet{
            
        }
    }
    
    //MARK:- 导航子页
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
        createContents()
    }
    
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
}
