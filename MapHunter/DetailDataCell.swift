//
//  DetailDataCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/23.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class DetailDataCell: UIView {
    
    private var type: DetailDataViewType.Additional!
    
    private var leftLabel: UILabel?
    private lazy var rightLabel: UILabel? = {
        let label: UILabel = UILabel(frame: CGRect(x: self.bounds.width / 2,
                                                   y: self.bounds.height / 2 - 2,
                                                   width: self.bounds.width / 2 - self.bounds.height,
                                                   height: 20))
        label.textAlignment = .right
        label.textColor = wordColor
        return label
    }()
    var value: Any?{
        didSet{
            //展示数据
            var text: String
            var unit: String
            var v0 = 0
            var v1 = 0
            var v2 = 0
            var v3 = [Int]()
            switch type as DetailDataViewType.Additional {
            case .exercise:
                unit = "分钟"
                if let v = value as? (Int, Int) {
                    v0 = v.0
                    v1 = v.1
                }
                
                //right label
                let rightText = "\(v1)次锻炼"
                let attributeString = NSMutableAttributedString(string: rightText, attributes: [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: wordColor])
                attributeString.addAttributes([NSFontAttributeName: fontTiny, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(rightText.characters.count - 3, 3))
                rightLabel?.attributedText = attributeString
                
                addSubview(rightLabel!)
            case .stepTarget:
                unit = "小时"
                if let v = value as? [Int]{
                    v3 = v
                }
            case .restHeartrate:
                unit = "次／分钟"
                if let v = value as? (Int, Int) {
                    v0 = v.0
                    v1 = v.1
                }
                
                //right label
                let rightText = "30天平均\(v1)次／分钟"
                let attributeString = NSMutableAttributedString(string: rightText, attributes: [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: wordColor])
                attributeString.addAttributes([NSFontAttributeName: fontTiny, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(rightText.characters.count - 4, 4))
                attributeString.addAttributes([NSFontAttributeName: fontTiny, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(0, 5))
                rightLabel?.attributedText = attributeString
                
                addSubview(rightLabel!)
            case .bloodPressureTrend:
                unit = ""
                if let v = value as? (Int, Int, Int) {
                    v0 = v.0
                    unit = "保持平稳"
                    v1 = v.1
                    v2 = v.2
                }
                
                //right label
                let rightText = "平均\(v1)／\(v2)mmHg"
                let attributeString = NSMutableAttributedString(string: rightText, attributes: [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: wordColor])
                attributeString.addAttributes([NSFontAttributeName: fontTiny, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(rightText.characters.count - 4, 4))
                attributeString.addAttributes([NSFontAttributeName: fontTiny, NSForegroundColorAttributeName: lightWordColor], range: NSMakeRange(0, 2))
                rightLabel?.attributedText = attributeString
                
                addSubview(rightLabel!)
            default:
                unit = ""
            }
            
            //left label
            text = "\(v0)" + unit
            let mainAttributedString = NSMutableAttributedString(string: text,
                                                                 attributes: [NSFontAttributeName: fontMiddle])
            let unitLength = unit.characters.count
            mainAttributedString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - unitLength, unitLength))
            leftLabel?.attributedText = mainAttributedString
        }
    }
    
    //点击事件
    var tap: UITapGestureRecognizer?
    var closure: ((DetailDataViewType.Additional)->())?
    
    //MARK:-init****************************************************************************************************************
    init(with detailDataViewType: DetailDataViewType.Additional){
        let frame = CGRect(x: 0, y: 0, width: view_size.width - edgeWidth * 2, height: 44)
        super.init(frame: frame)
        
        self.type = detailDataViewType        
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func click(recongnizer: UITapGestureRecognizer){
        closure?(type)
    }
    
    private func config(){
        let topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
        topSeparator.backgroundColor = subWordColor
        topSeparator.alpha = 0.1
        addSubview(topSeparator)
        
        let bottomSeparator = UIView(frame: CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1))
        bottomSeparator.backgroundColor = subWordColor
        bottomSeparator.alpha = 0.1
        addSubview(bottomSeparator)
        
        //初始化点击事件
        tap = UITapGestureRecognizer(target: self, action: #selector(click(recongnizer:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
    
    private func createContents(){
        var firstLabelStr: String
        var iconName: String
        switch type as DetailDataViewType.Additional {
        case .exercise:
            firstLabelStr = "锻炼"
            iconName = "resource/dataicon/totaltime"
        case .stepTarget:
            firstLabelStr = "达到250步的小时"
            iconName = "resource/dataicon/totaltime"
        case .restHeartrate:
            firstLabelStr = "静息心率"
            iconName = "resource/dataicon/totaltime"
        case .bloodPressureTrend:
            firstLabelStr = "90天血压趋势"
            iconName = "resource/dataicon/totaltime"
        default:
            firstLabelStr = ""
            iconName = ""
        }
        
        //image icon
        let radius = bounds.height * 0.5
        let iconImageView = UIImageView(frame: CGRect(x: (bounds.height - radius) / 2,
                                                      y: (bounds.height - radius) / 2,
                                                      width: radius,
                                                      height: radius))
        iconImageView.image = UIImage(named: iconName)
        addSubview(iconImageView)
        
        //first label
        let firstLabel = UILabel(frame: CGRect(x: bounds.height,
                                               y: bounds.height / 2 - 14,
                                               width: bounds.width - radius - iconImageView.frame.origin.x * 2,
                                               height: 12))
        firstLabel.font = UIFont(name: font_name, size: 12)
        firstLabel.textColor = subWordColor
        firstLabel.text = firstLabelStr
        addSubview(firstLabel)
        
        //left label
        leftLabel = UILabel(frame: CGRect(x: bounds.height,
                                            y: bounds.height / 2 - 2,
                                            width: bounds.width / 2 - bounds.height,
                                            height: 20))
        leftLabel?.textColor = wordColor
        addSubview(leftLabel!)
        
        //disclosureIndicator 右箭头
        let indicatorFrame = CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
        let indicator = UIActivityIndicatorView(frame: indicatorFrame)
        addSubview(indicator)
    }
}
