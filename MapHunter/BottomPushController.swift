//
//  BottomPushController.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class BottomPushController: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    fileprivate weak var fromViewController: UIViewController?
    fileprivate weak var toViewController: UIViewController?
    
    private var startRect: CGRect?
    
    convenience init(startRect: CGRect) {
        self.init()
        
        self.startRect = startRect
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        fromViewController = transitionContext.viewController(forKey: .from)
        
        let finalFrame = transitionContext.finalFrame(for: toViewController!)
        
        let containerView = transitionContext.containerView
        
        let screenBounds = UIScreen.main.bounds
        toViewController?.view.frame = finalFrame.offsetBy(dx: 0, dy: screenBounds.size.height)
        
        let toViewView = toViewController!.view
        containerView.addSubview(toViewView!)
        
        //路径动画
        toViewController?.view.frame = finalFrame
        
        let startRadius = view_size.width * 0.1
        
        let initialRect = startRect ?? CGRect(x: view_size.width / 2 - startRadius,
                                              y: view_size.height / 2 - startRadius,
                                              width: startRadius * 2,
                                              height: startRadius * 2)
        let circlePathInitial = UIBezierPath(ovalIn: initialRect)
        
        let finallyRect = startRect == nil ? CGRect(x: view_size.width / 2 - view_size.height / 2,
                                                    y: 0,
                                                    width: view_size.height,
                                                    height: view_size.height) : CGRect(x: startRect!.origin.x - view_size.height,
                                                                                       y: startRect!.origin.y - view_size.height,
                                                                                       width: view_size.height * 2,
                                                                                       height: view_size.height * 2)
        let circlePathFinally = UIBezierPath(ovalIn: finallyRect)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePathInitial.cgPath
        toViewController?.view.layer.mask = shapeLayer
        
        let maskAnim = CABasicAnimation(keyPath: "path")
        maskAnim.fromValue = circlePathInitial.cgPath
        maskAnim.toValue = circlePathFinally.cgPath
        maskAnim.duration = transitionDuration(using: transitionContext)
        maskAnim.isRemovedOnCompletion = false
        maskAnim.fillMode = kCAFillModeBoth
        maskAnim.delegate = self
        maskAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(maskAnim, forKey: "path")
    }
    
}

//MARK:- 路径动画代理
extension BottomPushController: CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        transitionContext?.completeTransition(true)
        
        toViewController?.view.layer.mask = nil
    }
}
