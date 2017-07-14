//
//  MeCell3.swift
//  MapHunter
//
//  Created by YiGan on 19/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
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
        case .target:
            imageName = "me_target"
            titleString = "目标设定"
        case .family:
            imageName = "me_family"
            titleString = "家人"
        case .friend:
            imageName = "me_friend"
            titleString = "朋友"
        case .setting:
            imageName = "me_setting"
            titleString = "设置"
        case .more:
            imageName = "me_more"
            titleString = "更多"
        default:
            imageName = ""
            titleString = ""
        }

        //设置icon
        let imageViewFrame = CGRect(x: 10, y: 10, width: 24, height: 24)
        let imageView = UIImageView(frame: imageViewFrame)
        let image = UIImage(named: "resource/me/\(imageName)")?.transfromImage(size: CGSize(width: 34, height: 34))
        imageView.image = image
        contentView.addSubview(imageView)
        
        //设置文字
        let labelFrame = CGRect(x: 54, y: 10, width: frame.size.width / 2, height: 24)
        let label = UILabel(frame: labelFrame)
        label.text = titleString
        label.textColor = subWordColor
        label.font = fontSmall
        label.textAlignment = .left
        contentView.addSubview(label)
    }
}
