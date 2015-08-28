//
//  DetailViewController.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/13/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dont want to add blur if pushed on nav controller.. causes ugly effect.
        if self.navigationController == nil {
            view.backgroundColor = UIColor.clearColor()
            
            let blurView = UIVisualEffectView(frame: view.bounds)
            blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            view.insertSubview(blurView, atIndex: 0)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            
            let w = NSLayoutConstraint(item: blurView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: blurView.superview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
            blurView.superview?.addConstraint(w)
            
            let h = NSLayoutConstraint(item: blurView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: blurView.superview, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
            blurView.superview?.addConstraint(h)
        }
        
        imageView.image = UIImage(named: "cover")
        imageView.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapCover:")
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - UITapGestureRecognizer

    func didTapCover(gestureRecognizer: UITapGestureRecognizer) {
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


private typealias Zoomable = DetailViewController
extension Zoomable: SMZoomableImageViewSource {
        
    func imageViewToAnimate() -> UIImageView? {
        return imageView
    }
    
    func destinationFrame(containerView: UIView) -> CGRect {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        return imageView?.frame ?? CGRectZero
    }
}
