//
//  DetailScrollView.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class DetailScrollView: UIScrollView {
    fileprivate var type: DataCubeType!
    
    var detailBack: DetailBack!
    
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
        
        delegate = self
    }
    
    private func createContents(){
        
        //添加back
        detailBack = DetailBack(detailType: type)
        addSubview(detailBack)
        contentSize = CGSize(width: view_size.width, height: detailBack.frame.origin.y + detailBack.frame.height)
    }
}

extension DetailScrollView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        detailBack.detailTop?.currentTouchesBegan(touches)
        isScrollEnabled = false
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        detailBack.detailTop?.currentTouchesMoved(touches)
        isScrollEnabled = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        detailBack.detailTop?.currentTouchesEnded(touches)
        isScrollEnabled = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        isScrollEnabled = true
    }
}

extension DetailScrollView: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < (detailBack.frame.origin.y - 66) / 2 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -66), animated: true)
        }else if offsetY < detailBack.frame.origin.y - 66 {
            scrollView.setContentOffset(CGPoint(x: 0, y: detailBack.frame.origin.y - 66), animated: true)
        }
    }
}
