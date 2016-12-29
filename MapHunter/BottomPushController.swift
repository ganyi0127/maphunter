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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.toViewController?.view.frame = finalFrame
        }, completion: {
            _ in
            transitionContext.completeTransition(true)
        })
    }
}
