//
//  FunVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/10.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class FunVC: UIViewController {
    
    //滑动视图
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isScroll = true{
        didSet{
            scrollView.isScrollEnabled = isScroll
        }
    }
    
    //视图列表
    @IBOutlet weak var pathContainerView: UIView!
    @IBOutlet weak var recommendRouteContainerView: UIView!
    @IBOutlet weak var myRouteContainerView: UIView!
    @IBOutlet weak var spriteContainerView: UIView!
    fileprivate lazy var containerList: [UIView] = {
        var list = [UIView]()
        list.append(self.pathContainerView)
        list.append(self.recommendRouteContainerView)
        list.append(self.myRouteContainerView)
        list.append(self.spriteContainerView)
        return list
    }()
    
    //当前选择的container view
    fileprivate var selectContainerView: UIView?{
        didSet{
            guard let selectView = selectContainerView else {
                return
            }

            if selectView == pathContainerView{
                navigationController?.navigationBar.topItem?.title = pathViewController?.customTitle
            }else if selectView == recommendRouteContainerView{
                navigationController?.navigationBar.topItem?.title = recommendRouteViewController?.customTitle
            }else if selectView == myRouteContainerView{
                navigationController?.navigationBar.topItem?.title = myRouteViewController?.customTitle
            }else if selectView == spriteContainerView{
                navigationController?.navigationBar.topItem?.title = spriteViewController?.customTitle
            }else{
                navigationController?.navigationBar.topItem?.title = ""
            }
        }
    }
    
    fileprivate var pathViewController: PathViewController?
    fileprivate var recommendRouteViewController: RecommendRouteViewController?
    fileprivate var myRouteViewController: MyRouteViewController?
    fileprivate var spriteViewController: SpriteViewController?
    
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isScroll = true
        selectContainerView = pathContainerView
    }
    
    //MARK:- 初始化获取view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        func animation(using: @escaping ()->()){
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: using, completion: nil)
        }
        
        if segue.identifier == "path" {
            pathViewController = segue.destination as? PathViewController
            pathViewController?.closure = {
                //path点击事件
                guard self.selectContainerView == self.pathContainerView else{
                    return
                }
                
                if self.isScroll{
                    self.isScroll = false
                    
                    animation{
                        self.pathContainerView.layer.transform = CATransform3DIdentity
                    }
                }else{
                    self.isScroll = true
                    
                    let progress = 1 - (self.scrollView.contentOffset.x - self.pathContainerView.frame.origin.x) / (view_size.width * 2)
                    animation{
                        self.pathContainerView.layer.transform = self.menuTransformForPercent(progress, index: 0)
                    }
                }
            }
        }else if segue.identifier == "recommendroute"{
            recommendRouteViewController = segue.destination as? RecommendRouteViewController
            recommendRouteViewController?.closure = {
                //recommendRoute点击事件
                guard self.selectContainerView == self.recommendRouteContainerView else{
                    return
                }
                
                if self.isScroll{
                    self.isScroll = false
                    animation {
                        self.recommendRouteContainerView.layer.transform = CATransform3DIdentity
                    }
                }else{
                    self.isScroll = true
                    
                    let progress = 1 - (self.scrollView.contentOffset.x - self.recommendRouteContainerView.frame.origin.x) / (view_size.width * 2)
                    animation {
                        self.recommendRouteContainerView.layer.transform = self.menuTransformForPercent(progress, index: 1)
                    }
                }
            }
        }else if segue.identifier == "myroute"{
            myRouteViewController = segue.destination as? MyRouteViewController
            myRouteViewController?.closure = {
                //myRoute点击事件
                guard self.selectContainerView == self.myRouteContainerView else{
                    return
                }
                
                if self.isScroll{
                    self.isScroll = false
                    animation {
                        
                        self.myRouteContainerView.layer.transform = CATransform3DIdentity
                    }
                }else{
                    self.isScroll = true
                    
                    let progress = 1 - (self.scrollView.contentOffset.x - self.myRouteContainerView.frame.origin.x) / (view_size.width * 2)
                    animation {
                        self.myRouteContainerView.layer.transform = self.menuTransformForPercent(progress, index: 2)
                    }
                }
            }
        }else if segue.identifier == "sprite"{
            spriteViewController = segue.destination as? SpriteViewController
            spriteViewController?.closure = {
                //sprite点击事件
                guard self.selectContainerView == self.spriteContainerView else{
                    return
                }
                
                if self.isScroll{
                    self.isScroll = false
                    animation {
                        
                        self.spriteContainerView.layer.transform = CATransform3DIdentity
                    }
                }else{
                    self.isScroll = true
                    
                    let progress = 1 - (self.scrollView.contentOffset.x - self.spriteContainerView.frame.origin.x) / (view_size.width * 2)
                    animation {                        
                        self.spriteContainerView.layer.transform = self.menuTransformForPercent(progress, index: 3)
                    }
                }
            }
        }
    }
    
    private func config(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(tap)
        
    }
    
    private func createContents(){
       
    }
    
    //MARK:- 点击事件
    @objc private func click(recognizer: UITapGestureRecognizer){

        //隐藏与显示tarbar
        navigationController?.setTabbar(hidden: isScroll)
        
        //获取点击位置
        let location = recognizer.location(in: scrollView)

        //根据位置判断点击的模块
        if pathViewController?.view.layer.hitTest(location) != nil {
            pathViewController?.closure?()
        }else if recommendRouteViewController?.view.layer.hitTest(CGPoint(x: location.x - view_size.width, y: location.y)) != nil {
            recommendRouteViewController?.closure?()
        }else if myRouteViewController?.view.layer.hitTest(CGPoint(x: location.x - view_size.width * 2, y: location.y)) != nil {
            myRouteViewController?.closure?()
        }else if spriteViewController?.view.layer.hitTest(CGPoint(x: location.x - view_size.width * 3, y: location.y)) != nil {
            spriteViewController?.closure?()
        }
    }
}

extension FunVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerList.enumerated().forEach(){
            index, containerView in
            
            let progress = 1 - (scrollView.contentOffset.x - containerView.frame.origin.x + view_size.width * 0.1) / (view_size.width * 2)
            
            containerView.layer.transform = menuTransformForPercent(progress, index: index)
            containerView.layer.zPosition = 1 - fabs(scrollView.contentOffset.x / pathContainerView.bounds.width - CGFloat(index))
            containerView.alpha = 1 - fabs(scrollView.contentOffset.x / pathContainerView.bounds.width - CGFloat(index)) * 0.5
        }
    }
    
    //滑动结束回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = pathContainerView.bounds.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        selectContainerView = containerList[page]
    }
    
    //矩阵变换
    func menuTransformForPercent(_ percent: CGFloat, index: Int) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1 / 1000   //1 / [camera distance]
        let remainingPercent = 1 - percent
        let angle = remainingPercent * CGFloat(-M_PI_2)
        let rotationTransform = CATransform3DRotate(identity, angle, 0, 1, 0)
        let translationTransform = CATransform3DMakeTranslation(pathContainerView.bounds.width * 0.4 * (scrollView.contentOffset.x / pathContainerView.bounds.width - CGFloat(index)), 0, 0)
        let scaleTransform = CATransform3DMakeScale(0.8, 0.8, 0)
        let concat = CATransform3DConcat(rotationTransform, translationTransform)
        return CATransform3DConcat(concat, scaleTransform)
    }
}
