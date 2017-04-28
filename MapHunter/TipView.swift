//
//  TipView.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/26.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class TipView: UIView {
    
    private var titleLabel: UILabel?
    private var textLabel: UITextView?
    
    var data: HaData?{
        didSet{
            titleLabel?.text = data?.title
            textLabel?.text = data?.text
        }
    }
    
    
    
    
    //MARK:- init------------------------------------------------------------------------------------------
    init() {
        let frame = CGRect(x: hatip_width * 0.05 / 2, y: 2, width: hatip_width * 0.95, height: hatip_height - 4)
        super.init(frame: frame)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 4
    }
    
    private func createContents(){
        
        let sideLength: CGFloat = 8                             //边距
        let topLength: CGFloat = 10                             //顶部边距
        let buttonLenght: CGFloat = 26                          //按钮高度
        
        //标题
        let titleFrame = CGRect(x: sideLength, y: topLength, width: frame.width, height: 24)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel?.textColor = wordColor
        titleLabel?.textAlignment = .left
        titleLabel?.font = fontMiddle
        addSubview(titleLabel!)
        
        //文本
        let textFrameY = titleFrame.origin.y + titleFrame.height
        let textFrame = CGRect(x: sideLength,
                               y: textFrameY,
                               width: frame.width - sideLength * 2,
                               height: frame.height - textFrameY - 4 - 26 - 4)
        textLabel = UITextView(frame: textFrame)
        textLabel?.textColor = subWordColor
        textLabel?.textAlignment = .left
        textLabel?.font = fontSmall
        textLabel?.isEditable = false
        textLabel?.isScrollEnabled = false
        addSubview(textLabel!)
        
        
        let buttonY = textFrame.origin.y + textFrame.height     //哈博士y位置
        
        //hatip
        let hatipFrame = CGRect(x: sideLength, y: buttonY, width: 120, height: 24)
        let hatipLabel = UILabel(frame: hatipFrame)
        hatipLabel.textAlignment = .left
        addSubview(hatipLabel)
        
        let mutableAttributed = NSMutableAttributedString(string: " 哈博士", attributes: [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.lightGray])
        let length = fontSmall.pointSize * 1.2
        let imageSize = CGSize(width: length, height: length)
        let imageBounds = CGRect(x: 0, y: length / 2 - 24 / 2, width: length, height: length)
        let attach = NSTextAttachment()
        attach.image = UIImage(named: "resource/hatip")?.transfromImage(size: imageSize)
        attach.bounds = imageBounds
        let attributed = NSAttributedString(attachment: attach)
        mutableAttributed.insert(attributed, at: 0)
        hatipLabel.attributedText = mutableAttributed
        
        //更多按钮
        let moreButtonFrame = CGRect(x: frame.width - sideLength - 80, y: buttonY, width: 80, height: buttonLenght)
        let moreButton = UIButton(frame: moreButtonFrame)
        moreButton.setTitle("了解更多", for: .normal)
        moreButton.setTitleColor(defaut_color, for: .normal)
        moreButton.setTitleColor(defaultColor.withAlphaComponent(0.5), for: .highlighted)
        moreButton.titleLabel?.font = fontSmall
        moreButton.addTarget(self, action: #selector(learnMore(sender:)), for: .touchUpInside)
        addSubview(moreButton)
        
        //评价按钮
        let commentButtonImageSize = CGSize(width: buttonLenght, height: buttonLenght)
        let commentButtonFrame = CGRect(x: frame.width - buttonLenght - sideLength, y: topLength / 2, width: buttonLenght + sideLength, height: buttonLenght + topLength)
        let commentButton = UIButton(frame: commentButtonFrame)
        if let image = UIImage(named: "resource/time/tipicon")?.transfromImage(size: commentButtonImageSize){
            commentButton.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "resource/time/tipicon_selected")?.transfromImage(size: commentButtonImageSize){
            commentButton.setImage(image, for: .selected)
        }
        commentButton.addTarget(self, action: #selector(comment(sender:)), for: .touchUpInside)
        addSubview(commentButton)
    }
    
    //MARK:- 点击更多按钮
    @objc private func learnMore(sender: UIButton){
        debugPrint("<selector>click learn more from hatip, need loading H5 view")
    }
    
    //MARK:- 点击评价按钮
    @objc private func comment(sender: UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
        }
    }
}
