//
//  BindingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/2/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class BindingVC: UIViewController {
    @IBOutlet weak var bandImageview: UIImageView!
    @IBOutlet weak var unbindingButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var synchroDateLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    private var funcTable: FuncTable?{
        didSet{
            guard let ft = funcTable else {
                return
            }
            debugPrint(ft)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        unbindingButton.setTitleColor(.white, for: .normal)
        unbindingButton.backgroundColor = .red
        unbindingButton.layer.cornerRadius = 10
    }
    
    private func createContents(){
        
        let name = PeripheralManager.share().currentPeripheral?.name
        nameLabel.text = name
        
        let angelManager = AngelManager.share()
        print("angelManger:", angelManager ?? "nil")
        
        angelManager?.getMacAddressFromBand{
            errorCode, macaddress in
            guard errorCode == ErrorCode.success else{
                return
            }
            
            angelManager?.getDevice{
                device in

                guard let existDevice = device else{
                    return
                }
                let isMain = Thread.isMainThread
                print(isMain ? "main" : "not main")
                DispatchQueue.main.async {
                    self.versionLabel.text = "\(existDevice.version)"
                    self.energyLabel.text = "\(existDevice.battLevel)"
                    self.funcTable = existDevice.funcTable
                }
            }
        }
        
    }
    
    @IBAction func unbinding(_ sender: UIButton) {
        
        if let peripheral = PeripheralManager.share().currentPeripheral {
            
            GodManager.share().disconnect(peripheral){
                success in
                if success{
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
