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
    
    var type: MeCell3Type!
    
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
        
        self.accessoryType = .disclosureIndicator           //设置箭头
    }
    
    private func createContents(){
        
        var imageName: String
        var titleString: String
        switch type as MeCell3Type {
        case .device:
            imageName = "me_device"
            titleString = "绑定设备"
        case .target:
            imageName = "me_target"
            titleString = "目标设定"
        case .applehealth:
            imageName = "me_applehealth"
            titleString = "连接苹果健康"
        }

        //设置icon
        let imageViewFrame = CGRect(x: 10, y: 10, width: 24, height: 24)
        let imageView = UIImageView(frame: imageViewFrame)
        let image = UIImage(named: "resource/me/\(imageName)")
        imageView.image = image
        contentView.addSubview(imageView)
        
        //设置文字
        let labelFrame = CGRect(x: 54, y: 10, width: frame.size.width / 2, height: 24)
        let label = UILabel(frame: labelFrame)
        label.text = titleString
        label.textColor = wordColor
        label.font = fontSmall
        label.textAlignment = .left
        contentView.addSubview(label)
    }
}
