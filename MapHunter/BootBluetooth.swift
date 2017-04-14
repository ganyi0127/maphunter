//
//  BootBluetooth.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/12.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootBluetooth: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLabel.font = fontMiddle
        firstLabel.text = "打开蓝牙"
        secondLabel.font = fontSmall
        secondLabel.text = "您的蓝牙功能好像已被关闭，请转至“设置->蓝牙”并打开蓝牙开关，同时您也可以使用“控制中心”"

        continueButton.setTitleColor(defaut_color, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK:- 返回上两级页面
    @IBAction func continueBluetooth(_ sender: UIButton) {
        
        let viewcontrollers = navigationController?.viewControllers
        guard let count = viewcontrollers?.count, count >= 3 else{
            return
        }
        
        guard let vc = viewcontrollers?[count - 3] else {
            return
        }
        _ = navigationController?.popToViewController(vc, animated: true)
    }
}
