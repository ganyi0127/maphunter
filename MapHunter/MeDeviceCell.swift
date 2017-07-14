//
//  MeDeviceCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/14.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class MeDeviceCell: UITableViewCell {
    
    var name: String? = nil {
        didSet{
            guard let n = name else {
                return
            }
            nameLabel?.text = n
        }
    }
    
    private var nameLabel: UILabel?
    
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
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
        
        //设置icon
        let imageViewFrame = CGRect(x: 10, y: 10, width: 30, height: 30)
        let imageView = UIImageView(frame: imageViewFrame)
        let image = UIImage(named: "resource/me/me_device")?.transfromImage(size: CGSize(width: 34, height: 34))
        imageView.image = image
        contentView.addSubview(imageView)
        
        //设置文字
        let labelFrame = CGRect(x: 54, y: 10, width: frame.size.width / 2, height: 24)
        nameLabel = UILabel(frame: labelFrame)
        nameLabel?.text = "id"
        nameLabel?.textColor = wordColor
        nameLabel?.font = fontSmall
        nameLabel?.textAlignment = .left
        contentView.addSubview(nameLabel!)
    }
}
