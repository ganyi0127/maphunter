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
    
//    fileprivate var type: DataCubeType!
//    
//    init(type: DataCubeType) {
//        super.init(nibName: "targetsetting", bundle: Bundle.main)
//        
//        self.type = type
//        
//        config()
//        createContents()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
