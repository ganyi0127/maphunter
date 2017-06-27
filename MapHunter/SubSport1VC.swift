//
//  SubSecondSportVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/26.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SubSport1VC: UIViewController {
    
    fileprivate let startX: CGFloat = 38
    fileprivate let endX: CGFloat = 16
    
    private var date: Date!
    var subTableView: SubTableView?
    
    fileprivate let bigRedius: CGFloat = 6 / 2
    fileprivate let smallRedius: CGFloat = 4 / 2
    
    
    
    //睡眠说明文字
    fileprivate lazy var tipLabel: UILabel = {
        
        let tipLabelFrame = CGRect(x: 0, y: 8 + navigation_height! + 20, width: self.view.frame.width, height: 17)
        let tipLabel: UILabel = UILabel(frame: tipLabelFrame)
        tipLabel.font = fontSmall
        tipLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        tipLabel.textAlignment = .center
        tipLabel.backgroundColor = .clear
        
        //添加图片混排
        let text = "达到250步的小时"
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: fontSmall])
        let length = fontSmall.pointSize * 1
        let imageSize = CGSize(width: length, height: length)
        let imageBounds = CGRect(x: 0, y: length / 2 - tipLabelFrame.height / 2, width: length, height: length)
        let endIndex: Int = 0       //插入位置
        let startAttach = NSTextAttachment()
        startAttach.bounds = imageBounds
        startAttach.image = self.getImage()
        let startAttributed = NSAttributedString(attachment: startAttach)
        attributedString.insert(startAttributed, at: endIndex)
        tipLabel.attributedText = attributedString
        
        return tipLabel
    }()
    
    private func getImage() -> UIImage{
        
        let v = UIView(frame: CGRect(x: 17 / 2 - bigRedius, y: 17 / 2 - bigRedius, width: bigRedius * 2, height: bigRedius * 2))
        v.layer.cornerRadius = bigRedius
        v.backgroundColor = UIColor.red
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 17, height: 17), false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        v.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.transfromImage(size: CGSize(width: 17, height: 17))!
    }    
    
    //MARK:-init******************************************************************************************************************
    init(withDate date: Date){
        super.init(nibName: nil, bundle: nil)
        
        self.date = date
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white]
        navigationController?.setNavigation(hidden: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .clear
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.locations = [-0.6, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let startColor = modelStartColors[.sport]!
        gradient.colors = [startColor.cgColor, timeColor.cgColor]
        gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
        
        view.addSubview(tipLabel)
    }
    
    private func createContents(){
        
        //模拟数据
        var dataList = [(date: Date, stepList: [Int])]()
        for i in 0..<7 {
            let date = Date(timeInterval: -TimeInterval(6 - i) * 60 * 60 * 24, since: Date())

            var stepList = [Int]()
            for j in 0..<96{
                if i == 6 && j > 5{
                    continue
                }
                let step = Int(arc4random_uniform(500))
                stepList.append(step)
            }
            dataList.append((date, stepList))
        }
        
        let topViewHeight = detailTopHeight + navigation_height! + 20   //整个上半部分高度
        let rectHeight = detailTopHeight * 0.8                          //仅图形高度
        
        
        //绘制数据
        for (index, element) in dataList.enumerated(){
            
            let y = (1 - CGFloat(index) / 6) * (rectHeight - bigRedius * 2 - edgeWidth) + (topViewHeight - rectHeight + bigRedius)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y:  y - 17 / 2, width: self.startX, height: 17)
            label.text = element.date.weekdayString()
            label.font = fontSmall
            label.textColor = .white
            label.textAlignment = .center
            //upLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
            view.addSubview(label)
            
            //绘制步数点
            for i in 0..<9{
                
                let x = CGFloat(i) * ((view.bounds.width - startX - endX - bigRedius * 4) / (9 - 1)) + startX + bigRedius * 2
                
                let stepViewFrame = CGRect(x: x - bigRedius, y: y - bigRedius, width: bigRedius * 2, height: bigRedius * 2)
                let stepView = UIView(frame: stepViewFrame)
                stepView.layer.cornerRadius = bigRedius
                stepView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                view.addSubview(stepView)

                if i < element.stepList.count{
                    let step = element.stepList[i]
                    if step > 250 {
                        if element.date.isToday(){
                            stepView.backgroundColor = .white
                        }else{
                            stepView.backgroundColor = UIColor.red
                        }
                    }
                }else{
                    stepView.frame = CGRect(x: x - self.smallRedius, y: y - self.smallRedius, width: self.smallRedius * 2, height: self.smallRedius * 2)
                    stepView.layer.cornerRadius = smallRedius
                }
            }
        }
        
        //Bottom
        addDateList()
    }
    
    //MARK:-添加日期列表
    private func addDateList(){
        //绘制列表
        subTableView = SubTableView(withType: .sport)
        view.addSubview(subTableView!)
    }
}
