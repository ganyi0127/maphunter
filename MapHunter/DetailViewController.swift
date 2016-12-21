//
//  DetailViewController.swift
//  MapHunter
//
//  Created by YiGan on 30/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    
    private var type: DataCubeType!
    
    //MARK:- init
    init(detailType: DataCubeType){
        super.init(nibName: nil, bundle: nil)
        
        type = detailType
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigation(hidden: true)
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        print("sender: \(sender)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .clear
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.locations = [0.2, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [modelStartColors[type]!.cgColor, modelEndColors[type]!.cgColor]
        gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
    }
    
    private func createContents(){
        
    }
}

extension DetailViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
