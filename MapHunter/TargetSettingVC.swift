//
//  TargetSettingVC.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
import UIKit
class TargetSettingVC: UIViewController {
    
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    private func config(){
        
        navigationItem.hidesBackButton = true
    }
    
    private func createContents(){
        
    }
}

extension TargetSettingVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }
}
