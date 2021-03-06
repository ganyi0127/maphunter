//
//  ScanCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/3/15.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
enum BandIdType{
    case id107plus
    case id119
    case id127
    case id129
    case undefined
}
class ScanCell: UITableViewCell {
    
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
            case .id107plus:
                imageName = "resource/scan/id107plus"
            case .id119:
                imageName = "resource/scan/id119"
            case .id127:
                imageName = "resource/scan/id127"
            case .id129:
                imageName = "resource/scan/id129"
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
            }
            
            //显示绑定或选中
            if abs_rssi == 0 || isSelected {
                bindingImageView?.isHidden = false
                if isSelected {
                    bindingImageView?.image = UIImage(named: "resource/scan/checkmark")
                }else{
                    bindingImageView?.image = UIImage(named: "resource/scan/connected")
                }
            }else{
                bindingImageView?.isHidden = true
            }
            
            rssiLabel?.text = "RSSI: \(abs_rssi)"
            
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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        //手动添加分割线
        let separatorFrame = CGRect(x: 0, y: 88 - 1, width: view_size.width, height: 1)
        let separatorLine = UIView(frame: separatorFrame)
        separatorLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addSubview(separatorLine)
    }
    
    private func config(){
        
        backgroundColor = .white
    }
    
    private func createContents(){
        
        //绘制渐变
//        gradient.frame = CGRect(x: view_size.width * 0.03,
//                                y: view_size.width * 0.03,
//                                width: view_size.width * 0.94,
//                                height: view_size.width * 0.94 * 200 / 718 + view_size.width * 0.03)
//        gradient.backgroundColor = UIColor.white.cgColor
//        gradient.cornerRadius =  view_size.width * 0.02
//        gradient.shadowColor = UIColor.gray.cgColor
//        gradient.shadowRadius = 2
//        gradient.shadowOffset = .zero
//        gradient.shadowOpacity = 0.5
//        layer.addSublayer(gradient)
        
        let cellHeight: CGFloat = 88    //view_size.width / 3
        let cellToTop: CGFloat = 88 / 2 - 24 - 6 / 2
        
        if idImageView == nil{
            let imageFrame = CGRect(x: view_size.width * 0.05,
                                    y: cellToTop / 2,
                                    width: view_size.width * 0.2,
                                    height: cellHeight - cellToTop)
            idImageView = UIImageView(frame: imageFrame)
            addSubview(idImageView!)
        }
        
        if nameLabel == nil{
            let labelFrame = CGRect(x: view_size.width * 0.4,
                                    y: cellToTop,
                                    width: view_size.width * 0.5,
                                    height: 24)
            nameLabel = UILabel(frame: labelFrame)
            nameLabel?.font = fontMiddle
            nameLabel?.textColor = .black
            addSubview(nameLabel!)
        }
        
        if rssiImageView == nil{
            let imageFrame = CGRect(x: view_size.width * 0.4,
                                    y: cellToTop + 30,
                                    width: view_size.width * 0.05,
                                    height: view_size.width * 0.05)
            rssiImageView = UIImageView(frame: imageFrame)
            addSubview(rssiImageView!)
        }
        
        if rssiLabel == nil{
            let labelFrame = CGRect(x: view_size.width * 0.4 + view_size.width * 0.06,
                                    y: cellToTop + 30,
                                    width: view_size.width * 0.5,
                                    height: 24)
            rssiLabel = UILabel(frame: labelFrame)
            rssiLabel?.font = fontSmall
            rssiLabel?.textColor = .gray
            addSubview(rssiLabel!)
        }
        
        if bindingImageView == nil{
            let imageLenght: CGFloat = 18
            let imageFrame = CGRect(x: view_size.width * 0.94 - view_size.width * 0.03 - imageLenght,
                                    y: cellHeight / 2 - imageLenght / 2,
                                    width: imageLenght,
                                    height: imageLenght)
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
