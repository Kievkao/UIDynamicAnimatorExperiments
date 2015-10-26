//
//  TopVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/26/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

protocol DynamicTopVCDelegate: class {
    
    func topVCTestBtnClicked(viewController: UIViewController)
}

class TopVC: UIViewController {
    
    weak var delegate: DynamicTopVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func testBtnClicked(sender: AnyObject) {
        self.delegate?.topVCTestBtnClicked(self)
    }
}
