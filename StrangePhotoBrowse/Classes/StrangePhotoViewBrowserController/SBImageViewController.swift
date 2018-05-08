//
//  SBImageViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit
import Photos


class SBImageViewController: UIViewController {
    
    var indexPage = 0
    
    private let item:PHAsset
    private let viewController: SBImageBrowserViewController
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
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
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        PHImageManager.default().requestImage(for: item, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) {[weak self] (image, _) in
            
            self?.imageView.image = image
            
//            self?.calculationMaximumZoomScale()
        }
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
    }
    
    @objc func handleImageTap(gesture: UITapGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil)
        
//        self.viewController.handleSingleTapAction()
    }
    
    private func calculationMaximumZoomScale(){
        
        guard let image = self.imageView.image else{ return }
        
        let imageSize = image.size;
        let boundsSize = self.scrollView.bounds.size;
        
        let imageAspectRate = imageSize.width/imageSize.height
        let viewAspectRate = boundsSize.width/boundsSize.height
        
        if imageAspectRate > viewAspectRate {
            
            scrollView.maximumZoomScale = imageSize.width / boundsSize.width
        }else{
            scrollView.maximumZoomScale = imageSize.height / boundsSize.height
        }
        
        if imageSize.width < boundsSize.width*3 && imageSize.height < boundsSize.height*3 {
            
            scrollView.maximumZoomScale = 3
        }
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
