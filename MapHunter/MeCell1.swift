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
    
    @IBOutlet weak var averageStepLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
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
//    var nickName: String = "NICK NAME"{
//        didSet{
//            //去除空格与回车
//            let str = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
//            if str == "" {
//                nickNameLabel.text = "NICK NAME"
//            }else{
//                nickNameLabel.text = str
//            }
//        }
//    }
    
    //分钟数
    var averageSteps: Int16 = 0{
        didSet{
            let title = "日均步数\n"
            let text = title + "\(averageSteps)"
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, title.characters.count))
            averageStepLabel.attributedText = attributedString
        }
    }
    
    //次数
    var actionCount: Int16 = 0{
        didSet{
            let title = "锻炼次数\n"
            let text = title + "\(actionCount)"
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, title.characters.count))
            countLabel.attributedText = attributedString
        }
    }
    
    //卡路里
    var targetCount: Int16 = 0{
        didSet{
            let title = "达标天数\n"
            let text = title + "\(targetCount)"
            
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: UIColor.white])
            attributedString.addAttributes([NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, title.characters.count))
            targetLabel.attributedText = attributedString
        }
    }
    
    //MARK:-init*******************************************************************************************
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
        
        //初始化
        backgroundColor = defaut_color
        
        averageStepLabel.font = fontMiddle
        averageStepLabel.textColor = .white
        
        countLabel.font = fontMiddle
        countLabel.textColor = .white
        
        targetLabel.font = fontMiddle
        targetLabel.textColor = .white        
    }
    
    private func createContents(){
        
        //设置头像
        let image = UIImage(named: "resource/me/me_head_boy")?.transfromImage(size: headImageView.bounds.size)
        headImage = image
    }
}
