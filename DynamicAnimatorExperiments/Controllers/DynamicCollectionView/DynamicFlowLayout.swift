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
        self.itemSize = CGSize(width: 100, height: 100);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    override func prepare() {
        super.prepare()
        
        let visibleItems = self.visibleItems()
        let noVisibleItems = self.noVisibleItemsUsingVisible(visibleItems)
        
        self.removeBehaviorsForInvisibleItems(noVisibleItems as! [UIAttachmentBehavior])
        
        let newlyVisibleItems = visibleItems.filter({
            !self.visibleIndexPaths.contains(($0 as UICollectionViewLayoutAttributes).indexPath)
        })
        
        let touchLocation = self.collectionView?.panGestureRecognizer.location(in: self.collectionView)
        
        for item in newlyVisibleItems as [UICollectionViewLayoutAttributes] {
            
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: (item as UIDynamicItem).center)
            
            behavior.length = 0.0
            behavior.damping = 0.8
            behavior.frequency = 1.0
            
            if !touchLocation!.equalTo(CGPoint.zero) {
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
            self.visibleIndexPaths.add(item.indexPath)
        }
    }
    
    func visibleItems() -> [UICollectionViewLayoutAttributes] {
        let visibleRect = CGRect(x: (self.collectionView?.bounds.origin.x)!, y: (self.collectionView?.bounds.origin.y)!, width: self.collectionView!.frame.size.width, height: self.collectionView!.frame.size.height)
        
        return super.layoutAttributesForElements(in: visibleRect)!
    }
    
    func removeBehaviorsForInvisibleItems(_ items:[UIAttachmentBehavior]) {
        for behavior: UIAttachmentBehavior in items {
            self.dynamicAnimator.removeBehavior(behavior)
            self.visibleIndexPaths.remove((behavior.items.first as! UICollectionViewLayoutAttributes).indexPath)
        }
    }
    
    func noVisibleItemsUsingVisible(_ visibleItems: [UICollectionViewLayoutAttributes]) -> [UIDynamicBehavior] {
        let indexPathsOfVisibleItems: Set = Set(visibleItems.map({return $0.indexPath}))
        
        return self.dynamicAnimator.behaviors.filter({
            !indexPathsOfVisibleItems.contains((($0 as! UIAttachmentBehavior).items.first as! UICollectionViewLayoutAttributes).indexPath)
        })
    }
    
    func resetLayout() {
        self.dynamicAnimator.removeAllBehaviors()
        self.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCell(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        let scrollView: UIScrollView! = self.collectionView
        let delta = newBounds.origin.y - scrollView.bounds.origin.y
        let touchLocation = self.collectionView?.panGestureRecognizer.location(in: self.collectionView)
        
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
            self.dynamicAnimator.updateItem(usingCurrentState: layoutAttributes!)
        }
        
        self.latestDelta = delta
        
        return false
    }
}
