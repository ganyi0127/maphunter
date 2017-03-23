//
//  ViewControllerExtension.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/19.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import UIKit
private var loading: Loading?
extension UIViewController{
    open override func awakeFromNib() {
        didReceiveMemoryWarning()
        
         let firstMethod = class_getInstanceMethod(self.classForCoder,#selector(didReceiveMemoryWarning))
         let secondMethod = class_getInstanceMethod(self.classForCoder,#selector(didReceiveCurrentWarning))
        method_exchangeImplementations(firstMethod, secondMethod)
    }
    
    func didReceiveCurrentWarning(){
        debugPrint("memory warning: \(self)")
        if view.window == nil || !isViewLoaded{
            view = nil
        }
        debugPrint("<clear>memory warning: \(self)")
        //if self.isViewLoaded && view.window != nil
    }
    
    //loading实现
    func beginLoading(){
        if loading == nil{
            loading = Loading()
        }else if loading?.superview != nil{
            loading?.removeFromSuperview()
        }
        
        loading?.alpha = 0
        self.view.addSubview(loading!)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            loading?.alpha = 1
        }, completion: nil)
    }
    
    func endLoading(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            loading?.alpha = 0
        }, completion: {
            _ in
            loading?.alpha = 1
            loading?.removeFromSuperview()
        })
    }
}
