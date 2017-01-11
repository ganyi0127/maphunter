//
//  PathViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathViewController: FunOriginViewController {

    override func config() {
        super.config()
        
        customTitle = "轨迹"        
    }
    
    override func createContents() {
        super.createContents()
        
    }
    
    @IBAction func test(_ sender: UIButton) {
        
        let mapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map") as! MapVC
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
