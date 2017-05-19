//
//  HaTip.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/26.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
let hatip_width = view_size.width * 1
let hatip_height = view_size.width * 0.4
struct HaData {
    var title: String?
    var text: String?
}
class HaTip: UITableViewCell {
    
    var dataList = [HaData](){
        didSet{
            pageControl?.numberOfPages = dataList.count
            contentList.removeAll()
            scrollView?.subviews.forEach{
                subView in
                subView.removeFromSuperview()
            }
            guard let sv = scrollView else {
                return
            }
            
            dataList.enumerated().forEach{
                index, data in
                let tip = TipView()
                tip.data = data
                contentList.append(tip)
                tip.frame.origin.x = hatip_width * CGFloat(index) + hatip_width * 0.05 / 2
                sv.addSubview(tip)
//                let progress = 1 - (sv.contentOffset.x - CGFloat(index) * hatip_width + hatip_width * 0.05) / (hatip_width * 2)
//                tip.layer.transform = self.menuTransformForPercent(progress, index: index)
            }
            sv.contentSize = CGSize(width: hatip_width * CGFloat(contentList.count), height: hatip_height)
            sv.contentOffset = .zero
        }
    }
    var selectedContentView: UIView?
    
    fileprivate var contentList = [TipView]()
    fileprivate var scrollView: UIScrollView?
    fileprivate var pageControl: UIPageControl?
    
    //MARK:- init
    init(reuseIdentifier identifier: String){
        super.init(style: .default, reuseIdentifier: identifier)
        let initFrame = CGRect(x: 0, y: 0, width: hatip_width, height: hatip_height)
        frame = initFrame
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    private func config(){
        backgroundColor = timeColor
    }
    
    private func createContents(){
        
        let scrollFrame = CGRect(x: view_size.width / 2 - hatip_width / 2, y: 4, width: hatip_width, height: hatip_height)
        scrollView = UIScrollView(frame: scrollFrame)
        scrollView?.backgroundColor = timeColor
        scrollView?.isPagingEnabled = true
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        addSubview(scrollView!)
        
        let pageControlFrame = CGRect(x: 0, y: scrollFrame.origin.y + scrollFrame.height, width: contentView.frame.width, height: 20)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl?.currentPage = 0
        pageControl?.currentPageIndicatorTintColor = UIColor.gray
        pageControl?.pageIndicatorTintColor = UIColor.lightGray
        contentView.addSubview(pageControl!)
    }
}

extension HaTip: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / hatip_width)
        pageControl?.currentPage = index
//        contentList.enumerated().forEach(){
//            index, contentView in
//            
//            let progress = 1 - (scrollView.contentOffset.x - contentView.frame.origin.x + hatip_width * 0.05) / (hatip_width * 2)
//            contentView.layer.transform = menuTransformForPercent(progress, index: index)            
//        }
    }
    
    //滑动结束回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = view_size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        if page < contentList.count{
            selectedContentView = contentList[page]
        }
    }
    
    //矩阵变换
    func menuTransformForPercent(_ percent: CGFloat, index: Int) -> CATransform3D {
        guard let sv = scrollView else {
            return CATransform3DIdentity
        }
        var identity = CATransform3DIdentity
//        identity.m34 = -1 / 1000   //1 / [camera distance]
        let remainingPercent = 1 - percent
        let indexDelta = sv.contentOffset.x / hatip_width - CGFloat(index)           //计算偏移量 index
        let angle = remainingPercent * -.pi / 2
        let rotationTransform = CATransform3DRotate(identity, angle, 0, 1, 0)
        let translationTransform = CATransform3DMakeTranslation(hatip_width * 0.15 * indexDelta, 0, 0)
        let scaleTransform = CATransform3DMakeScale(0.9, 0.9, 0)    //0.9 * (1 - fabs(indexDelta) * 0.8)
        let concat = CATransform3DConcat(rotationTransform, translationTransform)
        return CATransform3DConcat(concat, scaleTransform)
    }
}
