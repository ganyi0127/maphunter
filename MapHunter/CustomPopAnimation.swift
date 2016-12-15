//
//  CustomPopAnimatation.swift
//  MapHunter
//
//  Created by YiGan on 14/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import Foundation
class CustomPopAnimatation: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    fileprivate weak var fromViewController: UIViewController?
    fileprivate weak var toViewController: UIViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        fromViewController = transitionContext.viewController(forKey: .from)
        
        let finalFrame = transitionContext.finalFrame(for: toViewController!)
        
        let containerView = transitionContext.containerView
        
        toViewController?.view.alpha = 0
        
        let toViewView = toViewController!.view
        containerView.addSubview(toViewView!)
        
        //animate
        
         let duration = transitionDuration(using: transitionContext)
         
         UIView.animate(withDuration: duration, animations: {
         
            //执行动画
            self.fromViewController?.view.alpha = 0
            self.toViewController?.view.alpha = 1
            self.toViewController?.view.frame = finalFrame
         }){
         complete in
         
         //完成动画
            transitionContext.completeTransition(true)
         }
    }
}
