//
//  SMNavigationController.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/13/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit


/// Naivgation controller which uses the SMZoomNavigationTransition.
/// Also combines that with a UIPercentDrivenInteractiveTransition interactive transition.

class SMNavigationController: UINavigationController, UINavigationControllerDelegate {

    private var percentDrivenInteraction: UIPercentDrivenInteractiveTransition?
    private var edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.whiteColor()
        
        edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenEdgePan:")
        edgeGestureRecognizer.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgeGestureRecognizer)
    }

    func handleScreenEdgePan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        if let vc = topViewController {
            let location = gestureRecognizer.translationInView(vc.view)
            let percentage = location.x / CGRectGetWidth(vc.view.bounds)
            let velocity_x = gestureRecognizer.velocityInView(vc.view).x
            
            switch gestureRecognizer.state {
            case .Began:
                popViewControllerAnimated(true)
            case .Changed:
                percentDrivenInteraction?.updateInteractiveTransition(percentage)
            case .Ended:
                if percentage > 0.3 || velocity_x > 1000 {
                    percentDrivenInteraction?.finishInteractiveTransition()
                }
                else {
                    percentDrivenInteraction?.cancelInteractiveTransition()
                }
            case .Cancelled:
                percentDrivenInteraction?.cancelInteractiveTransition()
            default:
                break
            }
        }
    }

    // MARK: - UINavigationControllerDelegate

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SMZoomNavigationAnimator(navigationOperation: operation)
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        if edgeGestureRecognizer.state == .Began {
            percentDrivenInteraction = UIPercentDrivenInteractiveTransition()
            percentDrivenInteraction!.completionCurve = .EaseOut
        }
        else {
            percentDrivenInteraction = nil
        }

        return percentDrivenInteraction
    }
}
