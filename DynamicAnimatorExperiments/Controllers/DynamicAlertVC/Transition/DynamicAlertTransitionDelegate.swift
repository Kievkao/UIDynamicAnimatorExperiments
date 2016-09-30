//
//  DynamicAlertTransitionDelegate.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/16/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DynamicAlertTransitionDelegate : NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DynamicAlertAnimatedTransitioning(isPresented: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DynamicAlertAnimatedTransitioning(isPresented: false)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DynamicAlertPresentationC(presentedViewController: presented, presenting: presenting)
    }
}
