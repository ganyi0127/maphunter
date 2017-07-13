//
//  RankVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/7/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RankVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    
    
    fileprivate var dataList = [Int](){
        didSet{
            dataList = dataList.sorted().reversed()
            tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<20{
            let value = Int(arc4random_uniform(40000))
            dataList.append(value)
        }
    }
}

//MARK:-tableview delegate
extension RankVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {   //设置相册
            let imageViewFrame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.width * 0.75)
            let coverImageView = UIImageView(frame: imageViewFrame)
            let img = UIImage(named: "resource/me/me_head_boy")
            coverImageView.image = img
            

            //封面占领用户
            
            let text = "ganyi 占领了封面"
            let nsText = NSString(string: text)
            var labelFrame = nsText.boundingRect(with: view_size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontSmall], context: nil)
            
            let headWidth: CGFloat = 20
            let headFrame = CGRect(x: (view_size.width - labelFrame.width - edgeWidth - headWidth) / 2, y: edgeWidth, width: headWidth, height: headWidth)
            labelFrame.origin = CGPoint(x: headFrame.origin.x + headWidth + edgeWidth, y: edgeWidth)
            
            let shadowOffset = CGSize(width: 0, height: 1)
            
            //头像
            let headImg = UIImage(named: "resource/me/me_head_boy")
            let headImageView = UIImageView(frame: headFrame)
            headImageView.image = headImg
            headImageView.layer.cornerRadius = headWidth / 2
            headImageView.clipsToBounds = true
            coverImageView.addSubview(headImageView)
            
            //文字
            let label = UILabel(frame: labelFrame)
            label.font = fontSmall
            label.textColor = .white
            label.text = text
            label.shadowColor = UIColor.red
            label.shadowOffset = shadowOffset
            coverImageView.addSubview(label)
            
            return coverImageView
        }
        
        //设置自己的成绩
        let step = Int(arc4random_uniform(20000))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RankCell
        cell.rank = 123
        cell.name = "gan"
        cell.value = step
        cell.headImage = UIImage(named: "resource/me/me_head_boy")
        cell.likeCount = 12
        
        cell.rankLabel.font = fontMiddle
        cell.rankLabel.textColor = wordColor
        
        cell.nameLabel.font = fontMiddle
        cell.nameLabel.textColor = subWordColor
        
        cell.valueLabel.font = fontBig
        cell.valueLabel.textColor = step < 8000 ? lightWordColor : defaut_color
        
        cell.headImageView.layer.cornerRadius = cell.headImageView.bounds.width / 2
        cell.headImageView.clipsToBounds = true
        
        let likeNormalImage = UIImage(named: "resource/discover/rank/like_normal")?.withRenderingMode(.alwaysOriginal)
        let likeSelectedImage = UIImage(named: "resource/discover/rank/like_selected")?.withRenderingMode(.alwaysOriginal)
        cell.likeButton.setImage(likeNormalImage, for: .normal)
        cell.likeButton.setImage(likeSelectedImage, for: .selected)
        cell.likeButton.setTitleColor(subWordColor, for: .normal)
        cell.likeButton.setTitleColor(lightWordColor, for: .selected)
        
        cell.likeSelected = true
        
        cell.contentView.backgroundColor = timeColor
        
        let contentView = cell.contentView
        return contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return view_size.width * 0.75
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let data = dataList[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankCell
        if section == 0{
            
        }else{
            cell.rank = row > 9999 ? nil : row + 1
            cell.headImage = UIImage(named: "resource/me/me_head_boy")
            cell.name = "somename"
            cell.value = data
            cell.likeCount = 981
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }
}
