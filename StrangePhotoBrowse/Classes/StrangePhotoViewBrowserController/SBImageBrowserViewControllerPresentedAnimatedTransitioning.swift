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
        
        if let toViewController = transitionContext.viewController(forKey: .to) as? SBImageBrowserViewController,toViewController.ispreview {
            
            containerView.addSubview(toViewController.view)
            toViewController.view.transform = toViewController.view.transform.translatedBy(x: toViewController.view.frame.width, y: 0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toViewController.view.transform = .identity
            }) { (_) in
                
                transitionContext.completeTransition(true)
            }
            return;
        }
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? SBImageBrowserViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? StrangePhotoViewController,
            let indexPath = fromViewController.collectionView.indexPathsForSelectedItems?.first,
            let cell = fromViewController.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell,
        let toSubViewController = toViewController.viewControllers?.first as? SBImageViewController
        else{
            return transitionContext.completeTransition(true)
        }
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let fromMode = cell.imageView.contentMode
        let toMode = toSubViewController.imageView.contentMode
        
        let toRect = toSubViewController.imageView.frame
        let fromRect = fromViewController.view.convert(cell.frame, from: fromViewController.collectionView)

        containerView.addSubview(toViewController.view)

        toSubViewController.imageView.frame = fromRect
        toSubViewController.imageView.contentMode = fromMode

        toViewController.topLayoutView.alpha = 0
        toViewController.navgationBarView.alpha = 0
        
        toViewController.bottomLayoutView.alpha = 0
        toViewController.toolBarView.alpha = 0
        
        toViewController.collectionView.alpha = 0
        
        toViewController.view.backgroundColor = toViewController.view.backgroundColor?.a0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)-0.1) {
            
            toViewController.collectionView.alpha = 1
            
            toViewController.topLayoutView.alpha = 1
            toViewController.navgationBarView.alpha = 1
            
            toViewController.bottomLayoutView.alpha = 1
            toViewController.toolBarView.alpha = 1
            
            toViewController.view.backgroundColor = toViewController.view.backgroundColor?.a10
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            toSubViewController.imageView.frame = toRect
            toSubViewController.imageView.contentMode = toMode
            
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
}


class SBImageBrowserViewControllerDismissedAnimatedTransitioning: UIPercentDrivenInteractiveTransition,UIViewControllerAnimatedTransitioning {
    
    
    //////////// UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if let toViewController = transitionContext.viewController(forKey: .to) ,let fromViewController = transitionContext.viewController(forKey: .from) as? SBImageBrowserViewController,fromViewController.ispreview {
            
