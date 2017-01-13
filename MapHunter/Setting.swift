//
//  ShowView.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/13.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
protocol SettingDelegate {
    func settingSwitch(_ flag: Bool)
    func settingSelect(buttonTag tag: Int, value: CGFloat)
}
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
    
    var delegate: SettingDelegate?
    
    @IBAction func click(_ sender: UIButton) {
        
        list.forEach(){
            btn in
            btn.backgroundColor = .clear
            btn.setTitleColor(.white, for: .normal)
        }
        
        sender.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        sender.setTitleColor(UIColor(red: 241 / 255, green: 155 / 255, blue: 80 / 255, alpha: 1), for: .normal)
        sender.layer.cornerRadius = sender.bounds.height / 2
        
        let tag = sender.tag
        switch tag {
        case 0:
            delegate?.settingSelect(buttonTag: tag, value: 0.5)
        case 1:
            delegate?.settingSelect(buttonTag: tag, value: 1.0)
        case 2:
            delegate?.settingSelect(buttonTag: tag, value: 2.0)
        case 3:
            delegate?.settingSelect(buttonTag: tag, value: 3.0)
        case 4:
            delegate?.settingSelect(buttonTag: tag, value: 5)
        case 5:
            delegate?.settingSelect(buttonTag: tag, value: 10)
        case 6:
            delegate?.settingSelect(buttonTag: tag, value: 15)
        case 7:
            delegate?.settingSelect(buttonTag: tag, value: 20)
        default:
            break
        }
    }
    @IBAction func `switch`(_ sender: UISwitch) {
        delegate?.settingSwitch(sender.isOn)
    }
}
