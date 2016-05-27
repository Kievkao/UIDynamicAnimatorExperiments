//
//  FadeViewVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class FadeViewVC: UIViewController {

    let transitionDelegate = FadeTransitionDelegate()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.presentationSetup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.presentationSetup()
    }

    func presentationSetup() {
        self.transitioningDelegate = self.transitionDelegate
        self.modalPresentationStyle = .Custom
    }

    static func identifier() -> String {
        return "FadeViewVC"
    }

    @IBAction func dismissClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
