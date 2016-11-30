//
//  RootTBVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class RootTBC: UITabBarController {
    
    //展开按钮
    private var menuButtonFlag: Bool?{
        didSet{
            guard let flag = menuButtonFlag else {
                return
            }
            if flag{
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = 0
                animation.toValue = M_PI_2 / 2 + M_PI
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                menuButton.titleLabel?.layer.add(animation, forKey: nil)
            }else{
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = M_PI_2 / 2 + M_PI
                animation.toValue = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                menuButton.titleLabel?.layer.add(animation, forKey: nil)
            }
        }
    }
    
    private lazy var menuButton: UIButton! = { () -> UIButton in
        let menuButtonWidth = view_size.width * 0.2
        let menuButtonFrame = CGRect(x: view_size.width / 2 - menuButtonWidth / 2,
                                     y: view_size.height - menuButtonWidth,
                                     width: menuButtonWidth,
                                     height: menuButtonWidth)
        let menuButton = UIButton(frame: menuButtonFrame)
        menuButton.layer.cornerRadius = menuButtonWidth / 2
        menuButton.backgroundColor = UIColor.lightGray
        menuButton.setTitle("+", for: .normal)
        menuButton.titleLabel?.font = UIFont.systemFont(ofSize: menuButtonWidth)
        menuButton.addTarget(self, action: #selector(clickMenuButton(sender:)), for: .touchUpInside)
        return menuButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        //修改默认界面
        selectedIndex = 0
    }
    
    private func createContents(){
        view.addSubview(menuButton)
        menuButtonFlag = false
    }
    
    //MARK:- 点击展开按钮
    @objc private func clickMenuButton(sender: UIButton){
        menuButtonFlag = !menuButtonFlag!
    }
}
