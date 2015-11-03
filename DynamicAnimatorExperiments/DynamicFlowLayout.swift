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
    var visibleIndexPaths: NSMutableSet = NSMutableSet()
    var latestDelta: CGFloat = 0.0

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
        self.itemSize = CGSizeMake(100, 100);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let visibleRect = CGRectMake((self.collectionView?.bounds.origin.x)!, (self.collectionView?.bounds.origin.y)!, self.collectionView!.frame.size.width, self.collectionView!.frame.size.height)
        
        let visibleItems: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(visibleRect)!
        let indexPathsOfVisibleItems: Set = Set(visibleItems.map({return $0.indexPath}))
        
        let noLongerVisibleBehaviours = self.dynamicAnimator.behaviors.filter({
            !indexPathsOfVisibleItems.contains((($0 as! UIAttachmentBehavior).items.first as! UICollectionViewLayoutAttributes).indexPath)
        })
        
        for behavior: UIAttachmentBehavior in noLongerVisibleBehaviours as! [UIAttachmentBehavior] {
            self.dynamicAnimator.removeBehavior(behavior)
            self.visibleIndexPaths.removeObject((behavior.items.first as! UICollectionViewLayoutAttributes).indexPath)
        }
        
        let newlyVisibleItems = visibleItems.filter({
            !self.visibleIndexPaths.containsObject(($0 as UICollectionViewLayoutAttributes).indexPath)
        })
        
        let touchLocation = self.collectionView?.panGestureRecognizer.locationInView(self.collectionView)
        
        
        for item in newlyVisibleItems as [UICollectionViewLayoutAttributes] {
            
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: (item as UIDynamicItem).center)
            
            behavior.length = 0.0
            behavior.damping = 0.8
            behavior.frequency = 1.0
            
            if !CGPointEqualToPoint(touchLocation!, CGPointZero) {
                let yDistanceFromTouch = fabs(touchLocation!.y - behavior.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation!.x - behavior.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1300.0
                var center = item.center
                
                if self.latestDelta < 0 {
                    center.y += max(self.latestDelta, self.latestDelta * scrollResistance)
                }
                else {
                    center.y += min(self.latestDelta, self.latestDelta * scrollResistance)
                }
                
                item.center = center
            }
            
            self.dynamicAnimator.addBehavior(behavior)
            self.visibleIndexPaths.addObject(item.indexPath)
        }
    }
    
    func resetLayout() {
        self.dynamicAnimator.removeAllBehaviors()
        self.prepareLayout()
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
            let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1300.0
            
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
        
        self.latestDelta = delta
        
        return false
    }
}
