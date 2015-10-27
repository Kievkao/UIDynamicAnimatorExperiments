//
//  DynamicFlowLayout.swift
//  DynamicAnimatorExperiments
//
//  Created by Andrii Kravchenko on 10/27/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import UIKit

class DynamicFlowLayout: UICollectionViewFlowLayout {
    
    var dynamicAnimator: UIDynamicAnimator!

    override init() {
        super.init()
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(44, 44);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let contentSize = self.collectionView?.contentSize
        let items = super.layoutAttributesForElementsInRect(CGRectMake(0.0, 0.0, (contentSize?.width)!, (contentSize?.height)!))
        
        if self.dynamicAnimator.behaviors.count == 0 {
            for item in items! {
                let attachBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: (item as UIDynamicItem).center)
                attachBehavior.length = 0.0
                attachBehavior.damping = 0.8
                attachBehavior.frequency = 1.0
                
                self.dynamicAnimator.addBehavior(attachBehavior)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        
        let scrollView: UIScrollView! = self.collectionView
        let delta = newBounds.origin.y - scrollView.bounds.origin.y
        let touchLocation = self.collectionView?.panGestureRecognizer.locationInView(self.collectionView)
        
        for behavior in self.dynamicAnimator.behaviors {
            
            let yDistanceFromTouch = fabs(touchLocation!.y - (behavior as! UIAttachmentBehavior).anchorPoint.y)
            let xDistanceFromTouch = fabs(touchLocation!.x - (behavior as! UIAttachmentBehavior).anchorPoint.x)
            let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
            
            let layoutAttributes = (behavior as! UIAttachmentBehavior).items.first
            var center = layoutAttributes!.center
            
            if delta < 0 {
                center.y += max(delta, delta * scrollResistance)
            }
            else {
                center.y += min(delta, delta * scrollResistance)
            }
            
            layoutAttributes!.center = center
            self.dynamicAnimator.updateItemUsingCurrentState(layoutAttributes!)
        }
        
        return false
    }
}
