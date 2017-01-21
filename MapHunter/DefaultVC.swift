//
//  DefaultVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/13.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class DefaultVC: UIViewController {
    
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
