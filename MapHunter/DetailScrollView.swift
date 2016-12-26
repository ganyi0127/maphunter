//
//  DetailScrollView.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class DetailScrollView: UIScrollView {
    private var type: DataCubeType!
    
    init(detailType: DataCubeType, date: Date) {
        let frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        super.init(frame: frame)
        
        type = detailType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){

        self.showsVerticalScrollIndicator = false
    }
    
    private func createContents(){
        
        //添加back
        let detailBack = DetailBack(detailType: type)
        addSubview(detailBack)
        contentSize = CGSize(width: view_size.width, height: detailBack.frame.origin.y + detailBack.frame.height)
    }
}
