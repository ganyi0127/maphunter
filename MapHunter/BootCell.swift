//
//  BootCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class BootCell: UICollectionViewCell {
    
//    var index: Int?{
//        didSet{
//            if index == oldValue {
//                return
//            }
//            guard let i = index else {
//                return
//            }
//            backImageView?.image = backImages[i]
//            frontImageView?.image = frontImages[i]
//        }
//    }
    
//    private let frontImages = [UIImage(named: "resource/boot/main/0_1")?.transfromImage(size: view_size),
//                               UIImage(named: "resource/boot/main/1_1")?.transfromImage(size: view_size),
//                               UIImage(named: "resource/boot/main/2_1")?.transfromImage(size: view_size),
//                               UIImage(named: "resource/boot/main/3_1")?.transfromImage(size: view_size)]
//    private let backImages = [UIImage(named: "resource/boot/main/0_2")?.transfromImage(size: view_size),
//                              UIImage(named: "resource/boot/main/1_2")?.transfromImage(size: view_size),
//                              UIImage(named: "resource/boot/main/2_2")?.transfromImage(size: view_size),
//                              UIImage(named: "resource/boot/main/3_2")?.transfromImage(size: view_size)]
    
//    private var backImageView: UIImageView?
//    private var frontImageView: UIImageView?
    
    //MARK:- 导航子页
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
        createContents()
    }
    
    
    private func config(){
        
    }
    
    private func createContents(){
//        backImageView = UIImageView(frame: CGRect(origin: .zero, size: view_size))
//        backImageView?.layer.zPosition = 1
//        addSubview(backImageView!)
//        
//        frontImageView = UIImageView(frame: CGRect(origin: .zero, size: view_size))
//        frontImageView?.layer.zPosition = 10
//        addSubview(frontImageView!)
    }
}
