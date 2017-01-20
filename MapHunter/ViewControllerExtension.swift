//
//  ViewControllerExtension.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/19.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    open override func awakeFromNib() {
        didReceiveMemoryWarning()
        
         let firstMethod = class_getInstanceMethod(self.classForCoder,#selector(didReceiveMemoryWarning))
         let secondMethod = class_getInstanceMethod(self.classForCoder,#selector(didReceiveCurrentWarning))
        method_exchangeImplementations(firstMethod, secondMethod)
    }
    
    func didReceiveCurrentWarning(){
        debugPrint("memory warning: \(self)")
//        view = nil
    }
}
