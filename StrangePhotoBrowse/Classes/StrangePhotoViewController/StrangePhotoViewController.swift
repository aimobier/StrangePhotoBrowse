//
//  StrangePhotoViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Photos
import FLAnimatedImage

fileprivate let SCREENWIDTH = UIScreen.main.bounds.width
fileprivate let SCREENHEIGHT = UIScreen.main.bounds.height

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

public class StrangePhotoViewController: UIViewController{
    
    /// ViewController 上方的View
    let topLayoutView = UIView()
    let navgationBarView = SBPhotoCollectionNavBarView()
    
    /// ViewController 下方的View
    let toolBarView = SBPhotoCollectionToolBarView()
    let bottomLayoutView = UIView()
    
    /// 空白示意图
    private var emptyView:SBPhotoEmptyView!
    
    private var thumbnailSize:CGSize! // 缩略图大小
    private var previousPreheatRect = CGRect.zero
    var collectionView : UICollectionView!
    
    /// 默认的 collectionView FlowLayout
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 是否选择了原图
    private var isOriginal = false
    
    /// 当前视图的
    private let imageManager = PHCachingImageManager()
    private var assetCollection: PHAssetCollection?
    var fetchResult: PHFetchResult<PHAsset>!
    
    public var delegate:StrangePhotoViewControllerDelegate?
    
    /// 默认的全部照片
    private lazy var allPhotos: PHFetchResult<PHAsset> = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.predicate = NSPredicate(format: "mediaType != %d", PHAssetMediaType.video.rawValue)
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }()
    
    /// 当前选中的 Asset
    var selectedAsset = [PHAsset]()
    
    /// 设置 StatusBar 类型
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return SBPhotoConfigObject.share.statusStyle
    }
    
    override public var title: String?{
        
        didSet{
            
            let title = (self.title ?? "").withFont(UIFont.f13.bold).withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor)
            
            toolBarView.choiceButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchResult = allPhotos
        
        PHPhotoLibrary.shared().register(self)
        
        self.view.backgroundColor = SBPhotoConfigObject.share.collectionViewBackViewBackgroundColor
        
        makeTopNavView()
        makeBottomToolView()
        makeCollectionView()
        
        UIApplication.shared.statusBarStyle = SBPhotoConfigObject.share.statusStyle
    }
    
    private var _isFirstNeedToScrollBottom = true
    public override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if _isFirstNeedToScrollBottom {
            _isFirstNeedToScrollBottom = false
            collectionView.scrollToItem(at: IndexPath(item: SBPhotoConfigObject.share.canTakePictures ? self.fetchResult.count : self.fetchResult.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    deinit {
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        
        #if DEBUG
        print("♻️ 相册主视图 成功销毁")
        #endif
    }
    
    /// 配置该视图的 Delegate
    ///
    /// - Parameter delegate: 代理对象
    /// - Returns: 视图
    public func makeDelegate(_ delegate:StrangePhotoViewControllerDelegate) -> StrangePhotoViewController {
     
        self.delegate = delegate
        
        return self
    }
    
    /// 取消选择 某一个已经选中的 照片
    ///
    /// - Parameter index: 选中照片的Index
    public func unSelected(_ index:Int){
        
        guard let asset = self.selectedAsset[safe: index] else {
            return
        }
        
        self.unSelected(asset)
    }
    
    /// 取消选择 某一个已经选中的 照片
    ///
    /// - Parameter asset: 资源文件
    public func unSelected(_ asset:PHAsset)  {
        
        let indexPath = IndexPath(item: fetchResult.index(of: asset), section: 0)
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell else { return }
        
        self.cellDidSelectButtonClick(cell)
    }
}

// MARK: - Layout Methods
extension StrangePhotoViewController{
    
    /// 制作上方的 视图
    private func makeTopNavView(){
        
        navgationBarView.titleLabel.attributedText = "照片".withFont(UIFont.boldSystemFont(ofSize: 17)).withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor)
        
        topLayoutView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        navgationBarView.backgroundColor = SBPhotoConfigObject.share.navBarViewToolViewBackgroundColor
        
        navgationBarView.delegate = self
        
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
        
        view.addSubview(bottomLayoutView)
        bottomLayoutView.translatesAutoresizingMaskIntoConstraints  = false
        view.addConstraints([
            NSLayoutConstraint(item: bottomLayoutView, attribute: .top, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomLayoutView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            ])
        
        updateOriginalButton(button: toolBarView.originalButton)
        
        toolBarView.delegate = self
        view.addSubview(toolBarView)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            ])
        
        refreshPreViewButtonState()
    }
    
    /// 制作展示图片的 CollectionView
    private func makeCollectionView(){
        
        emptyView = SBPhotoEmptyView(SBPhotoConfigObject.share.emptyTitleAttributeString, subTitle: SBPhotoConfigObject.share.emptySubTitleAttributeString)
        
        let sizeWidth = (SCREENWIDTH-SBPhotoConfigObject.share.perLineDisplayNumber.f-1)/SBPhotoConfigObject.share.perLineDisplayNumber.f
        
        collectionViewFlowLayout.itemSize = CGSize(width: sizeWidth, height: sizeWidth)
        collectionViewFlowLayout.minimumLineSpacing = 1.5
        collectionViewFlowLayout.minimumInteritemSpacing = 1
        
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: sizeWidth * scale, height: sizeWidth * scale)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = SBPhotoConfigObject.share.collectionViewBackViewBackgroundColor
        view.addSubview(collectionView)
        view.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: navgationBarView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: toolBarView, attribute: .top, multiplier: 1, constant: 0),
            ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SBPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "SBPhotoCollectionViewCell")
        collectionView.register(SBPhotographCollectionViewCell.self, forCellWithReuseIdentifier: "SBPhotographCollectionViewCell")
    }
}

