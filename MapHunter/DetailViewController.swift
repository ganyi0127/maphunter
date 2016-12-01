//
//  DetailViewController.swift
//  MapHunter
//
//  Created by YiGan on 30/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    
    //MARK:- init
    init(detailType: DetailType){
        super.init(nibName: nil, bundle: nil)
        
        config()
        createContents()
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        print("sender: \(sender)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
    }
    
    private func createContents(){
        
    }
}
