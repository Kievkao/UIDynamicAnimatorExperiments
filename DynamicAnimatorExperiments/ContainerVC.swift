//
//  ContainerVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/26/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController, DynamicTopVCDelegate {
    
    let kContentVCSegueIdentifier = "ContentVCSegue"
    let kMaxRightShiftDistance: CGFloat = 280.0
    let kPushByButtonShiftDistance: CGFloat = 50.0
    
    @IBOutlet weak var topVCContainer: UIView!

    var animator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var pushBehavior: UIPushBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        // create collision boundaries based on screen size with additional area over right side for shifting by pan
        let collisionBehavior = UICollisionBehavior(items: [self.topVCContainer])
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(0, -1, 0, -kMaxRightShiftDistance))
        
        // create gravity effect based on left screen side
        self.gravityBehavior = UIGravityBehavior(items: [self.topVCContainer])
        self.gravityBehavior.gravityDirection = CGVectorMake(-1, 0)
        
        self.pushBehavior = UIPushBehavior(items: [self.topVCContainer], mode: .Instantaneous)
        self.pushBehavior.magnitude = 0.0   // for Instantaneous mode we cannot use this property
        self.pushBehavior.angle = 0.0       // angle is equal to direction property
        self.pushBehavior.pushDirection = CGVectorMake(kPushByButtonShiftDistance, 0.0)
        self.pushBehavior.active = false
        
        // elasticity determines bouncing in the moment, when topVC touches border of parent view
        let itemBehavior = UIDynamicItemBehavior(items: [self.topVCContainer])
        itemBehavior.elasticity = 0.5
        
        self.animator.addBehavior(collisionBehavior)
        self.animator.addBehavior(self.gravityBehavior)
        self.animator.addBehavior(self.pushBehavior)
        self.animator.addBehavior(itemBehavior)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == kContentVCSegueIdentifier {
            let topVC: TopVC = segue.destinationViewController as! TopVC
            topVC.delegate = self
        }
    }
    
    func topVCTestBtnClicked(viewController: UIViewController) {
        //self.pushBehavior.pushDirection = CGVectorMake(kPushByButtonShiftDistance, 0.0)
        self.pushBehavior.active = true
    }
}
