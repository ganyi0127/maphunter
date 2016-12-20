//
//  MePushController.swift
//  MapHunter
//
//  Created by YiGan on 20/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
class MePushController: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    fileprivate weak var fromViewController: UIViewController?
    fileprivate weak var toViewController: UIViewController?
    
    var clickPoint: CGPoint!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
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
        let circlePathInitial = UIBezierPath(ovalIn: CGRect(x: view_size.width - startRadius,
                                                            y: view_size.height / 2 - startRadius,
                                                            width: startRadius,
                                                            height: startRadius))
        
        let circlePathFinally = UIBezierPath(ovalIn: CGRect(x: view_size.width - view_size.height * 1.5 / 2,
                                                            y: 0,
                                                            width: view_size.height * 1.5,
                                                            height: view_size.height * 1.5))
        
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
        shapeLayer.add(maskAnim, forKey: "path")
    }
}

//MARK:- 路径动画代理
extension MePushController: CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        transitionContext?.completeTransition(true)
        
        toViewController?.view.layer.mask = nil
    }
}
