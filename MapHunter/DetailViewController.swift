//
//  DetailViewController.swift
//  MapHunter
//
//  Created by YiGan on 30/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    
    private var type: DataCubeType!     //类型
    private var date: Date!             //日期
    
    
    //MARK:- init
    init(detailType: DataCubeType, date: Date){
        super.init(nibName: nil, bundle: nil)
        
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
        let dateStr = formatter.string(from: date!)
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
        let startColor = modelStartColors[type]!
        gradient.colors = [startColor.cgColor, timeColor.cgColor]
        gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
        
        //添加scrollView
        /*
        let detailScrollView = DetailScrollView(detailType: type, date: date)
        detailScrollView.detailBack.detailTop?.closure = {
            //点击模块回调
            let targetSettingVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "targetsetting")
            self.present(targetSettingVC, animated: true, completion: nil)
        }
        detailScrollView.detailBack.detailTop?.editClosure = {
            //点击编辑回调
            let weightEditVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "weightedit")
            self.navigationController?.show(weightEditVC, sender: nil)
        }
        detailScrollView.detailBack.closure = {
            //点击数据view回调
            let introduceVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "introduce") as! IntroduceVC
            introduceVC.type = self.type
            self.navigationController?.show(introduceVC, sender: nil)
        }
        view.addSubview(detailScrollView)
         */
    }
    
    private func createContents(){
        
    }
}

extension DetailViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
