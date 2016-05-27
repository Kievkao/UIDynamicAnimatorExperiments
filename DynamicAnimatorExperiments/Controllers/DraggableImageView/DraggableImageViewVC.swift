//
//  DraggableImageViewVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DraggableImageViewVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var dynamicAnimator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!

    override func viewDidLoad() {
        self.dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
    }

    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .Began:
            let anchorPoint = sender.locationInView(self.view)
            let locationInImage = CGPoint(x: anchorPoint.x - imageView.center.x, y: anchorPoint.y - imageView.center.y)
            let locationAdjustedForRotate = CGPointApplyAffineTransform(locationInImage, CGAffineTransformInvert(self.imageView.transform))

            self.attachmentBehavior = UIAttachmentBehavior(item: self.imageView, offsetFromCenter: UIOffsetMake(locationAdjustedForRotate.x, locationAdjustedForRotate.y), attachedToAnchor: anchorPoint)
            self.dynamicAnimator.addBehavior(self.attachmentBehavior)
            break

        case .Changed:
            self.attachmentBehavior.anchorPoint = sender.locationInView(self.view)
            break

        default:
            self.dynamicAnimator.removeBehavior(self.attachmentBehavior)
            self.attachmentBehavior = nil
            break
        }
    }
}
