//
//  TrackSV.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit

class TrackSV: UIScrollView {
    fileprivate var track: Track!
    
    var trackBottom: TrackBottom!
    var trackTop: TrackTopBase!
    
    private var isDetail = false
    
    
    
    //MARK:-init****************************************************************
    init(with track: Track) {
        let frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        super.init(frame: frame)
        
        self.track = track
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        self.showsVerticalScrollIndicator = true
        
        delegate = self
    }
    
    private func createContents(){
        //添加底部面板
        trackBottom = TrackBottom(with: track)
        addSubview(trackBottom)
        contentSize = CGSize(width: view_size.width, height: trackBottom.frame.origin.y + trackBottom.frame.height)
        
        //添加顶部面板
        let sportType = SportType(rawValue: track.type)!
        switch sportType {
        case .weight:
            break
        case .calorie:
            break
        case .sleep:
            trackTop = SleepTrackTop(with: track)
        case .badminton, .skipping:
            break
        default:
            trackTop = SportTrackTop(with: track)
        }
        addSubview(trackTop)
        
        //添加评论面板
        
    }
}

//MARK:- 触摸事件
extension TrackSV{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        trackTop.currentTouchesBegan(touches)
        isScrollEnabled = false
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        trackTop.currentTouchesMoved(touches)
        isScrollEnabled = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        trackTop.currentTouchesEnded(touches)
        isScrollEnabled = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isScrollEnabled = true
    }
}

//MARK:- scroll delegate
extension TrackSV: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let trackVC = viewController() as! TrackVC
        let y = scrollView.contentOffset.y
        if y > 0 {
            trackVC.navigationController?.navigationBar.tintColor = subWordColor
            trackVC.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: subWordColor]
            trackVC.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            
        }else{
            trackVC.navigationController?.navigationBar.tintColor = .white
            trackVC.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white]
            trackVC.navigationController?.setNavigation(hidden: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < (trackBottom.frame.origin.y - 64) / 2 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        }else if offsetY < trackBottom.frame.origin.y - 64 {
            scrollView.setContentOffset(CGPoint(x: 0, y: trackBottom.frame.origin.y - 64), animated: true)
        }
    }
}
