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
        self.containerView?.addSubview(self.presentedView!)
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        
        let width: CGFloat = 200.0
        let height: CGFloat = 100.0
        let frame = CGRect(x: self.containerView!.center.x - width/2, y: self.containerView!.frame.minY - height, width: width, height: height)
        return frame
    }
}
