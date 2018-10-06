//
//  SBImageViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit
import Photos
import FLAnimatedImage

class SBImageViewController: UIViewController {
    
    var indexPage = 0
    
    let item:PHAsset
    private weak var viewController: SBImageBrowserViewController!
    
    let scrollView = UIScrollView()
    let imageView = FLAnimatedImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    //// DISMISSED NEED PROTI
    private var pan:UIPanGestureRecognizer!
    private var pinch:UIPinchGestureRecognizer!
    private var rotation:UIRotationGestureRecognizer!
    
    private var startPoint = CGPoint.zero
    var startImagePoint = CGPoint.zero
    
    init(asset:PHAsset,viewController: SBImageBrowserViewController){
        
        self.item = asset
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewController = viewController
        
        if SBPhotoConfigObject.share.previewViewControllerTopBottomSpaceZero , #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        scrollView.frame = self.view.bounds
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight,.flexibleTopMargin,.flexibleRightMargin,.flexibleLeftMargin,.flexibleBottomMargin]
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.contentInset = .zero
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        imageView.frame = scrollView.bounds
        imageView.autoresizingMask = [.flexibleWidth,.flexibleHeight,.flexibleTopMargin,.flexibleRightMargin,.flexibleLeftMargin,.flexibleBottomMargin]
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(gesture:)))
        self.view.addGestureRecognizer(imageTap)
        imageTap.require(toFail: doubleTap)
        
        if self.viewController.ispreview {
            return
        }
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        pan.maximumNumberOfTouches = 1
        pan.delaysTouchesBegan = true
        pan.delegate = self
        imageView.addGestureRecognizer(pan)
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(gesture:)))
        pinch.delegate = self
        scrollView.addGestureRecognizer(pinch)
        
        rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(gesture:)))
        rotation.delegate = self
        scrollView.addGestureRecognizer(rotation)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let options = PHImageRequestOptions()
        
        /// 消除 Warnings  [ImageManager] First stage of an opportunistic image request returned a non-table format image, this is not fatal, but it is unexpected
        options.deliveryMode = .highQualityFormat
        
        if self.item.isGif {
            
            PHImageManager.default().requestImageData(for: item, options: options) { (data, _, _, _) in
                
                guard let ndata = data else { return }
                
                self.imageView.animatedImage = FLAnimatedImage(animatedGIFData: ndata)
            }
        }else{
            
            
            let fastOptions = PHImageRequestOptions()
            fastOptions.deliveryMode = .fastFormat
            
            let size = CGSize(width: UIScreen.main.bounds.width*UIScreen.main.scale, height: UIScreen.main.bounds.width*(item.pixelWidth.f/item.pixelHeight.f)*UIScreen.main.scale)
            
            let fastRequest = PHImageManager.default().requestImage(for: item, targetSize: size, contentMode: .aspectFill, options: fastOptions) { [unowned self] (image, _) in
                
                self.imageView.image = image
            }
            
            PHImageManager.default().requestImage(for: item, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) {[weak self] (image, _) in

                self?.imageView.image = image
                PHImageManager.default().cancelImageRequest(fastRequest)
            }
        }
        
        self.viewController.sbStatusBarStyle = SBPhotoConfigObject.share.statusStyle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
    }
}

