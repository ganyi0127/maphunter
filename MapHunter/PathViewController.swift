//
//  PathViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathViewController: FunOriginViewController {

    @IBOutlet weak var testButton: UIButton!
    override func config() {
        super.config()
        
        customTitle = "轨迹"        
    }
    
    override func createContents() {
        super.createContents()
        
    }
    
    override func click(location: CGPoint) {
        super.click(location: location)
        
        let layer = view.layer.hitTest(location)
        
        if layer == testButton.layer {
            pushMap()
        }
    }
    
    @IBAction func test(_ sender: UIButton) {
        
        pushMap()
    }
    
    //MARK:- 切换到地图页面
    private func pushMap(){
        
        let mapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map") as! MapVC
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
