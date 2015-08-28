//
//  SimpleViewController.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/23/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import UIKit

class SimpleViewController: UIViewController {

    var centeredImageView: UIImageView!
    private var transDelegate: SMZoomModalAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Zoom from image"
        
        centeredImageView = UIImageView(frame: CGRectZero)
        centeredImageView.translatesAutoresizingMaskIntoConstraints = false
        centeredImageView.image = UIImage(named: "cover")
        centeredImageView.userInteractionEnabled = true
        view.addSubview(centeredImageView)

        [
            centeredImageView.centerXAnchor.constraintEqualToAnchor(centeredImageView.superview?.centerXAnchor),
            centeredImageView.centerYAnchor.constraintEqualToAnchor(centeredImageView.superview?.centerYAnchor),
            centeredImageView.widthAnchor.constraintEqualToConstant(100),
            centeredImageView.heightAnchor.constraintEqualToConstant(150)
        ].forEach { constraint in
            constraint.active = true
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapCover:")
        centeredImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - UITapGestureRecognizer
    
    func didTapCover(gestureRecognizer: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if  let detailVC = sb.instantiateViewControllerWithIdentifier("detailVC") as? DetailViewController {
            transDelegate = SMZoomModalAnimator()
            detailVC.transitioningDelegate = transDelegate
            detailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.presentViewController(detailVC, animated: true, completion: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private typealias Zoomable = SimpleViewController
extension Zoomable : SMZoomableImageViewSource {
    func imageViewToAnimate() -> UIImageView? {
        return centeredImageView
    }
    
    func destinationFrame(containerView: UIView) -> CGRect {
        return containerView.convertRect(centeredImageView.frame, fromView: view)
    }
}
