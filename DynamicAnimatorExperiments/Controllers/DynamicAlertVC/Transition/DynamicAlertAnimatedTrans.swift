//
//  DynamicAlertAnimatedTrans.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/16/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DynamicAlertAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresented: Bool!
    var dynamicAnimator: UIDynamicAnimator!
    
    init(isPresented: Bool) {
        self.isPresented = isPresented
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC: UIViewController? = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC: UIViewController? = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView: UIView? = transitionContext.containerView()
        
        self.setupDynamicAnimator(fromVC, toVC: toVC, containerView: containerView)
        
        if self.isPresented == true {
            self.animatePresentation(transitionContext, fromVC: fromVC, toVC: toVC, containerView: containerView)
        }
        else {
            self.animateDismissal(transitionContext, fromVC: fromVC, toVC: toVC, containerView: containerView)
        }
    }
    
    func setupDynamicAnimator(fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView?) {
        self.dynamicAnimator = UIDynamicAnimator(referenceView: containerView!)
    }
    
    func animatePresentation(transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView?) {
        
        toVC?.view.frame = (transitionContext?.finalFrameForViewController(toVC!))!
        
        // we have to add toVC to container. In this example we use PresentationController, where we do it. Otherwise we would have to do it here
    
        let snapBehaviour = UISnapBehavior(item: (toVC?.view)!, snapToPoint: (containerView?.center)!)
        snapBehaviour.damping = 0.65
        self.dynamicAnimator.addBehavior(snapBehaviour)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            transitionContext?.completeTransition(true)
        }
    }
    
    func animateDismissal(transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView?) {

        let gravityBehavior = UIGravityBehavior(items: [(fromVC?.view)!])
        gravityBehavior.gravityDirection = CGVectorMake(0, 10)
        self.dynamicAnimator.addBehavior(gravityBehavior)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            transitionContext?.completeTransition(true)
        }
    }
}
