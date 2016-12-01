//
//  NavigationExtension.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
extension UINavigationController:UINavigationControllerDelegate{
    
    open override func awakeFromNib() {
        
        delegate = self
        
        //初始化存储navigation高度
        if navigation_height == nil{
            navigation_height = navigationBar.frame.height
        }
        
        navigationBar.topItem?.title = "FunSport"
        
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: font_name, size: 17)!,
                                             NSForegroundColorAttributeName: UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)]
        
        navigationBar.tintColor = UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
        
        navigationBar.backgroundColor = defaultColor
        
        let image = UIImage(named: "navigation_back")
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
                
                let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(sender:)))
                viewController.navigationItem.rightBarButtonItem = shareBarButton
            }
        }else{
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    //MARK:分享
    @objc private func share(sender: UIBarButtonItem){
        
        print("share action")
    }
}
