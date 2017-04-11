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
            
            if name == "id100" || name == "id102"{
                bandIdType = .id100_102
            }else if name == "id101"{
                bandIdType = .id101
            }else if name == "id107" || name == "id107plus" || name == "id107plushr"{
                bandIdType = .id107
            }else if name == "id115"{
                bandIdType = .id115
            }else if name == "id119"{
                bandIdType = .id119
            }else{
                bandIdType = .undefined
            }
            
            nameLabel?.text = name
        }
    }
    
    //MARK:- id型号
    private var bandIdType: BandIdType?{
        didSet{
            //            createContents()
            
            guard let type = bandIdType else {
                return
            }
            
            var imageName: String
            switch type {
            case .id100_102:
                imageName = "resource/scan/id100_102"
            case .id101:
                imageName = "resource/scan/id101"
            case .id107:
                imageName = "resource/scan/id107"
            case .id115:
                imageName = "resource/scan/id115"
            case .id119:
                imageName = "resource/scan/id119"
            default:
                imageName = "resource/scan/undefined"
            }
            guard let image = UIImage(named: imageName) else {
                return
            }
            idImageView?.image = image
        }
    }
    
    //图片
    private var idImageView: UIImageView?
    
    //底图渐变
    let gradient = CAGradientLayer()
    
    
    
    
    //MARK:- init
    init(identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        backgroundColor = timeColor
    }
    
    private func createContents(){
        
        //绘制渐变
        gradient.frame = CGRect(x: view_size.width * 0.03,
                                y: view_size.width * 0.03,
                                width: view_size.width * 0.94,
                                height: view_size.width * 0.94 * 200 / 718 + view_size.width * 0.03)
        gradient.backgroundColor = UIColor.darkGray.cgColor
        gradient.cornerRadius =  view_size.width * 0.02
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowRadius = 2
        gradient.shadowOffset = .zero
        gradient.shadowOpacity = 0.5
        layer.addSublayer(gradient)

        if idImageView == nil{
            let imageFrame = CGRect(x: view_size.width * 0.03,
                                    y: view_size.width * 0.03,
                                    width: view_size.width * 0.2,
                                    height: view_size.width * 0.94 * 200 / 718 + view_size.width * 0.03)
            idImageView = UIImageView(frame: imageFrame)
            addSubview(idImageView!)
        }
        
        if nameLabel == nil{
            let labelFrame = CGRect(x: view_size.width * 0.35,
                                    y: view_size.width * 0.08,
                                    width: view_size.width * 0.5,
                                    height: 24)
            nameLabel = UILabel(frame: labelFrame)
            nameLabel?.font = fontMiddle
            nameLabel?.textColor = .black
            addSubview(nameLabel!)
        }
    }
}
