//
//  AlertExtension.swift
//  MapHunter
//
//  Created by YiGan on 21/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
extension UIAlertController{
    func setBlackTextColor(){
        
//        var count: uint = 0
//        let ivars = class_copyIvarList(UIAlertController.classForCoder(), &count)
//        (0..<count).forEach(){
//            i in
//            debugPrint("\n\n", i)
//            let ivar = ivars?[Int(i)]
//            let name = ivar_getName(ivar)
//            let varName = String(cString: name!)
//            debugPrint("ivar:\n", ivar!, "\nname:\n", varName)
//        }
        
        //设置所有action颜色
        actions.forEach(){$0.setBlackTextColor()}
    }
}

extension UIAlertAction{
    func setBlackTextColor(){
        setValue(UIColor.black, forKey: "titleTextColor")
    }
}
