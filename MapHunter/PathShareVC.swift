//
//  PathShareVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/19.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathShareVC: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    var distance: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        distanceLabel.text = String(format: "%.2fKM", distance / 1000)
    }
    
    //MARK:- 分享
    @IBAction func share(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
