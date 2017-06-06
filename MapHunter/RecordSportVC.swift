//
//  RecordSportVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordSportVC: ManualRecordVC {
    
    init(){
        super.init(withRecordType: .sport)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func config() {
        super.config()
    }
    
    override func createContents() {
        super.createContents()
    }
    
    //MARK:- 存储
    override func accept(sender: UIButton) {
        
        //存储操作        
        super.accept(sender: sender)
    }
}
