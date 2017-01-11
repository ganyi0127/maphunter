//
//  FunOriginViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class FunOriginViewController: UIViewController {
    
    var customTitle: String?    //名字
    var isOpen = false          //判断是否点开
    
    //点击事件
    private var tap: UITapGestureRecognizer?
    
    //回调
    var closure: (()->())?
    
    //MARK:- init
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        config()
        createContents()
    }
    
    deinit {
        if let t = tap {
            view.removeGestureRecognizer(t)
        }
    }
    
    func config(){
        
        view.layer.cornerRadius = 20
        
//        view.isUserInteractionEnabled = true
//        tap = UITapGestureRecognizer(target: self, action: #selector(tap(recognizer:)))
//        tap?.numberOfTouchesRequired = 1
//        tap?.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tap!)
    }
    
    func createContents(){
        
    }
    
//    @objc private func tap(recognizer: UITapGestureRecognizer){
//        closure?()
//    }
}
