//
//  MainSubMenuButton.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/2.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
let originMainSubMenuButtonSize = CGSize(width: 88, height: 88)
let initMainSubMenuButtonSize = CGSize(width: 1, height: 1)
class MainSubMenuButton: UIButton {
    
    //存储原始位置
    private var originFrame: CGRect?
    private var initFrame: CGRect?
    
    //文字
    private var index: Int?
    private let textList = ["运动", "睡眠", "体重", "心情", "血压", "心率"]
    
    //MARK:- init
    init(index: Int) {
        originFrame = CGRect(origin: CGPoint(x: view_size.width / 2 - originMainSubMenuButtonSize.width / 2 + CGFloat(index % 3 - 1) * 88,
                                             y: view_size.height - 49 * 6 + CGFloat(index / 3) * 88),
                             size: originMainSubMenuButtonSize)
        initFrame = CGRect(origin: CGPoint(x: view_size.width / 2 - originMainSubMenuButtonSize.width / 2,
                                           y: view_size.height + originMainSubMenuButtonSize.height / 2),
                           size: originMainSubMenuButtonSize)
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
            setImage(UIImage(named: "resource/submenuicon/\(i)")?.transfromImage(size: CGSize(width: 48, height: 48)), for: .normal)
            tag = i
        }
    }
    
    private func createContents(){
        
        guard let i = index else {
            return
        }
        
        let labelFrame = CGRect(x: 0, y: originMainSubMenuButtonSize.height - 17, width: originMainSubMenuButtonSize.width, height: 17)
        let label = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.textColor = .white
        label.text = textList[i]
        label.font = fontSmall
        addSubview(label)
    }
    
    func setHidden(flag: Bool){
        guard let i = index else {
            return
        }
        guard let initFrm = initFrame, let originFrm = originFrame else {
            return
        }
        
        let pos0 = CGPoint(x: view_size.width / 2, y: view_size.height + originFrm.height / 2)
        let pos2 = CGPoint(x: view_size.width / 2 + CGFloat(i % 3 - 1) * 88, y: view_size.height - 49 * 6 + CGFloat(i / 3) * 88)
        let pos1 = CGPoint(x: pos2.x - (pos2.x - pos0.x) * 0.05, y: pos2.y + (pos2.y - pos0.y) * 0.05)
        
        //动画
        let moveAnim = CAKeyframeAnimation(keyPath: "position")
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        let rotaAnim = CAKeyframeAnimation(keyPath: "transform.rotation")
        let pi = Double.pi * 2 * 2  //两圈
        let groupAnim = CAAnimationGroup()
        if flag{
            
            //隐藏
            if frame.origin.y < initFrm.origin.y {
                moveAnim.values = [NSValue(cgPoint: pos2), NSValue(cgPoint: pos1), NSValue(cgPoint: pos0)]
                moveAnim.keyTimes = [0, 0.2, 1]
            }
           
            scaleAnim.values = [1, 1.3, 0.85, 0.1]
            scaleAnim.keyTimes = [0, 0.3, 0.7, 1]
            
            opacityAnim.fromValue = 1
            opacityAnim.toValue = 0
            
            rotaAnim.values = [0, pi]
            rotaAnim.keyTimes = [0, 1]
            
            frame = initFrm

        }else{
            
            //显示
            moveAnim.values = [NSValue(cgPoint: pos0), NSValue(cgPoint: pos1), NSValue(cgPoint: pos2)]
            moveAnim.keyTimes = [0, 0.8, 1]
            
            scaleAnim.values = [0.1, 1.15, 0.9, 1]
            scaleAnim.keyTimes = [0, 0.5, 0.9, 1]
            
            opacityAnim.fromValue = 0
            opacityAnim.toValue = 1
            
            rotaAnim.values = [0, pi * 1.5, pi * 0.8, pi]
            rotaAnim.keyTimes = [0, 0.8, 0.95, 1]
            
            frame = originFrm
        }
        
        groupAnim.animations = [moveAnim, scaleAnim, opacityAnim]
        groupAnim.duration = 0.3 + CFTimeInterval(arc4random_uniform(30)) / 100
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeBoth
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layer.add(groupAnim, forKey: nil)
    }
}
