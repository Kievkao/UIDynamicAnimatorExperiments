//
//  FadeTransitionDelegate.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class FadeTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpAnimator()
    }
}
