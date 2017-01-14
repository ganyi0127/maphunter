//
//  PremapVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/14.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PremapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    //按钮
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
//    private lazy var continueButton: UIButton = {
//        let frame = CGRect(x: view_size.width / 2 - self.pauseButton.bounds.width * 1.1 * 2, y: self.pauseButton.frame.origin.y, width: self.pauseButton.bounds.width / 2, height: self.pauseButton.bounds.height / 2)
//        let button: UIButton = UIButton(frame: frame)
//        let img = UIImage(named: "resource/map/continue")
//        button.setImage(img, for: .normal)
//        button.isHidden = true
//        button.addTarget(self, action: #selector(self.pressContinue(_:)), for: .touchUpInside)
//        return button
//    }()
//    private lazy var finishButton: UIButton = {
//        let frame = CGRect(x: view_size.width / 2 + self.pauseButton.bounds.width * 0.1 * 2, y: self.pauseButton.frame.origin.y, width: self.pauseButton.bounds.width / 2, height: self.pauseButton.bounds.height / 2)
//        let button: UIButton = UIButton(frame: frame)
//        let img = UIImage(named: "resource/map/finish")
//        button.setImage(img, for: .normal)
//        button.isHidden = true
//        button.addTarget(self, action: #selector(self.pressFinish(_:)), for: .touchUpInside)
//        return button
//    }()
    
    //设置地图开关
    private let closeImg = UIImage(named: "resource/map/itemclose")?.transfromImage(size: CGSize(width: 20, height: 20))        //叉叉
    private var mapOpen: Bool = false{
        didSet{
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                if self.mapOpen {
                    self.mapView.isUserInteractionEnabled = true
                }else{
                    self.mapView.isUserInteractionEnabled = false
                }
            }, completion: {
                complete in
                if self.mapOpen{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.closeImg, style: .done, target: self, action: #selector(self.clickMap(_:)))
                }else{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "   ", style: .done, target: self, action: #selector(self.clickMap(_:)))
                }
            })
            
            let anim = CABasicAnimation(keyPath: "path")
            anim.toValue = mapOpen ? self.bigPath : self.smallPath
            anim.duration = 0.5
            anim.isRemovedOnCompletion = false
            anim.fillMode = kCAFillModeBoth
            self.maskLayer.add(anim, forKey: nil)
        }
    }
    
    //路径
    private let smallRadius: CGFloat = 44 / 2
    private let bigRadius: CGFloat = view_size.height * 1.5
    private lazy var centerPoint: CGPoint = {return CGPoint(x: view_size.width - self.smallRadius - 20, y: self.smallRadius + 20)}()
    private lazy var smallPath: CGPath = {
        let bezier = UIBezierPath(arcCenter: self.centerPoint, radius: self.smallRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        return bezier.cgPath
    }()
    private lazy var bigPath: CGPath = {
        let bezier = UIBezierPath(arcCenter: self.centerPoint, radius: self.bigRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        return bezier.cgPath
    }()
    private lazy var maskLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.path = self.smallPath
        return shape
    }()
    
    //MARK:- init -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        navigationController?.setTabbar(hidden: true)
        navigationController?.setNavigation(hidden: true)
        
        self.mapView.layer.mask = maskLayer
        mapOpen = false
    }
    
    private func createContents(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "   ", style: .done, target: self, action: #selector(self.clickMap(_:)))
        navigationItem.hidesBackButton = true               //隐藏返回按钮
        
    }
    
    //MARK:- 打开或关闭地图
    @objc private func clickMap(_ sender: UIButton){
        mapOpen = !mapOpen
    }
    
    //MARK:- 暂停
    @IBAction func pause(_ sender: UIButton) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.continueButton.isHidden = false
            self.finishButton.isHidden = false
            self.pauseButton.isHidden = true
        }, completion: {
            complete in
        })
    }
    
    //MARK:- 继续
    @IBAction func pressContinue(_ sender: UIButton) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.continueButton.isHidden = true
            self.finishButton.isHidden = true
            self.pauseButton.isHidden = false
        }, completion: {
            complete in
        })
    }
    
    //MARK:- 结束
    @IBAction func pressFinish(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}
