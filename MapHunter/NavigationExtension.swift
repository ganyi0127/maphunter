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
        navigationBar.tintColor = UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
        
        navigationBar.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
//        navigationBar.isTranslucent = false
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
