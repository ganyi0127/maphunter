//
//  InfoVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/15.
//  Copyright © 2017年 ganyi. All rights reserved.
//
//1、根据手机语言，如果是中文，默认是公制， 其他，默认是英制
//2.性别的默认值男，身高默认值 175cm，范围(30cm-255cm)，体重默认值 65kg， 范围(25kg-255kg) 生日的默认值 25 岁，范围:0-250 岁
//3.在设置身高和体重的时候都可以修改公英制

import Foundation
enum InfoSex {      //性别
    case male       //男
    case female     //女
}
class InfoVC: UIViewController {
    
    //按钮
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //图片
    @IBOutlet weak var sexImageView: InfoSexView!
    @IBOutlet weak var heightImageView: UIImageView!
    @IBOutlet weak var weightImageView: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    
    //信息value
    private var sex: InfoSex? {
        didSet{
            
        }
    }
    private var height: UInt8? {      //以厘米为单位
        didSet{
            
        }
    }
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        view.backgroundColor = timeColor
        
        //设置标签字体
        firstLabel.font = fontMiddle
        
        //设置下一步颜色
        nextButton.setTitleColor(defaut_color, for: .normal)
        
        //设置返回图片
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private func createContents(){
        
    }
}
