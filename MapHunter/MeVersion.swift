//
//  MeVersion.swift
//  MapHunter
//
//  Created by YiGan on 21/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
class MeVersion: UIViewController {
    init(){
        super.init(nibName: nil, bundle: nil)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .gray
    }
}
