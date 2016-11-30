//
//  DetailCell.swift
//  MapHunter
//
//  Created by YiGan on 29/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class DetailCell: UITableViewCell {
    
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        layer.cornerRadius = frame.height / 2
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DScale(transform, 0.9, 0.7, 1)
        layer.transform = transform
    }
    
    private func createContents(){
        
    }
}
