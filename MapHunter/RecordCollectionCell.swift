//
//  RecordCollectionCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class RecordCollectionCell: UICollectionViewCell {
    
    var type: SportType?{
        didSet{
            guard let t = type else {
                imageView?.image = nil
                label?.text = ""
                return
            }
            
            let name = sportTypeNameMap[t]!
        
            let originImage = UIImage(named: "resource/sporticons/icon/" + name)?.transfromImage(size: imageView!.bounds.size)
            let image = isSelected ? originImage?.withRenderingMode(.alwaysOriginal) : originImage?.withRenderingMode(.alwaysTemplate)
            imageView?.image = image
            
            label?.text = name
            label?.textColor = isSelected ? .white : defaut_color
            
            createContents()
        }
    }
    
    private lazy var imageView: UIImageView? = {
        let length: CGFloat = 140 * 2 / 3
        let imageViewFrame = CGRect(x: (self.bounds.width - length) / 2, y: (self.bounds.height - length) / 2, width: length, height: length)
        let imageView: UIImageView = UIImageView(frame: imageViewFrame)
        imageView.tintColor = defaut_color
        return imageView
    }()
    
    private lazy var label: UILabel? = {
        let labelFrame = CGRect(x: 0, y: self.bounds.height * 0.75, width: self.bounds.width, height: self.bounds.height * 0.25)
        let label: UILabel = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.font = fontTiny
        label.textColor = .clear
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            backgroundColor = isSelected ? defaut_color : .white
            if let img = imageView?.image{
                imageView?.image = isSelected ? img.withRenderingMode(.alwaysOriginal) : img.withRenderingMode(.alwaysTemplate)
            }
            label?.textColor = isSelected ? .white : defaut_color
        }
    }
    
    //MARK:- 运动类型子页
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        createContents()
    }
    
    private func config(){
        backgroundColor = .white
    }
    
    private func createContents(){
        
        addSubview(imageView!)
        addSubview(label!)
    }
}
