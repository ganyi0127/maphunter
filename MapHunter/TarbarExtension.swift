//
//  TarbarExtension.swift
//  MapHunter
//
//  Created by YiGan on 30/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
extension UITabBarController{
    
    open override func awakeFromNib() {
        
        tabBar.tintColor = UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
        
        //修改底图
        if let backImage = UIImage(named: "tarbar_back"){
            let tabbarSize = tabBar.frame.size
            tabBar.backgroundImage = getImage(image: backImage, size: tabbarSize)
            tabBar.shadowImage = UIImage()
        }
    }
    
    private func getImage(image: UIImage, size: CGSize) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