// MARK: - UICollectionViewDataSource
extension StrangePhotoViewController: UICollectionViewDataSource,SBPhotoCollectionViewCellDelegate{
    
    private func realmNumber(_ number:Int)-> Int{
        
        self.collectionView.backgroundView = number <= 0 ? emptyView : nil
        
        return number
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return realmNumber(fetchResult.count)+(SBPhotoConfigObject.share.canTakePictures ? 1 : 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == fetchResult.count {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "SBPhotographCollectionViewCell", for: indexPath)
        }
        
        let asset = fetchResult.object(at: indexPath.item)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SBPhotoCollectionViewCell", for: indexPath) as? SBPhotoCollectionViewCell
            else { fatalError("unexpected cell in collection view") }
        
        cell.delegate = self
        
        let index = self.selectedAsset.index(of: asset)
        
        cell.coverView.isHidden = !(index == nil && SBPhotoConfigObject.share.maxCanSelectNumber <= self.selectedAsset.count)
        cell.selectButton.sb_setSelected(index: index)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        if asset.isGif && SBPhotoConfigObject.share.showGifInCollectionMainView {
            imageManager.requestImageData(for: asset, options: nil) { (data, _, _, _) in
                guard let ndata = data,cell.representedAssetIdentifier == asset.localIdentifier else { return }
                cell.imageView.animatedImage = FLAnimatedImage(animatedGIFData: ndata)
            }
        }else{
            imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.thumbnailImage = image
                }
            })
        }
        
        return cell
    }
    
    /// 当用户点击了Cell中的选择按钮
    ///
    /// - Parameter cell: cell
    func cellDidSelectButtonClick(_ cell: SBPhotoCollectionViewCell) {
        
        guard let index = self.collectionView.indexPath(for: cell) else{
            return
        }
        
        let asset = fetchResult.object(at: index.item)
        
        if let index = selectedAsset.index(of: asset) {
            
            selectedAsset.remove(at: index)
            cell.selectButton.sb_setSelected(index: selectedAsset.index(of: asset), animate: true)
            reloadIndexAfterMethod(index: index)
            
        }else{
        
            if self.selectedAsset.count >= SBPhotoConfigObject.share.maxCanSelectNumber {
                
                return alertMaxNumberWarningMethod()
            }
            
            selectedAsset.append(asset)
            cell.selectButton.sb_setSelected(index: selectedAsset.index(of: asset), animate: true)
        }
        
        refreshPreViewButtonState()
    }
    
    /// 刷新 index 之后的 选中视图
    ///
    /// - Parameter index: index
    private func reloadIndexAfterMethod(index:Int){
        
        if self.selectedAsset.count - index == 0 {
            
            return
        }
        
        var indexPaths = [IndexPath]()
        
        for asset in self.selectedAsset[index...(self.selectedAsset.count-1)]{
            
            let index = self.fetchResult.index(of: asset)
            
            let indexPath = IndexPath(item: index, section: 0)
            
            if self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
                
                indexPaths.append(indexPath)
            }
        }
        
        if indexPaths.count > 0 {
            
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
    
    /// 刷新 预览按钮 状态
    private func refreshPreViewButtonState(){
        
        let isEnabled:Bool
        let titleAttribute:NSAttributedString
        
        if self.selectedAsset.count <= 0 {
            isEnabled = false
            titleAttribute = "预览".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold)
        }else{
            
            isEnabled = true
            titleAttribute = "预览(\(self.selectedAsset.count))".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold)
        }
        
        self.navgationBarView.submitButton.isEnabled = isEnabled
        self.toolBarView.previewButton.isEnabled = isEnabled
        self.toolBarView.previewButton.setAttributedTitle(titleAttribute, for: .normal)
        
        if let viewController = self.presentedViewController as? SBImageBrowserViewController{
            
            viewController.collectionView.isHidden = !isEnabled
            viewController.navgationBarView.submitButton.isEnabled = isEnabled
        }
        
        DispatchQueue.main.async {[weak self] in
            
            self?.reloadCoverView()
        }
    }
    
    /// 刷新 View
    private func reloadCoverView(){
        
        /// 最大的不对的话 则配置 梦层 白色
        if SBPhotoConfigObject.share.maxCanSelectNumber-1 <= self.selectedAsset.count {
            
            let indexPaths = self.collectionView.indexPathsForVisibleItems
                .filter{
                    !($0.row == self.fetchResult.count && SBPhotoConfigObject.share.canTakePictures)
                }.filter(){
                    !self.selectedAsset.contains(self.fetchResult.object(at: $0.row))
            }
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
}

extension StrangePhotoViewController: SBPhotoCollectionNavBarViewDelegate{
    
    func didClickCloseButton(button: UIButton) {
        
        self.delegate?.didCancel()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func didClickSubmitButton(button: UIButton) {
        
        self.delegate?.didFinish(images:  self.selectedAsset.images(), resources:  self.selectedAsset)
        
        self.dismiss(animated: true, completion: nil)
    }
}


extension StrangePhotoViewController: SBPhotoCollectionToolBarViewDelegate, SBImageBrowserViewControllerDelegate{

    /// 点击 预览按钮
    func didClickPreviewButton(button: UIButton) {
        
        let viewController = SBImageBrowserViewController(viewController: self, currentIndex: 0, previews: self.selectedAsset)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    /// 点击原图按钮
    func didClickOriginalButton(button: UIButton) {
        
        self.isOriginal = !isOriginal
        
        self.updateOriginalButton(button: button)
    }

    /// 点击 选择相册 按钮
    func didClickChoiceButton(button: UIButton) {
        
        let viewController = SBPhotoChoiceCollectionViewController(delegate: self, assetCollection: self.assetCollection)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func browserDidClickSubmitButton(viewController: SBImageBrowserViewController, button: UIButton) {
        
        self.didClickSubmitButton(button: button)
    }
    
    /// 照片 浏览 视图 点击选择按钮
    func browserDidClickSelectButton(viewController: SBImageBrowserViewController, button: SBPhotoCollectionButton) {
        
        guard let imageViewController = viewController.viewControllers?.first as? SBImageViewController else{ return }
        
        if let index = selectedAsset.index(of: imageViewController.item) {
            
            selectedAsset.remove(at: index)
            
            if let viewController = self.presentedViewController as? SBImageBrowserViewController {
                
                if  viewController.ispreview{
                 
                    viewController.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                }else{
                    
                    viewController.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }
            }
            
            reloadIndexAfterMethod(index: index)
            
        }else{
            
            if self.selectedAsset.count >= SBPhotoConfigObject.share.maxCanSelectNumber {
                
                return alertMaxNumberWarningMethod()
            }
            
            selectedAsset.append(imageViewController.item)
            
            if let viewController = self.presentedViewController as? SBImageBrowserViewController {
                
                let indexPath = IndexPath(item: selectedAsset.count-1, section: 0)
                
                if  viewController.ispreview{
                    
                    viewController.collectionView.reloadItems(at: [indexPath])
                }else{
                    
                    viewController.collectionView.insertItems(at: [indexPath])
                    viewController.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
                }
            }
        }
        
        button.sb_setSelected(index: selectedAsset.index(of: imageViewController.item), animate: true)
        
        let indexPath = IndexPath(item: self.allPhotos.index(of: imageViewController.item), section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SBPhotoCollectionViewCell  {
        
            cell.selectButton.sb_setSelected(index: selectedAsset.index(of: imageViewController.item), animate: false)
        }
        
        refreshPreViewButtonState()
    }
    
    /// 照片 浏览视图 点击原图按钮
    func browserDidClickOriginalButton(viewController: SBImageBrowserViewController, button: UIButton) {
        
        self.isOriginal = !isOriginal
        
        self.updateOriginalButton(button: button)
        
        self.updateOriginalButton(button: self.toolBarView.originalButton)
    }
    
    /// 更新 原图的 按钮 状态
    ///
    /// - Parameter button: 按钮
    func updateOriginalButton(button: UIButton){
        
        if self.isOriginal {
        
            button.setImage(SBPhotoConfigObject.share.pickerOriginalSelectImage, for: .normal)
        }else{
            
            button.setImage(SBPhotoConfigObject.share.pickerOriginalDefaultImage, for: .normal)
        }
        
        button.setAttributedTitle(button.attributedTitle(for: .normal), for: .normal)
    }
    
    /// 弹出数目 超出的问题
    func alertMaxNumberWarningMethod(){
        
        UIAlertController.show(self.presentedViewController ?? self, message: "你最多可以选择\(SBPhotoConfigObject.share.maxCanSelectNumber)张照片")
    }
}

/// MARK: - SBPhotoChoiceCollectionViewControllerDelegate
/// 当用户 在选择相册视图中 点击了 UITableViewCell
/// 将此视图 完成 内容重新布置
extension StrangePhotoViewController: SBPhotoChoiceCollectionViewControllerDelegate{
    
    func didChioce(assetCollection: PHAssetCollection?, fetchResults: PHFetchResult<PHAsset>) {
        
        if self.fetchResult == fetchResults{
            return
        }
        
        self.title = assetCollection?.localizedTitle ?? "全部照片"
        
        self.dismiss(animated: true, completion: nil)
        
        self.fetchResult = fetchResults
        self.assetCollection = assetCollection
        
        self.collectionView.reloadData()
        
        collectionView.scrollToItem(at: IndexPath(item: SBPhotoConfigObject.share.canTakePictures ? self.fetchResult.count : self.fetchResult.count-1, section: 0), at: .bottom, animated: false)
    }
}


// MARK: - PHPhotoLibraryChangeObserver
extension StrangePhotoViewController: PHPhotoLibraryChangeObserver{
    
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



// MARK: - UICollectionViewDelegateFlowLayout
extension StrangePhotoViewController: UICollectionViewDelegateFlowLayout{
    
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
            .filter{ $0.item != self.fetchResult.count || !SBPhotoConfigObject.share.canTakePictures }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
            .filter{ $0.item != self.fetchResult.count || !SBPhotoConfigObject.share.canTakePictures }
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  SBPhotoConfigObject.share.canTakePictures && indexPath.item == self.fetchResult.count{
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePickerController = UIImagePickerController()
                
                imagePickerController.sourceType = .camera
                
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else{
                
                UIAlertController.show(self, message: "相机异常，请确认摄像头可用")
            }
            
        }else{
            
            let viewController = SBImageBrowserViewController(viewController: self, currentIndex: indexPath.row)
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension StrangePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

import MobileCoreServices
