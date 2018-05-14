//
//  StrangePhotoViewControllerDelegate.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/14.
//

import Photos
import Foundation

public protocol StrangePhotoViewControllerDelegate {
    
    /// 用户确认完成
    ///
    /// - Parameters:
    ///   - images: 图片结合
    ///   - resources: 资源集合
    func didFinish(images:[UIImage],resources:[PHAsset])
    
    /// 用户确认返回
    func didCancel()
}
