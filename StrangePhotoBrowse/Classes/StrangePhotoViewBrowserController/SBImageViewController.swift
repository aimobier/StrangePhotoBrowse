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
    private let viewController: SBImageBrowserViewController
    
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
        self.viewController = viewController
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.frame = self.view.bounds
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight,.flexibleTopMargin,.flexibleRightMargin,.flexibleLeftMargin,.flexibleBottomMargin]
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        
        imageView.frame = self.view.bounds
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
        
        if self.item.isGif {
            
            PHImageManager.default().requestImageData(for: item, options: nil) { (data, _, _, _) in
                
                guard let ndata = data else { return }
                
                self.imageView.animatedImage = FLAnimatedImage(animatedGIFData: ndata)
            }
        }else{
            
            PHImageManager.default().requestImage(for: item, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) {[weak self] (image, _) in
                
                self?.imageView.image = image
            }
        }
        
        self.viewController.sbStatusBarStyle = SBPhotoConfigObject.share.statusStyle
    }
}

extension SBImageViewController: UIGestureRecognizerDelegate{
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer){
        
        if self.scrollView.zoomScale > 1 {
            return self.scrollView.setZoomScale(1, animated: true)
        }
        
        let touchPoint = gesture.location(in: imageView)
        let newZoomScale = scrollView.maximumZoomScale
        let xsize = scrollView.bounds.size.width / newZoomScale
        let ysize = scrollView.bounds.size.height / newZoomScale
        scrollView.zoom(to: CGRect(x: touchPoint.x - xsize/2, y: touchPoint.y - ysize/2, width: xsize, height: ysize), animated: true)
        
        self.viewController.handleSingleTapAction(true)
    }
    
    @objc func handleImageTap(gesture: UITapGestureRecognizer){
        
        self.viewController.handleSingleTapAction()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        
        switch gesture.state {
        case .began:
            self.startPoint = gesture.location(in: self.view)
            self.startImagePoint = imageView.center
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
//            self.pinch.cancelsTouchesInView = true
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
        
        if !self.viewController.dismissedAnimatedTransitioning.isDismissInteractive { return }
        
        self.viewController.dismissedAnimatedTransitioning.updatePanParam(rotation: gesture.rotation)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.pan == gestureRecognizer {
            return true
        }
        return false
    }

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.pan {
            let translation = self.pan.translation(in: self.pan.view)
            return translation.y > 0 && abs(translation.x) < abs(translation.y)
        }
        
        if gestureRecognizer == self.pinch  {
            return self.pinch.scale < 1 && self.scrollView.zoomScale == 1
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer == self.rotation && otherGestureRecognizer == self.pinch){
        
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
                frameToCenter.origin.x = (boundsSize.width - frame.width)/2
            }else{
                frameToCenter.origin.x = 0
            }
            
            if frameToCenter.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frame.height)/2
            }else{
                frameToCenter.origin.y = 0
            }
            
            self.imageView.frame = frameToCenter
        }
    }
}
