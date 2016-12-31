//
//  WeightEditVC.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/31.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class WeightEditVC: UIViewController {
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

extension WeightEditVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }
}
