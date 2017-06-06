//
//  TrackVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
class TrackVC: UIViewController {
    
    private var track: Track!
    
    fileprivate var trackSV: TrackSV!
    
    //MARK:-init************************************************************************************
    init(with track: Track){
        super.init(nibName: nil, bundle: nil)
        
        self.track = track
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigation(hidden: true)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white]
        
        //显示日期
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"

        let dateStr = formatter.string(from: track.date! as Date)
        let todayStr = formatter.string(from: Date())
        
        if dateStr == todayStr {
            navigationItem.title = "今天"
        }else{
            navigationItem.title = dateStr
        }
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
        var startColor: UIColor!
        startColor = .orange
        gradient.colors = [startColor.cgColor, timeColor.cgColor]
        //gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
        
        //添加scrollView
        trackSV = TrackSV(with: track)
//        trackSV.detailCenter.closure = {
//            //点击模块回调
//            let targetSettingVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "targetsetting")
//            self.present(targetSettingVC, animated: true, completion: nil)
//        }
        view.addSubview(trackSV)
    }
    
    private func createContents(){
        
    }
}
