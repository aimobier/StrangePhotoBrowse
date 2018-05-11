//
//  SBPhotoChoiceCollectionViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/6.
//

import UIKit
import Photos
import FLAnimatedImage

protocol SBPhotoChoiceCollectionViewControllerDelegate {
    
    /// 用户选择了 其他的相册
    ///
    /// - Parameters:
    ///   - assetCollection: 相册对象
    ///   - fetchResults: 相册内的数据
    func didChioce(assetCollection:PHAssetCollection?,fetchResults:PHFetchResult<PHAsset>)
}

// MARK: - UIViewControllerTransitioningDelegate
extension SBPhotoChoiceCollectionViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SBPhotoChoiceCollectionViewControllerDismissedAnimatedTransitioning()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SBPhotoChoiceCollectionViewControllerPresentedAnimatedTransitioning()
    }
}

class SBPhotoChoiceCollectionViewController: UIViewController{
    
    typealias IndexPathAssetCollection = (assetCollection:PHAssetCollection?,fetchResults:PHFetchResult<PHAsset>?)
    
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
    let backView = SBPhotoChoiceTableBackView()
    
    /// 选中的相册
    private var assetCollection:PHAssetCollection?
    
    /// 缓存器
    fileprivate var assetCollectionCache = [IndexPath: IndexPathAssetCollection]()
    
    /// ViewController 下方的View
    let toolBarView = SBPhotoCollectionToolBarView(.choice)
    let bottomLayoutView = UIView()
    
    init(delegate: SBPhotoChoiceCollectionViewControllerDelegate?=nil,assetCollection:PHAssetCollection?) {
        
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        self.assetCollection = assetCollection
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func sortOptions() -> PHFetchOptions{
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.predicate = NSPredicate(format: "mediaType != %d", PHAssetMediaType.video.rawValue)
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return allPhotosOptions
    }
    
    override func viewDidLoad() {
        
        allPhotos = PHAsset.fetchAssets(with: self.sortOptions())
        
        let noVideo = PHFetchOptions()
//        noVideo.predicate = NSPredicate(format: "(assetCollectionSubtype & %d) == 0 && (assetCollectionSubtype & %d) == 0", PHAssetCollectionSubtype.smartAlbumVideos,PHAssetCollectionSubtype.smartAlbumSlomoVideos)
        
//        noVideo.predicate = NSPredicate(format: "assetCollectionSubtype = %d", PHAssetCollectionSubtype.smartAlbumSlomoVideos.rawValue)
        
//        @available(iOS 8.0, *)
//        open class PHAssetCollection : PHCollection {
//
//
//            open var assetCollectionType: PHAssetCollectionType { get }
//
//            open var assetCollectionSubtype: PHAssetCollectionSubtype { get }
//
//
//            // These counts are just estimates; the actual count of objects returned from a fetch should be used if you care about accuracy. Returns NSNotFound if a count cannot be quickly returned.
//            open var estimatedAssetCount: Int { get }
//
//
//            open var startDate: Date? { get }
//
//            open var endDate: Date? { get }
//
//
//            open var approximateLocation: CLLocation? { get }
//
//            open var localizedLocationNames: [String] { get }
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: noVideo)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        PHPhotoLibrary.shared().register(self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCancelAction))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        makeBottomToolView()
        makeSubViewLayoutMethod()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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
        
        tableView.separatorStyle = .none
        
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
        
        toolBarView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        bottomLayoutView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        
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
        
        cell.selectedImageView.isHidden = true
        if (basicData.assetCollection?.localizedTitle == nil && self.assetCollection == nil) || basicData.assetCollection?.localIdentifier == self.assetCollection?.localIdentifier{
            
            cell.selectedImageView.isHidden = false
        }
        
        DispatchQueue.global(qos: .background).async {
            // Background Thread
            
            let images = basicData.fetchResults?.getFirstPicture(is: 3)
            
            DispatchQueue.main.async {
                // Run UI Updates or call completion block
                
                cell.imageView1.image = images?[safe: 0]
                cell.imageView2.image = images?[safe: 1]
                cell.imageView3.image = images?[safe: 2]
                
                if SBPhotoConfigObject.share.showGifInCollectionMainView,let asset = basicData.fetchResults?.firstObject ,asset.isGif{
                    
                    PHImageManager.default().requestImageData(for: asset, options: nil) { (data, _, _, _) in
                        guard let ndata = data else { return }
                        cell.imageView1.animatedImage = FLAnimatedImage(animatedGIFData: ndata)
                    }
                }
            }
        }
        
        return cell
    }
    
    /// 在本页面 根据 IndexPath 获取当前Cell展示 PHAssetCollection 以及 PHFetchResult
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 数据
    private func getBasicDataBy(_ indexPath: IndexPath,cache: Bool = false) -> IndexPathAssetCollection{
        
        if cache , let assest = self.assetCollectionCache[indexPath] {
            return assest
        }
        
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
            fetchResult = PHAsset.fetchAssets(in: coll, options: sortOptions())
        }
        
        let assest = (collection,fetchResult)
        
        self.assetCollectionCache[indexPath] = assest
        
        return assest
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
                tableView.reloadData()
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
            
            for indexPath in tableView.indexPathsForVisibleRows ?? [IndexPath](){
                
                guard let results = self.getBasicDataBy(indexPath,cache: true).fetchResults else { return }
                
                if let _ = changeInstance.changeDetails(for: results) {
                    
                    tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
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

