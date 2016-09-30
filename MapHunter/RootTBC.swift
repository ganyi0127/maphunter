//
//  RootTBVC.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
class RootTBC: UITabBarController {
    
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
        
    }
}
