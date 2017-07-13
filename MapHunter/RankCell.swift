//
//  RankCell.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class RankCell: UITableViewCell  {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    var rank: Int? {
        didSet{
            rankLabel.text = rank == nil ? "~" : "\(rank!)"
        }
    }
    
    var headImage: UIImage? {
        didSet{
            headImageView.image = headImage
        }
    }
    
    var name: String? {
        didSet{
            guard let n = name else {
                return
            }
            nameLabel.text = n
        }
    }
    
    var value: Int? {
        didSet{
            guard let v = value else {
                return
            }
            valueLabel.text = "\(v)"
            valueLabel.textColor = v < 8000 ? lightWordColor : defaut_color
        }
    }
    
    var likeCount: Int? {
        didSet{
            guard let l = likeCount else {
                return
            }
            
            let text = "\(l)"
            let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: lightWordColor])
            likeLabel.attributedText = attributedString
        }
    }
    
    var likeSelected = false {
        didSet{
            likeButton.isSelected = likeSelected
        }
    }
    
    //MARK:-init***************************************************************
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        rankLabel.font = fontMiddle
        rankLabel.textColor = wordColor
        
        nameLabel.font = fontMiddle
        nameLabel.textColor = subWordColor
        
        valueLabel.font = fontBig
        
        headImageView.layer.cornerRadius = headImageView.bounds.width / 2
        headImageView.clipsToBounds = true
        
        let likeNormalImage = UIImage(named: "resource/discover/rank/like_normal")?.withRenderingMode(.alwaysOriginal)
        let likeSelectedImage = UIImage(named: "resource/discover/rank/like_selected")?.withRenderingMode(.alwaysOriginal)
        likeButton.setImage(likeNormalImage, for: .normal)
        likeButton.setImage(likeSelectedImage, for: .selected)
    }
    
    //MARK:-点赞
    @IBAction func likeClick(_ sender: Any) {
        likeSelected = true
    }
}
