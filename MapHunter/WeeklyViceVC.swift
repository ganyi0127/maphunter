//
//  WeeklyViceVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/10.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class WeeklyViceVC: UIViewController {
    
    var view0: UIView!
    var view1: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    func config(){
        
        let topHeight: CGFloat = 64
        let subViewWidth = view_size.width - edgeWidth * 2
        let subViewHeight = (view_size.height - topHeight - edgeWidth * 4) / 2
        
        let frame0 = CGRect(x: edgeWidth, y: topHeight + edgeWidth, width: subViewWidth, height: subViewHeight)
        view0 = UIView(frame: frame0)
        view0.layer.cornerRadius = weeklyRadius
        view.addSubview(view0)
        
        let frame1 = CGRect(x: edgeWidth, y: view_size.height - edgeWidth - subViewHeight, width: subViewWidth, height: subViewHeight)
        view1 = UIView(frame: frame1)
        view1.layer.cornerRadius = weeklyRadius
        view.addSubview(view1)
    }
    
    func createContents(){
        
    }
}
