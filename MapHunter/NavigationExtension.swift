//
//  NavigationExtension.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
extension UINavigationController: UINavigationControllerDelegate{
    
    open override func awakeFromNib() {
        
        delegate = self
        
        //初始化存储navigation高度
        if navigation_height == nil{
            navigation_height = navigationBar.frame.height
        }
        
        
        
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: font_name, size: 17)!,
                                             NSForegroundColorAttributeName: UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)]
        
        navigationBar.tintColor = UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
        
        navigationBar.backgroundColor = defaultColor
        
        let image = UIImage(named: "resource/navigation_back")?.transfromImage(size: CGSize(width: view_size.width, height: navigation_height! + 64))
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    //切换界面时调用_手环按钮
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //判断是否为根视图
        if viewControllers.count == 1{
            if navigationItem.leftBarButtonItem == nil {
                
                let linkBarButton = ItemButton(buttonType: .link)
                viewController.navigationItem.leftBarButtonItem = linkBarButton
            }
            
            if navigationItem.rightBarButtonItem == nil && viewController.isKind(of: StateVC.self){
                
                let image = UIImage(named: "resource/icon_calendar")
                let imageSize = CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6)
                let calenderBarButton = UIBarButtonItem(image: image?.transfromImage(size: imageSize), style: .done, target: self, action: #selector(switchCalender(sender:)))
                viewController.navigationItem.rightBarButtonItem = calenderBarButton
            }
            
            //设置显示navigation
            var image: UIImage!
            if viewController.isKind(of: MapVC.self){
                //地图页面置透明
                image = UIImage(named: "resource/navigation_alpha")
                
                navigationBar.topItem?.title = nil
            }else{
                //设置为不透明
                image = UIImage(named: "resource/navigation_back")?.transfromImage(size: CGSize(width: view_size.width, height: navigation_height! + 64))
                
                navigationBar.topItem?.title = "FunSport"
            }
            navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.backgroundColor = .clear
            
            //显示tabbar
            setTabbar(hidden: false)
        }else{
            navigationItem.leftBarButtonItem = nil
            
            //设置navigation透明
            let image = UIImage(named: "resource/navigation_alpha")
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.backgroundColor = nil
            
            //隐藏tabbar
            setTabbar(hidden: true)
        }
    }
    
    //MARK:分享
    @objc private func switchCalender(sender: UIBarButtonItem){
        notiy.post(name: calendar_notiy, object: nil)
    }
    
    //MARK:- 控制tabbar显示与隐藏
    public func setTabbar(hidden flag: Bool){
        
        var tabbarFrame = tabBarController!.tabBar.frame
        
        if flag {
            //隐藏tabbar
            if tabbarFrame.origin.y < view_size.height {
                
                let offsetY:CGFloat = tabbarFrame.height + view_size.width * 0.06
                let duration: TimeInterval = 0.2
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    self.tabBarController?.tabBar.frame = tabbarFrame.offsetBy(dx: 0, dy: offsetY)
                }, completion: nil)
            }
        }else{
            //显示tabbar

            if tabbarFrame.origin.y >= view_size.height{
                
                tabbarFrame.origin.y = view_size.height - tabbarFrame.height
                let duration: TimeInterval = 0.2
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    self.tabBarController?.tabBar.frame = tabbarFrame
                }, completion: nil)
            }
        }
    }
    
    //MARK:- 转场代理实现
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //状态页自定义切换
        if fromVC.isKind(of: StateVC.self) || toVC.isKind(of: StateVC.self) {
            
            if operation == .push{
                return CustomAnimationController()
            }
            return CustomPopAnimatation()
        }
        
        return nil
    }
}

