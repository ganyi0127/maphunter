//
//  BottomPopController.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class BottomPopController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        var finalFrame = transitionContext.finalFrame(for: toViewController!)
        finalFrame = finalFrame.offsetBy(dx: 0, dy: view_size.height)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController!.view)
        containerView.sendSubview(toBack: toViewController!.view)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.fromViewController!.view.frame = finalFrame
        }, completion: {
            _ in
            self.fromViewController?.removeFromParentViewController()
            transitionContext.completeTransition(true)
        })
    }
}
