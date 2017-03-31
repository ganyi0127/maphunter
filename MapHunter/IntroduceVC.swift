//
//  IntroduceVC.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class IntroduceVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var type: DataCubeType?
    
    private var text = ""{
        didSet{
            label.text = text
        }
    }
    
    override func viewDidLoad() {
        text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        config()
        createContents()
    }
    
    private func config(){
        
        navigationItem.hidesBackButton = true
        
    }
    
    private func createContents(){
        
        guard let cubeType = type else {
            return
        }
        
        switch cubeType {
        case .sport:
            text = "运动介绍"
        case .sleep:
            text = ""
            let image = UIImage(named: "resource/introduce/sleep")
            let imageView = UIImageView(frame: view.frame)
            imageView.image = image
            view.addSubview(imageView)            
        default:
            text = ""
        }
    }
    
}

extension IntroduceVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }
}
