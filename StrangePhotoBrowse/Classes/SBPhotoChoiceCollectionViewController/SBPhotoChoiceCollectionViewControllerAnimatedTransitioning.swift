//
//  SBPhotoChoiceCollectionViewControllerAnimatedTransitioning.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/10.
//

import UIKit

class SBPhotoChoiceCollectionViewControllerPresentedAnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? SBPhotoChoiceCollectionViewController else{
            fatalError("Boom shaga laga")
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        
        toViewController.view.backgroundColor = UIColor.black.a0
        
        toViewController.backView.transform = toViewController.backView.transform.translatedBy(x: 0, y: toViewController.view.frame.height)
        
        toViewController.toolBarView.alpha = 0
        toViewController.bottomLayoutView.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            toViewController.view.backgroundColor = UIColor.black.a4
            
            toViewController.backView.transform = .identity
            
            
            toViewController.toolBarView.alpha = 1
            toViewController.bottomLayoutView.alpha = 1
            
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
}

class SBPhotoChoiceCollectionViewControllerDismissedAnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? SBPhotoChoiceCollectionViewController else{
            fatalError("Boom sha ga la ga")
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromViewController.view.backgroundColor = UIColor.black.a0
            
            fromViewController.backView.transform = fromViewController.backView.transform.translatedBy(x: 0, y: fromViewController.view.frame.height)
            
            fromViewController.toolBarView.alpha = 0
            fromViewController.bottomLayoutView.alpha = 0
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
}
