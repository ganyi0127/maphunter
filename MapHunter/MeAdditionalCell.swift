//
//  MeAdditionalCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/14.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class MeAdditionalCell: UITableViewCell {
    
    private var label: UILabel?
    
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        
        let text = " 添加新设备"
        let nsText = NSString(string: text)
        var labelFrame = nsText.boundingRect(with: view_size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontSmall], context: nil)
        
        let headWidth: CGFloat = 24
        let headFrame = CGRect(x: (view_size.width - labelFrame.width - edgeWidth - headWidth) / 2, y: (frame.height - headWidth) / 2, width: headWidth, height: headWidth)
        labelFrame.origin = CGPoint(x: headFrame.origin.x + headWidth + edgeWidth, y: (44 - labelFrame.height) / 2)
        
        //头像
        let headSize = CGSize(width: headWidth, height: headWidth)
        let headImg = UIImage(named: "resource/me/me_additional_normal")?.transfromImage(size: headSize)?.withRenderingMode(.alwaysTemplate)
        let headImageView = UIImageView(frame: headFrame)
        headImageView.image = headImg
        headImageView.layer.cornerRadius = headWidth / 2
        headImageView.clipsToBounds = true
        headImageView.tintColor = lightWordColor
//        headImageView.backgroundColor = lightWordColor
        contentView.addSubview(headImageView)
        
        //文字
        let label = UILabel(frame: labelFrame)
        label.font = fontSmall
        label.textColor = lightWordColor
        label.text = text
        contentView.addSubview(label)
    }
}
