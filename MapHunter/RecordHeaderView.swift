//
//  RecordHeaderView.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordHeaderView: UIView {
    
    private var type: RecordType!
    
    //图片背景
    private lazy var sportImageView: UIImageView? = {
        let length: CGFloat = min(self.bounds.width, self.bounds.height) * 0.8
        let imageFrame = CGRect(x: (self.bounds.width - length) / 2, y: (self.bounds.height - length) / 2, width: length, height: length)
        let imageView = UIImageView(frame: imageFrame)
        return imageView
    }()
    var sportType: SportType?{
        didSet{
            guard let t = sportType else {
                return
            }
            
            if let name = sportTypeNameMap[t]{
                let image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: sportImageView!.bounds.size)
                sportImageView?.image = image
            }else{
                sportImageView?.image = nil
            }
        }
    }
    
    //MARK:- init
    init(withRecordType type: RecordType, top: CGFloat, bottom: CGFloat) {
        let frame = CGRect(x: 0, y: top - 8, width: view_size.width, height: bottom - (top - 8) - 22)
        super.init(frame: frame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = .clear
    }
    
    private func createContents(){
        switch type as RecordType {
        case .sport:
            addSubview(sportImageView!)
        default:
            break
        }
    }
}
