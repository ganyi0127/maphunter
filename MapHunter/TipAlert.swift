//
//  TipAlert.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/2.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class TipAlert: UIView {
    
    //MARK:- init************************************************************
    init(){
        let height = view_size.height * 0.2
        let width = view_size.width - 16 * 2
        let frame = CGRect(x: view_size.width / 2 - width / 2, y: view_size.height / 2 - height / 2, width: width, height: height)
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        layer.cornerRadius = 2
        backgroundColor = .white
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
    }
    
    func createContents(){
        
        //取消按钮
        let cancelButtonSize = CGSize(width: 26, height: 26)
        let cancelButtonFrame = CGRect(x: frame.width - cancelButtonSize.width - 4, y: 4, width: cancelButtonSize.width, height: cancelButtonSize.height)
        let cancelButton = UIButton(frame: cancelButtonFrame)
        cancelButton.setImage(UIImage(named: "resource/time/tipicon_selected")?.transfromImage(size: cancelButtonSize), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
        addSubview(cancelButton)
        
    }
    
    @objc func cancel(sender: UIButton){
        removeFromSuperview()
    }
}
