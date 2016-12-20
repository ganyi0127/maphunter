//
//  MeDetails.swift
//  MapHunter
//
//  Created by YiGan on 20/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class MeDetails: UIViewController {
    
    private var type: MeCell3Type!
    
    init(type: MeCell3Type){
        super.init(nibName: nil, bundle: nil)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .lightGray
    }
    
    private func createContents(){
        
    }
}
