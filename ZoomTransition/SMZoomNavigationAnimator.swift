//
//  SMZoomNavigationAnimator.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/28/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit

/// Transition that suits view controllers pushed onto a navigation controller
class SMZoomNavigationAnimator: NSObject {
    
    private var pushing: Bool
    
    init(navigationOperation: UINavigationControllerOperation) {
        pushing = navigationOperation == UINavigationControllerOperation.Push
        super.init()
    }
}

extension SMZoomNavigationAnimator: SMZoomAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                transitionContext.completeTransition(false)
                return
        }
        
        if pushing {
            containerView.addSubview(fromViewController.view)
            
            toViewController.view.frame = containerView.bounds
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0.5
            
            UIView.animateWithDuration(animationDuration,
                animations: {
                    toViewController.view.alpha = 1.0                },
                completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
            )
        }
        else {
            toViewController.view.frame = containerView.bounds
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            
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
        /// Using same image animation block for presentation and dismissal
        imageAnimationBlock(transitionContext)?()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
}