//
//  PHFetchResult+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import Photos

extension PHFetchResult where ObjectType == PHAsset{
    
    /// 获取前几张图片
    ///
    /// - Parameter count: 前几张
    /// - Returns: 图片结合
    func getFirstPicture(is count:Int) -> [UIImage]{
        
        let scale = UIScreen.main.scale
        let thumbnailSize = CGSize(width: 66*scale, height: 66*scale)
        
        let images = getFirstAsset(is: count).map { (asset) -> UIImage? in
            
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
    
    /// 获取 前几个 PHAsset 对象
    func getFirstAsset(is count:Int) -> [PHAsset] {
        
        return self.objects(at: IndexSet(integersIn: 0..<(min(count, self.count))))
    }
    
    /// 获取所有的 PHAsset 对象集合
    func getAllAsset() -> [PHAsset] {
        
        return getFirstAsset(is: self.count)
    }
}

