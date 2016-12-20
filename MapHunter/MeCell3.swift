//
//  MeCell3.swift
//  MapHunter
//
//  Created by YiGan on 19/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
enum MeCell3Type: Int{
    case device = 0
    case target
    case applehealth
}
class MeCell3: UITableViewCell {
    
    private var type: MeCell3Type!
    
    init(type: MeCell3Type, reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        let imageViewFrame = CGRect(x: 0, y: 0, width: 44, height: 44)
        var imageName: String!
        switch type as MeCell3Type {
        case .device:
            imageName = "me_device"
        case .target:
            imageName = "me_target"
        case .applehealth:
            imageName = "me_applehealth"
        }

        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "resource/me/\(imageName)")?.transfromImage(size: CGSize(width: 44, height: 44))
        addSubview(imageView)
    }
}
