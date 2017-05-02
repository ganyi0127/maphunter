//
//  MainSubMenuButton.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/2.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
let mainSubMenuButtonSize = CGSize(width: 48, height: 48)
class MainSubMenuButton: UIButton {
    
    //存储原始位置
    private var originFrame: CGRect?
    private var initFrame: CGRect?
    
    //文字
    private var index: Int?
    private let textList = ["运动", "睡眠", "体重", "心情", "血压", "心率"]
    
    //MARK:- init
    init(index: Int) {
        originFrame = CGRect(origin: CGPoint(x: view_size.width / 2 - mainSubMenuButtonSize.width / 2 + CGFloat(index % 3 - 1) * 88,
                                             y: view_size.height - 49 * 6 + CGFloat(index / 3) * 88),
                             size: mainSubMenuButtonSize)
        initFrame = CGRect(origin: CGPoint(x: view_size.width / 2 - mainSubMenuButtonSize.width / 2, y: view_size.height),
                           size: CGSize(width: mainSubMenuButtonSize.width * 0.3, height: mainSubMenuButtonSize.height * 0.3))
        super.init(frame: initFrame!)
        
        self.index = index
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        if let i = index {
            setImage(UIImage(named: "resource/submenuicon/\(i)"), for: .normal)
            tag = i
        }
    }
    
    private func createContents(){
        
        guard let i = index else {
            return
        }
        
        let labelFrame = CGRect(x: 0, y: mainSubMenuButtonSize.height, width: mainSubMenuButtonSize.width, height: 17)
        let label = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.textColor = .white
        label.text = textList[i]
        label.font = fontSmall
        addSubview(label)
    }
    
    func setHidden(flag: Bool){
        guard let initFrm = initFrame, let originFrm = originFrame else {
            return
        }
        if flag{
            frame = initFrm
            alpha = 0
        }else{
            frame = originFrm
            alpha = 1
        }
    }
}
