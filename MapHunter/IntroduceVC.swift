//
//  IntroduceVC.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class IntroduceVC: UIViewController {
    
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

extension IntroduceVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }
}
