//
//  EntranceView.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/28.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class EntranceView: UIView {
    
    var title: String?{
        didSet{
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let labelFrame = CGRect(x: 8, y: 8, width: 120, height: 20)
        let label = UILabel(frame: labelFrame)
        label.textAlignment = .left
        label.font = fontMiddle
        label.textColor = .white
        return label
    }()
    
    private var tap: UITapGestureRecognizer?
    var closure: ((_ tag: Int)->())?
    
    //MARK:-init*******************************************************************
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        config()
        createContents()
    }
    
    override func removeFromSuperview() {
        if let t = tap{
            removeGestureRecognizer(t)
        }
        super.removeFromSuperview()
    }
    
    func config(){
        
        layer.cornerRadius = 2
        
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
    
    @objc private func click(recognizer: UITapGestureRecognizer){
        closure?(tag)
    }
    
    func createContents(){
        
        addSubview(titleLabel)
    }
}
