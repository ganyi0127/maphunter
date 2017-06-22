//
//  DetailVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/31.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class DetailVC: UIViewController {
    
    private var type: DataCubeType!     //类型
    private var date: Date?             //日期
    
    var detailSV: DetailSV!
    
    private var isDetail = false
    //MARK:- init
    init(detailType: DataCubeType, date: Date?, isDetail: Bool){
        super.init(nibName: nil, bundle: nil)
        
        self.isDetail = isDetail
        type = detailType
        self.date = date
        
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
        let dateStr = formatter.string(from: date ?? selectDate)
        let todayStr = formatter.string(from: Date())
        
        if dateStr == todayStr {
            navigationItem.title = "今天"
        }else{
            navigationItem.title = dateStr
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //test
        let subSportVC = SubSportVC(withDate: date ?? Date())
        navigationController?.show(subSportVC, sender: nil)
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
        let startColor = modelStartColors[type]!
        gradient.colors = [startColor.cgColor, timeColor.cgColor]
        gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
        
        //添加scrollView
        detailSV = DetailSV(detailType: type, date: date, isDetail: isDetail)
        detailSV.detailCenter.closure = {
            //点击模块回调
            let targetSettingVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "targetsetting")
            self.present(targetSettingVC, animated: true, completion: nil)
        }
        detailSV.detailCenter.editClosure = {
            //点击编辑回调
            let weightEditVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "weightedit")
            self.navigationController?.show(weightEditVC, sender: nil)
        }
        detailSV.detailBottom.closure = {
            //点击数据view回调
            let introduceVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "introduce") as! IntroduceVC
            introduceVC.type = self.type
            self.navigationController?.show(introduceVC, sender: nil)
        }
        view.addSubview(detailSV)
        
    }
    
    private func createContents(){
        
    }
}
