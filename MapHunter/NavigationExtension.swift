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
    }
    
    //切换界面时调用_手环按钮
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //判断是否为根视图
        if viewControllers.count == 1{
            if navigationItem.leftBarButtonItem == nil {
                
                let linkBarButton = ItemButton(buttonType: .link)
                viewController.navigationItem.leftBarButtonItem = linkBarButton
            }
            
        }else{
            navigationItem.leftBarButtonItem = nil
        }
    }
}
