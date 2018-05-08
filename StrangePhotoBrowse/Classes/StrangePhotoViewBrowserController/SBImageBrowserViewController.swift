//
//  SBImageBrowserViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit
import Photos

protocol SBImageBrowserViewControllerDelegate {
    
    func didChange(pageIndex:Int)
}

extension SBImageBrowserViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SBImageBrowserViewControllerDismissedAnimatedTransitioning()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SBImageBrowserViewControllerPresentedAnimatedTransitioning()
    }
}

class SBImageBrowserViewController: UIPageViewController{
    
    private let viewController: StrangePhotoViewController
    
    /// ViewController 上方的View
    private let topLayoutView = UIView()
    private let navgationBarView = SBPhotoCollectionNavBarView()
    
    /// ViewController 下方的View
    private let toolBarView = SBPhotoCollectionToolBarView()
    private let bottomLayoutView = UIView()
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(viewController: StrangePhotoViewController,currentIndex:Int) {
        
        self.viewController = viewController
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [
            UIPageViewControllerOptionInterPageSpacingKey: SBPhotoConfigObject.share.pageViewControllerOptionInterPageSpace
            ])
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
        self.dataSource = self
        
        let viewController = SBImageViewController(asset: self.viewController.fetchResult.object(at: currentIndex), viewController: self)
        viewController.indexPage = currentIndex
        self.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    override var prefersStatusBarHidden: Bool{
        return topLayoutView.transform != .identity
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
        
        self.makeTopNavView()
        self.makeBottomToolView()
    }
}

extension SBImageBrowserViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let nViewController = viewController as? SBImageViewController else { return nil }
        
        let index = nViewController.indexPage + 1
        
        if index >= self.viewController.fetchResult.count { return nil }
        
        let toViewController = SBImageViewController(asset: self.viewController.fetchResult.object(at: index), viewController: self)
        
        toViewController.indexPage = index
        
        return toViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let nViewController = viewController as? SBImageViewController else { return nil }
        
        let index = nViewController.indexPage - 1
        
        if index <= 0 { return nil }
        
        let toViewController = SBImageViewController(asset: self.viewController.fetchResult.object(at: index), viewController: self)
        
        toViewController.indexPage = index
        
        return toViewController
    }
}


extension SBImageBrowserViewController{
    
    /// 制作上方的 视图
    private func makeTopNavView() {
        
        navgationBarView.titleLabel.attributedText = "照片".withFont(UIFont.boldSystemFont(ofSize: 17)).withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor)
        
        topLayoutView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        navgationBarView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        
        view.addSubview(navgationBarView)
        navgationBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: navgationBarView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: navgationBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: navgationBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: navgationBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
            ])
        
        view.addSubview(topLayoutView)
        topLayoutView.translatesAutoresizingMaskIntoConstraints  = false
        view.addConstraints([
            NSLayoutConstraint(item: topLayoutView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topLayoutView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topLayoutView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topLayoutView, attribute: .bottom, relatedBy: .equal, toItem: navgationBarView, attribute: .top, multiplier: 1, constant: 0),
            ])
    }
    
    /// 制作上方的 视图
    private func makeBottomToolView(){
        
        bottomLayoutView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        toolBarView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        
        view.addSubview(toolBarView)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            ])
        
        view.addSubview(bottomLayoutView)
        bottomLayoutView.translatesAutoresizingMaskIntoConstraints  = false
        view.addConstraints([
            NSLayoutConstraint(item: bottomLayoutView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .top, relatedBy: .equal, toItem: toolBarView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
            ])
        
    }
    
    /// 处理单次 点击 视图
    func handleSingleTapAction()  {
        
        UIView.animate(withDuration: 0.3) {
            
            if self.navgationBarView.transform == .identity {
                
                self.view.backgroundColor = UIColor.black
                
                UIApplication.shared.setStatusBarHidden(true, with: .slide)
                self.topLayoutView.transform = self.topLayoutView.transform.translatedBy(x: 0, y: -self.topLayoutView.frame.height)
                self.navgationBarView.transform = self.navgationBarView.transform.translatedBy(x: 0, y: -self.navgationBarView.frame.height-self.topLayoutView.frame.height)
                
                self.bottomLayoutView.transform = self.bottomLayoutView.transform.translatedBy(x: 0, y: self.bottomLayoutView.frame.height)
                self.toolBarView.transform = self.toolBarView.transform.translatedBy(x: 0, y: self.toolBarView.frame.height+self.bottomLayoutView.frame.height)
            }else{
                
                self.view.backgroundColor = UIColor.white
                
                UIApplication.shared.setStatusBarHidden(false, with: .slide)
                
                self.topLayoutView.transform = .identity
                self.navgationBarView.transform = .identity
                
                self.toolBarView.transform = .identity
                self.bottomLayoutView.transform = .identity
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
