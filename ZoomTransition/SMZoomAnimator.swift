//
//  ZoomAnimation.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/13/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit

protocol SMZoomableImageViewSource {
    func imageViewToAnimate() -> UIImageView?
    func destinationFrame(containerView: UIView) -> CGRect
}

typealias SMZoomAnimatedTransitioning = UIViewControllerAnimatedTransitioning
extension SMZoomAnimatedTransitioning {

    var animationDuration: Double { return 0.33 }

    ///returns an animation block for performing the image zoom transition
    func imageAnimationBlock(transitionContext: UIViewControllerContextTransitioning) -> (() -> Void)? {

        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                transitionContext.completeTransition(false)
                return nil
        }

        var imageAnimationBlock: (() -> Void)?

        if let toVC = zoomableViewController(toViewController),
            fromVC = zoomableViewController(fromViewController),
            toImageView = toVC.imageViewToAnimate(),
            fromImageView = fromVC.imageViewToAnimate() {

                toImageView.alpha = 0.0
                fromImageView.alpha = 0.0
                
                let localImageView = UIImageView(image: fromImageView.image)
                localImageView.frame = containerView.convertRect(fromImageView.frame, fromView: fromImageView.superview)
                containerView.addSubview(localImageView)
                
                imageAnimationBlock = {
                    let destinationFrame = toVC.destinationFrame(containerView)
                    UIView.animateWithDuration(self.animationDuration,
                        delay: 0.0,
                        usingSpringWithDamping: 0.65,
                        initialSpringVelocity: 0.9,
                        options: UIViewAnimationOptions.CurveEaseOut,
                        animations: {
                            localImageView.frame = destinationFrame
                        },
                        completion: { (finished) -> Void in
                            //if animation cancelled, make sure we properly re-adjust alpha
                            if transitionContext.transitionWasCancelled() {
                                fromImageView.alpha = 1.0
                            }
                            toImageView.alpha = 1.0
                            localImageView.removeFromSuperview()
                        }
                    )
                }
        }

        return imageAnimationBlock
    }
    
    /// Extracts the proper view controller in adition to checking conformance to SMZoomableImageViewSource
    private func zoomableViewController(vc: UIViewController) -> SMZoomableImageViewSource? {
        var targetVC = vc
        //Only handling UINavigationController and UITabBarController
        while targetVC is UINavigationController || targetVC is UITabBarController {
            if let targetVCNav = targetVC as? UINavigationController {
                targetVC = targetVCNav.topViewController ?? targetVC
            }
            else if let targetVCTab = targetVC as? UITabBarController {
                targetVC = targetVCTab.selectedViewController ?? targetVC
            }
        }
        return targetVC as? SMZoomableImageViewSource
    }
}
