//
//  ElasticPositionImageViewVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class ElasticPositionImageViewVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    let MaxAllowedVelocity: CGFloat = 2000.0
    let PushAwayScale: CGFloat = 50.0

    var dynamicAnimator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!

    var lastVelocity = CGPoint.zero
    var lastOffset = UIOffset.zero

    override func viewDidLoad() {
        self.dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        self.snapBehavior = UISnapBehavior(item: self.imageView, snapTo: self.view.center)
    }

    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.dynamicAnimator.removeAllBehaviors()

            let anchorPoint = sender.location(in: self.view)
            let locationInImage = CGPoint(x: anchorPoint.x - imageView.center.x, y: anchorPoint.y - imageView.center.y)
            let locationAdjustedForRotate = locationInImage.applying(self.imageView.transform.inverted())

            self.lastOffset = UIOffsetMake(locationAdjustedForRotate.x, locationAdjustedForRotate.y)
            self.attachmentBehavior = UIAttachmentBehavior(item: self.imageView, offsetFromCenter: lastOffset, attachedToAnchor: anchorPoint)
            self.dynamicAnimator.addBehavior(self.attachmentBehavior)

            break

        case .changed:
            let anchorPoint = sender.location(in: self.view)
            self.attachmentBehavior.anchorPoint = anchorPoint
            self.lastVelocity = sender.velocity(in: self.view)
            break

        default:
            self.dynamicAnimator.removeBehavior(self.attachmentBehavior)
            self.attachmentBehavior = nil
            if (sqrt(lastVelocity.x * lastVelocity.x + lastVelocity.y * lastVelocity.y) > MaxAllowedVelocity) {
                let pushBehavior = UIPushBehavior(items: [self.imageView], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: self.lastVelocity.x / PushAwayScale, dy: self.lastVelocity.y / PushAwayScale)
                pushBehavior.setTargetOffsetFromCenter(self.lastOffset, for: self.imageView)
                self.dynamicAnimator.addBehavior(pushBehavior)
            }
            else {
                self.dynamicAnimator.addBehavior(self.snapBehavior)
            }
            break
        }
    }
}
