//
//  ShowView.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/13.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation

class SettingVC: UIViewController {
    
    @IBOutlet weak var tipSwitch: UISwitch!
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    
    private lazy var list: [UIButton] = {return [self.button0, self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7]}()
    
    @IBAction func click(_ sender: UIButton) {
        
    }
    @IBAction func `switch`(_ sender: UISwitch) {
        
    }
}
