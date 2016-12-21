//
//  MeCell1.swift
//  MapHunter
//
//  Created by YiGan on 19/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class MeCell1: UITableViewCell {
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    //照片
    var headImage: UIImage?{
        didSet{
            guard let image = headImage else {
                return
            }
            headImageView.image = image
        }
    }
    
    //用户名
    var nickName: String = "NICK NAME"{
        didSet{
            //去除空格与回车
            let str = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
            if str == "" {
                nickNameLabel.text = "NICK NAME"
            }else{
                nickNameLabel.text = str
            }
        }
    }
    
    //简介
    var introduce: String = "运动宣言"{
        didSet{
            //去除空格与回车
            let str = introduce.trimmingCharacters(in: .whitespacesAndNewlines)
            if str == "" {
                introduceLabel.text = "运动宣言"
            }else{
                introduceLabel.text = str
            }
        }
    }
    
    //分钟数
    var minutes: Int16 = 0{
        didSet{
            if minutes > 0 {
                minuteLabel.text = "\(minutes)"
            }else{
                minuteLabel.text = "0"
            }
        }
    }
    
    //次数
    var count: Int16 = 0{
        didSet{
            if count > 0 {
                countLabel.text = "\(count)"
            }else{
                countLabel.text = "0"
            }
        }
    }
    
    //卡路里
    var calorie: Int16 = 0{
        didSet{
            if calorie > 0{
                calorieLabel.text = "\(calorie)"
            }else{
                calorieLabel.text = "0"
            }
        }
    }
    
    //距离
    var distance: Int16 = 0{
        didSet{
            if distance > 0 {
                distanceLabel.text = "\(distance)"
            }else{
                distanceLabel.text = "0"
            }
        }
    }
    
    //MARK:- init
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        config()
        createContents()
    }
    
    override func draw(_ rect: CGRect) {
        
        //设置头像遮罩
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn: headImageView.bounds).cgPath
        headImageView.layer.mask = maskLayer
    }
    
    private func config(){
        
        //设置分割线
        separatorInset = .zero
        if responds(to: #selector(setter: MeCell1.layoutMargins)) {
            layoutMargins = .zero
        }
        if responds(to: #selector(setter: MeCell1.preservesSuperviewLayoutMargins)) {
            preservesSuperviewLayoutMargins = false
        }
    }
    
    private func createContents(){
        
        //设置头像
        let image = UIImage(named: "resource/me/me_head_boy")?.transfromImage(size: headImageView.bounds.size)
        headImage = image
    }
}
