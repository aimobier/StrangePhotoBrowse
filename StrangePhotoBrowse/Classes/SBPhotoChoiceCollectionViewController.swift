//
//  SBPhotoChoiceCollectionViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/6.
//

import UIKit
import Photos


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


protocol SBPhotoChoiceCollectionViewControllerDelegate {
    
    /// 用户选择了 其他的相册
    ///
    /// - Parameters:
    ///   - assetCollection: 相册对象
    ///   - fetchResults: 相册内的数据
    func didChioce(assetCollection:PHAssetCollection?,fetchResults:PHFetchResult<PHAsset>)
}

class SBPhotoChoiceTableBackView: UIView{
    
    var maskLayer: CAShapeLayer!
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if maskLayer != nil { return }
        
        maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        
        self.layer.mask = maskLayer
    }
}

extension SBPhotoChoiceCollectionViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SBPhotoChoiceCollectionViewControllerDismissedAnimatedTransitioning()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SBPhotoChoiceCollectionViewControllerPresentedAnimatedTransitioning()
    }
}

class SBPhotoChoiceCollectionViewController: UIViewController{
    
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
    
    private var delegate:SBPhotoChoiceCollectionViewControllerDelegate?
    
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    
    /// 自定义 UITableView
    private let tableView = UITableView()
    fileprivate let backView = SBPhotoChoiceTableBackView()
    
    private let optionConfig:SHPhotoConfigObject
    
    /// ViewController 下方的View
    fileprivate let toolBarView = SBPhotoCollectionToolBarView(.choice)
    fileprivate let bottomLayoutView = UIView()
    
    init(optionConfig: SHPhotoConfigObject,delegate: SBPhotoChoiceCollectionViewControllerDelegate?=nil) {
        self.optionConfig = optionConfig
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        PHPhotoLibrary.shared().register(self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCancelAction))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        makeBottomToolView()
        makeSubViewLayoutMethod()
    }
}

extension SBPhotoChoiceCollectionViewController{
    
    func makeSubViewLayoutMethod() {
        
        view.insertSubview(backView, at: 0)
        backView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: backView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 88),
            NSLayoutConstraint(item: backView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backView, attribute: .bottom, relatedBy: .equal, toItem: toolBarView, attribute: .top, multiplier: 1, constant: 0),
            ])
        
        tableView.register(SBPhotoChoiceTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = 90
        tableView.estimatedRowHeight = 90
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(tableView)
        backView.addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: backView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: backView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: backView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: backView, attribute: .bottom, multiplier: 1, constant: 0),
            ])
    }
    
    /// 制作上方的 视图
    private func makeBottomToolView(){
        
        bottomLayoutView.backgroundColor = self.optionConfig.navBarViewToolViewBackColor
        toolBarView.backgroundColor = self.optionConfig.navBarViewToolViewBackColor
        
        view.addSubview(bottomLayoutView)
        bottomLayoutView.translatesAutoresizingMaskIntoConstraints  = false
        view.addConstraints([
            NSLayoutConstraint(item: bottomLayoutView, attribute: .top, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            ])
        
        view.addSubview(toolBarView)
        toolBarView.delegate = self
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            ])
    }
}

extension SBPhotoChoiceCollectionViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SBPhotoChoiceTableViewCell
        
        let basicData = getBasicDataBy(indexPath)
        
        let title = basicData.assetCollection?.localizedTitle ?? "全部照片"
        
        let cStr = (basicData.fetchResults?.count ?? 0).s
        
        cell.titleLabel.attributedText = title.withFont(.f15).withTextColor(UIColor.black)
        cell.countLabel.attributedText = "\(cStr)张".withFont(.f13).withTextColor(UIColor.black.a5)
        
        DispatchQueue.global(qos: .background).async {
            // Background Thread
            
            let images = basicData.fetchResults?.getFirstPicture(is: 3)
            
            DispatchQueue.main.async {
                // Run UI Updates or call completion block
                
                cell.imageView1.image = images?[safe: 0]
                cell.imageView2.image = images?[safe: 1]
                cell.imageView3.image = images?[safe: 2]
            }
        }
        
        return cell
    }
    
    /// 在本页面 根据 IndexPath 获取当前Cell展示 PHAssetCollection 以及 PHFetchResult
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 数据
    private func getBasicDataBy(_ indexPath: IndexPath) -> (assetCollection:PHAssetCollection?,fetchResults:PHFetchResult<PHAsset>?){
        
        var fetchResult:PHFetchResult<PHAsset>?
        var collection:PHAssetCollection?
        
        switch Section(rawValue: indexPath.section)! {
        case .smartAlbums:
            collection = smartAlbums.object(at: indexPath.row)
        case .userCollections:
            collection = userCollections.object(at: indexPath.row) as? PHAssetCollection
        case .allPhotos:
            fetchResult = allPhotos
        }
        
        if let coll = collection {
            let sortOptions = PHFetchOptions()
            sortOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchResult = PHAsset.fetchAssets(in: coll, options: sortOptions)
        }
        
        return (collection,fetchResult)
    }
}

extension SBPhotoChoiceCollectionViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let basicData = getBasicDataBy(indexPath)
        
        guard let results = basicData.fetchResults else {
            return
        }
        
        delegate?.didChioce(assetCollection: basicData.assetCollection, fetchResults: results)
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension SBPhotoChoiceCollectionViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                allPhotos = changeDetails.fetchResultAfterChanges
                // (The table row for this one doesn't need updating, it always says "All Photos".)
            }
            
            // Update the cached fetch results, and reload the table sections to match.
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
            }
            
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
            }
        }
    }
}

extension SBPhotoChoiceCollectionViewController: SBPhotoCollectionToolBarViewDelegate,UIGestureRecognizerDelegate{
    
    func didClickCancelButton(button: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCancelAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = gestureRecognizer.location(in: self.view)
        
        return !self.backView.frame.contains(point) && !self.toolBarView.frame.contains(point) && !self.bottomLayoutView.frame.contains(point)
    }
}

extension PHFetchResult where ObjectType == PHAsset{
    
    /// 获取前几张图片
    ///
    /// - Parameter count: 前几张
    /// - Returns: 图片结合
    func getFirstPicture(is count:Int) -> [UIImage]{
        
        let scale = UIScreen.main.scale
        let thumbnailSize = CGSize(width: 66*scale, height: 66*scale)
        
        let images = self.objects(at: IndexSet(integersIn: 0..<(min(count, self.count)))).map { (asset) -> UIImage? in
            
            var rimage:UIImage?
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: thumbnailSize,
                                                  contentMode: .aspectFill,
                                                  options: options) { (image, _) in
                                                    rimage = image
            }
            
            return rimage
        }
        
        let realImages = images.filter(){ $0 != nil }.map{ $0! }
        
        return realImages
    }
}

