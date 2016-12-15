//
//  ImageExtension.swift
//  MapHunter
//
//  Created by YiGan on 12/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
extension UIImage{
    
    //MARK:- 根据尺寸重新绘制图像
    func transfromImage(size: CGSize) -> UIImage?{
        let resultSize = CGSize(width: size.width * 2, height: size.height * 2)
        UIGraphicsBeginImageContext(resultSize)
        self.draw(in: CGRect(origin: .zero, size: resultSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: result!.cgImage!, scale: 2, orientation: UIImageOrientation.up)
    }
}
