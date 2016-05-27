//
//  SlideUpAnimator.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class SlideUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            transitionContext.completeTransition(false)
            return
        }

        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { 
            fromVC.view.frame.offsetInPlace(dx: 0, dy: -fromVC.view.frame.size.height)
            }) { (success) in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(success)
        }
    }
}
