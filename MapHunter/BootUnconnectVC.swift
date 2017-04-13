//
//  BootUnconnectVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/12.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootUnconnectVC: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var bandImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let image = UIImage(named: "resource/boot/bluetooth") {
            bandImageView.image = image
        }
    }
    
    //MARK:- 返回上两级页面
    @IBAction func back(_ sender: UIButton) {
        
        let viewcontrollers = navigationController?.viewControllers
        guard let count = viewcontrollers?.count, count >= 3 else{
            return
        }
        
        guard let vc = viewcontrollers?[count - 3] else {
            return
        }
        _ = navigationController?.popToViewController(vc, animated: true)
    }
    
    //MARK:- 返回上一级页面
    @IBAction func tryAgain(_ sender: UIButton) {        
        _ = navigationController?.popViewController(animated: true)
    }
}
