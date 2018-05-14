//
//  Collection+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit
import Photos

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Collection where Element == PHAsset {
    
    /// 请求图片集合
    ///
    /// - Parameter imgSize: 请求的图片大小
    /// - Returns: 返回图片集合
    func images(imgSize:CGSize = PHImageManagerMaximumSize) -> [UIImage] {
        
        let images = self.map { (asset) -> UIImage? in
            
            var rimage:UIImage?
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: imgSize,
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
