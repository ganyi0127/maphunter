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
    open var isOpen = false          //判断是否点开
    private let lightImageView = UIImageView()      //光效
    
    //点击事件
    private var tap: UITapGestureRecognizer?
    
    //回调
    var closure: ((_ open: Bool)->())?
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        if let t = tap {
            view.removeGestureRecognizer(t)
        }
    }
    
    func config(){
        
        //设置圆角mask
        let bezier = UIBezierPath(roundedRect: CGRect(origin: .zero, size: view_size), cornerRadius: 20)
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezier.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        view.layer.mask = maskLayer
        view.layer.shouldRasterize = true       //光栅化
        
        //设置点击事件
        view.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(tap(recognizer:)))
        tap?.numberOfTouchesRequired = 1
        tap?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap!)
    }
    
    func createContents(){
        
        //光效 动画
        lightImageView.frame = view.frame
        var images = [UIImage]()
        (0..<9).forEach(){
            i in
            let name = "resource/map/light/\(i)"
            if let img = UIImage(named: name){
                images.append(img)
            }
        }
        lightImageView.animationImages = images
        lightImageView.animationDuration = 0.5
        lightImageView.animationRepeatCount = 1
        lightImageView.startAnimating()
        view.addSubview(lightImageView)
    }
    
    //MARK:- 强制点击事件
    func click(location: CGPoint, open: Bool = true){
//        closure?(open)
//        
//        //打开与关闭状态
//        isOpen = open
//        if isOpen {
//            //延迟调用光效动画
//            _ = delay(0.5){
//                if self.isOpen{
//                    self.lightImageView.startAnimating()
//                }
//            }
//        }
    }
    
    //MARK:- 默认点击事件（3d下无法获取）
    @objc private func tap(recognizer: UITapGestureRecognizer){
//        isOpen = false
//        closure?(isOpen)
        
        lightImageView.stopAnimating()
    }
}
