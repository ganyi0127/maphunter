//
//  ScanCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/3/15.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
enum BandIdType{
    case id100_102
    case id101
    case id107
    case id115
    case id119
    case undefined
}
class ScanCell: UITableViewCell {
    
    //MARK:- 名称
    var bandName: String?{
        didSet{
            guard let name = bandName else {
                return
            }
            
            if name.contains("100") || name.contains("102"){
                bandIdType = .id100_102
            }else if name.contains("101"){
                bandIdType = .id101
            }else if name.contains("107"){
                bandIdType = .id107
            }else if name.contains("115"){
                bandIdType = .id115
            }else if name.contains("119"){
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
    
    //MARK:- RSSI
    var bandRSSI: Int?{
        didSet{
            guard let rssi = bandRSSI else {
                return
            }
            
            var imageName: String
            let abs_rssi = abs(rssi)
            if abs_rssi > 98 {
                imageName = "resource/scan/rssi_0"
            }else if abs_rssi > 78{
                imageName = "resource/scan/rssi_1"
            }else if abs_rssi > 56{
                imageName = "resource/scan/rssi_2"
            }else{
                imageName = "resource/scan/rssi_3"
                if abs_rssi == 0 {
                    bindingImageView?.isHidden = false
                }
            }
            
            rssiLabel?.text = "RSSI: \(rssi)"
            
            guard let image = UIImage(named: imageName) else {
                return
            }
            rssiImageView?.image = image
        }
    }
    
    //图片
    private var idImageView: UIImageView?
    //名字
    private var nameLabel: UILabel?
    //rssi
    private var rssiImageView: UIImageView?
    private var rssiLabel: UILabel?
    //binding
    private var bindingImageView: UIImageView?
    
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
        gradient.backgroundColor = UIColor.white.cgColor
        gradient.cornerRadius =  view_size.width * 0.02
        gradient.shadowColor = UIColor.gray.cgColor
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
        
        if rssiImageView == nil{
            let imageFrame = CGRect(x: view_size.width * 0.35,
                                    y: view_size.width * 0.08 + 30,
                                    width: view_size.width * 0.05,
                                    height: view_size.width * 0.05)
            rssiImageView = UIImageView(frame: imageFrame)
            addSubview(rssiImageView!)
        }
        
        if rssiLabel == nil{
            let labelFrame = CGRect(x: view_size.width * 0.35 + view_size.width * 0.06,
                                    y: view_size.width * 0.08 + 30,
                                    width: view_size.width * 0.5,
                                    height: 24)
            rssiLabel = UILabel(frame: labelFrame)
            rssiLabel?.font = fontSmall
            rssiLabel?.textColor = .gray
            addSubview(rssiLabel!)
        }
        
        if bindingImageView == nil{
            let imageFrame = CGRect(x: view_size.width * 0.94 - view_size.width * 0.03 - 24,
                                    y: view_size.width * 0.08,
                                    width: 24,
                                    height: 24)
            bindingImageView = UIImageView(frame: imageFrame)
            if let image = UIImage(named: "resource/scan/connected") {
                bindingImageView?.image = image
            }
            bindingImageView?.isHidden = true
            addSubview(bindingImageView!)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
}
