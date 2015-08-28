//
//  SMZoomModalAnimator.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/28/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit

/// Zoom transition that suits presenting view controllers modally
class SMZoomModalAnimator: NSObject {
    private var presenting: Bool = true
}

extension SMZoomModalAnimator: SMZoomAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                transitionContext.completeTransition(false)
                return
        }
        
        if presenting {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = containerView.bounds
            toViewController.view.alpha = 0.5
            
            UIView.animateWithDuration(animationDuration,
                animations: {
                    toViewController.view.alpha = 1.0
                },
                completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
            )
        }
        else {
            UIView.animateWithDuration(animationDuration,
                animations: {
                    fromViewController.view.alpha = 0.0
                    toViewController.view.alpha = 1.0
                },
                completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
            )
        }
        
        imageAnimationBlock(transitionContext)?()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
}

extension SMZoomModalAnimator: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}
