//
//  PlayVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/28.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PlayVC: UIViewController {
 
    @IBOutlet weak var outdoorView: OutdoorView!        //户外运动
    @IBOutlet weak var indoorView: IndoorView!          //室内运动
    @IBOutlet weak var huntingView: HuntingView!        //运动寻宝
    @IBOutlet weak var dekaronView: DekaronView!        //挑战
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "趣玩"
    }
    
    private func config(){
        
        view.backgroundColor = timeColor
        
        outdoorView.closure = clickView(_:)
        indoorView.closure = clickView(_:)
        huntingView.closure = clickView(_:)
        dekaronView.closure = clickView(_:)
    }
    
    private func createContents(){
                
    }
    
    //MARK:-点击回调
    func clickView(_ tag: Int) {
        switch tag {
        case 0:  //室外运动
            performSegue(withIdentifier: "outdoor", sender: nil)
        default:
            break
        }
    }
}
