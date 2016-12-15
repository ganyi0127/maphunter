//
//  ViewExtension.swift
//  MapHunter
//
//  Created by YiGan on 15/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
extension UIView{
    func viewController() -> UIViewController{
        var result: AnyObject! = self
        while result != nil {
            result = (result as! UIResponder).next
            if result.isKind(of: UIViewController.self) {
                break
            }
        }
        
        return result as! UIViewController
    }
}
