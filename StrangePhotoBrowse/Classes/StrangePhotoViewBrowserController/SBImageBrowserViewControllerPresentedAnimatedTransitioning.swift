//
//  SBImageBrowserViewControllerPresentedAnimatedTransitioning.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

class SBImageBrowserViewControllerPresentedAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? SBImageBrowserViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? StrangePhotoViewController,
            let indexPath = fromViewController.collectionView.indexPathsForSelectedItems?.first,
            let cell = fromViewController.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell,
        let toSubViewController = toViewController.viewControllers?.first as? SBImageViewController
        else{
            return transitionContext.completeTransition(true)
        }
        
        let fromMode = cell.imageView.contentMode
        let toMode = toSubViewController.imageView.contentMode
        
        let toRect = toSubViewController.imageView.frame
        let fromRect = fromViewController.view.convert(cell.frame, from: fromViewController.collectionView)

        containerView.addSubview(toViewController.view)

        toSubViewController.imageView.frame = fromRect
        toSubViewController.imageView.contentMode = fromMode
        toViewController.view.backgroundColor = toViewController.view.backgroundColor?.a0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            toSubViewController.imageView.frame = toRect
            toSubViewController.imageView.contentMode = toMode
            
            toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(10)
            
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
}


class SBImageBrowserViewControllerDismissedAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? StrangePhotoViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? SBImageBrowserViewController,
            let fromSubViewController = fromViewController.viewControllers?.first as? SBImageViewController
        else {
                return transitionContext.completeTransition(true)
        }
        
        let indexPath = IndexPath(item: fromSubViewController.indexPage, section: 0)
        
        if !toViewController.collectionView.indexPathsForVisibleItems.contains(indexPath) {
            toViewController.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        }
        
        DispatchQueue.main.async {
            
            guard let cell = toViewController.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell else{
                return transitionContext.completeTransition(true)
            }
            
            cell.imageView.isHidden = true
            
            let toMode = cell.imageView.contentMode
            let toRect = toViewController.view.convert(cell.frame, from: toViewController.collectionView)
            
            fromSubViewController.imageView.contentMode = toMode
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
                
                fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.a0
            }
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                fromSubViewController.imageView.frame = toRect
                
            }) { (_) in
                
                cell.imageView.isHidden = false
                
                transitionContext.completeTransition(true)
            }
        }
    }
}
