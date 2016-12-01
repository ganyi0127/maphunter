//
//  DetailCell.swift
//  MapHunter
//
//  Created by YiGan on 29/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class DetailCell: UITableViewCell {
    
    private var stepDetailView: DetailView?
    private var calorieDetailView: DetailView?
    private var distanceDetailView: DetailView?
    private var moreDetailView: DetailView?
    
    var closure: ((DetailType)->())?
    //MARK:- init
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
//        layer.cornerRadius = frame.height / 2
//        
//        var transform = CATransform3DIdentity
//        transform.m34 = -1 / 500
//        transform = CATransform3DScale(transform, 0.9, 0.7, 1)
//        layer.transform = transform
        
        backgroundColor = .clear
        
        
    }
    
    private func createContents(){
        
        let detailViewWidth = view_size.width / 4 * 0.3
        let intervalWidth = view_size.width / 4
        
        var viewFrame = CGRect(x: (intervalWidth - detailViewWidth) / 2, y: 0, width: detailViewWidth, height: detailViewWidth)
        stepDetailView = DetailView(detailType: .step, frame: viewFrame, selected: selected)
        addSubview(stepDetailView!)
        
        viewFrame = CGRect(x: (intervalWidth - detailViewWidth) / 2 + intervalWidth, y: 0, width: detailViewWidth, height: detailViewWidth)
        calorieDetailView = DetailView(detailType: .calorie, frame: viewFrame, selected: selected)
        addSubview(calorieDetailView!)
        
        viewFrame = CGRect(x: (intervalWidth - detailViewWidth) / 2 + intervalWidth * 2, y: 0, width: detailViewWidth, height: detailViewWidth)
        distanceDetailView = DetailView(detailType: .distance, frame: viewFrame, selected: selected)
        addSubview(distanceDetailView!)
        
        viewFrame = CGRect(x: (intervalWidth - detailViewWidth) / 2 + intervalWidth * 3, y: 0, width: detailViewWidth, height: detailViewWidth)
        moreDetailView = DetailView(detailType: .more, frame: viewFrame, selected: selected)
        addSubview(moreDetailView!)
    }
    
    private func selected(_ detailType: DetailType){
        closure?(detailType)
    }
}
