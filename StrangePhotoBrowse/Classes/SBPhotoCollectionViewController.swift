//
//  SBPhotoCollectionViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Photos

fileprivate let SCREENWIDTH = UIScreen.main.bounds.width
fileprivate let SCREENHEIGHT = UIScreen.main.bounds.height

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

public class SBPhotoCollectionViewController: UIViewController{
    
    /// ViewController 上方的View
    private let topLayoutView = UIView()
    private let navgationBarView = SBPhotoCollectionNavBarView()
    
    /// ViewController 下方的View
    private let toolBarView = SBPhotoCollectionToolBarView()
    private let bottomLayoutView = UIView()
    
    /// 默认的 collectionView FlowLayout
    
    private var emptyView:SBPhotoEmptyView!
    
    private var thumbnailSize:CGSize!
    private var previousPreheatRect = CGRect.zero
    private var collectionView : UICollectionView!
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 当前视图的
    private let imageManager = PHCachingImageManager()
    private var fetchResult: PHFetchResult<PHAsset>!
    
    /// 默认的全部照片
    private lazy var allPhotos: PHFetchResult<PHAsset> = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }()
    
    /// 当前选中的 Asset
    private var selectedAsset = [PHAsset]()
    
    /// 设置 StatusBar 类型
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    
    override public var title: String?{
        
        didSet{
            
            let title = (self.title ?? "").withFont(UIFont.f13.bold).withTextColor(UIColor.white)
            
            toolBarView.choiceButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchResult = allPhotos
        
        PHPhotoLibrary.shared().register(self)
        
        self.view.backgroundColor = SHPhotoConfigObject.share.collectionViewBackView
        
        makeTopNavView()
        makeBottomToolView()
        makeCollectionView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    deinit {
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

// MARK: - Layout Methods
extension SBPhotoCollectionViewController{
    
    /// 制作上方的 视图
    private func makeTopNavView(){
        
        navgationBarView.titleLabel.attributedText = "照片".withFont(UIFont.boldSystemFont(ofSize: 17)).withTextColor(UIColor.white)
        
        topLayoutView.backgroundColor = SHPhotoConfigObject.share.navBarViewToolViewBackColor
        navgationBarView.backgroundColor = SHPhotoConfigObject.share.navBarViewToolViewBackColor
        
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
        
        bottomLayoutView.backgroundColor = SHPhotoConfigObject.share.navBarViewToolViewBackColor
        toolBarView.backgroundColor = SHPhotoConfigObject.share.navBarViewToolViewBackColor
        
        view.addSubview(bottomLayoutView)
        bottomLayoutView.translatesAutoresizingMaskIntoConstraints  = false
        view.addConstraints([
            NSLayoutConstraint(item: bottomLayoutView, attribute: .top, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            ])
        
        toolBarView.delegate = self
        view.addSubview(toolBarView)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            ])
    }
    
    /// 制作展示图片的 CollectionView
    private func makeCollectionView(){
        
        emptyView = SBPhotoEmptyView(SHPhotoConfigObject.share.emptyTitleAttributeString, subTitle: SHPhotoConfigObject.share.emptySubTitleAttributeString)
        
        let sizeWidth = (SCREENWIDTH-SHPhotoConfigObject.share.perLineDisplayNumber.f-1)/SHPhotoConfigObject.share.perLineDisplayNumber.f
        
        collectionViewFlowLayout.itemSize = CGSize(width: sizeWidth, height: sizeWidth)
        collectionViewFlowLayout.minimumLineSpacing = 1.5
        collectionViewFlowLayout.minimumInteritemSpacing = 1
        
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: sizeWidth * scale, height: sizeWidth * scale)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: navgationBarView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: toolBarView, attribute: .top, multiplier: 1, constant: 0),
            ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SBPhotoCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SBPhotoCollectionViewCell.self))
    }
}

// MARK: - UICollectionViewDataSource
extension SBPhotoCollectionViewController: UICollectionViewDataSource,SBPhotoCollectionViewCellDelegate{
    
    private func realmNumber(_ number:Int)-> Int{
        
        self.collectionView.backgroundView = number <= 0 ? emptyView : nil
        
        return number
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return realmNumber(fetchResult.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = fetchResult.object(at: indexPath.item)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SBPhotoCollectionViewCell.self), for: indexPath) as? SBPhotoCollectionViewCell
            else { fatalError("unexpected cell in collection view") }
        
        cell.delegate = self
        
        cell.selectButton.setImage(self.selectedAsset.contains(asset) ?
            SBImageMake("photo_sel_photoPickerVc", color: SHPhotoConfigObject.share.mainColor) :
            SBImageMake("photo_def_previewVc"), for: .normal)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        return cell
    }
    
    func cellDidSelectButtonClick(_ cell: SBPhotoCollectionViewCell) {
        
        guard let index = self.collectionView.indexPath(for: cell) else{
            return
        }
        
        let asset = fetchResult.object(at: index.item)
        
        if let index = selectedAsset.index(of: asset) {
            selectedAsset.remove(at: index)
        }else{
            selectedAsset.append(asset)
        }
        
        self.collectionView.reloadItems(at: [index])
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SBPhotoCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    // MARK: UIScrollView
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}


// MARK: - PHPhotoLibraryChangeObserver
extension SBPhotoCollectionViewController: PHPhotoLibraryChangeObserver{
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view.
                collectionView.performBatchUpdates({
                    // For indexes to make sense, updates must be in this order:
                    // delete, insert, reload, move
                    if let removed = changes.removedIndexes, removed.count > 0 {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let changed = changes.changedIndexes, changed.count > 0 {
                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                // Reload the collection view if incremental diffs are not available.
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
}


extension SBPhotoCollectionViewController: SBPhotoCollectionToolBarViewDelegate{
    
    func didClickPreviewButton(button: UIButton) {
        
    }
    
    func didClickOriginalButton(button: UIButton) {
        
    }
    
    func didClickChoiceButton(button: UIButton) {
        
        self.present(SBPhotoChoiceCollectionViewController(delegate: self), animated: true, completion: nil)
    }
}


extension SBPhotoCollectionViewController: SBPhotoChoiceCollectionViewControllerDelegate{
    
    func didChioce(assetCollection: PHAssetCollection?, fetchResults: PHFetchResult<PHAsset>) {
        
        if self.fetchResult == fetchResults{
            return
        }
        
        self.title = assetCollection?.localizedTitle ?? "全部照片"
        
        self.dismiss(animated: true, completion: nil)
        
        self.fetchResult = fetchResults
        
        self.collectionView.reloadData()
    }
}
