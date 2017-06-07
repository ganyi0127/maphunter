//
//  TrackTopBase.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
class TrackTopBase: UIView {
    //高亮选择
    lazy var selectedView: UIView = {
        let selectedView: UIView = UIView()
        selectedView.backgroundColor = .clear
        
        selectedView.alpha = 1
        selectedView.isHidden = true
        
        let dataWidth: CGFloat = 2
        
        selectedView.frame = CGRect(x: 0, y: 0, width: dataWidth, height: detailTopHeight)
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: dataWidth, height: self.frame.height)
        gradient.locations = [0.2, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gradient.name = "layer"
        selectedView.layer.addSublayer(gradient)
        
        self.selectedLabel.frame.origin.x = dataWidth / 2 - 40
        selectedView.addSubview(self.selectedLabel)
        
        //添加小三角
        
        selectedView.addSubview(self.triangleView)
        
        return selectedView
    }()
    //小三角
    lazy var triangleView: UIImageView = {
        let triangleFrame = CGRect(x: 0, y: self.selectedLabel.bounds.height, width: 11, height: 4)
        let triangle = UIImageView(frame: triangleFrame)
        let triangleImage = UIImage(named: "resource/sporticons/mood/triangle")
        triangle.image = triangleImage
        return triangle
    }()
    //显示选择数据值
    lazy var selectedLabel: UILabel = {
        let selectedLabel: UILabel = UILabel()
        selectedLabel.tag = 0
        selectedLabel.font = fontSmall
        
        var labelFrame = CGRect(x: self.frame.width / 2 - 40, y: 0, width: 80, height: 34)
        selectedLabel.frame = labelFrame
        selectedLabel.layer.backgroundColor = UIColor.white.cgColor
        selectedLabel.textColor = .black
        
        selectedLabel.textAlignment = .center
        selectedLabel.numberOfLines = -1
        selectedLabel.layer.cornerRadius = 2
        selectedLabel.layer.shadowColor = UIColor.black.cgColor
        selectedLabel.layer.shadowOpacity = 0.5
        selectedLabel.layer.shadowRadius = 1
        selectedLabel.layer.shadowOffset = .zero
        labelFrame.origin = .zero
        selectedLabel.layer.shadowPath = CGPath(rect: labelFrame, transform: nil)
        selectedLabel.clipsToBounds = false
        return selectedLabel
    }()
    //MARK:- 无数据label
    lazy var emptyLabel: UILabel = {
        var text: String
        switch self.sportType as SportType{
        case .sleep:
            text = "睡眠"
        default:
            text = "运动"
        }
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: self.frame.height - 64 - 20, width: self.bounds.size.width, height: 20))
        label.text = "无" + text + "数据"
        label.font = fontSmall
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    fileprivate var sportType: SportType!
    
    
    var detailCenter: DetailCenter{
        return (self.superview as! DetailSV).detailCenter
    }
    var delegate: DetailDelegate?
    var closure: (()->())?
    
    
    //MARK:- init ********************************************************
    init(with track: Track){
        let frame = CGRect(x: edgeWidth,
                           y: 0,
                           width: view_size.width - edgeWidth * 2,
                           height: detailTopHeight)
        super.init(frame: frame)
        
        sportType = SportType(rawValue: track.type)!
        
        config()
    }
    
    private var onceDraw = false
    override func didMoveToSuperview() {
        
        //绘制顶部图等
        if !onceDraw{
            onceDraw = true
            createContents()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        backgroundColor = .clear
        
        //添加empty label
        addSubview(emptyLabel)
    }
    
    
    func createContents(){
        
    }
}

extension TrackTopBase{
    func currentTouchesBegan(_ touches: Set<UITouch>) {
        
    }
    
    func currentTouchesMoved(_ touches: Set<UITouch>) {
        
    }
    
    func currentTouchesEnded(_ touches: Set<UITouch>){
        
    }
}
