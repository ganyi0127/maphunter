//
//  TipAlertLike.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/2.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class TipAlertLike: TipAlert {
    
    override func createContents() {
        super.createContents()
        
        //抬头文字
        let titleLabelFrame = CGRect(x: 0, y: 20, width: frame.width, height: 36)
        let titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.font = fontMiddle
        titleLabel.textColor = wordColor
        titleLabel.text = "谢谢"
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        //详情文字
        let detailLabelFrame = CGRect(x: 0, y: titleLabelFrame.origin.y + titleLabelFrame.height, width: frame.width, height: 20)
        let detailLabel = UILabel(frame: detailLabelFrame)
        detailLabel.font = fontSmall
        detailLabel.textColor = subWordColor
        detailLabel.text = "您的反馈将让哈博士更加懂你！"
        detailLabel.textAlignment = .center
        addSubview(detailLabel)
        
        _ = delay(3){
            self.removeFromSuperview()
        }
    }
}
