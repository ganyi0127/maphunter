//
//  SubSportVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/20.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class SubSportVC: UIViewController {
    
    private var date: Date!
    private var subTableView: SubTableView?
    
    //MARK:-init******************************************************************************************************************
    init(withDate date: Date){
        super.init(nibName: nil, bundle: nil)
        
        self.date = date
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .red
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func createContents(){
        
        subTableView = SubTableView(withType: .sport)
        view.addSubview(subTableView!)
    }    
}
