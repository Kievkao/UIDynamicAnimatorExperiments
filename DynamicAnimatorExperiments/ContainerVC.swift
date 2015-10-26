//
//  ContainerVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/26/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController, DynamicTopVCDelegate, UIGestureRecognizerDelegate {
    
    let kContentVCSegueIdentifier = "ContentVCSegue"
    let kMaxRightShiftDistance: CGFloat = 280.0
    let kPushByButtonShiftDistance: CGFloat = 50.0
    
    @IBOutlet weak var topVCContainer: UIView!

    var animator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var pushBehavior: UIPushBehavior!
    
    var panAttachmentBehavior: UIAttachmentBehavior?
    var leftScreenEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var rightScreenEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var topVCOpened: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftScreenEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target:self, action:"handleScreenPan:")
        self.leftScreenEdgeGestureRecognizer.edges = .Left
        self.leftScreenEdgeGestureRecognizer.delegate = self
        
        self.rightScreenEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target:self, action:"handleScreenPan:")
        self.rightScreenEdgeGestureRecognizer.edges = .Right
        self.rightScreenEdgeGestureRecognizer.delegate = self
        
        self.view.addGestureRecognizer(self.leftScreenEdgeGestureRecognizer)
        self.view.addGestureRecognizer(self.rightScreenEdgeGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        // create collision boundaries based on screen size with additional area over right side for shifting by pan
        let collisionBehavior = UICollisionBehavior(items: [self.topVCContainer])
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(0, 0, 0, -kMaxRightShiftDistance))
        
        // create gravity effect based on left screen side
        self.gravityBehavior = UIGravityBehavior(items: [self.topVCContainer])
        self.gravityBehavior.gravityDirection = CGVectorMake(-1, 0)
        
        self.pushBehavior = UIPushBehavior(items: [self.topVCContainer], mode: .Instantaneous)
        self.pushBehavior.magnitude = 0.0   // for Instantaneous mode we cannot use this property
        self.pushBehavior.angle = 0.0       // angle is equal to direction property
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
        self.pushBehavior.pushDirection = CGVectorMake(kPushByButtonShiftDistance, 0.0)
        self.pushBehavior.active = true
    }
    
    func handleScreenPan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        var location = gestureRecognizer.locationInView(self.view)
        location.y = CGRectGetMidY(self.topVCContainer.bounds)
        
        switch gestureRecognizer.state {
        
        case .Began:
            self.animator.removeBehavior(self.gravityBehavior)
            self.panAttachmentBehavior = UIAttachmentBehavior(item: self.topVCContainer, attachedToAnchor: location)
            self.animator.addBehavior(self.panAttachmentBehavior!)
            
        case .Changed:
            self.panAttachmentBehavior!.anchorPoint = location
            
        case .Ended:
            self.animator.removeBehavior(self.panAttachmentBehavior!)
            self.panAttachmentBehavior = nil
            
            let velocity = gestureRecognizer.velocityInView(self.view)
            
            if velocity.x > 0 {
                self.topVCOpened = true
                self.gravityBehavior.gravityDirection = CGVectorMake(1, 0)
            }
            else {
                self.topVCOpened = false
                self.gravityBehavior.gravityDirection = CGVectorMake(-1, 0)
            }
            
            self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 10, 0)
            self.pushBehavior.active = true
            
            self.animator.addBehavior(self.gravityBehavior)
            
        default:
            break
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {

        if (gestureRecognizer == self.leftScreenEdgeGestureRecognizer) && !self.topVCOpened {
            return true
        }
        else if (gestureRecognizer == self.rightScreenEdgeGestureRecognizer) && self.topVCOpened {
            return true
        }
        else {
            return false
        }
    }
}