extension SBImageViewController: UIGestureRecognizerDelegate{
    
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = self.scrollView.frame.size.width / scale
        let h = self.scrollView.frame.size.height / scale
        let x = touchPoint.x - (h / max(UIScreen.main.scale, 2.0))
        let y = touchPoint.y - (w / max(UIScreen.main.scale, 2.0))
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer){
        
        if self.scrollView.zoomScale > 1 {
            return self.scrollView.setZoomScale(1, animated: true)
        }
        
        self.centerImageView()
        
        let touchPoint = gesture.location(in: self.imageView)
        
        scrollView.zoom(to: zoomRectForScrollView(scrollView: self.scrollView, scale: self.scrollView.maximumZoomScale, center: touchPoint), animated: true)
        
        self.viewController.handleSingleTapAction(true)
    }
    
    func zoomRectForScrollView(scrollView:UIScrollView,scale:CGFloat,center:CGPoint) -> CGRect {
        
        var zoomRect = CGRect()
        
        // The zoom rect is in the content view's coordinates.
        // At a zoom scale of 1.0, it would be the size of the
        // imageScrollView's bounds.
        // As the zoom scale decreases, so more content is visible,
        // the size of the rect grows.
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - zoomRect.width/2
        zoomRect.origin.y = center.y - zoomRect.height/2
        
        return zoomRect
    }
    
    @objc func handleImageTap(gesture: UITapGestureRecognizer){
        
        self.viewController.handleSingleTapAction()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        
        switch gesture.state {
        case .began:
            self.startPoint = gesture.location(in: self.view)
            self.startImagePoint = imageView.center
            self.viewController.dismissedAnimatedTransitioning.isPan = true
            self.viewController.dismissedAnimatedTransitioning.isDismissInteractive = true
            self.dismiss(animated: true, completion: nil)
        case .changed:
            let progressY = self.startImagePoint.y + gesture.translation(in: gesture.view).y.realValue
            let progressX = self.startImagePoint.x + gesture.translation(in: gesture.view).x.realValue
            let progress = (gesture.location(in: self.view).y-startPoint.y)/(self.imageView.frame.height/2)
            self.viewController.dismissedAnimatedTransitioning.updatePanParam(CGPoint(x: progressX, y: progressY)).update(progress)
        default:
            
            let progress = max(min(0.99, (gesture.location(in: self.view).y-startPoint.y)/(self.imageView.frame.height/2)), 0)
            
            if progress >= 0.5 || gesture.velocity(in: self.view).y > 800{
                
                self.viewController.dismissedAnimatedTransitioning.finish()
            }else{
                self.viewController.dismissedAnimatedTransitioning.isPan = false
                self.viewController.dismissedAnimatedTransitioning.isDismissInteractive = false
                self.viewController.dismissedAnimatedTransitioning.cancel()
            }
        }
    }
    
    @objc func handlePinch(gesture:UIPinchGestureRecognizer){
        
        switch gesture.state {
        case .began:
            self.viewController.dismissedAnimatedTransitioning.isDismissInteractive = true
            self.dismiss(animated: true, completion: nil)
            self.pinch.cancelsTouchesInView = true
            self.startImagePoint = imageView.center
        case .changed: self.viewController.dismissedAnimatedTransitioning.updatePanParam(gesture.location(in: self.view),scale: gesture.scale).update(1-gesture.scale)
        default:
            if gesture.scale <= 0.65 || gesture.velocity <= -5{
                self.viewController.dismissedAnimatedTransitioning.finish()
            }else{
                self.viewController.dismissedAnimatedTransitioning.isDismissInteractive = false
                self.viewController.dismissedAnimatedTransitioning.cancel()
            }
        }
    }
    
    @objc func handleRotation(gesture:UIRotationGestureRecognizer){
        
        guard self.viewController.dismissedAnimatedTransitioning.isDismissInteractive else { return }
        
        self.viewController.dismissedAnimatedTransitioning.updatePanParam(rotation: gesture.rotation)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.pan == gestureRecognizer {
            return true
        }
        return false
    }

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.pan && self.scrollView.zoomScale <= self.scrollView.minimumZoomScale{
            let translation = self.pan.translation(in: self.pan.view)
            return translation.y > 0 && abs(translation.x) < abs(translation.y)
        }
        
        if gestureRecognizer == self.pinch  {
            return self.pinch.scale < 1 && self.scrollView.zoomScale <= 1
        }
        
        if self.rotation == gestureRecognizer {
            
            return true
        }
        
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer == self.rotation && otherGestureRecognizer == self.pinch) || (gestureRecognizer == self.pinch && otherGestureRecognizer == self.rotation){
        
            return true
        }
        
        return true
    }
}

extension SBImageViewController: UIScrollViewDelegate{
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        self.centerImageView()
    }
    
    private func centerImageView(){
        
        if let image = self.imageView.image {
            
            var frame = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(x: 0, y: 0, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height))
            
            if self.scrollView.contentSize.width == 0 && self.scrollView.contentSize.height == 0 {
                frame = AVMakeRect(aspectRatio: image.size, insideRect: self.scrollView.bounds)
            }
            
            let boundsSize = self.scrollView.bounds.size
            
            var frameToCenter = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            
            if frameToCenter.width < boundsSize.width {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.width)/2
            }else{
                frameToCenter.origin.x = 0
            }
            
            if frameToCenter.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.height)/2
            }else{
                frameToCenter.origin.y = 0
            }
            
            self.imageView.frame = frameToCenter
        }
    }
}
