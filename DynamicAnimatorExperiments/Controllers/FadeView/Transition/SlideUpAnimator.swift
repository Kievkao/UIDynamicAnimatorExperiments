//
//  SlideUpAnimator.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class SlideUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            transitionContext.completeTransition(false)
            return
        }

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: { 
            fromVC.view.frame = fromVC.view.frame.offsetBy(dx: 0, dy: -fromVC.view.frame.size.height)
            }) { (success) in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(success)
        }
    }
}
