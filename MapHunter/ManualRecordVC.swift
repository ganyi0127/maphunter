//
//  ManualRecordVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
enum RecordType: Int{
    case sport = 0, sleep, weight, mood, bloodPressure, heartrate
}

class ManualRecordVC: UIViewController {
    
    var type: RecordType!
    
    
    //MARK:- init**************************************************************************************************
    init(withRecordType type: RecordType){
        super.init(nibName: nil, bundle: nil)
        
        //存储类型
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        
        //绘制背景
        view.backgroundColor = .white
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let startColor = recordStartColors[type!]!
        let endColor = recordEndColors[type!]!
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.addSublayer(gradient)    
    }
    
    func createContents(){
        
        //设置按钮图片大小
        let buttonImageSize = CGSize(width: 20, height: 20)
        
        //添加取消按钮
        let refuseButtonFrame = CGRect(x: 0, y: 20, width: 64, height: 44)
        let refuseButton = UIButton(frame: refuseButtonFrame)
        if let img = UIImage(named: "resource/target/target_refuse_normal")?.transfromImage(size: buttonImageSize){
            refuseButton.setImage(img, for: .normal)
        }
        refuseButton.addTarget(self, action: #selector(refuse(sender:)), for: .touchUpInside)
        view.addSubview(refuseButton)
        
        //添加确认按钮
        let acceptButtonFrame = CGRect(x: view_size.width - 64, y: 20, width: 64, height: 44)
        let acceptButton = UIButton(frame: acceptButtonFrame)
        if let img = UIImage(named: "resource/target/target_accept_normal")?.transfromImage(size: buttonImageSize){
            acceptButton.setImage(img, for: .normal)
        }
        acceptButton.addTarget(self, action: #selector(accept(sender:)), for: .touchUpInside)
        view.addSubview(acceptButton)
        
        //添加记录选择器
        let recordTableView = RecordTableView(withRecordType: type)
        view.addSubview(recordTableView)
    }
    
    //MARK:- 点击按钮 同意
    @objc func accept(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 点击按钮 拒绝
    @objc private func refuse(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
