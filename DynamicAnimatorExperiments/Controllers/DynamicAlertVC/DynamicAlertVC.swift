//
//  DynamicAlertVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/16/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DynamicAlertVC : UIViewController, UIGestureRecognizerDelegate {

    let dynamicAlertTransDelegate = DynamicAlertTransitionDelegate()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.presentationSetup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.presentationSetup()
    }
    
    func presentationSetup() {
        self.transitioningDelegate = self.dynamicAlertTransDelegate
        self.modalPresentationStyle = .custom
    }
    
    @IBAction func closeClicked(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
