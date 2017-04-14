//
//  BootScanCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootScanCell: UITableViewCell {
    
    //名字
    private var nameLabel: UILabel?
    
    //MARK:- 名称
    var bandName: String?{
        didSet{
            let name = bandName?.lowercased().replacingOccurrences(of: " ", with: "")
            
            if name == "id107plus" || name == "id107plushr"{
                bandIdType = .id107plus
            }else if name == "id119"{
                bandIdType = .id119
            }else if name == "id127"{
                bandIdType = .id127
            }else if name == "id129"{
                bandIdType = .id129
            }else{
                bandIdType = .undefined
            }
            
            nameLabel?.text = name?.uppercased()
        }
    }
    
    //MARK:- id型号
    private var bandIdType: BandIdType?{
        didSet{
            
            guard let type = bandIdType else {
                return
            }
            
            var imageName: String
            switch type {
            case .id107plus:
                imageName = "resource/scan/id107plus_side"
            case .id119:
                imageName = "resource/scan/id119_side"
            case .id127:
                imageName = "resource/scan/id127_side"
            case .id129:
                imageName = "resource/scan/id129_side"
            default:
                imageName = "resource/scan/undefined_side"
            }
            guard let image = UIImage(named: imageName) else {
                return
            }
            idImageView?.image = image
        }
    }
    
    //图片
    private var idImageView: UIImageView?
    
    //MARK:- init
    init(identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        //手动添加分割线
        let separatorFrame = CGRect(x: 0, y: view_size.width * 0.25 - 1, width: frame.width, height: 1)
        let separatorLine = UIView(frame: separatorFrame)
        separatorLine.backgroundColor = lightWordColor
        contentView.addSubview(separatorLine)
    }
    
    private func config(){
        
        //设置分割线
//        separatorInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//        if responds(to: #selector(setter: BootCell.layoutMargins)) {
//            layoutMargins = UIEdgeInsets(top: 1, left: 11, bottom: 1, right: 1)
//        }
//        if responds(to: #selector(setter: BootCell.preservesSuperviewLayoutMargins)) {
//            preservesSuperviewLayoutMargins = false
//        }
        
    }
    
    private func createContents(){
        
        //手环图片
        if idImageView == nil{
            let imageFrame = CGRect(x: view_size.width * 0.6,
                                    y: view_size.width * 0.01,
                                    width: view_size.width * 0.35,
                                    height: view_size.width * 0.35)
            idImageView = UIImageView(frame: imageFrame)
            let maskLayer = CAShapeLayer()
            let maskRect = CGRect(x: -imageFrame.origin.x,
                                  y: -imageFrame.origin.y,
                                  width: view_size.width * 1,
                                  height: view_size.width * 0.25 - 1)
            maskLayer.path = UIBezierPath(rect: maskRect).cgPath
            idImageView?.layer.mask = maskLayer
            contentView.addSubview(idImageView!)
        }
        
        //手环名称
        if nameLabel == nil{
            let labelFrame = CGRect(x: view_size.width * 0.1,
                                    y: view_size.width * 0.1,
                                    width: view_size.width * 0.5,
                                    height: fontBig.pointSize)
            nameLabel = UILabel(frame: labelFrame)
            nameLabel?.font = fontBig
            nameLabel?.textColor = .black
            contentView.addSubview(nameLabel!)
        }
    }
}
