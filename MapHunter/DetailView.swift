//
//  DetailView.swift
//  MapHunter
//
//  Created by YiGan on 30/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
enum DetailType{
    case more
    case calorie
    case step
    case distance
}
class DetailView: UIView {
    
    private var type: DetailType!       //按钮类型
    
    var value: CGFloat?{
        didSet{
            guard let v = value else{
                return
            }
            
            switch type as DetailType {
            case .calorie:
                label.text = "\(v) 卡"
            case .step:
                label.text = "\(Int(v)) 步"
            case .distance:
                label.text = "\(v) 米"
            case .more:
                label.text = "更多"
            }
        }
    }
    
    private lazy var label: UILabel = {
        let bounds = self.frame
        let labelFrame = CGRect(x: -bounds.width * 1.5, y: bounds.height - 5, width: bounds.width * 4, height: bounds.height)
        let l: UILabel = UILabel(frame: labelFrame)
        l.font = UIFont(name: font_name, size: 12)
        l.textAlignment = .center
        l.textColor = UIColor(red: 184 / 255, green: 184 / 255, blue: 184 / 255, alpha: 1)
        return l
    }()
    
    private var closure: ((DetailType)->())?
    
    //MARK:- init
    init(detailType: DetailType, frame: CGRect, selected: @escaping (_ detailType: DetailType)->()){
        super.init(frame: frame)
        
        type = detailType
        closure = selected
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        isUserInteractionEnabled = true
    }
    
    private func createContents(){
        
        //初始化标签
        addSubview(label)
        value = 10000
        
        //导入图片
        var imgStr: String!
        switch type as DetailType {
        case .step:
            imgStr = "resource/icon_step"
        case .calorie:
            imgStr = "resource/icon_calorie"
        case .distance:
            imgStr = "resource/icon_distance"
        case .more:
            imgStr = "resource/icon_more"
        }
        
        let image = UIImage(named: imgStr)
        let imageFrame = CGRect(origin: .zero, size: frame.size)
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = image
        addSubview(imageView)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closure?(type)
    }
}
