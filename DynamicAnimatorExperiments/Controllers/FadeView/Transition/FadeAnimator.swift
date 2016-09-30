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

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        let containerView = transitionContext.containerView
        toVC.view.frame = toVC.view.frame.offsetBy(dx: 0.0, dy: -toVC.view.frame.size.height)
        containerView.addSubview(toVC.view)

        self.dynamicAnimator = UIDynamicAnimator(referenceView: containerView)
        self.dynamicAnimator.delegate = self

        self.collisionBehavior = UICollisionBehavior(items: [toVC.view])
        self.collisionBehavior.addBoundary(withIdentifier: "bottom" as NSCopying, from: CGPoint(x: 0, y: containerView.frame.size.height + 1), to: CGPoint(x: containerView.frame.size.width, y: containerView.frame.size.height + 1))

        self.gravityBehavior = UIGravityBehavior(items: [toVC.view])
        self.gravityBehavior.magnitude = 4.0

        self.dynamicAnimator.addBehavior(self.collisionBehavior)
        self.dynamicAnimator.addBehavior(self.gravityBehavior)

        self.context = transitionContext
    }

    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        self.context.completeTransition(true)
    }
}
