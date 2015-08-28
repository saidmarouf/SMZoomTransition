//
//  ViewController.swift
//  ZoomTransition
//
//  Created by Said Marouf on 8/12/15.
//  Copyright © 2015 Said Marouf. All rights reserved.
//

import UIKit


class CoverCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
}


class TableViewController: UITableViewController {

    private var selectedCellIndex: NSIndexPath?
    private var transDelegate: SMZoomModalAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Zoom from Cell"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension TableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CoverCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("coverCell", forIndexPath: indexPath) as! CoverCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.coverImageView.image = UIImage(named: "cover")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedCellIndex = indexPath
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = sb.instantiateViewControllerWithIdentifier("detailVC") as? DetailViewController {
            
            if indexPath.row % 2 == 0 {
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            else {
                transDelegate = SMZoomModalAnimator()
                detailVC.transitioningDelegate = transDelegate
                detailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentViewController(detailVC, animated: true, completion: nil)
                })
            }
        }
    }
}

private typealias Zoomable = TableViewController
extension Zoomable: SMZoomableImageViewSource {

    func imageViewToAnimate() -> UIImageView? {
        if let selectedIndexPath = selectedCellIndex {
            if let cell = tableView.cellForRowAtIndexPath(selectedIndexPath) as? CoverCell {
                return cell.coverImageView
            }
        }
        return nil
    }
    
    func destinationFrame(containerView: UIView) -> CGRect {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        //this should be relative to containing cell. Need to convert rect.
        return containerView.convertRect(imageViewToAnimate()?.frame ?? CGRectZero, fromView:imageViewToAnimate()!.superview)
    }
}
