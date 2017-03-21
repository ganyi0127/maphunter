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
        
        let hfactor = self.size.width / size.width
        let vfactor = self.size.height / size.height
        let factor = fmax(hfactor, vfactor)
        
        let scale: CGFloat = 2
        let newWidth = size.width * scale
        let newHeight = size.height * scale
//        let newWidth = self.size.width / factor
//        let newHeight = self.size.height / factor
        let resultSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(resultSize)
        self.draw(in: CGRect(origin: .zero, size: resultSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       
//        let data = UIImagePNGRepresentation(result!)
//        return UIImage(data: data!)
        return UIImage(cgImage: result!.cgImage!, scale: scale, orientation: UIImageOrientation.up)
    }
}
