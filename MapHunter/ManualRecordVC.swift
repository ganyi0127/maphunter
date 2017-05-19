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
    
    //选择列表
    var recordTableView: RecordTableView?
    
    //头
    var recordHeaderView: RecordHeaderView?
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
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
        if type != RecordType.mood {
            recordTableView = RecordTableView(withRecordType: type)
            
            recordTableView?.openClosure = {
                recordType, isOpen in
                
                switch recordType {
                case .sport:
                    //更新header视图
                    let sportType = RecordTableView.sportType
                    self.recordHeaderView?.sportType = sportType
                case .sleep:
                    break
                case .weight:
                    break
                case .bloodPressure:
                    break
                case .heartrate:
                    break
                default:
                    //身心状态不进行处理
                    break
                }
                
                if isOpen{
                    if self.effectView.superview == nil{
                        self.effectView.alpha = 0
                        self.view.insertSubview(self.effectView, at: 1)
                    }
                }else{
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    if isOpen{
                        self.recordHeaderView?.alpha = 0
                        self.effectView.alpha = 1
                    }else{
                        self.recordHeaderView?.alpha = 1
                        self.effectView.alpha = 0
                    }
                }, completion: {
                    complete in
                    guard complete else{
                        return
                    }
                    
                    if isOpen{
                        
                    }else{
                        if self.effectView.superview != nil{
                            self.effectView.removeFromSuperview()
                        }
                    }
                })
            }
            
            view.addSubview(recordTableView!)
            
            recordHeaderView = RecordHeaderView(withRecordType: type, top: recordTableView!.openOriginY, bottom: recordTableView!.closeOriginY)
            view.insertSubview(recordHeaderView!, belowSubview: recordTableView!)
        }
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
