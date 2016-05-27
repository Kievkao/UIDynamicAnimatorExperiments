//
//  FadeAnimator.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate {

    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    var bounceBehavior: UIDynamicItemBehavior!

    var context: UIViewControllerContextTransitioning!

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard   let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                let containerView = transitionContext.containerView()
            else {
                transitionContext.completeTransition(false)
                return
        }

        toVC.view.frame.offsetInPlace(dx: 0.0, dy: -toVC.view.frame.size.height)
        containerView.addSubview(toVC.view)

        self.dynamicAnimator = UIDynamicAnimator(referenceView: containerView)
        self.dynamicAnimator.delegate = self

        self.collisionBehavior = UICollisionBehavior(items: [toVC.view])
        self.collisionBehavior.addBoundaryWithIdentifier("bottom", fromPoint: CGPointMake(0, containerView.frame.size.height + 1), toPoint: CGPointMake(containerView.frame.size.width, containerView.frame.size.height + 1))

        self.gravityBehavior = UIGravityBehavior(items: [toVC.view])
        self.gravityBehavior.magnitude = 4.0

        self.dynamicAnimator.addBehavior(self.collisionBehavior)
        self.dynamicAnimator.addBehavior(self.gravityBehavior)

        self.context = transitionContext
    }

    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        self.context.completeTransition(true)
    }
}
