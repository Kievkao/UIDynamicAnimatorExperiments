//
//  DynamicAlertPresentationC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/16/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DynamicAlertPresentationC : UIPresentationController {
    
    override func presentationTransitionWillBegin() {
        // This should be done in Animated Transition or Presentation Controller!
        self.containerView?.addSubview(self.presentedView()!)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        let width: CGFloat = 200.0
        let height: CGFloat = 100.0
        let frame = CGRectMake(self.containerView!.center.x - width/2, CGRectGetMinY(self.containerView!.frame) - height, width, height)
        return frame
    }
}
