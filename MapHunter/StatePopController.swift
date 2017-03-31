//
//  CustomPopAnimatation.swift
//  MapHunter
//
//  Created by YiGan on 14/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
class StatePopController: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    fileprivate weak var fromViewController: UIViewController?
    fileprivate weak var toViewController: UIViewController?
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
    private var endRect: CGRect?
    
    convenience init(endRect: CGRect) {        
        self.init()
        
        self.endRect = endRect
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
        fromViewController?.view.layer.zPosition = 1
        
        let startRadius = view_size.width * 0
        let initialRect = endRect ?? CGRect(x: view_size.width / 2 - startRadius,
                                            y: view_size.height / 2 - startRadius,
                                            width: startRadius * 2,
                                            height: startRadius * 2)
        let circlePathInitial = UIBezierPath(ovalIn: initialRect)
        
        let finallyRect = endRect == nil ? CGRect(x: view_size.width / 2 - view_size.height / 2,
                                                    y: 0,
                                                    width: view_size.height,
                                                    height: view_size.height) : CGRect(x: endRect!.origin.x - view_size.height,
                                                                                       y: endRect!.origin.y - view_size.height,
                                                                                       width: view_size.height * 2,
                                                                                       height: view_size.height * 2)
        let circlePathFinally = UIBezierPath(ovalIn: finallyRect)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePathFinally.cgPath
        fromViewController?.view.layer.mask = shapeLayer
        
        let maskAnim = CABasicAnimation(keyPath: "path")
        maskAnim.fromValue = circlePathFinally.cgPath
        maskAnim.toValue = circlePathInitial.cgPath
        maskAnim.duration = transitionDuration(using: transitionContext)
        maskAnim.isRemovedOnCompletion = false
        maskAnim.fillMode = kCAFillModeBoth
        maskAnim.delegate = self
        maskAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(maskAnim, forKey: "path")

        //模糊动画
        toViewController?.view.addSubview(effectView)
        effectView.alpha = 0.5
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            self.effectView.alpha = 0
        }){
            _ in
            self.effectView.removeFromSuperview()
        }
    }
}

//MARK:- 路径动画代理
extension StatePopController: CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        transitionContext?.completeTransition(true)
        fromViewController?.view.layer.zPosition = 0
        fromViewController?.view.layer.mask = nil
    }
}
