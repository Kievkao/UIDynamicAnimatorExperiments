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

    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            let anchorPoint = sender.location(in: self.view)
            let locationInImage = CGPoint(x: anchorPoint.x - imageView.center.x, y: anchorPoint.y - imageView.center.y)
            let locationAdjustedForRotate = locationInImage.applying(self.imageView.transform.inverted())

            self.attachmentBehavior = UIAttachmentBehavior(item: self.imageView, offsetFromCenter: UIOffsetMake(locationAdjustedForRotate.x, locationAdjustedForRotate.y), attachedToAnchor: anchorPoint)
            self.dynamicAnimator.addBehavior(self.attachmentBehavior)
            break

        case .changed:
            self.attachmentBehavior.anchorPoint = sender.location(in: self.view)
            break

        default:
            self.dynamicAnimator.removeBehavior(self.attachmentBehavior)
            self.attachmentBehavior = nil
            break
        }
    }
}