            transitionContext.containerView.insertSubview(toViewController.view, at: 0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromViewController.view.transform = fromViewController.view.transform.translatedBy(x: toViewController.view.frame.width, y: 0)
            }) { (_) in
                
                transitionContext.completeTransition(true)
            }
            return;
        }
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? StrangePhotoViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? SBImageBrowserViewController,
            let fromSubViewController = fromViewController.viewControllers?.first as? SBImageViewController
        else {
                return transitionContext.completeTransition(true)
        }
        
        let indexPath = IndexPath(item: fromSubViewController.indexPage, section: 0)
        
        guard let cell = toViewController.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell else{
            return transitionContext.completeTransition(true)
        }
        
        cell.imageView.isHidden = true
        
        let toMode = cell.imageView.contentMode
        let toRect = toViewController.view.convert(cell.frame, from: toViewController.collectionView)
        
        fromSubViewController.imageView.contentMode = toMode
        
        transitionContext.containerView.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            
            fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.a0
            
            fromViewController.collectionView.alpha = 0
            
            fromViewController.topLayoutView.alpha = 0
            fromViewController.navgationBarView.alpha = 0
            
            fromViewController.bottomLayoutView.alpha = 0
            fromViewController.toolBarView.alpha = 0
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            fromSubViewController.imageView.frame = toRect
            
        }) { (_) in
            
            cell.imageView.isHidden = false
            
            transitionContext.completeTransition(true)
        }
    }
    
    ///////////// UIPercentDrivenInteractiveTransition
    
    var isDismissInteractive = false
    
    var scale:CGFloat = 1
    var rotation:CGFloat = 0
    var currentImageCenterPoint = CGPoint.zero
    
    private var containerView:UIView!
    private var transitionContext: UIViewControllerContextTransitioning!
    
    private var toViewController:StrangePhotoViewController!
    private var fromViewController:SBImageBrowserViewController!
    private var fromSubViewController:SBImageViewController!
    
    private var toCell:SBPhotoCollectionViewCell?
    
    /// 该值为true时，才会进行来源页面的上下视图隐藏动画
    private var animateToHiddenTopAndBottomView = false
    
    //// 是不是 滑动手势触发的该对象
    var isPan = false
    
    /// 记录进来页面时的 StatusBar 是否隐藏情况
    private var isHiddenStatusBar = false
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? StrangePhotoViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? SBImageBrowserViewController,
            let fromSubViewController = fromViewController.viewControllers?.first as? SBImageViewController
            else {
                return transitionContext.completeTransition(true)
        }
        
        self.transitionContext = transitionContext
        
        self.containerView = transitionContext.containerView
        self.toViewController = toViewController
        self.fromViewController = fromViewController
        self.fromSubViewController = fromSubViewController
        
        transitionContext.containerView.insertSubview(toViewController.view, at: 0)
        
        let indexPath = IndexPath(item: fromSubViewController.indexPage, section: 0)
        
        guard let cell = toViewController.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell else{
            return transitionContext.completeTransition(true)
        }
        
        toCell = cell
        toCell?.isHidden = true
        
        animateToHiddenTopAndBottomView = fromViewController.navgationBarView.transform == .identity
        
        scale = 1
        rotation = 0
        currentImageCenterPoint = .zero
        
        if !SBPhotoConfigObject.share.BaseStatusBarViewController {
            
            fromViewController.sbIsStatusBarHidden = false
            self.isHiddenStatusBar = fromViewController.sbIsStatusBarHidden
        }
        
        fromViewController.beginAppearanceTransition(true, animated: true)
    }
    
    @discardableResult
    func updatePanParam(_ center:CGPoint?=nil,scale:CGFloat?=nil,rotation:CGFloat?=nil) -> SBImageBrowserViewControllerDismissedAnimatedTransitioning {
        if let r = rotation {
            self.rotation = r
        }
        
        if let s = scale {
            self.scale = s
        }
        
        if let p = center {
            self.currentImageCenterPoint = p
        }
        return self
    }
    
    override func update(_ percentComplete: CGFloat) {
        
        let progress = max(0, min(percentComplete, 1))
        
        if fromSubViewController == nil { return }
        
        if isPan {
            fromSubViewController.imageView.transform = CGAffineTransform(scaleX: scale-(0.2*progress), y: scale-(0.2*progress))
        }else{
            fromSubViewController.imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        fromSubViewController.imageView.center = currentImageCenterPoint
        fromSubViewController.imageView.transform = fromSubViewController.imageView.transform.rotated(by: rotation)
        
        makeProgress(progress: progress)
    }
    
    override func cancel() {
        
        if self.toCell == nil {
            
            let indexPath = IndexPath(item: fromSubViewController.indexPage, section: 0)
            
            if let cell = toViewController.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell {
                
                self.toCell = cell
            }
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            self.makeProgress(progress: 0)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: self.transitionContext), delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.fromSubViewController.imageView.transform = .identity
            self.fromSubViewController.imageView.center = self.fromSubViewController.startImagePoint
        }) { (_) in
            
            self.toCell?.isHidden = false
            
            self.transitionContext.completeTransition(false)
            
            if !SBPhotoConfigObject.share.BaseStatusBarViewController {
                
                self.fromViewController.sbIsStatusBarHidden = self.isHiddenStatusBar
            }
            
            self.dealloc()
        }
    }
    
    override func finish() {

        fromViewController.beginAppearanceTransition(false, animated: true)
        
        guard let cell = toCell else {
            
            self.transitionContext.completeTransition(true)
            return
        }
        
        let toMode = cell.imageView.contentMode
        let toRect = toViewController.view.convert(cell.frame, from: toViewController.collectionView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            self.fromSubViewController.imageView.contentMode = toMode
            self.makeProgress(progress: 1)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.fromSubViewController.imageView.transform = .identity
            self.fromSubViewController.imageView.frame = toRect
            
        }) { (_) in
            
            cell.isHidden = false
            
            self.transitionContext.completeTransition(true)
            
            self.dealloc()
        }
    }

    private func makeProgress(progress:CGFloat){
        
        fromViewController.view.backgroundColor =  fromViewController.view.backgroundColor?.withAlphaComponent(1-progress) ?? .white
        
        if animateToHiddenTopAndBottomView {
            
            fromViewController.collectionView.alpha = 1-progress
            
            fromViewController.topLayoutView.alpha = 1-progress
            fromViewController.navgationBarView.alpha = 1-progress
            
            fromViewController.bottomLayoutView.alpha = 1-progress
            fromViewController.toolBarView.alpha = 1-progress
        }
        
        toViewController.topLayoutView.alpha = progress
        toViewController.navgationBarView.alpha = progress
        
        toViewController.bottomLayoutView.alpha = progress
        toViewController.toolBarView.alpha = progress
    }
    
    func dealloc()  {
        
        self.transitionContext = nil
        self.toViewController = nil
        self.fromViewController = nil
        self.fromSubViewController = nil
        self.toCell = nil
    }
}
