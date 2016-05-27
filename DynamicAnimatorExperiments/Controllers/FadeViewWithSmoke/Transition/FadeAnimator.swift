//
//  FadeAnimator.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard   let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                let containerView = transitionContext.containerView()
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toVC.view)
        transitionContext.completeTransition(true)
    }
}
