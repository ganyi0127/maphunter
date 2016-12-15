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
    private var menuButtonFlag: Bool = false{
        didSet{
            if menuButtonFlag{
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = 0
                animation.toValue = M_PI_2 / 2 + M_PI
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                menuButton.layer.add(animation, forKey: nil)
                
                //添加高斯模糊
                self.selectedViewController?.view.addSubview(effectView)
                effectView.addGestureRecognizer(tap)
                
                //隐藏tabbar
                let tabbarFrame = self.tabBar.frame
                let offsetY:CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : tabbarFrame.height
                let buttonFrame = menuButton.frame
                let buttonOffsetY: CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : -tabbarFrame.height * 2.2
                let duration: TimeInterval = 0.1
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.tabBar.frame = tabbarFrame.offsetBy(dx: 0, dy: offsetY)
                    self.menuButton.frame = buttonFrame.offsetBy(dx: 0, dy: buttonOffsetY)
                }){
                    complete in
                    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        let buttonOffsetY: CGFloat = tabbarFrame.origin.y > view_size.height ? 0 : -tabbarFrame.height * 2
                        self.menuButton.frame = buttonFrame.offsetBy(dx: 0, dy: buttonOffsetY)
                    }, completion: nil)
                }
                
            }else{
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 0.2
                animation.repeatCount = 1
                animation.fromValue = M_PI_2 / 2 + M_PI
                animation.toValue = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeBoth
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                menuButton.layer.add(animation, forKey: nil)
                
                //移除高斯模糊
                effectView.removeGestureRecognizer(tap)
                effectView.removeFromSuperview()
                
                //显示tabbar
                var tabbarFrame = self.tabBar.frame
                tabbarFrame.origin.y = view_size.height - tabbarFrame.height
                var buttonFrame = menuButton.frame
                buttonFrame.origin.y = -buttonFrame.width * 0.3
                let duration: TimeInterval = 0.1
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.tabBar.frame = tabbarFrame
                    self.menuButton.frame = buttonFrame
                }, completion: nil)
            }
        }
    }
    
    //按钮
    private lazy var menuButton: UIButton! = { () -> UIButton in
        let menuButtonWidth = view_size.width * 0.2
        let menuButtonFrame = CGRect(x: view_size.width / 2 - menuButtonWidth / 2,
                                     y: -menuButtonWidth * 0.3,
                                     width: menuButtonWidth,
                                     height: menuButtonWidth)
        let menuButton = UIButton(frame: menuButtonFrame)
        let image = UIImage(named: "resource/tabbar/main")
        menuButton.setImage(image, for: .normal)
        menuButton.addTarget(self, action: #selector(clickMenuButton(sender:)), for: .touchUpInside)
        return menuButton
    }()
    
    
    //取消点击事件
    private var tap: UITapGestureRecognizer{
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(recognizer:)))
        tap.numberOfTapsRequired = 1
        return tap
    }
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
    //MARK:- init
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
        
        tabBar.addSubview(menuButton)
        menuButtonFlag = false
    }
    
    //MARK:- 点击展开按钮
    @objc private func clickMenuButton(sender: UIButton){
        menuButtonFlag = !menuButtonFlag
    }
    
    //MARK:- 点击关闭按钮
    @objc private func tap(recognizer: UITapGestureRecognizer){
        clickMenuButton(sender: menuButton)
    }
}
