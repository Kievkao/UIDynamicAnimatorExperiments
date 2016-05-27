//
//  FadeViewContainerVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class FadeViewContainerVC: UIViewController {

    @IBAction func dropViewClicked(sender: UIButton) {
        if let fadeVC = self.storyboard?.instantiateViewControllerWithIdentifier(FadeViewVC.identifier()) {
            self.presentViewController(fadeVC, animated: true, completion: nil)
        }
    }
}
