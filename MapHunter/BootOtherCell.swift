//
//  BootOtherCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/13.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class BootOtherCell: UITableViewCell {
    
    //名字
    private var nameLabel: UILabel?
    
    //MARK:- init
    init(identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .clear
        
        //设置分割线
//        separatorInset = .zero
//        if responds(to: #selector(setter: BootCell.layoutMargins)) {
//            layoutMargins = .zero
//        }
//        if responds(to: #selector(setter: BootCell.preservesSuperviewLayoutMargins)) {
//            preservesSuperviewLayoutMargins = false
//        }
    }
    
    private func createContents(){
        
        //手环名称
        if nameLabel == nil{
            let labelFrame = CGRect(x: 0,
                                    y: view_size.width * 0.1,
                                    width: view_size.width,
                                    height: fontBig.pointSize)
            nameLabel = UILabel(frame: labelFrame)
            nameLabel?.textAlignment = .center
            nameLabel?.font = fontSmall
            nameLabel?.textColor = .gray
            nameLabel?.text = "其他设备"
            addSubview(nameLabel!)
        }
    }
}
