//
//  FadeViewContainerVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Andrii Kravchenko. All rights reserved.
//

import UIKit

class FadeViewContainerVC: UIViewController {

    @IBAction func dropViewClicked(_ sender: UIButton) {
        if let fadeVC = self.storyboard?.instantiateViewController(withIdentifier: FadeViewVC.identifier()) {
            self.present(fadeVC, animated: true, completion: nil)
        }
    }
}
