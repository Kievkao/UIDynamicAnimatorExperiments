//
//  DynamicCollectionVC.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/27/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DynamicCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 250
    }
    
    
}
