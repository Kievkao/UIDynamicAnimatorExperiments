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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC: UIViewController? = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC: UIViewController? = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView: UIView? = transitionContext.containerView
        
        self.setupDynamicAnimator(fromVC, toVC: toVC, containerView: containerView)
        
        if self.isPresented == true {
            self.animatePresentation(transitionContext, fromVC: fromVC, toVC: toVC, containerView: containerView)
        }
        else {
            self.animateDismissal(transitionContext, fromVC: fromVC, toVC: toVC, containerView: containerView)
        }
    }
    
    func setupDynamicAnimator(_ fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView?) {
        self.dynamicAnimator = UIDynamicAnimator(referenceView: containerView!)
    }
    
    func animatePresentation(_ transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView?) {
        
        toVC?.view.frame = (transitionContext?.finalFrame(for: toVC!))!
        
        // we have to add toVC to container. In this example we use PresentationController, where we do it. Otherwise we would have to do it here
    
        let snapBehaviour = UISnapBehavior(item: (toVC?.view)!, snapTo: (containerView?.center)!)
        snapBehaviour.damping = 0.65
        self.dynamicAnimator.addBehavior(snapBehaviour)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            transitionContext?.completeTransition(true)
        }
    }
    
    func animateDismissal(_ transitionContext: UIViewControllerContextTransitioning?, fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView?) {

        let gravityBehavior = UIGravityBehavior(items: [(fromVC?.view)!])
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 10)
        self.dynamicAnimator.addBehavior(gravityBehavior)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            transitionContext?.completeTransition(true)
        }
    }
}
