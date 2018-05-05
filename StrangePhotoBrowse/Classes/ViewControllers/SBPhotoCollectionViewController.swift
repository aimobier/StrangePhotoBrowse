//
//  SBPhotoCollectionViewController.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Photos

class SBPhotoCollectionViewController: UIViewController{
    
    /// 默认的 collectionView FlowLayout
    private var collectionView = UICollectionViewFlowLayout()
    
    private var fetchResult: PHFetchResult<PHAsset>!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    deinit {
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    /// 默认的全部照片
    lazy var allPhotos: PHFetchResult<PHAsset> = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }()
}

extension SBPhotoCollectionViewController{
    
}
