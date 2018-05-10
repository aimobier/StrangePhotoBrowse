//
//  SBImageBrowserViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit
import Photos

protocol SBImageBrowserViewControllerDelegate {
    
    /// 视图 是否点击 选择按钮
    func browserDidClickSelectButton(viewController:SBImageBrowserViewController,button: SBPhotoCollectionButton)
    
    /// 视图 是否点击 原图按钮
    func browserDidClickOriginalButton(viewController:SBImageBrowserViewController,button: UIButton)
    
    /// 视图点击 提交按钮
    func browserDidClickSubmitButton(viewController:SBImageBrowserViewController,button: UIButton)
}

extension SBImageBrowserViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return dismissedAnimatedTransitioning
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return presentedAnimatedTransitioning
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if dismissedAnimatedTransitioning.isDismissInteractive && !ispreview{
            
            return dismissedAnimatedTransitioning
        }
        
        dismissedAnimatedTransitioning.isDismissInteractive = false
        
        return nil
    }
}

class SBImageBrowserViewController: UIPageViewController{
    
    var dismissedAnimatedTransitioning = SBImageBrowserViewControllerDismissedAnimatedTransitioning()
    var presentedAnimatedTransitioning = SBImageBrowserViewControllerPresentedAnimatedTransitioning()
    
    let viewController: StrangePhotoViewController
    
    /// ViewController 上方的View
    let topLayoutView = UIView()
    let navgationBarView = SBPhotoCollectionNavBarView(.cancel)
    
    /// ViewController 下方的View
    let toolBarView = SBPhotoCollectionToolBarView(.preview)
    let bottomLayoutView = UIView()
    
    var browserDelegate: SBImageBrowserViewControllerDelegate?
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(viewController: StrangePhotoViewController,currentIndex:Int,previews:[PHAsset]? = nil) {
        
        self.previewDs = previews
        self.ispreview = self.previewDs != nil
        self.viewController = viewController
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [
            UIPageViewControllerOptionInterPageSpacingKey: SBPhotoConfigObject.share.pageViewControllerOptionInterPageSpace
            ])
        
//        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
        self.dataSource = self
        self.delegate = self
        
        self.browserDelegate = viewController
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
        let viewController = SBImageViewController(asset: PHASSETDATASOURCE[currentIndex], viewController: self)
        viewController.indexPage = currentIndex
        self.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    let ispreview:Bool
    private let previewDs:[PHAsset]?
    /// DataSource
    private var PHASSETDATASOURCE: [PHAsset] {
        if ispreview {
            return previewDs!
        }
        return self.viewController.fetchResult.getAllAsset()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.makeTopNavView()
        self.makeBottomToolView()
        
        self.updateToolBarViewSelectButton()
    }
    
    var sbStatusBarStyle:UIStatusBarStyle = .lightContent{
        didSet{
            UIApplication.shared.setStatusBarStyle(sbStatusBarStyle, animated: true)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var sbIsStatusBarHidden:Bool = false{
        didSet{
            UIApplication.shared.setStatusBarHidden(sbIsStatusBarHidden, with: UIStatusBarAnimation.none)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.sbStatusBarStyle
    }
    override var prefersStatusBarHidden: Bool{
        return self.sbIsStatusBarHidden
    }
}

extension SBImageBrowserViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let nViewController = viewController as? SBImageViewController else { return nil }
        
        let index = nViewController.indexPage + 1
        
        if index >= PHASSETDATASOURCE.count { return nil }
        
        let toViewController = SBImageViewController(asset: PHASSETDATASOURCE[index], viewController: self)
        
        toViewController.indexPage = index
        
        return toViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let nViewController = viewController as? SBImageViewController else { return nil }
        
        let index = nViewController.indexPage - 1
        
        if index <= 0 { return nil }
        
        let toViewController = SBImageViewController(asset: PHASSETDATASOURCE[index], viewController: self)
        
        toViewController.indexPage = index
        
        return toViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        didChangeViewControllerItem()
        
        updateToolBarViewSelectButton()
    }
    
    /// 当用户完成 了 PageViewController 切换 ViewController
    /// 切换完成之后 获取 IndexPath ，如果 VisibleItems 不存在该 IndexPath
    /// 则显示 CollectionView 进行 ScrollToItem 处理 用于完成 Dismiss Cell 切换动画使用
    func didChangeViewControllerItem()  {
        
        guard let currentViewController = self.viewControllers?.first as? SBImageViewController else { return }
        
        let indexPath = IndexPath(item: currentViewController.indexPage, section: 0)
        
        if !self.viewController.collectionView.indexPathsForVisibleItems.contains(indexPath) {
            
            viewController.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        }
    }
}


extension SBImageBrowserViewController{
    
    /// 制作上方的 视图
    private func makeTopNavView() {
        
        topLayoutView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        navgationBarView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        
        view.addSubview(navgationBarView)
        navgationBarView.delegate = self
        navgationBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: navgationBarView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: navgationBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: navgationBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: navgationBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
            ])
        
        navgationBarView.submitButton.isEnabled = self.viewController.navgationBarView.submitButton.isEnabled
        
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
        
        self.viewController.updateOriginalButton(button: toolBarView.originalButton)
        toolBarView.delegate = self
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
    func handleSingleTapAction(_ foreceHidden:Bool=false)  {
        
        UIView.animate(withDuration: 0.3) {
            
            if foreceHidden || self.navgationBarView.transform == .identity {
                
                self.view.backgroundColor = UIColor.black
                
                UIApplication.shared.setStatusBarHidden(true, with: .slide)
                self.topLayoutView.transform = self.topLayoutView.transform.translatedBy(x: 0, y: -self.topLayoutView.frame.height)
                self.navgationBarView.transform = self.navgationBarView.transform.translatedBy(x: 0, y: -self.navgationBarView.frame.height-self.topLayoutView.frame.height)
                
                self.bottomLayoutView.transform = self.bottomLayoutView.transform.translatedBy(x: 0, y: self.bottomLayoutView.frame.height)
                self.toolBarView.transform = self.toolBarView.transform.translatedBy(x: 0, y: self.toolBarView.frame.height+self.bottomLayoutView.frame.height)
                
                self.sbIsStatusBarHidden = true
            }else{
                
                self.view.backgroundColor = UIColor.white
                
                UIApplication.shared.setStatusBarHidden(false, with: .slide)
                
                self.topLayoutView.transform = .identity
                self.navgationBarView.transform = .identity
                
                self.toolBarView.transform = .identity
                self.bottomLayoutView.transform = .identity
                
                self.sbIsStatusBarHidden = false
            }
        }
    }
    
    func updateToolBarViewSelectButton()  {
        
        guard let imageViewController = self.viewControllers?.first as? SBImageViewController else { return }
        
        self.toolBarView.selectButton.sb_setSelected(index: self.viewController.selectedAsset.index(of: imageViewController.item), animate: false)
    }
}

extension SBImageBrowserViewController: SBPhotoCollectionNavBarViewDelegate{
    
    func didClickSubmitButton(button: UIButton) {
        
        self.browserDelegate?.browserDidClickSubmitButton(viewController: self, button: button)
    }
    
    func didClickCancelButton(button: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension SBImageBrowserViewController: SBPhotoCollectionToolBarViewDelegate{
    
    func didClickSelectButton(button: SBPhotoCollectionButton) {
        
        self.browserDelegate?.browserDidClickSelectButton(viewController: self, button: button)
    }
    
    func didClickOriginalButton(button: UIButton) {
        
        self.browserDelegate?.browserDidClickOriginalButton(viewController: self, button: button)
    }
}
